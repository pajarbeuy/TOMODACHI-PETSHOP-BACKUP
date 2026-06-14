<?php

namespace Tests\Unit;

use App\Models\Category;
use App\Models\Product;
use App\Models\Role;
use App\Models\Stock;
use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\Support\BuildsPetShopData;
use Tests\TestCase;

class ModelRelationshipTest extends TestCase
{
    use BuildsPetShopData;
    use RefreshDatabase;

    public function test_role_has_many_users(): void
    {
        $role = $this->role('owner');
        $this->userWithRole('owner');

        $this->assertInstanceOf(User::class, $role->users()->first());
    }

    public function test_user_belongs_to_role(): void
    {
        $user = $this->userWithRole('kasir');

        $this->assertInstanceOf(Role::class, $user->role);
        $this->assertSame('kasir', $user->role->name);
    }

    public function test_category_has_many_products(): void
    {
        $category = $this->category();
        $this->product([], $category);

        $this->assertInstanceOf(Product::class, $category->products()->first());
    }

    public function test_product_belongs_to_category(): void
    {
        $category = $this->category(['name' => 'Cat Food']);
        $product = $this->product([], $category);

        $this->assertSame('Cat Food', $product->category->name);
    }

    public function test_product_has_one_stock(): void
    {
        $product = $this->product(['offline_qty' => 7]);

        $this->assertInstanceOf(Stock::class, $product->stock);
        $this->assertSame(7, $product->stock->offline_qty);
    }

    public function test_stock_belongs_to_product(): void
    {
        $product = $this->product(['name' => 'Stock Product']);

        $this->assertSame('Stock Product', $product->stock->product->name);
    }

    public function test_transaction_belongs_to_cashier(): void
    {
        $cashier = $this->userWithRole('kasir', ['name' => 'Cashier Test']);
        $transaction = $this->transaction($cashier);

        $this->assertSame('Cashier Test', $transaction->cashier->name);
    }

    public function test_transaction_has_many_items(): void
    {
        $cashier = $this->userWithRole('kasir');
        $transaction = $this->transaction($cashier);
        $this->transactionItem($transaction, $this->product());

        $this->assertInstanceOf(TransactionItem::class, $transaction->items()->first());
    }

    public function test_transaction_item_belongs_to_transaction(): void
    {
        $cashier = $this->userWithRole('kasir');
        $transaction = $this->transaction($cashier, ['transaction_code' => 'TRX-REL-001']);
        $item = $this->transactionItem($transaction, $this->product());

        $this->assertSame('TRX-REL-001', $item->transaction->transaction_code);
    }

    public function test_transaction_item_belongs_to_product(): void
    {
        $cashier = $this->userWithRole('kasir');
        $product = $this->product(['name' => 'Item Product']);
        $item = $this->transactionItem($this->transaction($cashier), $product);

        $this->assertSame('Item Product', $item->product->name);
    }

    public function test_product_soft_deletes(): void
    {
        $product = $this->product();

        $product->delete();

        $this->assertNotNull(Product::withTrashed()->find($product->id)->deleted_at);
    }

    public function test_stock_last_updated_casts_to_datetime(): void
    {
        $product = $this->product();

        $this->assertTrue(method_exists($product->stock->last_updated, 'toIso8601String'));
    }

    public function test_transaction_midtrans_payload_casts_to_array(): void
    {
        $transaction = $this->transaction($this->userWithRole('kasir'), [
            'midtrans_payload' => ['transaction_status' => 'settlement'],
        ]);

        $this->assertSame('settlement', $transaction->fresh()->midtrans_payload['transaction_status']);
    }

    public function test_transaction_money_fields_cast_to_decimal_strings(): void
    {
        $transaction = $this->transaction($this->userWithRole('kasir'), [
            'total' => 12345.67,
        ]);

        $this->assertSame('12345.67', $transaction->fresh()->total);
    }

    public function test_category_fillable_fields_can_be_mass_assigned(): void
    {
        $category = Category::create([
            'name' => 'Mass Category',
            'animal_type' => 'bird',
            'sub_category' => 'food',
            'description' => 'Mass assigned',
        ]);

        $this->assertSame('bird', $category->animal_type);
    }
}
