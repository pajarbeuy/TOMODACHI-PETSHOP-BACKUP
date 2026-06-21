<?php

namespace Tests\Support;

use App\Models\Category;
use App\Models\Product;
use App\Models\Role;
use App\Models\Stock;
use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

trait BuildsPetShopData
{
    protected function role(string $name): Role
    {
        return Role::firstOrCreate(['name' => $name]);
    }

    protected function userWithRole(string $roleName, array $attributes = []): User
    {
        $role = $this->role($roleName);
        $email = $attributes['email'] ?? $roleName . uniqid('', true) . '@test.local';

        return User::create(array_merge([
            'name' => ucfirst($roleName) . ' User',
            'email' => $email,
            'password' => Hash::make('password123'),
            'role_id' => $role->id,
            'email_verified_at' => now(),
        ], $attributes, ['email' => $email, 'role_id' => $attributes['role_id'] ?? $role->id]));
    }

    protected function category(array $attributes = []): Category
    {
        return Category::create(array_merge([
            'name' => 'Makanan Kucing ' . uniqid(),
            'animal_type' => 'cat',
            'sub_category' => 'food',
            'description' => 'Kategori test',
        ], $attributes));
    }

    protected function product(array $attributes = [], ?Category $category = null): Product
    {
        $category ??= $this->category();

        $product = Product::create(array_merge([
            'category_id' => $category->id,
            'name' => 'Tomodachi Test Product ' . uniqid(),
            'sku' => 'SKU-' . strtoupper(uniqid()),
            'buy_price' => 40000,
            'sell_price' => 60000,
            'margin_percentage' => 50,
            'image_url' => null,
            'description' => 'Produk test',
        ], $attributes));

        Stock::create([
            'product_id' => $product->id,
            'offline_qty' => $attributes['offline_qty'] ?? 10,
            'online_qty' => $attributes['online_qty'] ?? 5,
            'min_threshold' => $attributes['min_threshold'] ?? 2,
            'last_updated' => now(),
        ]);

        return $product->fresh(['category', 'stock']);
    }

    protected function transaction(User $cashier, array $attributes = []): Transaction
    {
        return Transaction::create(array_merge([
            'kasir_id' => $cashier->id,
            'transaction_code' => 'TRX-' . now()->format('Ymd') . '-' . strtoupper(uniqid()),
            'channel' => 'offline',
            'subtotal' => 60000,
            'tax' => 0,
            'total' => 60000,
            'payment_method' => 'cash',
            'amount_paid' => 100000,
            'change_amount' => 40000,
            'status' => 'completed',
        ], $attributes));
    }

    protected function transactionItem(Transaction $transaction, Product $product, array $attributes = []): TransactionItem
    {
        return TransactionItem::create(array_merge([
            'transaction_id' => $transaction->id,
            'product_id' => $product->id,
            'quantity' => 1,
            'unit_price' => 60000,
            'subtotal' => 60000,
        ], $attributes));
    }
}
