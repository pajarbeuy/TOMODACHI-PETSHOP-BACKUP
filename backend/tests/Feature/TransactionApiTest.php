<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Support\BuildsPetShopData;
use Tests\TestCase;

class TransactionApiTest extends TestCase
{
    use BuildsPetShopData;
    use RefreshDatabase;

    public function test_kasir_can_checkout_cash_transaction_and_deduct_offline_stock(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $product = $this->product(['offline_qty' => 10]);

        $this->postJson('/api/transactions', $this->checkoutPayload($product->id, ['quantity' => 3]))
            ->assertCreated()
            ->assertJsonPath('status', true)
            ->assertJsonPath('data.change', 20000);

        $this->assertSame(7, $product->stock->fresh()->offline_qty);
    }

    public function test_owner_can_checkout_transaction(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));
        $product = $this->product();

        $this->postJson('/api/transactions', $this->checkoutPayload($product->id))
            ->assertCreated()
            ->assertJsonPath('data.payment_status', 'completed');
    }

    public function test_admin_can_checkout_transaction(): void
    {
        Sanctum::actingAs($this->userWithRole('admin'));
        $product = $this->product();

        $this->postJson('/api/transactions', $this->checkoutPayload($product->id))
            ->assertCreated()
            ->assertJsonPath('data.payment_status', 'completed');
    }

    public function test_checkout_validates_required_items(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));

        $this->postJson('/api/transactions', [
            'channel' => 'offline',
            'payment_method' => 'cash',
            'amount_paid' => 100000,
            'items' => [],
        ])->assertUnprocessable();
    }

    public function test_checkout_rejects_invalid_channel(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $product = $this->product();

        $this->postJson('/api/transactions', $this->checkoutPayload($product->id, [], [
            'channel' => 'marketplace',
        ]))->assertUnprocessable();
    }

    public function test_checkout_rejects_cash_payment_below_total(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $product = $this->product();

        $this->postJson('/api/transactions', $this->checkoutPayload($product->id, [], [
            'amount_paid' => 1000,
        ]))->assertUnprocessable();
    }

    public function test_checkout_rejects_insufficient_offline_stock(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $product = $this->product(['offline_qty' => 1]);

        $this->postJson('/api/transactions', $this->checkoutPayload($product->id, ['quantity' => 2]))
            ->assertUnprocessable();

        $this->assertSame(1, $product->stock->fresh()->offline_qty);
    }

    public function test_online_checkout_deducts_online_stock(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $product = $this->product(['online_qty' => 4]);

        $this->postJson('/api/transactions', $this->checkoutPayload($product->id, ['quantity' => 2], [
            'channel' => 'online',
        ]))->assertCreated();

        $this->assertSame(2, $product->stock->fresh()->online_qty);
    }

    public function test_authenticated_user_can_list_transactions(): void
    {
        $kasir = $this->userWithRole('kasir');
        Sanctum::actingAs($kasir);
        $this->transaction($kasir);

        $this->getJson('/api/transactions')
            ->assertOk()
            ->assertJsonCount(1, 'data');
    }

    public function test_transaction_history_filters_by_channel(): void
    {
        $kasir = $this->userWithRole('kasir');
        Sanctum::actingAs($kasir);
        $this->transaction($kasir, ['channel' => 'offline']);
        $this->transaction($kasir, ['channel' => 'online']);

        $this->getJson('/api/transactions?channel=online')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.channel', 'online');
    }

    public function test_authenticated_user_can_show_transaction_by_code(): void
    {
        $kasir = $this->userWithRole('kasir');
        Sanctum::actingAs($kasir);
        $transaction = $this->transaction($kasir, ['transaction_code' => 'TRX-TEST-001']);
        $this->transactionItem($transaction, $this->product());

        $this->getJson('/api/transactions/TRX-TEST-001')
            ->assertOk()
            ->assertJsonPath('data.transaction_id', 'TRX-TEST-001');
    }

    public function test_authenticated_user_can_fetch_receipt(): void
    {
        $kasir = $this->userWithRole('kasir');
        Sanctum::actingAs($kasir);
        $transaction = $this->transaction($kasir, ['transaction_code' => 'TRX-RECEIPT-001']);
        $this->transactionItem($transaction, $this->product(), ['quantity' => 2]);

        $this->getJson('/api/transactions/TRX-RECEIPT-001/receipt')
            ->assertOk()
            ->assertJsonPath('data.transaction_id', 'TRX-RECEIPT-001')
            ->assertJsonPath('data.items.0.quantity', 2);
    }

    public function test_midtrans_notification_rejects_invalid_signature(): void
    {
        config(['midtrans.server_key' => 'server-key']);

        $this->postJson('/api/midtrans/notification', [
            'order_id' => 'ORDER-1',
            'status_code' => '200',
            'gross_amount' => '60000.00',
            'signature_key' => 'invalid',
        ])->assertForbidden();
    }

    public function test_midtrans_notification_marks_transaction_completed(): void
    {
        config(['midtrans.server_key' => 'server-key']);
        $kasir = $this->userWithRole('kasir');
        $transaction = $this->transaction($kasir, [
            'status' => 'pending',
            'midtrans_order_id' => 'ORDER-COMPLETE',
            'amount_paid' => 0,
        ]);

        $this->postJson('/api/midtrans/notification', $this->midtransPayload('ORDER-COMPLETE', 'settlement'))
            ->assertOk()
            ->assertJsonPath('status', true);

        $this->assertSame('completed', $transaction->fresh()->status);
    }

    private function checkoutPayload(int $productId, array $itemOverrides = [], array $overrides = []): array
    {
        return array_merge([
            'channel' => 'offline',
            'payment_method' => 'cash',
            'amount_paid' => 200000,
            'items' => [
                array_merge([
                    'product_id' => $productId,
                    'quantity' => 2,
                    'unit_price' => 60000,
                ], $itemOverrides),
            ],
        ], $overrides);
    }

    private function midtransPayload(string $orderId, string $transactionStatus): array
    {
        $statusCode = '200';
        $grossAmount = '60000.00';

        return [
            'order_id' => $orderId,
            'status_code' => $statusCode,
            'gross_amount' => $grossAmount,
            'signature_key' => hash('sha512', $orderId . $statusCode . $grossAmount . 'server-key'),
            'transaction_status' => $transactionStatus,
            'transaction_id' => 'MID-' . $orderId,
            'payment_type' => 'bank_transfer',
        ];
    }
}
