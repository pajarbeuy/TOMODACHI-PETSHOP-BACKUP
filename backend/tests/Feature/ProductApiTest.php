<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Support\BuildsPetShopData;
use Tests\TestCase;

class ProductApiTest extends TestCase
{
    use BuildsPetShopData;
    use RefreshDatabase;

    public function test_authenticated_user_can_list_products(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $this->product(['name' => 'Cat Food Tuna']);

        $this->getJson('/api/products')
            ->assertOk()
            ->assertJsonPath('status', true)
            ->assertJsonCount(1, 'data');
    }

    public function test_product_search_filters_by_name(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $this->product(['name' => 'Tuna Cat Food', 'sku' => 'TUNA-CAT']);
        $this->product(['name' => 'Dog Collar', 'sku' => 'DOG-COLLAR']);

        $this->getJson('/api/products?search=Tuna')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.name', 'Tuna Cat Food');
    }

    public function test_product_filter_by_category_id(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $cat = $this->category(['name' => 'Cat Food']);
        $dog = $this->category(['name' => 'Dog Food', 'animal_type' => 'dog']);
        $this->product(['name' => 'Cat Product'], $cat);
        $this->product(['name' => 'Dog Product'], $dog);

        $this->getJson("/api/products?category_id={$dog->id}")
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.name', 'Dog Product');
    }

    public function test_product_filter_by_animal_type_and_sub_category(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $food = $this->category(['name' => 'Cat Food', 'animal_type' => 'cat', 'sub_category' => 'food']);
        $medicine = $this->category(['name' => 'Cat Medicine', 'animal_type' => 'cat', 'sub_category' => 'medicine']);
        $this->product(['name' => 'Food Product'], $food);
        $this->product(['name' => 'Medicine Product'], $medicine);

        $this->getJson('/api/products?animal_type=cat&sub_category=medicine')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.name', 'Medicine Product');
    }

    public function test_in_stock_filter_uses_offline_channel(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $this->product(['name' => 'Available', 'offline_qty' => 3]);
        $this->product(['name' => 'Unavailable', 'offline_qty' => 0]);

        $this->getJson('/api/products?in_stock=true&channel=offline')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.name', 'Available');
    }

    public function test_in_stock_filter_uses_online_channel(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $this->product(['name' => 'Online Available', 'online_qty' => 2]);
        $this->product(['name' => 'Online Empty', 'online_qty' => 0]);

        $this->getJson('/api/products?in_stock=true&channel=online')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.name', 'Online Available');
    }

    public function test_kasir_product_list_hides_buy_price_and_margin(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $this->product();

        $this->getJson('/api/products')
            ->assertOk()
            ->assertJsonMissingPath('data.0.buy_price')
            ->assertJsonMissingPath('data.0.margin_percentage');
    }

    public function test_owner_product_list_includes_buy_price_and_margin(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));
        $this->product();

        $this->getJson('/api/products')
            ->assertOk()
            ->assertJsonStructure(['data' => [['buy_price', 'margin_percentage']]]);
    }

    public function test_authenticated_user_can_show_product_detail(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $product = $this->product(['name' => 'Detail Product']);

        $this->getJson("/api/products/{$product->id}")
            ->assertOk()
            ->assertJsonPath('data.name', 'Detail Product');
    }

    public function test_show_product_returns_404_for_missing_product(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));

        $this->getJson('/api/products/999')->assertNotFound();
    }

    public function test_owner_can_create_product_with_stock(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));
        $category = $this->category();

        $this->postJson('/api/products', $this->productPayload($category->id, [
            'name' => 'Created Product',
            'sku' => 'CREATED-PRODUCT',
        ]))
            ->assertCreated()
            ->assertJsonPath('data.name', 'Created Product')
            ->assertJsonPath('data.stock.offline_qty', 8);
    }

    public function test_create_product_rejects_sell_price_below_cost_without_confirmation(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));
        $category = $this->category();

        $this->postJson('/api/products', $this->productPayload($category->id, [
            'buy_price' => 100000,
            'sell_price' => 90000,
        ]))->assertUnprocessable();
    }

    public function test_create_product_accepts_sell_price_below_cost_with_confirmation(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));
        $category = $this->category();

        $this->postJson('/api/products', $this->productPayload($category->id, [
            'buy_price' => 100000,
            'sell_price' => 90000,
            'confirm_price_below_cost' => true,
        ]))->assertCreated();
    }

    public function test_admin_can_update_product_and_stock(): void
    {
        Sanctum::actingAs($this->userWithRole('admin'));
        $category = $this->category();
        $product = $this->product([], $category);

        $this->putJson("/api/products/{$product->id}", $this->productPayload($category->id, [
            'name' => 'Updated Product',
            'sku' => $product->sku,
            'offline_qty' => 12,
            'online_qty' => 9,
        ]))
            ->assertOk()
            ->assertJsonPath('data.name', 'Updated Product')
            ->assertJsonPath('data.stock.offline_qty', 12);
    }

    public function test_post_update_route_updates_product(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));
        $category = $this->category();
        $product = $this->product([], $category);

        $this->postJson("/api/products/{$product->id}/update", $this->productPayload($category->id, [
            'name' => 'Post Updated Product',
            'sku' => $product->sku,
        ]))
            ->assertOk()
            ->assertJsonPath('data.name', 'Post Updated Product');
    }

    public function test_owner_can_soft_delete_product(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));
        $product = $this->product();

        $this->deleteJson("/api/products/{$product->id}")
            ->assertOk()
            ->assertJsonPath('status', true);

        $this->assertSoftDeleted('products', ['id' => $product->id]);
    }

    private function productPayload(int $categoryId, array $overrides = []): array
    {
        return array_merge([
            'name' => 'Payload Product',
            'category_id' => $categoryId,
            'buy_price' => 50000,
            'sell_price' => 75000,
            'sku' => 'PAYLOAD-' . strtoupper(uniqid()),
            'description' => 'Payload description',
            'offline_qty' => 8,
            'online_qty' => 4,
            'min_threshold' => 2,
        ], $overrides);
    }
}
