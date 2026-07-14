<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Models\User;
use App\Models\Role;
use App\Models\Product;
use App\Models\Category;
use App\Notifications\LowStockAlert;
use Illuminate\Support\Facades\Notification;

class LowStockNotificationTest extends TestCase
{
    use RefreshDatabase;

    protected $owner;
    protected $kasir;
    protected $product;
    protected $category;

    protected function setUp(): void
    {
        parent::setUp();

        $ownerRole = Role::create(['name' => 'owner']);
        $kasirRole = Role::create(['name' => 'kasir']);

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

        $this->category = Category::create([
            'name' => 'Makanan Kucing',
            'animal_type' => 'cat',
            'sub_category' => 'food',
            'description' => 'Kategori test',
        ]);

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
            'min_threshold' => 3,
            'last_updated' => now(),
        ]);
    }

    /** @test */
    public function it_sends_notification_only_when_stock_drops_below_threshold()
    {
        Notification::fake();

        // 1. Initial State: Stock is 10 (above threshold 3). We update it to 4. Still above 3.
        $this->product->stock->update(['offline_qty' => 4]);
        Notification::assertNothingSent();

        // 2. Cross threshold: Update offline_qty to 3 (equal to threshold 3). Should send alert.
        $this->product->stock->update(['offline_qty' => 3]);
        Notification::assertSentTo(
            [$this->owner],
            LowStockAlert::class,
            function ($notification) {
                return $notification->type === 'offline';
            }
        );

        // Reset fake for next assertion
        Notification::fake();

        // 3. Prevent Spam: Update offline_qty from 3 to 2 (already low). Should not send alert again.
        $this->product->stock->update(['offline_qty' => 2]);
        Notification::assertNothingSent();
    }
}
