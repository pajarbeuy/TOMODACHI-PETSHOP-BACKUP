<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\Product;
use App\Models\Stock;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;
use Midtrans\Config as MidtransConfig;
use Midtrans\Snap;

class TransactionController extends Controller
{
    private function configureMidtrans(): void
    {
        MidtransConfig::$serverKey = config('midtrans.server_key');
        MidtransConfig::$isProduction = (bool) config('midtrans.is_production');
        MidtransConfig::$isSanitized = (bool) config('midtrans.is_sanitized');
        MidtransConfig::$is3ds = (bool) config('midtrans.is_3ds');
    }

    /**
     * Display a listing of transactions.
     * GET /api/transactions
     */
    public function index(Request $request)
    {
        $query = Transaction::with(['cashier']);

        // Filter by channel
        if ($request->has('channel') && !empty($request->query('channel'))) {
            $query->where('channel', $request->query('channel'));
        }

        // Filter by start_date & end_date
        if ($request->has('start_date') && !empty($request->query('start_date'))) {
            $query->whereDate('created_at', '>=', $request->query('start_date'));
        }
        if ($request->has('end_date') && !empty($request->query('end_date'))) {
            $query->whereDate('created_at', '<=', $request->query('end_date'));
        }

        $perPage = $request->query('per_page', 15);
        $paginated = $query->latest()->paginate($perPage);

        return response()->json([
            'status' => true,
            'message' => 'Transactions retrieved',
            'data' => $paginated->items(),
            'pagination' => [
                'current_page' => $paginated->currentPage(),
                'per_page' => $paginated->perPage(),
                'total' => $paginated->total(),
            ]
        ], 200);
    }

    /**
     * Store a newly created transaction.
     * POST /api/transactions
     */
    public function store(Request $request)
    {
        try {
            $validated = $request->validate([
                'channel' => 'required|in:offline,online',
                'payment_method' => 'required|in:cash,qris,transfer',
                'amount_paid' => 'required|numeric|min:0',
                'items' => 'required|array|min:1',
                'items.*.product_id' => 'required|exists:products,id',
                'items.*.quantity' => 'required|integer|min:1',
                'items.*.unit_price' => 'required|numeric|min:0',
            ]);

            $channel = $validated['channel'];
            $itemsData = $validated['items'];

            // Run everything inside an atomic database transaction
            $transactionData = DB::transaction(function () use ($validated, $channel, $itemsData) {
                $subtotal = 0;
                $processedItems = [];

                // 1. Stock verification & deduction loop
                foreach ($itemsData as $item) {
                    $productId = $item['product_id'];
                    $qtyRequired = intval($item['quantity']);
                    $unitPrice = floatval($item['unit_price']);

                    $product = Product::with('stock')->find($productId);
                    $stock = $product->stock;

                    if (!$stock) {
                        throw ValidationException::withMessages([
                            'items' => ["Stok produk '{$product->name}' tidak terdefinisi."]
                        ]);
                    }

                    // Check stock limit based on channel
                    if ($channel === 'online') {
                        if ($stock->online_qty < $qtyRequired) {
                            throw ValidationException::withMessages([
                                'items' => ["Stok online untuk produk '{$product->name}' tidak mencukupi. (Tersedia: {$stock->online_qty}, Diminta: {$qtyRequired})"]
                            ]);
                        }
                        // Deduct stock
                        $stock->online_qty -= $qtyRequired;
                    } else {
                        if ($stock->offline_qty < $qtyRequired) {
                            throw ValidationException::withMessages([
                                'items' => ["Stok offline untuk produk '{$product->name}' tidak mencukupi. (Tersedia: {$stock->offline_qty}, Diminta: {$qtyRequired})"]
                            ]);
                        }
                        // Deduct stock
                        $stock->offline_qty -= $qtyRequired;
                    }

                    $stock->last_updated = now();
                    $stock->save();

                    // Calculate subtotal
                    $itemSubtotal = $qtyRequired * $unitPrice;
                    $subtotal += $itemSubtotal;

                    $processedItems[] = [
                        'product_id' => $productId,
                        'product_name' => $product->name,
                        'quantity' => $qtyRequired,
                        'unit_price' => $unitPrice,
                        'subtotal' => $itemSubtotal,
                    ];
                }

                $tax = 0; // standard tax is 0 as per instructions
                $total = $subtotal + $tax;
                $amountPaid = floatval($validated['amount_paid']);
                $isCashPayment = $validated['payment_method'] === 'cash';
                $changeAmount = $isCashPayment ? $amountPaid - $total : 0;

                if ($isCashPayment && $changeAmount < 0) {
                    throw ValidationException::withMessages([
                        'amount_paid' => ["Uang pembayaran kurang. Total: " . number_format($total) . ", Dibayar: " . number_format($amountPaid)]
                    ]);
                }

                // 2. Generate daily sequential transaction code
                // Count transactions created today to assign index
                $todayDate = now()->toDateString();
                $todayCount = Transaction::whereDate('created_at', $todayDate)->count();
                $sequence = str_pad($todayCount + 1, 3, '0', STR_PAD_LEFT);
                $transactionCode = 'TRX-' . now()->format('Ymd') . '-' . $sequence;
                $midtransOrderId = $isCashPayment ? null : $transactionCode . '-' . now()->timestamp;

                // 3. Save Transaction
                $transaction = Transaction::create([
                    'kasir_id' => auth()->id(),
                    'transaction_code' => $transactionCode,
                    'channel' => $channel,
                    'subtotal' => $subtotal,
                    'tax' => $tax,
                    'total' => $total,
                    'payment_method' => $validated['payment_method'],
                    'amount_paid' => $isCashPayment ? $amountPaid : 0,
                    'change_amount' => $changeAmount,
                    'status' => $isCashPayment ? 'completed' : 'pending',
                    'midtrans_order_id' => $midtransOrderId,
                    'paid_at' => $isCashPayment ? now() : null,
                ]);

                // 4. Save items
                foreach ($processedItems as $pItem) {
                    TransactionItem::create([
                        'transaction_id' => $transaction->id,
                        'product_id' => $pItem['product_id'],
                        'quantity' => $pItem['quantity'],
                        'unit_price' => $pItem['unit_price'],
                        'subtotal' => $pItem['subtotal'],
                    ]);
                }

                $paymentData = null;

                if (!$isCashPayment) {
                    if (empty(config('midtrans.server_key'))) {
                        throw ValidationException::withMessages([
                            'payment_method' => ['MIDTRANS_SERVER_KEY belum diatur di file .env backend.']
                        ]);
                    }

                    $this->configureMidtrans();

                    $snapResponse = Snap::createTransaction([
                        'transaction_details' => [
                            'order_id' => $midtransOrderId,
                            'gross_amount' => (int) round($total),
                        ],
                        'item_details' => collect($processedItems)->map(function ($item) {
                            return [
                                'id' => (string) $item['product_id'],
                                'price' => (int) round($item['unit_price']),
                                'quantity' => (int) $item['quantity'],
                                'name' => mb_substr($item['product_name'], 0, 50),
                            ];
                        })->values()->all(),
                        'customer_details' => [
                            'first_name' => auth()->user()?->name ?? 'Kasir',
                            'email' => auth()->user()?->email,
                        ],
                    ]);

                    $transaction->update([
                        'midtrans_snap_token' => $snapResponse->token ?? null,
                        'midtrans_redirect_url' => $snapResponse->redirect_url ?? null,
                    ]);

                    $paymentData = [
                        'midtrans_order_id' => $midtransOrderId,
                        'snap_token' => $snapResponse->token ?? null,
                        'redirect_url' => $snapResponse->redirect_url ?? null,
                    ];
                }

                return [
                    'transaction_id' => $transaction->transaction_code,
                    'transaction_date' => $transaction->created_at->toIso8601String(),
                    'kasir_name' => $transaction->cashier?->name ?? 'Unknown Kasir',
                    'items' => $processedItems,
                    'subtotal' => $subtotal,
                    'tax' => $tax,
                    'total' => $total,
                    'payment_method' => $transaction->payment_method,
                    'payment_status' => $transaction->status,
                    'amount_paid' => floatval($transaction->amount_paid),
                    'change' => $changeAmount,
                    'payment' => $paymentData,
                    'created_at' => $transaction->created_at->toIso8601String(),
                ];
            });

            return response()->json([
                'status' => true,
                'message' => 'Transaction created successfully',
                'data' => $transactionData
            ], 201);

        } catch (ValidationException $e) {
            return response()->json([
                'status' => false,
                'message' => 'Validation failed',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            return response()->json([
                'status' => false,
                'message' => 'Transaction failed: ' . $e->getMessage()
            ], 500);
        }
    }

    public function midtransNotification(Request $request)
    {
        $payload = $request->all();
        $serverKey = config('midtrans.server_key');

        if (empty($serverKey)) {
            return response()->json([
                'status' => false,
                'message' => 'MIDTRANS_SERVER_KEY belum diatur',
            ], 500);
        }

        $orderId = $payload['order_id'] ?? null;
        $statusCode = $payload['status_code'] ?? null;
        $grossAmount = $payload['gross_amount'] ?? null;
        $signatureKey = $payload['signature_key'] ?? null;

        if (!$orderId || !$statusCode || !$grossAmount || !$signatureKey) {
            return response()->json([
                'status' => false,
                'message' => 'Payload notifikasi Midtrans tidak lengkap',
            ], 422);
        }

        $expectedSignature = hash('sha512', $orderId . $statusCode . $grossAmount . $serverKey);
        if (!hash_equals($expectedSignature, $signatureKey)) {
            return response()->json([
                'status' => false,
                'message' => 'Signature Midtrans tidak valid',
            ], 403);
        }

        $transaction = Transaction::with('items.product.stock')
            ->where('midtrans_order_id', $orderId)
            ->first();

        if (!$transaction) {
            return response()->json([
                'status' => false,
                'message' => 'Transaksi tidak ditemukan',
            ], 404);
        }

        $midtransStatus = $payload['transaction_status'] ?? null;
        $fraudStatus = $payload['fraud_status'] ?? null;
        $localStatus = $this->mapMidtransStatus($midtransStatus, $fraudStatus);

        DB::transaction(function () use ($transaction, $payload, $midtransStatus, $fraudStatus, $localStatus) {
            $previousStatus = $transaction->status;

            $transaction->update([
                'status' => $localStatus,
                'amount_paid' => $localStatus === 'completed' ? $transaction->total : $transaction->amount_paid,
                'midtrans_transaction_id' => $payload['transaction_id'] ?? $transaction->midtrans_transaction_id,
                'midtrans_payment_type' => $payload['payment_type'] ?? $transaction->midtrans_payment_type,
                'midtrans_transaction_status' => $midtransStatus,
                'midtrans_fraud_status' => $fraudStatus,
                'midtrans_payload' => $payload,
                'paid_at' => $localStatus === 'completed' ? now() : $transaction->paid_at,
            ]);

            if ($previousStatus === 'pending' && $localStatus === 'cancelled') {
                foreach ($transaction->items as $item) {
                    $stock = $item->product?->stock;
                    if (!$stock) {
                        continue;
                    }

                    if ($transaction->channel === 'online') {
                        $stock->online_qty += $item->quantity;
                    } else {
                        $stock->offline_qty += $item->quantity;
                    }

                    $stock->last_updated = now();
                    $stock->save();
                }
            }
        });

        return response()->json([
            'status' => true,
            'message' => 'Notifikasi Midtrans diproses',
        ]);
    }

    private function mapMidtransStatus(?string $transactionStatus, ?string $fraudStatus): string
    {
        if ($transactionStatus === 'capture') {
            return $fraudStatus === 'challenge' ? 'pending' : 'completed';
        }

        if ($transactionStatus === 'settlement') {
            return 'completed';
        }

        if (in_array($transactionStatus, ['cancel', 'deny', 'expire', 'failure'], true)) {
            return 'cancelled';
        }

        return 'pending';
    }

    /**
     * Display transaction detail.
     * GET /api/transactions/{id}
     */
    public function show(string $id)
    {
        // Accept either auto-increment ID or TRX transaction_code
        $transaction = Transaction::with(['cashier', 'items.product'])
            ->where('id', $id)
            ->orWhere('transaction_code', $id)
            ->first();

        if (!$transaction) {
            return response()->json([
                'status' => false,
                'message' => 'Transaksi tidak ditemukan'
            ], 404);
        }

        // Format items representation to match API contract
        $itemsFormatted = $transaction->items->map(function ($item) {
            return [
                'product_id' => $item->product_id,
                'product_name' => $item->product?->name ?? 'Unknown Product',
                'quantity' => $item->quantity,
                'unit_price' => floatval($item->unit_price),
                'subtotal' => floatval($item->subtotal),
            ];
        });

        $data = [
            'id' => $transaction->id,
            'transaction_id' => $transaction->transaction_code,
            'kasir_id' => $transaction->kasir_id,
            'kasir_name' => $transaction->cashier?->name ?? 'Unknown Kasir',
            'channel' => $transaction->channel,
            'subtotal' => floatval($transaction->subtotal),
            'tax' => floatval($transaction->tax),
            'total' => floatval($transaction->total),
            'payment_method' => $transaction->payment_method,
            'amount_paid' => floatval($transaction->amount_paid),
            'change' => floatval($transaction->change_amount),
            'items' => $itemsFormatted,
            'created_at' => $transaction->created_at->toIso8601String(),
        ];

        return response()->json([
            'status' => true,
            'message' => 'Transaction detail retrieved',
            'data' => $data
        ], 200);
    }

    /**
     * Get printed/digital receipt.
     * GET /api/transactions/{id}/receipt
     */
    public function receipt(string $id)
    {
        $transaction = Transaction::with(['cashier', 'items.product'])
            ->where('id', $id)
            ->orWhere('transaction_code', $id)
            ->first();

        if (!$transaction) {
            return response()->json([
                'status' => false,
                'message' => 'Transaksi tidak ditemukan'
            ], 404);
        }

        $itemsFormatted = $transaction->items->map(function ($item) {
            return [
                'product_name' => $item->product?->name ?? 'Unknown Product',
                'quantity' => $item->quantity,
                'unit_price' => floatval($item->unit_price),
                'subtotal' => floatval($item->subtotal),
            ];
        });

        $data = [
            'transaction_id' => $transaction->transaction_code,
            'transaction_date' => $transaction->created_at->toIso8601String(),
            'kasir_name' => $transaction->cashier?->name ?? 'Unknown Kasir',
            'items' => $itemsFormatted,
            'subtotal' => floatval($transaction->subtotal),
            'tax' => floatval($transaction->tax),
            'total' => floatval($transaction->total),
            'payment_method' => $transaction->payment_method,
            'amount_paid' => floatval($transaction->amount_paid),
            'change' => floatval($transaction->change_amount),
        ];

        return response()->json([
            'status' => true,
            'message' => 'Receipt data retrieved',
            'data' => $data
        ], 200);
    }
}
