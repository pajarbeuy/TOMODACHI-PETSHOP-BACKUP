<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ChatHistory;
use App\Services\AiService;
use App\Services\RestockAnalysisService;
use App\Support\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class AiController extends Controller
{
    public function __construct(
        private AiService $aiService,
        private RestockAnalysisService $restockService
    ) {}

    /**
     * POST /api/ai/chat
     *
     * Body:
     *   message    string  required  Pertanyaan dari user
     *   session_id string  optional  ID sesi percakapan; jika kosong, buat session baru
     */
    public function chat(Request $request)
    {
        try {
            $validated = $request->validate([
                'message'    => 'required|string|min:1|max:1000',
                'session_id' => 'nullable|string|max:100',
            ]);

            $userId    = $request->user()?->id;
            $sessionId = $validated['session_id'] ?? Str::uuid()->toString();
            $message   = trim($validated['message']);

            $result = $this->aiService->chat($message, $userId, $sessionId);

            return response()->json([
                'status'  => true,
                'message' => 'AI response retrieved',
                'data'    => [
                    'reply'      => $result['reply'],
                    'session_id' => $result['session_id'],
                ],
            ], 200);

        } catch (ValidationException $e) {
            return ApiResponse::error('Validation failed', 422, $e->errors());

        } catch (\RuntimeException $e) {
            return ApiResponse::error($e->getMessage(), 503);

        } catch (\Exception $e) {
            report($e);

            return ApiResponse::error('Terjadi kesalahan pada AI service.', 500);
        }
    }

    /**
     * GET /api/ai/chat/history?session_id=xxx
     *
     * Ambil riwayat percakapan berdasarkan session_id.
     * Hanya riwayat milik user yang sedang login yang dikembalikan.
     */
    public function history(Request $request)
    {
        try {
            $sessionId = $request->query('session_id');
            $userId    = $request->user()->id;

            $query = ChatHistory::where('user_id', $userId)
                ->orderBy('created_at', 'asc');

            if ($sessionId) {
                $query->where('session_id', $sessionId);
            }

            $history = $query->get()->map(fn ($msg) => [
                'role'       => $msg->role,
                'content'    => $msg->content,
                'session_id' => $msg->session_id,
                'created_at' => $msg->created_at->toIso8601String(),
            ]);

            return response()->json([
                'status'  => true,
                'message' => 'Chat history retrieved',
                'data'    => $history,
            ], 200);

        } catch (\Exception $e) {
            report($e);

            return ApiResponse::error('Failed to retrieve chat history. Please try again later.', 500);
        }
    }

    /**
     * GET /api/ai/restock
     *
     * Endpoint terpisah untuk mendapatkan data restock dalam format JSON mentah
     * (berguna untuk dashboard tanpa memanggil LLM).
     */
    public function restock(Request $request)
    {
        try {
            $analysis = $this->restockService->getRestockAnalysis();

            $needRestock = array_values(array_filter($analysis, fn ($p) => $p['status'] === 'RESTOCK'));
            $safe        = array_values(array_filter($analysis, fn ($p) => $p['status'] === 'SAFE'));

            return response()->json([
                'status'  => true,
                'message' => 'Restock analysis retrieved',
                'data'    => [
                    'summary' => [
                        'total_products'    => count($analysis),
                        'need_restock'      => count($needRestock),
                        'safe'              => count($safe),
                    ],
                    'need_restock' => $needRestock,
                    'safe'         => $safe,
                ],
            ], 200);

        } catch (\Exception $e) {
            report($e);

            return ApiResponse::error('Failed to get restock analysis. Please try again later.', 500);
        }
    }
}
