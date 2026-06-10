<?php

namespace App\Services;

use App\Models\ChatHistory;
use App\Models\Transaction;
use App\Models\TransactionItem;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

/**
 * AiService
 *
 * Mengelola komunikasi antara backend Laravel dan OpenRouter AI API.
 *
 * Alur:
 *  1. Build context (data inventaris & penjualan dari DB)
 *  2. Buat system prompt dengan context + aturan domain dari CODEX.md
 *  3. Kirim pesan ke OpenRouter (OpenAI-compatible format)
 *  4. Kembalikan jawaban teks dari LLM
 */
class AiService
{
    private RestockAnalysisService $restockService;

    public function __construct(RestockAnalysisService $restockService)
    {
        $this->restockService = $restockService;
    }

    /**
     * Proses satu pesan chat dari user dan kembalikan jawaban AI.
     *
     * @param  string $userMessage  Pesan dari user
     * @param  int|null $userId     ID user (untuk menyimpan history)
     * @param  string  $sessionId   ID sesi percakapan
     * @return array{reply: string, session_id: string}
     */
    public function chat(string $userMessage, ?int $userId, string $sessionId): array
    {
        // ── 1. Bangun konteks dari database ─────────────────────────────────
        $context = $this->buildContext();

        // ── 2. Ambil riwayat percakapan sesi ini (max 10 pesan terakhir) ────
        $history = ChatHistory::where('session_id', $sessionId)
            ->orderBy('created_at', 'asc')
            ->take(10)
            ->get()
            ->map(fn ($msg) => [
                'role'    => $msg->role,
                'content' => $msg->content,
            ])
            ->toArray();

        // ── 3. Siapkan messages array untuk OpenRouter ───────────────────────
        $messages = [
            ['role' => 'system', 'content' => $this->buildSystemPrompt($context)],
            ...$history,
            ['role' => 'user', 'content' => $userMessage],
        ];

        // ── 4. Panggil OpenRouter API ────────────────────────────────────────
        $reply = $this->callOpenRouter($messages);

        // ── 5. Simpan pesan user dan jawaban AI ke chat_histories ────────────
        ChatHistory::insert([
            [
                'user_id'    => $userId,
                'session_id' => $sessionId,
                'role'       => 'user',
                'content'    => $userMessage,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'user_id'    => $userId,
                'session_id' => $sessionId,
                'role'       => 'assistant',
                'content'    => $reply,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        return [
            'reply'      => $reply,
            'session_id' => $sessionId,
        ];
    }

    // ─────────────────────────────────────────────────────────────────────────
    // PRIVATE HELPERS
    // ─────────────────────────────────────────────────────────────────────────

    /**
     * Build ringkasan data bisnis dari database sebagai konteks untuk LLM.
     */
    private function buildContext(): array
    {
        // Total penjualan bulan ini
        $currentMonth    = now()->month;
        $currentYear     = now()->year;
        $monthlySales    = Transaction::whereMonth('created_at', $currentMonth)
            ->whereYear('created_at', $currentYear)
            ->where('status', 'completed')
            ->sum('total');
        $monthlyTxCount  = Transaction::whereMonth('created_at', $currentMonth)
            ->whereYear('created_at', $currentYear)
            ->where('status', 'completed')
            ->count();

        // Total penjualan hari ini
        $todaySales = Transaction::whereDate('created_at', now()->toDateString())
            ->where('status', 'completed')
            ->sum('total');

        // Top 5 produk terlaris bulan ini
        $topProducts = TransactionItem::join('transactions', 'transaction_items.transaction_id', '=', 'transactions.id')
            ->join('products', 'transaction_items.product_id', '=', 'products.id')
            ->where('transactions.status', 'completed')
            ->whereMonth('transactions.created_at', $currentMonth)
            ->whereYear('transactions.created_at', $currentYear)
            ->select(
                'products.name as product_name',
                'products.sku',
                DB::raw('SUM(transaction_items.quantity) as qty_sold'),
                DB::raw('SUM(transaction_items.subtotal) as revenue')
            )
            ->groupBy('products.id', 'products.name', 'products.sku')
            ->orderByDesc('qty_sold')
            ->limit(5)
            ->get()
            ->toArray();

        // Analisis restock semua produk
        $restockAnalysis = $this->restockService->getRestockAnalysis();

        // Jumlah produk per status
        $needRestock = count(array_filter($restockAnalysis, fn ($p) => $p['status'] === 'RESTOCK'));
        $safe        = count(array_filter($restockAnalysis, fn ($p) => $p['status'] === 'SAFE'));

        return compact(
            'monthlySales',
            'monthlyTxCount',
            'todaySales',
            'topProducts',
            'restockAnalysis',
            'needRestock',
            'safe',
            'currentMonth',
            'currentYear'
        );
    }

    /**
     * Buat system prompt lengkap dengan data konteks dan aturan CODEX.md.
     */
    private function buildSystemPrompt(array $ctx): string
    {
        $monthName   = now()->setMonth($ctx['currentMonth'])->format('F');
        $monthlySalesFmt = 'Rp ' . number_format($ctx['monthlySales'], 0, ',', '.');
        $todaySalesFmt   = 'Rp ' . number_format($ctx['todaySales'],   0, ',', '.');

        // Format restock data
        $restockLines = '';
        foreach ($ctx['restockAnalysis'] as $p) {
            $restockLines .= sprintf(
                "  - %s (SKU: %s): Stok=%d, Avg Jual/Hari=%.1f, Perlu 7hr=%.1f → %s\n",
                $p['product_name'],
                $p['sku'],
                $p['current_stock'],
                $p['avg_daily_sales'],
                $p['predicted_need_7days'],
                $p['status']
            );
        }

        // Format top products
        $topLines = '';
        foreach ($ctx['topProducts'] as $i => $p) {
            $rev = 'Rp ' . number_format($p['revenue'], 0, ',', '.');
            $topLines .= sprintf(
                "  %d. %s — %d unit terjual (%s)\n",
                $i + 1,
                $p['product_name'],
                $p['qty_sold'],
                $rev
            );
        }

        return <<<PROMPT
Kamu adalah asisten AI untuk sistem inventaris **Tomodachi Pet Shop**.
Namamu adalah **Tommi**, asisten pintar yang membantu pemilik toko menganalisis data bisnis.

---
DATA INVENTARIS & PENJUALAN SAAT INI ({$monthName} {$ctx['currentYear']}):

**Ringkasan Penjualan:**
- Penjualan hari ini: {$todaySalesFmt}
- Total penjualan bulan ini: {$monthlySalesFmt} ({$ctx['monthlyTxCount']} transaksi)

**Top 5 Produk Terlaris Bulan Ini:**
{$topLines}

**Status Stok & Rekomendasi Restock (Formula: rata-rata jual/hari × 7 vs stok saat ini):**
- Produk perlu restock: {$ctx['needRestock']} produk
- Produk aman: {$ctx['safe']} produk

Detail per produk:
{$restockLines}

---
ATURAN YANG WAJIB DIIKUTI:

1. Hanya jawab pertanyaan yang berkaitan dengan:
   - Stok dan inventaris produk
   - Data penjualan dan transaksi
   - Rekomendasi restock
   - Laporan dan analisis bisnis petshop
   - Performa produk

2. Jika pertanyaan TIDAK berkaitan dengan domain di atas, balas PERSIS dengan kalimat ini saja:
   "Maaf, saya hanya dapat membantu terkait stok, penjualan, dan analisis inventaris."
   Jangan tambahkan kalimat lain.

3. Gunakan Bahasa Indonesia yang sopan dan profesional.

4. Format jawaban harus ramah untuk tampilan chat mobile:
   - Jangan gunakan tabel markdown.
   - Jangan gunakan pemisah seperti | --- |.
   - Jangan tulis paragraf panjang.
   - Gunakan heading pendek dengan **bold**.
   - Gunakan bullet pendek, maksimal 1-2 baris per bullet.
   - Untuk insight umum, pakai struktur:
     **Ringkasan**
     **Temuan Utama**
     **Rekomendasi Tindakan**
     **Prioritas Hari Ini**
   - Untuk rekomendasi restock, sebutkan nama produk, SKU, stok, kebutuhan 7 hari, dan jumlah saran restock jika bisa dihitung.

5. Berikan jawaban yang konkret, spesifik, dan actionable berdasarkan data di atas.

6. Jangan mengarang data. Semua angka harus bersumber dari DATA DI ATAS.
PROMPT;
    }

    /**
     * Panggil OpenRouter API dengan format OpenAI-compatible.
     *
     * @param  array $messages  Array of {role, content}
     * @return string           Teks jawaban dari LLM
     * @throws \RuntimeException jika API gagal
     */
    private function callOpenRouter(array $messages): string
    {
        $apiKey  = config('openrouter.api_key');
        $baseUrl = config('openrouter.base_url');
        $timeout = config('openrouter.timeout', 60);
        $models  = array_values(array_unique(array_filter([
            config('openrouter.model'),
            ...config('openrouter.fallback_models', []),
        ])));

        if (empty($apiKey)) {
            throw new \RuntimeException('OpenRouter API key tidak dikonfigurasi. Set OPENROUTER_API_KEY di .env');
        }

        $lastRateLimitRetry = null;

        try {
            foreach ($models as $model) {
                $response = Http::timeout($timeout)
                    ->withHeaders([
                        'Authorization'    => "Bearer {$apiKey}",
                        'HTTP-Referer'     => config('openrouter.site_url'),
                        'X-Title'          => config('openrouter.site_name'),
                        'Content-Type'     => 'application/json',
                    ])
                    ->post("{$baseUrl}/chat/completions", [
                        'model'    => $model,
                        'messages' => $messages,
                        'stream'   => false,
                    ]);

                if (!$response->successful()) {
                    $status = $response->status();
                    $errorMessage = $response->json('error.message') ?? 'Unknown error';
                    $retryAfter = $response->json('error.metadata.retry_after_seconds')
                        ?? $response->header('Retry-After');

                    Log::error('OpenRouter API error', [
                        'model'  => $model,
                        'status' => $status,
                        'body'   => $response->body(),
                    ]);

                    if ($this->shouldTryFallbackModel($status, $errorMessage)) {
                        $lastRateLimitRetry = $retryAfter;

                        Log::warning('OpenRouter model unavailable, trying fallback if available', [
                            'model' => $model,
                            'status' => $status,
                            'message' => $errorMessage,
                            'retry_after' => $retryAfter,
                        ]);

                        continue;
                    }

                    throw new \RuntimeException(
                        'AI service error: ' . $errorMessage
                    );
                }

                $content = $response->json('choices.0.message.content');

                if (empty($content)) {
                    throw new \RuntimeException('AI service mengembalikan respons kosong.');
                }

                if ($model !== config('openrouter.model')) {
                    Log::info('OpenRouter fallback model used', [
                        'model' => $model,
                    ]);
                }

                return trim($content);
            }

            $retryText = $lastRateLimitRetry ? " Coba lagi sekitar {$lastRateLimitRetry} detik." : '';

            throw new \RuntimeException(
                "Semua model AI yang tersedia sedang terkena rate limit dari OpenRouter.{$retryText}"
            );

        } catch (\Illuminate\Http\Client\ConnectionException $e) {
            Log::error('OpenRouter connection failed', ['error' => $e->getMessage()]);
            throw new \RuntimeException('Tidak dapat terhubung ke AI service. Coba lagi nanti.');
        }
    }

    private function shouldTryFallbackModel(int $status, string $errorMessage): bool
    {
        if ($status === 429) {
            return true;
        }

        $message = strtolower($errorMessage);

        return in_array($status, [400, 404, 503], true)
            && (
                str_contains($message, 'unavailable')
                || str_contains($message, 'rate limit')
                || str_contains($message, 'rate-limit')
                || str_contains($message, 'no endpoints')
                || str_contains($message, 'not found')
            );
    }
}
