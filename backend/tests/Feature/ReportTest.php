<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Product;
use App\Models\Role;
use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ReportTest extends TestCase
{
    use RefreshDatabase;

    private User $owner;
    private User $kasir;
    private Product $product;

    protected function setUp(): void
    {
        parent::setUp();

        $ownerRole = Role::create(['name' => 'owner']);
        $kasirRole = Role::create(['name' => 'kasir']);

        $this->owner = User::create([
            'name'     => 'Owner Test',
            'email'    => 'owner@test.com',
            'password' => bcrypt('password123'),
            'role_id'  => $ownerRole->id,
        ]);

        $this->kasir = User::create([
            'name'     => 'Kasir Test',
            'email'    => 'kasir@test.com',
            'password' => bcrypt('password123'),
            'role_id'  => $kasirRole->id,
        ]);

        $category = Category::create([
            'name'        => 'Makanan Kucing',
            'animal_type' => 'cat',
        ]);

        $this->product = Product::create([
            'category_id'       => $category->id,
            'name'              => 'Royal Canin 1kg',
            'sku'               => 'RC-CAT-001',
            'buy_price'         => 50000,
            'sell_price'        => 75000,
            'margin_percentage' => 50.00,
        ]);

        $this->product->stock()->create([
            'offline_qty'   => 50,
            'online_qty'    => 20,
            'min_threshold' => 5,
            'last_updated'  => now(),
        ]);

        // Seed 3 completed transactions
        $this->seedCompletedTransactions(3);
    }

    private function seedCompletedTransactions(int $count): void
    {
        for ($i = 0; $i < $count; $i++) {
            $transaction = Transaction::create([
                'kasir_id'         => $this->kasir->id,
                'transaction_code' => 'TRX-TEST-' . str_pad($i + 1, 3, '0', STR_PAD_LEFT),
                'channel'          => 'offline',
                'subtotal'         => 150000,
                'tax'              => 0,
                'total'            => 150000,
                'payment_method'   => 'cash',
                'amount_paid'      => 150000,
                'change_amount'    => 0,
                'status'           => 'completed',
                'paid_at'          => now(),
            ]);

            TransactionItem::create([
                'transaction_id' => $transaction->id,
                'product_id'     => $this->product->id,
                'quantity'       => 2,
                'unit_price'     => 75000,
                'subtotal'       => 150000,
            ]);
        }
    }

    // ─── Analytics Dashboard ─────────────────────────────────────────────────────

    /** @test */
    public function owner_can_access_dashboard_analytics()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->getJson('/api/dashboard/analytics');

        $response->assertStatus(200)
            ->assertJsonPath('status', true)
            ->assertJsonStructure([
                'data' => [
                    'kpi' => [
                        'today_sales',
                        'total_transactions_today',
                        'items_sold_today',
                        'monthly_revenue',
                        'active_products',
                        'low_stock_products',
                    ],
                    'sales_trend',
                    'top_products',
                    'low_stock_alerts',
                    'monthly_revenue',
                    'category_breakdown',
                ],
            ]);
    }

    /** @test */
    public function kasir_cannot_access_dashboard_analytics()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->getJson('/api/dashboard/analytics');

        $response->assertStatus(403);
    }

    /** @test */
    public function analytics_today_sales_reflects_completed_transactions()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->getJson('/api/dashboard/analytics');

        // 3 transactions × 150.000 = 450.000
        $this->assertEquals(450000, $response->json('data.kpi.today_sales'));
        $this->assertEquals(3, $response->json('data.kpi.total_transactions_today'));
    }

    /** @test */
    public function analytics_does_not_count_pending_transactions()
    {
        // Add a pending transaction that should NOT be counted
        Transaction::create([
            'kasir_id'         => $this->kasir->id,
            'transaction_code' => 'TRX-PENDING-001',
            'channel'          => 'online',
            'subtotal'         => 75000,
            'tax'              => 0,
            'total'            => 75000,
            'payment_method'   => 'qris',
            'amount_paid'      => 0,
            'change_amount'    => 0,
            'status'           => 'pending',
        ]);

        Sanctum::actingAs($this->owner);
        $response = $this->getJson('/api/dashboard/analytics');

        // Should still be 450.000, not 525.000
        $this->assertEquals(450000, $response->json('data.kpi.today_sales'));
        $this->assertEquals(3, $response->json('data.kpi.total_transactions_today'));
    }

    // ─── Sales Report ────────────────────────────────────────────────────────────

    /** @test */
    public function owner_can_get_sales_report()
    {
        Sanctum::actingAs($this->owner);

        $today = now()->toDateString();
        $response = $this->getJson("/api/reports/sales?start_date={$today}&end_date={$today}");

        $response->assertStatus(200)
            ->assertJsonPath('status', true)
            ->assertJsonStructure([
                'data' => [
                    'period'  => ['start_date', 'end_date'],
                    'summary' => [
                        'total_transactions',
                        'total_revenue',
                        'total_items_sold',
                        'average_transaction_value',
                    ],
                    'by_channel' => ['offline', 'online'],
                ],
            ]);

        $this->assertEquals(3, $response->json('data.summary.total_transactions'));
        $this->assertEquals(450000, $response->json('data.summary.total_revenue'));
    }

    /** @test */
    public function sales_report_requires_date_parameters()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->getJson('/api/reports/sales');

        $response->assertStatus(422);
    }

    /** @test */
    public function sales_report_can_filter_by_channel()
    {
        Sanctum::actingAs($this->owner);

        $today = now()->toDateString();

        // offline filter — all 3 transactions are offline
        $responseOffline = $this->getJson("/api/reports/sales?start_date={$today}&end_date={$today}&channel=offline");
        $this->assertEquals(3, $responseOffline->json('data.summary.total_transactions'));

        // online filter — 0 transactions
        $responseOnline = $this->getJson("/api/reports/sales?start_date={$today}&end_date={$today}&channel=online");
        $this->assertEquals(0, $responseOnline->json('data.summary.total_transactions'));
    }

    /** @test */
    public function kasir_cannot_access_sales_report()
    {
        Sanctum::actingAs($this->kasir);

        $today = now()->toDateString();
        $response = $this->getJson("/api/reports/sales?start_date={$today}&end_date={$today}");

        $response->assertStatus(403);
    }

    // ─── Top Products ────────────────────────────────────────────────────────────

    /** @test */
    public function owner_can_get_top_products()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->getJson('/api/reports/top-products');

        $response->assertStatus(200)
            ->assertJsonPath('status', true)
            ->assertJsonStructure([
                'data' => [
                    '*' => ['rank', 'product_id', 'product_name', 'sku', 'quantity_sold', 'total_revenue'],
                ],
            ]);

        // Our product sold 6 units (2 per transaction × 3 transactions)
        $this->assertEquals(6, $response->json('data.0.quantity_sold'));
        $this->assertEquals(450000, $response->json('data.0.total_revenue'));
    }

    /** @test */
    public function kasir_cannot_access_top_products()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->getJson('/api/reports/top-products');

        $response->assertStatus(403);
    }

    // ─── Sales Summary ───────────────────────────────────────────────────────────

    /** @test */
    public function owner_can_get_daily_sales_summary()
    {
        Sanctum::actingAs($this->owner);

        $year  = now()->year;
        $month = now()->month;

        $response = $this->getJson("/api/reports/sales/summary?period=daily&year={$year}&month={$month}");

        $response->assertStatus(200)
            ->assertJsonPath('status', true)
            ->assertJsonStructure([
                'data' => [
                    '*' => ['date', 'total_revenue', 'transaction_count'],
                ],
            ]);
    }

    /** @test */
    public function sales_summary_requires_period_and_year()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->getJson('/api/reports/sales/summary');

        $response->assertStatus(422);
    }
}
