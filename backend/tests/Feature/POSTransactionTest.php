<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Models\User;
use App\Models\Role;
use App\Models\Product;
use App\Models\Category;
use App\Models\Stock;
use Laravel\Sanctum\Sanctum;

class POSTransactionTest extends TestCase
{
    use RefreshDatabase;

    protected $owner;
    protected $kasir;
    protected $product;
    protected $category;

    protected function setUp(): void
    {
        parent::setUp();

        // 1. Seed Roles
        $ownerRole = Role::create(['name' => 'owner']);
        $kasirRole = Role::create(['name' => 'kasir']);

        // 2. Seed Users
        $this->owner = User::create([
            'name' => 'Owner Heri',
            'email' => 'owner@test.com',
            'password' => bcrypt('password123'),
            'role_id' => $ownerRole->id,
        ]);

        $this->kasir = User::create([
            'name' => 'Kasir Budi',
            'email' => 'kasir@test.com',
            'password' => bcrypt('password123'),
            'role_id' => $kasirRole->id,
        ]);

        // 3. Seed Category
        $this->category = Category::create([
            'name' => 'Makanan Kucing',
            'animal_type' => 'cat',
            'sub_category' => 'food',
            'description' => 'Kategori test',
        ]);

        // 4. Seed Product and Stock
        $this->product = Product::create([
            'category_id' => $this->category->id,
            'name' => 'Royal Canin Cat 1kg',
            'sku' => 'RC-CAT-1KG',
            'buy_price' => 50000,
            'sell_price' => 75000,
            'margin_percentage' => 50.00,
            'image_url' => null,
            'description' => 'Test produk',
        ]);

        $this->product->stock()->create([
            'offline_qty' => 10,
            'online_qty' => 5,
            'min_threshold' => 2,
            'last_updated' => now(),
        ]);
    }

    /** @test */
    public function it_filters_in_stock_products_correctly()
    {
        Sanctum::actingAs($this->kasir);

        // Fetch positive stock products
        $response = $this->getJson('/api/products?channel=offline&in_stock=true');

        $response->assertStatus(200)
            ->assertJsonPath('status', true)
            ->assertJsonCount(1, 'data');

        // Modify stock offline to 0
        $this->product->stock->update(['offline_qty' => 0]);

        // Fetch positive stock products again
        $response2 = $this->getJson('/api/products?channel=offline&in_stock=true');
        $response2->assertStatus(200)
            ->assertJsonCount(0, 'data');
    }

    /** @test */
    public function it_performs_checkout_successfully_and_deducts_stock()
    {
        Sanctum::actingAs($this->kasir);

        $payload = [
            'channel' => 'offline',
            'payment_method' => 'cash',
            'amount_paid' => 150000,
            'items' => [
                [
                    'product_id' => $this->product->id,
                    'quantity' => 2,
                    'unit_price' => 75000,
                ]
            ]
        ];

        $response = $this->postJson('/api/transactions', $payload);

        $response->assertStatus(201)
            ->assertJsonPath('status', true)
            ->assertJsonStructure([
                'status',
                'message',
                'data' => [
                    'transaction_id',
                    'transaction_date',
                    'kasir_name',
                    'items' => [
                        '*' => [
                            'product_id',
                            'product_name',
                            'quantity',
                            'unit_price',
                            'subtotal',
                        ],
                    ],
                    'subtotal',
                    'tax',
                    'total',
                    'payment_method',
                    'amount_paid',
                    'change',
                    'created_at'
                ]
            ]);

        $response->assertJsonPath('data.items.0.product_name', 'Royal Canin Cat 1kg')
            ->assertJsonPath('data.items.0.quantity', 2)
            ->assertJsonPath('data.payment_method', 'cash');

        // Verify stock deducted
        $this->assertEquals(8, $this->product->stock->fresh()->offline_qty);
    }

    /** @test */
    public function it_rejects_checkout_when_stock_is_insufficient()
    {
        Sanctum::actingAs($this->kasir);

        $payload = [
            'channel' => 'offline',
            'payment_method' => 'cash',
            'amount_paid' => 900000,
            'items' => [
                [
                    'product_id' => $this->product->id,
                    'quantity' => 12, // Exceeds available stock of 10
                    'unit_price' => 75000,
                ]
            ]
        ];

        $response = $this->postJson('/api/transactions', $payload);

        $response->assertStatus(422)
            ->assertJsonPath('status', false)
            ->assertJsonStructure(['errors']);

        // Verify stock is untouched
        $this->assertEquals(10, $this->product->stock->fresh()->offline_qty);
    }

    /** @test */
    public function it_validates_safety_price_levels()
    {
        Sanctum::actingAs($this->owner);

        // Attempting to create product where sell_price < buy_price without override
        $payload = [
            'name' => 'Murah Cat Food 1kg',
            'sku' => 'MURAH-CAT-1KG',
            'category_id' => $this->category->id,
            'buy_price' => 45000,
            'sell_price' => 30000, // < buy_price
            'offline_qty' => 10,
            'online_qty' => 5,
            'min_threshold' => 2,
        ];

        $response = $this->postJson('/api/products', $payload);

        $response->assertStatus(422)
            ->assertJsonPath('status', false)
            ->assertJsonStructure(['errors']);

        // Attempting with confirmation flag
        $payload['confirm_price_below_cost'] = true;
        $response2 = $this->postJson('/api/products', $payload);

        $response2->assertStatus(201)
            ->assertJsonPath('status', true);
    }
}
