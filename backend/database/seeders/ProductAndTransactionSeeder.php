<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class ProductAndTransactionSeeder extends Seeder
{
    public function run(): void
    {
        // ─── 1. Ambil semua category_id ───────────────────────────────────────
        $catFoodId        = DB::table('categories')->where('animal_type', 'cat') ->where('sub_category', 'food')     ->value('id');
        $catMedId         = DB::table('categories')->where('animal_type', 'cat') ->where('sub_category', 'medicine') ->value('id');
        $dogFoodId        = DB::table('categories')->where('animal_type', 'dog') ->where('sub_category', 'food')     ->value('id');
        $dogEquipmentId   = DB::table('categories')->where('animal_type', 'dog') ->where('sub_category', 'equipment')->value('id');
        $hamsterFoodId    = DB::table('categories')->where('animal_type', 'hamster')->where('sub_category', 'food')  ->value('id');
        $hamsterEquipId   = DB::table('categories')->where('animal_type', 'hamster')->where('sub_category', 'equipment')->value('id');
        $rabbitFoodId     = DB::table('categories')->where('animal_type', 'rabbit')->where('sub_category', 'food')  ->value('id');
        $fishEquipId      = DB::table('categories')->where('animal_type', 'fish') ->where('sub_category', 'equipment')->value('id');
        $birdFoodId       = DB::table('categories')->where('animal_type', 'bird') ->where('sub_category', 'food')   ->value('id');

        // ─── 2. Upsert 10 produk baru (beragam kategori) ─────────────────────
        DB::table('products')->upsert([
            // Makanan Kucing
            [
                'category_id'        => $catFoodId,
                'name'               => 'Whiskas Tuna Gravy 85g',
                'sku'                => 'CAT-WHISKAS-TUNA-85G',
                'buy_price'          => 6500,
                'sell_price'         => 10000,
                'margin_percentage'  => 53.85,
                'image_url'          => null,
                'description'        => 'Makanan basah kucing rasa tuna dengan saus gravy.',
                'created_at'         => now(),
                'updated_at'         => now(),
            ],
            // Obat Kucing
            [
                'category_id'        => $catMedId,
                'name'               => 'Drontal Cat Obat Cacing Kucing',
                'sku'                => 'CAT-MED-DRONTAL',
                'buy_price'          => 18000,
                'sell_price'         => 28000,
                'margin_percentage'  => 55.56,
                'image_url'          => null,
                'description'        => 'Obat cacing efektif untuk kucing dewasa, 1 tablet.',
                'created_at'         => now(),
                'updated_at'         => now(),
            ],
            // Makanan Anjing
            [
                'category_id'        => $dogFoodId,
                'name'               => 'Pedigree Adult Chicken & Veg 3kg',
                'sku'                => 'DOG-FOOD-PEDIGREE-3KG',
                'buy_price'          => 82000,
                'sell_price'         => 115000,
                'margin_percentage'  => 40.24,
                'image_url'          => null,
                'description'        => 'Makanan kering anjing dewasa rasa ayam & sayuran.',
                'created_at'         => now(),
                'updated_at'         => now(),
            ],
            // Perlengkapan Anjing
            [
                'category_id'        => $dogEquipmentId,
                'name'               => 'Tali Leash Anjing 120cm',
                'sku'                => 'DOG-LEASH-120CM',
                'buy_price'          => 22000,
                'sell_price'         => 38000,
                'margin_percentage'  => 72.73,
                'image_url'          => null,
                'description'        => 'Tali jalan anjing berbahan nylon kuat, panjang 120cm.',
                'created_at'         => now(),
                'updated_at'         => now(),
            ],
            // Makanan Hamster
            [
                'category_id'        => $hamsterFoodId,
                'name'               => 'Hamster Mix Seeds 500g',
                'sku'                => 'HAM-FOOD-SEEDS-500G',
                'buy_price'          => 12000,
                'sell_price'         => 20000,
                'margin_percentage'  => 66.67,
                'image_url'          => null,
                'description'        => 'Campuran biji-bijian bergizi untuk hamster, 500g.',
                'created_at'         => now(),
                'updated_at'         => now(),
            ],
            // Perlengkapan Hamster
            [
                'category_id'        => $hamsterEquipId,
                'name'               => 'Roda Lari Hamster Silent 20cm',
                'sku'                => 'HAM-EQUIP-WHEEL-20CM',
                'buy_price'          => 28000,
                'sell_price'         => 45000,
                'margin_percentage'  => 60.71,
                'image_url'          => null,
                'description'        => 'Roda lari hamster senyap, diameter 20cm.',
                'created_at'         => now(),
                'updated_at'         => now(),
            ],
            // Makanan Kelinci
            [
                'category_id'        => $rabbitFoodId,
                'name'               => 'Timothy Hay Premium 500g',
                'sku'                => 'RAB-FOOD-TIMOTHY-500G',
                'buy_price'          => 22000,
                'sell_price'         => 35000,
                'margin_percentage'  => 59.09,
                'image_url'          => null,
                'description'        => 'Jerami timothy premium sebagai pakan utama kelinci.',
                'created_at'         => now(),
                'updated_at'         => now(),
            ],
            // Perlengkapan Ikan
            [
                'category_id'        => $fishEquipId,
                'name'               => 'Filter Aquarium Hang On 300L/H',
                'sku'                => 'FISH-EQUIP-FILTER-300',
                'buy_price'          => 48000,
                'sell_price'         => 75000,
                'margin_percentage'  => 56.25,
                'image_url'          => null,
                'description'        => 'Filter gantung akuarium kapasitas 300 liter per jam.',
                'created_at'         => now(),
                'updated_at'         => now(),
            ],
            // Makanan Burung
            [
                'category_id'        => $birdFoodId,
                'name'               => 'Pakan Kenari Milet Putih 500g',
                'sku'                => 'BIRD-FOOD-MILET-500G',
                'buy_price'          => 9000,
                'sell_price'         => 15000,
                'margin_percentage'  => 66.67,
                'image_url'          => null,
                'description'        => 'Biji milet putih pilihan untuk burung kenari & parkit.',
                'created_at'         => now(),
                'updated_at'         => now(),
            ],
            // Makanan Kucing (premium, kategori berbeda dari produk pertama)
            [
                'category_id'        => $catFoodId,
                'name'               => 'Royal Canin Indoor Cat 2kg',
                'sku'                => 'CAT-RC-INDOOR-2KG',
                'buy_price'          => 135000,
                'sell_price'         => 185000,
                'margin_percentage'  => 37.04,
                'image_url'          => null,
                'description'        => 'Makanan kering premium untuk kucing yang tinggal di dalam ruangan.',
                'created_at'         => now(),
                'updated_at'         => now(),
            ],
        ], ['sku'], ['category_id', 'name', 'buy_price', 'sell_price', 'margin_percentage', 'description', 'updated_at']);

        // ─── 3. Upsert stok untuk 10 produk baru ─────────────────────────────
        $newSkus = [
            'CAT-WHISKAS-TUNA-85G'  => [50, 30,  10],
            'CAT-MED-DRONTAL'       => [20, 15,   5],
            'DOG-FOOD-PEDIGREE-3KG' => [30, 20,   8],
            'DOG-LEASH-120CM'       => [25, 10,   5],
            'HAM-FOOD-SEEDS-500G'   => [40, 20,   8],
            'HAM-EQUIP-WHEEL-20CM'  => [15, 10,   3],
            'RAB-FOOD-TIMOTHY-500G' => [30, 15,   5],
            'FISH-EQUIP-FILTER-300' => [12,  8,   3],
            'BIRD-FOOD-MILET-500G'  => [45, 25,  10],
            'CAT-RC-INDOOR-2KG'     => [20, 12,   5],
        ];

        foreach ($newSkus as $sku => [$offline, $online, $minThres]) {
            $productId = DB::table('products')->where('sku', $sku)->value('id');
            if ($productId) {
                DB::table('stocks')->upsert([
                    [
                        'product_id'    => $productId,
                        'offline_qty'   => $offline,
                        'online_qty'    => $online,
                        'min_threshold' => $minThres,
                        'last_updated'  => now(),
                        'created_at'    => now(),
                        'updated_at'    => now(),
                    ],
                ], ['product_id'], ['offline_qty', 'online_qty', 'min_threshold', 'last_updated', 'updated_at']);
            }
        }

        // ─── 4. Generate transaksi dummy Mar-May 2026 (>100 per bulan, random) ─────
        $allProductIds = DB::table('products')->pluck('sell_price', 'id')->toArray();
        if (empty($allProductIds)) {
            $this->command->warn('Tidak ada produk ditemukan, transaksi tidak dibuat.');
            return;
        }

        $kasirId   = DB::table('users')->where('email', 'kasir@tomodachi.com')->value('id');
        $channels  = ['offline', 'offline', 'offline', 'online'];   // offline lebih dominan
        $payMethods= ['cash', 'cash', 'qris', 'transfer'];

        DB::table('transactions')
            ->where(function ($query) {
                $query->where('transaction_code', 'like', 'DMY-202603%')
                    ->orWhere('transaction_code', 'like', 'DMY-202604%')
                    ->orWhere('transaction_code', 'like', 'DMY-202605%');
            })
            ->delete();

        // Bulan: Mar, Apr, May 2026
        $months = [
            ['start' => Carbon::create(2026, 3,  1, 0, 0, 0), 'end' => Carbon::create(2026, 3, 31, 23, 59, 59), 'count' => 125],
            ['start' => Carbon::create(2026, 4,  1, 0, 0, 0), 'end' => Carbon::create(2026, 4, 30, 23, 59, 59), 'count' => 135],
            ['start' => Carbon::create(2026, 5,  1, 0, 0, 0), 'end' => Carbon::create(2026, 5, 31, 23, 59, 59), 'count' => 145],
        ];

        $txCounter = DB::table('transactions')->max('id') ?? 0; // hindari duplikat kode
        $productList = array_keys($allProductIds);

        foreach ($months as $month) {
            $txCount = $month['count'];

            // Generate timestamp acak di dalam rentang bulan
            $timestamps = [];
            for ($i = 0; $i < $txCount; $i++) {
                $timestamps[] = Carbon::createFromTimestamp(
                    rand($month['start']->timestamp, $month['end']->timestamp)
                );
            }
            sort($timestamps); // urutkan agar data terlihat kronologis

            foreach ($timestamps as $ts) {
                $txCounter++;
                $channel    = $channels[array_rand($channels)];
                $payMethod  = $payMethods[array_rand($payMethods)];

                // Jika online, payment_method wajib qris/transfer
                if ($channel === 'online') {
                    $payMethod = (rand(0, 1) === 0) ? 'qris' : 'transfer';
                }

                $txCode = 'DMY-' . $ts->format('Ymd') . '-' . str_pad($txCounter, 5, '0', STR_PAD_LEFT);

                // Pilih 1–3 produk acak
                $numItems    = rand(1, 3);
                $pickedProds = (array) array_rand($allProductIds, min($numItems, count($allProductIds)));
                $subtotal    = 0;
                $itemsToInsert = [];

                foreach ($pickedProds as $pid) {
                    $unitPrice = $allProductIds[$pid];
                    $qty       = rand(1, 4);
                    $itemSub   = $unitPrice * $qty;
                    $subtotal += $itemSub;

                    $itemsToInsert[] = [
                        'product_id' => $pid,
                        'quantity'   => $qty,
                        'unit_price' => $unitPrice,
                        'subtotal'   => $itemSub,
                    ];
                }

                $tax    = round($subtotal * 0.00); // toko belum kenakan pajak
                $total  = $subtotal + $tax;
                $amtPaid= ($payMethod === 'cash')
                    ? $total + rand(0, 1) * (ceil($total / 5000) * 5000 - $total) // kembalian bulat
                    : $total;
                $change = $amtPaid - $total;

                $txId = DB::table('transactions')->insertGetId([
                    'kasir_id'       => $kasirId,
                    'transaction_code' => $txCode,
                    'channel'        => $channel,
                    'subtotal'       => $subtotal,
                    'tax'            => $tax,
                    'total'          => $total,
                    'payment_method' => $payMethod,
                    'amount_paid'    => $amtPaid,
                    'change_amount'  => $change,
                    'status'         => 'completed',
                    'created_at'     => $ts,
                    'updated_at'     => $ts,
                ]);

                foreach ($itemsToInsert as &$item) {
                    $item['transaction_id'] = $txId;
                    $item['created_at']     = $ts;
                    $item['updated_at']     = $ts;
                }
                unset($item);

                DB::table('transaction_items')->insert($itemsToInsert);
            }

            $monthName = $month['start']->format('F Y');
            $this->command->info("✅  {$monthName}: {$txCount} transaksi berhasil dibuat.");
        }

        $this->command->info('🎉  Seeding selesai!');
    }
}
