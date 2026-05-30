<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\Role;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Seed roles
        DB::table('roles')->upsert([
            ['name' => 'owner', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'kasir', 'created_at' => now(), 'updated_at' => now()],
            ['name' => 'admin', 'created_at' => now(), 'updated_at' => now()],
        ], ['name'], ['updated_at']);

        // Seed test users
        $ownerRole = Role::where('name', 'owner')->first();
        $kasirRole = Role::where('name', 'kasir')->first();
        $adminRole = Role::where('name', 'admin')->first();

        if ($ownerRole && $kasirRole && $adminRole) {
            User::updateOrCreate(
                ['email' => 'owner@tomodachi.com'],
                [
                    'name' => 'Pak Heri',
                    'password' => Hash::make('password123'),
                    'role_id' => $ownerRole->id,
                ]
            );

            User::updateOrCreate(
                ['email' => 'kasir@tomodachi.com'],
                [
                    'name' => 'Budi Santoso',
                    'password' => Hash::make('password123'),
                    'role_id' => $kasirRole->id,
                ]
            );

            User::updateOrCreate(
                ['email' => 'admin@tomodachi.com'],
                [
                    'name' => 'Admin Utama',
                    'password' => Hash::make('password123'),
                    'role_id' => $adminRole->id,
                ]
            );
        }

        DB::table('categories')->upsert([
            [
                'name' => 'Makanan Kucing',
                'animal_type' => 'cat',
                'sub_category' => 'food',
                'description' => 'Produk makanan untuk kucing.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Perlengkapan Anjing',
                'animal_type' => 'dog',
                'sub_category' => 'equipment',
                'description' => 'Aksesori dan perlengkapan untuk anjing.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Obat Kucing',
                'animal_type' => 'cat',
                'sub_category' => 'medicine',
                'description' => 'Vitamin, obat, dan perawatan kesehatan untuk kucing.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Makanan Anjing',
                'animal_type' => 'dog',
                'sub_category' => 'food',
                'description' => 'Produk makanan untuk anjing.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Makanan Hamster',
                'animal_type' => 'hamster',
                'sub_category' => 'food',
                'description' => 'Produk makanan untuk hamster.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Perlengkapan Hamster',
                'animal_type' => 'hamster',
                'sub_category' => 'equipment',
                'description' => 'Kandang, mainan, dan perlengkapan hamster.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Makanan Kelinci',
                'animal_type' => 'rabbit',
                'sub_category' => 'food',
                'description' => 'Produk makanan untuk kelinci.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Perlengkapan Ikan',
                'animal_type' => 'fish',
                'sub_category' => 'equipment',
                'description' => 'Akuarium, filter, dan perlengkapan ikan.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Makanan Burung',
                'animal_type' => 'bird',
                'sub_category' => 'food',
                'description' => 'Produk makanan untuk burung.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ], ['animal_type', 'sub_category', 'name'], ['description', 'updated_at']);

        $catFoodId = DB::table('categories')
            ->where('animal_type', 'cat')
            ->where('sub_category', 'food')
            ->where('name', 'Makanan Kucing')
            ->value('id');

        $dogEquipmentId = DB::table('categories')
            ->where('animal_type', 'dog')
            ->where('sub_category', 'equipment')
            ->where('name', 'Perlengkapan Anjing')
            ->value('id');

        DB::table('products')->upsert([
            [
                'category_id' => $catFoodId,
                'name' => 'Tomodachi Cat Food Tuna 1kg',
                'sku' => 'CAT-FOOD-TUNA-1KG',
                'buy_price' => 42000,
                'sell_price' => 55000,
                'margin_percentage' => 30.95,
                'image_url' => null,
                'description' => 'Makanan kucing rasa tuna ukuran 1kg.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'category_id' => $dogEquipmentId,
                'name' => 'Kalung Anjing Adjustable',
                'sku' => 'DOG-COLLAR-ADJ',
                'buy_price' => 18000,
                'sell_price' => 30000,
                'margin_percentage' => 66.67,
                'image_url' => null,
                'description' => 'Kalung anjing ukuran adjustable.',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ], ['sku'], ['category_id', 'name', 'buy_price', 'sell_price', 'margin_percentage', 'description', 'updated_at']);

        $catFoodProductId = DB::table('products')->where('sku', 'CAT-FOOD-TUNA-1KG')->value('id');
        $dogCollarProductId = DB::table('products')->where('sku', 'DOG-COLLAR-ADJ')->value('id');

        DB::table('stocks')->upsert([
            [
                'product_id' => $catFoodProductId,
                'offline_qty' => 24,
                'online_qty' => 12,
                'min_threshold' => 5,
                'last_updated' => now(),
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'product_id' => $dogCollarProductId,
                'offline_qty' => 10,
                'online_qty' => 4,
                'min_threshold' => 3,
                'last_updated' => now(),
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ], ['product_id'], ['offline_qty', 'online_qty', 'min_threshold', 'last_updated', 'updated_at']);

        // \App\Models\User::factory(10)->create();

        // \App\Models\User::factory()->create([
        //     'name' => 'Test User',
        //     'email' => 'test@example.com',
        // ]);
    }
}
