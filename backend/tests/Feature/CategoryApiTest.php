<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\Support\BuildsPetShopData;
use Tests\TestCase;

class CategoryApiTest extends TestCase
{
    use BuildsPetShopData;
    use RefreshDatabase;

    public function test_authenticated_user_can_list_categories(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $this->category(['name' => 'Food A', 'animal_type' => 'cat']);

        $this->getJson('/api/categories')
            ->assertOk()
            ->assertJsonPath('status', true)
            ->assertJsonCount(1, 'data');
    }

    public function test_categories_are_ordered_by_animal_type_then_sub_category(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $this->category(['name' => 'Dog Food', 'animal_type' => 'dog', 'sub_category' => 'food']);
        $this->category(['name' => 'Cat Equipment', 'animal_type' => 'cat', 'sub_category' => 'equipment']);

        $this->getJson('/api/categories')
            ->assertOk()
            ->assertJsonPath('data.0.animal_type', 'cat');
    }

    public function test_authenticated_user_can_show_category(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $category = $this->category(['name' => 'Obat Kucing']);

        $this->getJson("/api/categories/{$category->id}")
            ->assertOk()
            ->assertJsonPath('data.name', 'Obat Kucing');
    }

    public function test_show_returns_404_for_missing_category(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));

        $this->getJson('/api/categories/999')->assertNotFound();
    }

    public function test_owner_can_create_category(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));

        $this->postJson('/api/categories', [
            'name' => 'Perlengkapan Burung',
            'animal_type' => 'bird',
            'sub_category' => 'equipment',
            'description' => 'Perlengkapan kandang burung',
        ])
            ->assertCreated()
            ->assertJsonPath('data.animal_type', 'bird');
    }

    public function test_admin_can_create_category(): void
    {
        Sanctum::actingAs($this->userWithRole('admin'));

        $this->postJson('/api/categories', [
            'name' => 'Makanan Ikan',
            'animal_type' => 'fish',
            'sub_category' => 'food',
        ])->assertCreated();
    }

    public function test_create_category_requires_required_fields(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));

        $this->postJson('/api/categories', [])->assertUnprocessable();
    }

    public function test_owner_can_update_category(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));
        $category = $this->category();

        $this->putJson("/api/categories/{$category->id}", [
            'name' => 'Makanan Kucing Premium',
            'animal_type' => 'cat',
            'sub_category' => 'food',
            'description' => 'Premium',
        ])
            ->assertOk()
            ->assertJsonPath('data.name', 'Makanan Kucing Premium');
    }

    public function test_patch_category_uses_same_update_validation(): void
    {
        Sanctum::actingAs($this->userWithRole('admin'));
        $category = $this->category();

        $this->patchJson("/api/categories/{$category->id}", [
            'name' => 'Updated',
            'animal_type' => 'cat',
            'sub_category' => 'medicine',
        ])->assertOk();
    }

    public function test_update_category_returns_404_for_missing_category(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));

        $this->putJson('/api/categories/999', [
            'name' => 'Missing',
            'animal_type' => 'cat',
            'sub_category' => 'food',
        ])->assertNotFound();
    }

    public function test_owner_can_delete_category(): void
    {
        Sanctum::actingAs($this->userWithRole('owner'));
        $category = $this->category();

        $this->deleteJson("/api/categories/{$category->id}")
            ->assertOk()
            ->assertJsonPath('status', true);

        $this->assertDatabaseMissing('categories', ['id' => $category->id]);
    }

    public function test_grouped_product_categories_returns_grouped_payload(): void
    {
        Sanctum::actingAs($this->userWithRole('kasir'));
        $this->category(['name' => 'Makanan Kucing', 'animal_type' => 'cat', 'sub_category' => 'food']);
        $this->category(['name' => 'Obat Kucing', 'animal_type' => 'cat', 'sub_category' => 'medicine']);

        $this->getJson('/api/products/categories')
            ->assertOk()
            ->assertJsonPath('data.0.animal_type', 'cat')
            ->assertJsonCount(2, 'data.0.sub_categories');
    }
}
