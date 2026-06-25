<?php

namespace Tests\Feature;

use App\Models\Transaction;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Support\BuildsPetShopData;
use Tests\TestCase;

class ReportApiTest extends TestCase
{
    use BuildsPetShopData;
    use RefreshDatabase;

    public function test_owner_can_generate_sales_report_with_channel_filter(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));

        $startDate = now()->subDays(2)->toDateString();
        $endDate = now()->toDateString();

        $offlineProduct = $this->product(['name' => 'Offline Product']);
        $onlineProduct = $this->product(['name' => 'Online Product']);

        $offlineTransaction = $this->datedCompletedTransaction($this->userWithRole('kasir'), now()->subDay(), [
            'channel' => 'offline',
            'total' => 120000,
            'subtotal' => 120000,
            'amount_paid' => 120000,
            'change_amount' => 0,
        ]);
        $this->transactionItem($offlineTransaction, $offlineProduct, [
            'quantity' => 2,
            'unit_price' => 60000,
            'subtotal' => 120000,
        ]);

        $onlineTransaction = $this->datedCompletedTransaction($this->userWithRole('kasir'), now(), [
            'channel' => 'online',
            'total' => 90000,
            'subtotal' => 90000,
            'amount_paid' => 90000,
            'change_amount' => 0,
        ]);
        $this->transactionItem($onlineTransaction, $onlineProduct, [
            'quantity' => 1,
            'unit_price' => 90000,
            'subtotal' => 90000,
        ]);

        $pendingTransaction = $this->datedCompletedTransaction($this->userWithRole('kasir'), now()->subDay(), [
            'channel' => 'offline',
            'status' => 'pending',
            'total' => 50000,
            'subtotal' => 50000,
            'amount_paid' => 50000,
            'change_amount' => 0,
        ]);
        $this->transactionItem($pendingTransaction, $offlineProduct, [
            'quantity' => 1,
            'unit_price' => 50000,
            'subtotal' => 50000,
        ]);

        $this->getJson("/api/reports/sales?start_date={$startDate}&end_date={$endDate}&channel=offline")
            ->assertOk()
            ->assertJsonPath('status', true)
            ->assertJsonPath('data.summary.total_transactions', 1)
            ->assertJsonPath('data.summary.total_revenue', 120000.0)
            ->assertJsonPath('data.summary.total_items_sold', 2)
            ->assertJsonPath('data.by_channel.offline.total_transactions', 1)
            ->assertJsonPath('data.by_channel.offline.total_revenue', 120000.0)
            ->assertJsonPath('data.by_channel.online.total_transactions', 1)
            ->assertJsonPath('data.by_channel.online.total_revenue', 90000.0);
    }

    public function test_owner_can_retrieve_sales_summary_grouped_by_day(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));

        $today = now();
        $yesterday = now()->subDay();
        $todayProduct = $this->product(['name' => 'Today Product']);
        $yesterdayProduct = $this->product(['name' => 'Yesterday Product']);

        $todayTransaction = $this->datedCompletedTransaction($this->userWithRole('kasir'), $today, [
            'channel' => 'offline',
            'total' => 70000,
            'subtotal' => 70000,
            'amount_paid' => 70000,
            'change_amount' => 0,
        ]);
        $this->transactionItem($todayTransaction, $todayProduct, [
            'quantity' => 1,
            'unit_price' => 70000,
            'subtotal' => 70000,
        ]);

        $yesterdayTransaction = $this->datedCompletedTransaction($this->userWithRole('kasir'), $yesterday, [
            'channel' => 'offline',
            'total' => 120000,
            'subtotal' => 120000,
            'amount_paid' => 120000,
            'change_amount' => 0,
        ]);
        $this->transactionItem($yesterdayTransaction, $yesterdayProduct, [
            'quantity' => 2,
            'unit_price' => 60000,
            'subtotal' => 120000,
        ]);

        $this->getJson('/api/reports/sales/summary?period=daily&year=' . $today->year . '&month=' . $today->month)
            ->assertOk()
            ->assertJsonCount(2, 'data')
            ->assertJsonPath('data.0.date', $today->toDateString())
            ->assertJsonPath('data.0.transaction_count', 1)
            ->assertJsonPath('data.0.items_sold', 1)
            ->assertJsonPath('data.1.date', $yesterday->toDateString())
            ->assertJsonPath('data.1.transaction_count', 1)
            ->assertJsonPath('data.1.items_sold', 2);
    }

    public function test_owner_can_list_top_products_sorted_by_revenue(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));

        $premiumProduct = $this->product(['name' => 'Premium Cat Food']);
        $basicProduct = $this->product(['name' => 'Basic Dog Snack']);

        $premiumTransaction = $this->datedCompletedTransaction($this->userWithRole('kasir'), now(), [
            'channel' => 'offline',
            'total' => 150000,
            'subtotal' => 150000,
            'amount_paid' => 150000,
            'change_amount' => 0,
        ]);
        $this->transactionItem($premiumTransaction, $premiumProduct, [
            'quantity' => 3,
            'unit_price' => 50000,
            'subtotal' => 150000,
        ]);

        $basicTransaction = $this->datedCompletedTransaction($this->userWithRole('kasir'), now(), [
            'channel' => 'offline',
            'total' => 90000,
            'subtotal' => 90000,
            'amount_paid' => 90000,
            'change_amount' => 0,
        ]);
        $this->transactionItem($basicTransaction, $basicProduct, [
            'quantity' => 1,
            'unit_price' => 90000,
            'subtotal' => 90000,
        ]);

        $this->getJson('/api/reports/top-products?sort_by=revenue&limit=1')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.rank', 1)
            ->assertJsonPath('data.0.product_name', 'Premium Cat Food')
            ->assertJsonPath('data.0.total_revenue', 150000.0);
    }

    public function test_owner_dashboard_analytics_returns_expected_kpis(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));

        $catCategory = $this->category(['animal_type' => 'cat', 'sub_category' => 'food']);
        $dogCategory = $this->category(['animal_type' => 'dog', 'sub_category' => 'food']);

        $catProduct = $this->product(['name' => 'Cat Sales Product'], $catCategory);
        $dogProduct = $this->product(['name' => 'Dog Sales Product'], $dogCategory);
        $this->product([
            'name' => 'Low Stock Product',
            'offline_qty' => 0,
            'online_qty' => 0,
            'min_threshold' => 1,
        ], $catCategory);

        $todayTransaction = $this->datedCompletedTransaction($this->userWithRole('kasir'), now(), [
            'channel' => 'offline',
            'total' => 180000,
            'subtotal' => 180000,
            'amount_paid' => 180000,
            'change_amount' => 0,
        ]);
        $this->transactionItem($todayTransaction, $catProduct, [
            'quantity' => 3,
            'unit_price' => 60000,
            'subtotal' => 180000,
        ]);

        $yesterdayTransaction = $this->datedCompletedTransaction($this->userWithRole('kasir'), now()->subDay(), [
            'channel' => 'offline',
            'total' => 60000,
            'subtotal' => 60000,
            'amount_paid' => 60000,
            'change_amount' => 0,
        ]);
        $this->transactionItem($yesterdayTransaction, $dogProduct, [
            'quantity' => 1,
            'unit_price' => 60000,
            'subtotal' => 60000,
        ]);

        $this->getJson('/api/dashboard/analytics')
            ->assertOk()
            ->assertJsonPath('status', true)
            ->assertJsonPath('data.kpi.today_sales', 180000.0)
            ->assertJsonPath('data.kpi.total_transactions_today', 1)
            ->assertJsonPath('data.kpi.items_sold_today', 3)
            ->assertJsonPath('data.kpi.active_products', 3)
            ->assertJsonPath('data.kpi.low_stock_products', 1)
            ->assertJsonCount(7, 'data.sales_trend')
            ->assertJsonPath('data.sales_trend.6.date', now()->toDateString())
            ->assertJsonPath('data.top_products.0.product_name', 'Cat Sales Product')
            ->assertJsonPath('data.category_breakdown.cat', 75.0)
            ->assertJsonPath('data.category_breakdown.dog', 25.0);
    }

    private function datedCompletedTransaction($cashier, $date, array $overrides = []): Transaction
    {
        $transaction = $this->transaction($cashier, array_merge([
            'status' => 'completed',
        ], $overrides));

        $transaction->forceFill([
            'created_at' => $date,
            'updated_at' => $date,
        ])->saveQuietly();

        return $transaction->fresh();
    }
}