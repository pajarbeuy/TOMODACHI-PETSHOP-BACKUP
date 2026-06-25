<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Product;
use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ProductCrudTest extends TestCase
{
    use RefreshDatabase;

    private User $owner;
    private User $kasir;
    private Category $category;
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

        $this->category = Category::create([
            'name'         => 'Makanan Kucing',
            'animal_type'  => 'cat',
            'sub_category' => 'food',
            'description'  => 'Kategori test',
        ]);

        $this->product = Product::create([
            'category_id'       => $this->category->id,
            'name'              => 'Royal Canin 1kg',
            'sku'               => 'RC-CAT-001',
            'buy_price'         => 50000,
            'sell_price'        => 75000,
            'margin_percentage' => 50.00,
            'description'       => 'Test produk',
        ]);

        $this->product->stock()->create([
            'offline_qty'   => 10,
            'online_qty'    => 5,
            'min_threshold' => 2,
            'last_updated'  => now(),
        ]);
    }

    // ─── List Products ───────────────────────────────────────────────────────────

    /** @test */
    public function authenticated_user_can_list_products()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->getJson('/api/products');

        $response->assertStatus(200)
            ->assertJsonPath('status', true)
            ->assertJsonStructure([
                'data' => [['id', 'name', 'sku', 'sell_price', 'category', 'stock']],
                'pagination' => ['current_page', 'per_page', 'total'],
            ]);
    }

    /** @test */
    public function unauthenticated_user_cannot_list_products()
    {
        $response = $this->getJson('/api/products');

        $response->assertStatus(401);
    }

    /** @test */
    public function kasir_cannot_see_buy_price_in_product_list()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->getJson('/api/products');

        $firstProduct = $response->json('data.0');
        $this->assertArrayNotHasKey('buy_price', $firstProduct);
        $this->assertArrayNotHasKey('margin_percentage', $firstProduct);
    }

    /** @test */
    public function owner_can_see_buy_price_in_product_list()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->getJson('/api/products');

        $firstProduct = $response->json('data.0');
        $this->assertArrayHasKey('buy_price', $firstProduct);
    }

    /** @test */
    public function product_list_can_be_searched_by_name()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->getJson('/api/products?search=Royal');

        $response->assertStatus(200)
            ->assertJsonCount(1, 'data');

        $response2 = $this->getJson('/api/products?search=NONEXISTENT');
        $response2->assertStatus(200)
            ->assertJsonCount(0, 'data');
    }

    /** @test */
    public function product_list_can_be_filtered_by_in_stock()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->getJson('/api/products?in_stock=true&channel=offline');
        $response->assertStatus(200)->assertJsonCount(1, 'data');

        // Zero out offline stock
        $this->product->stock->update(['offline_qty' => 0]);

        $response2 = $this->getJson('/api/products?in_stock=true&channel=offline');
        $response2->assertStatus(200)->assertJsonCount(0, 'data');
    }

    // ─── Show Product ────────────────────────────────────────────────────────────

    /** @test */
    public function authenticated_user_can_get_product_detail()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->getJson("/api/products/{$this->product->id}");

        $response->assertStatus(200)
            ->assertJsonPath('status', true)
            ->assertJsonPath('data.id', $this->product->id)
            ->assertJsonPath('data.name', 'Royal Canin 1kg');
    }

    /** @test */
    public function it_returns_404_for_nonexistent_product()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->getJson('/api/products/99999');

        $response->assertStatus(404)
            ->assertJsonPath('status', false);
    }

    // ─── Create Product ──────────────────────────────────────────────────────────

    /** @test */
    public function owner_can_create_product()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->postJson('/api/products', [
            'name'         => 'Whiskas Tuna 400g',
            'category_id'  => $this->category->id,
            'buy_price'    => 20000,
            'sell_price'   => 28000,
            'offline_qty'  => 15,
            'online_qty'   => 10,
            'min_threshold'=> 3,
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('status', true)
            ->assertJsonPath('data.name', 'Whiskas Tuna 400g');

        $this->assertDatabaseHas('products', ['name' => 'Whiskas Tuna 400g']);
    }

    /** @test */
    public function kasir_cannot_create_product()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->postJson('/api/products', [
            'name'        => 'Produk Baru',
            'category_id' => $this->category->id,
            'buy_price'   => 10000,
            'sell_price'  => 15000,
        ]);

        $response->assertStatus(403);
    }

    /** @test */
    public function create_product_fails_if_sell_price_below_buy_without_confirm()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->postJson('/api/products', [
            'name'        => 'Produk Rugi',
            'category_id' => $this->category->id,
            'buy_price'   => 50000,
            'sell_price'  => 30000, // below buy_price
        ]);

        $response->assertStatus(422)
            ->assertJsonPath('status', false);
    }

    /** @test */
    public function create_product_with_sell_price_below_buy_succeeds_with_confirm_flag()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->postJson('/api/products', [
            'name'                    => 'Produk Promo',
            'category_id'             => $this->category->id,
            'buy_price'               => 50000,
            'sell_price'              => 30000,
            'confirm_price_below_cost'=> true,
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('status', true);
    }

    /** @test */
    public function create_product_auto_generates_sku_if_not_provided()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->postJson('/api/products', [
            'name'        => 'Produk Auto SKU',
            'category_id' => $this->category->id,
            'buy_price'   => 10000,
            'sell_price'  => 15000,
        ]);

        $response->assertStatus(201);
        $this->assertNotEmpty($response->json('data.sku'));
    }

    // ─── Update Product ──────────────────────────────────────────────────────────

    /** @test */
    public function owner_can_update_product()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->postJson("/api/products/{$this->product->id}/update", [
            'name'         => 'Royal Canin 2kg Updated',
            'category_id'  => $this->category->id,
            'buy_price'    => 90000,
            'sell_price'   => 130000,
            'sku'          => 'RC-CAT-001',
            'offline_qty'  => 20,
            'online_qty'   => 10,
        ]);

        $response->assertStatus(200)
            ->assertJsonPath('status', true)
            ->assertJsonPath('data.name', 'Royal Canin 2kg Updated');
    }

    /** @test */
    public function kasir_cannot_update_product()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->postJson("/api/products/{$this->product->id}/update", [
            'name'        => 'Tidak Bisa',
            'category_id' => $this->category->id,
            'buy_price'   => 50000,
            'sell_price'  => 75000,
            'sku'         => 'RC-CAT-001',
        ]);

        $response->assertStatus(403);
    }

    // ─── Delete Product ──────────────────────────────────────────────────────────

    /** @test */
    public function owner_can_soft_delete_product()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->deleteJson("/api/products/{$this->product->id}");

        $response->assertStatus(200)
            ->assertJsonPath('status', true);

        // Soft deleted — still in DB but not findable normally
        $this->assertSoftDeleted('products', ['id' => $this->product->id]);
    }

    /** @test */
    public function kasir_cannot_delete_product()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->deleteJson("/api/products/{$this->product->id}");

        $response->assertStatus(403);
    }

    // ─── Categories ──────────────────────────────────────────────────────────────

    /** @test */
    public function authenticated_user_can_list_categories()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->getJson('/api/categories');

        $response->assertStatus(200)
            ->assertJsonPath('status', true)
            ->assertJsonCount(1, 'data');
    }

    /** @test */
    public function owner_can_create_category()
    {
        Sanctum::actingAs($this->owner);

        $response = $this->postJson('/api/categories', [
            'name'         => 'Aksesoris Anjing',
            'animal_type'  => 'dog',
            'sub_category' => 'accessories',
        ]);

        $response->assertStatus(201)
            ->assertJsonPath('status', true);
    }

    /** @test */
    public function kasir_cannot_create_category()
    {
        Sanctum::actingAs($this->kasir);

        $response = $this->postJson('/api/categories', [
            'name'        => 'Test Kategori',
            'animal_type' => 'cat',
        ]);

        $response->assertStatus(403);
    }
}
