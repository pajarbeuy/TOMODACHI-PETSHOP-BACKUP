<?php

namespace App\Services;

use App\Models\Stock;
use App\Models\Product;
use Illuminate\Support\Facades\DB;

/**
 * RestockAnalysisService
 *
 * Menerapkan formula restock dari CODEX.md:
 *   avg_daily_sales      = total_qty_sold_last_30_days / 30
 *   predicted_need_7days = avg_daily_sales * 7
 *   status               = current_stock < predicted_need_7days ? "RESTOCK" : "SAFE"
 *
 * Laravel adalah yang menghitung — LLM hanya menjelaskan hasilnya.
 */
class RestockAnalysisService
{
    /**
     * Menganalisis semua produk dan mengembalikan rekomendasi restock.
     *
     * @return array<int, array{
     *   product_id: int,
     *   product_name: string,
     *   sku: string,
     *   current_stock: int,
     *   avg_daily_sales: float,
     *   predicted_need_7days: float,
     *   status: 'RESTOCK'|'SAFE'
     * }>
     */
    public function getRestockAnalysis(): array
    {
        $thirtyDaysAgo = now()->subDays(30)->toDateString();

        // Hitung total qty terjual per produk dalam 30 hari terakhir
        $salesData = DB::table('transaction_items')
            ->join('transactions', 'transaction_items.transaction_id', '=', 'transactions.id')
            ->where('transactions.status', 'completed')
            ->where('transactions.created_at', '>=', $thirtyDaysAgo)
            ->select(
                'transaction_items.product_id',
                DB::raw('SUM(transaction_items.quantity) as total_qty_sold')
            )
            ->groupBy('transaction_items.product_id')
            ->pluck('total_qty_sold', 'product_id')
            ->toArray();

        // Ambil semua produk beserta stok dan kategori
        $products = Product::with(['stock', 'category'])
            ->whereNull('deleted_at')
            ->get();

        $results = [];

        foreach ($products as $product) {
            $currentStock = ($product->stock?->offline_qty ?? 0)
                          + ($product->stock?->online_qty  ?? 0);

            $totalSold30Days = $salesData[$product->id] ?? 0;

            $avgDailySales      = $totalSold30Days / 30;
            $predictedNeed7Days = $avgDailySales * 7;

            $status = $currentStock < $predictedNeed7Days ? 'RESTOCK' : 'SAFE';

            $results[] = [
                'product_id'          => $product->id,
                'product_name'        => $product->name,
                'sku'                 => $product->sku,
                'category'            => $product->category?->name ?? 'N/A',
                'current_stock'       => $currentStock,
                'total_sold_30_days'  => (int) $totalSold30Days,
                'avg_daily_sales'     => round($avgDailySales, 2),
                'predicted_need_7days'=> round($predictedNeed7Days, 2),
                'status'              => $status,
                'min_threshold'       => $product->stock?->min_threshold ?? 0,
            ];
        }

        // Urutkan: RESTOCK dulu, lalu berdasarkan nama
        usort($results, function ($a, $b) {
            if ($a['status'] !== $b['status']) {
                return $a['status'] === 'RESTOCK' ? -1 : 1;
            }
            return strcmp($a['product_name'], $b['product_name']);
        });

        return $results;
    }

    /**
     * Hanya produk yang perlu direstock
     */
    public function getProductsNeedingRestock(): array
    {
        return array_filter(
            $this->getRestockAnalysis(),
            fn ($p) => $p['status'] === 'RESTOCK'
        );
    }
}
