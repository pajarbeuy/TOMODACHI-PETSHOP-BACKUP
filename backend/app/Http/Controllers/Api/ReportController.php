<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use App\Models\TransactionItem;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ReportController extends Controller
{
    /**
     * Get aggregate sales report for Owner.
     * GET /api/reports/sales
     */
    public function salesReport(Request $request)
    {
        $request->validate([
            'start_date' => 'required|date',
            'end_date' => 'required|date',
        ]);

        $startDate = $request->query('start_date');
        $endDate = $request->query('end_date');
        $channel = $request->query('channel', 'all');

        $query = Transaction::whereDate('created_at', '>=', $startDate)
            ->whereDate('created_at', '<=', $endDate)
            ->where('status', 'completed');

        if ($channel !== 'all' && in_array($channel, ['offline', 'online'])) {
            $query->where('channel', $channel);
        }

        // Summary details
        $totalTransactions = $query->count();
        $totalRevenue = floatval($query->sum('total'));

        // Count item quantities sold
        $transactionIds = $query->pluck('id');
        $totalItemsSold = intval(TransactionItem::whereIn('transaction_id', $transactionIds)->sum('quantity'));

        $averageTransactionValue = $totalTransactions > 0 ? $totalRevenue / $totalTransactions : 0;

        // Channel breakouts
        $offlineQuery = Transaction::whereDate('created_at', '>=', $startDate)
            ->whereDate('created_at', '<=', $endDate)
            ->where('status', 'completed')
            ->where('channel', 'offline');

        $onlineQuery = Transaction::whereDate('created_at', '>=', $startDate)
            ->whereDate('created_at', '<=', $endDate)
            ->where('status', 'completed')
            ->where('channel', 'online');

        $data = [
            'period' => [
                'start_date' => $startDate,
                'end_date' => $endDate,
            ],
            'summary' => [
                'total_transactions' => $totalTransactions,
                'total_revenue' => $totalRevenue,
                'total_items_sold' => $totalItemsSold,
                'average_transaction_value' => round($averageTransactionValue, 2),
            ],
            'by_channel' => [
                'offline' => [
                    'total_transactions' => $offlineQuery->count(),
                    'total_revenue' => floatval($offlineQuery->sum('total')),
                ],
                'online' => [
                    'total_transactions' => $onlineQuery->count(),
                    'total_revenue' => floatval($onlineQuery->sum('total')),
                ]
            ]
        ];

        return response()->json([
            'status' => true,
            'message' => 'Sales report retrieved',
            'data' => $data
        ], 200);
    }

    /**
     * Get sequential daily/weekly sales summary.
     * GET /api/reports/sales/summary
     */
    public function salesSummary(Request $request)
    {
        $request->validate([
            'period' => 'required|in:daily,weekly,monthly',
            'year' => 'required|integer',
        ]);

        $period = $request->query('period');
        $year = $request->query('year');
        $month = $request->query('month');

        $query = Transaction::whereYear('created_at', $year)
            ->where('status', 'completed');

        if ($period === 'monthly' && !empty($month)) {
            $query->whereMonth('created_at', $month);
        }

        if ($period === 'daily') {
            if (!empty($month)) {
                $query->whereMonth('created_at', $month);
            }
            
            $results = $query->select(
                DB::raw('DATE(created_at) as date'),
                DB::raw('SUM(total) as total_revenue'),
                DB::raw('COUNT(id) as transaction_count'),
                DB::raw('(SELECT SUM(quantity) FROM transaction_items WHERE transaction_id IN (SELECT id FROM transactions WHERE DATE(created_at) = DATE(transactions.created_at) AND status = "completed")) as items_sold')
            )
            ->groupBy('date')
            ->orderBy('date', 'desc')
            ->get();
        } else {
            // General group
            $results = $query->select(
                DB::raw('DATE(created_at) as date'),
                DB::raw('SUM(total) as total_revenue'),
                DB::raw('COUNT(id) as transaction_count')
            )
            ->groupBy('date')
            ->orderBy('date', 'desc')
            ->get();
        }

        $formatted = $results->map(function ($item) {
            return [
                'date' => $item->date,
                'total_revenue' => floatval($item->total_revenue),
                'transaction_count' => intval($item->transaction_count),
                'items_sold' => intval($item->items_sold ?? 0),
            ];
        });

        return response()->json([
            'status' => true,
            'message' => 'Sales summary retrieved',
            'data' => $formatted
        ], 200);
    }

    /**
     * Get top products by sales performance.
     * GET /api/reports/top-products
     */
    public function topProducts(Request $request)
    {
        $sortBy = $request->query('sort_by', 'quantity'); // quantity or revenue
        $limit = intval($request->query('limit', 10));
        $startDate = $request->query('start_date');
        $endDate = $request->query('end_date');

        $query = TransactionItem::join('transactions', 'transaction_items.transaction_id', '=', 'transactions.id')
            ->join('products', 'transaction_items.product_id', '=', 'products.id')
            ->where('transactions.status', 'completed');

        if (!empty($startDate)) {
            $query->whereDate('transactions.created_at', '>=', $startDate);
        }
        if (!empty($endDate)) {
            $query->whereDate('transactions.created_at', '<=', $endDate);
        }

        $query->select(
            'products.id as product_id',
            'products.name as product_name',
            'products.sku as sku',
            DB::raw('SUM(transaction_items.quantity) as quantity_sold'),
            DB::raw('SUM(transaction_items.subtotal) as total_revenue')
        )
        ->groupBy('products.id', 'products.name', 'products.sku');

        if ($sortBy === 'revenue') {
            $query->orderBy('total_revenue', 'desc');
        } else {
            $query->orderBy('quantity_sold', 'desc');
        }

        $results = $query->limit($limit)->get();

        $rank = 1;
        $formatted = $results->map(function ($item) use (&$rank) {
            return [
                'rank' => $rank++,
                'product_id' => $item->product_id,
                'product_name' => $item->product_name,
                'sku' => $item->sku,
                'quantity_sold' => intval($item->quantity_sold),
                'total_revenue' => floatval($item->total_revenue),
            ];
        });

        return response()->json([
            'status' => true,
            'message' => 'Top products retrieved',
            'data' => $formatted
        ], 200);
    }

    /**
     * Get analytical metrics for Owner Dashboard.
     * GET /api/dashboard/analytics
     */
    public function analytics(Request $request)
    {
        $todayStr = now()->toDateString();
        $yesterdayStr = now()->subDay()->toDateString();
        $currentMonthStart = now()->startOfMonth()->toDateString();
        $currentMonthEnd = now()->endOfMonth()->toDateString();
        $previousMonthStart = now()->subMonthNoOverflow()->startOfMonth()->toDateString();
        $previousMonthEnd = now()->subMonthNoOverflow()->endOfMonth()->toDateString();
        $percentChange = function (float $current, float $previous): float {
            if ($previous <= 0) {
                return $current > 0 ? 100.0 : 0.0;
            }

            return round((($current - $previous) / $previous) * 100, 1);
        };

        // 1. KPI cards data
        $todaySalesQuery = Transaction::whereDate('created_at', $todayStr)->where('status', 'completed');
        $todaySales = floatval($todaySalesQuery->sum('total'));
        $todayCount = $todaySalesQuery->count();
        $yesterdaySalesQuery = Transaction::whereDate('created_at', $yesterdayStr)->where('status', 'completed');
        $yesterdaySales = floatval($yesterdaySalesQuery->sum('total'));
        $yesterdayCount = $yesterdaySalesQuery->count();

        $monthlySalesQuery = Transaction::whereDate('created_at', '>=', $currentMonthStart)
            ->whereDate('created_at', '<=', $currentMonthEnd)
            ->where('status', 'completed');
        $monthlySales = floatval($monthlySalesQuery->sum('total'));
        $previousMonthlySales = floatval(Transaction::whereDate('created_at', '>=', $previousMonthStart)
            ->whereDate('created_at', '<=', $previousMonthEnd)
            ->where('status', 'completed')
            ->sum('total'));
        $activeProducts = Product::count();
        $lowStockProducts = Product::join('stocks', 'products.id', '=', 'stocks.product_id')
            ->whereRaw('(stocks.offline_qty + stocks.online_qty) <= stocks.min_threshold')
            ->count();

        $todayItemsQuery = TransactionItem::whereIn('transaction_id', $todaySalesQuery->pluck('id'));
        $todayItemsSold = intval($todayItemsQuery->sum('quantity'));

        $avgTodayVal = $todayCount > 0 ? $todaySales / $todayCount : 0;

        // 2. Sales Trend (Dynamic days: 7, 30, or 90)
        $trendDays = min(90, max(7, intval($request->query('trend_days', 7))));
        $trendData = [];
        for ($i = $trendDays - 1; $i >= 0; $i--) {
            $date = now()->subDays($i)->toDateString();
            $dayQuery = Transaction::whereDate('created_at', $date)->where('status', 'completed');
            $trendData[] = [
                'date' => $date,
                'revenue' => floatval($dayQuery->sum('total')),
                'transactions' => $dayQuery->count(),
            ];
        }

        // 3. Top Products (Limit 5)
        $topProds = TransactionItem::join('transactions', 'transaction_items.transaction_id', '=', 'transactions.id')
            ->join('products', 'transaction_items.product_id', '=', 'products.id')
            ->leftJoin('categories', 'products.category_id', '=', 'categories.id')
            ->where('transactions.status', 'completed')
            ->select(
                'products.id as product_id',
                'products.name as product_name',
                'products.sku',
                'categories.name as category_name',
                DB::raw('SUM(transaction_items.quantity) as quantity_sold'),
                DB::raw('SUM(transaction_items.subtotal) as total_revenue')
            )
            ->groupBy('products.id', 'products.name', 'products.sku', 'categories.name')
            ->orderBy('quantity_sold', 'desc')
            ->limit(5)
            ->get();

        // Low stock alerts: produk yang stok (offline+online) <= min_threshold masing-masing
        $lowStockAlerts = Product::with('stock')
            ->join('stocks', 'products.id', '=', 'stocks.product_id')
            ->whereRaw('(stocks.offline_qty + stocks.online_qty) <= stocks.min_threshold')
            ->select(
                'products.id',
                'products.name',
                'products.sku',
                'stocks.offline_qty',
                'stocks.online_qty',
                'stocks.min_threshold'
            )
            ->orderByRaw('(stocks.offline_qty + stocks.online_qty) asc')
            ->limit(20)
            ->get();

        $monthlyRows = Transaction::where('status', 'completed')
            ->whereDate('created_at', '>=', now()->subMonths(11)->startOfMonth()->toDateString())
            ->select(
                DB::raw('YEAR(created_at) as year'),
                DB::raw('MONTH(created_at) as month'),
                DB::raw('SUM(total) as total_revenue'),
                DB::raw('COUNT(id) as transaction_count')
            )
            ->groupBy('year', 'month')
            ->orderBy('year')
            ->orderBy('month')
            ->get()
            ->keyBy(fn ($item) => sprintf('%04d-%02d', $item->year, $item->month));

        $monthlyRevenue = [];
        for ($i = 11; $i >= 0; $i--) {
            $month = now()->subMonths($i);
            $key = $month->format('Y-m');
            $row = $monthlyRows->get($key);

            $monthlyRevenue[] = [
                'month' => $month->format('M'),
                'month_number' => intval($month->format('n')),
                'year' => intval($month->format('Y')),
                'total_revenue' => floatval($row?->total_revenue ?? 0),
                'transaction_count' => intval($row?->transaction_count ?? 0),
            ];
        }

        // 4. Category breakdown shares
        $catBreakdown = [];
        $totalItemsAll = intval(TransactionItem::join('transactions', 'transaction_items.transaction_id', '=', 'transactions.id')
            ->where('transactions.status', 'completed')
            ->sum('transaction_items.quantity'));

        if ($totalItemsAll > 0) {
            $cats = TransactionItem::join('transactions', 'transaction_items.transaction_id', '=', 'transactions.id')
                ->join('products', 'transaction_items.product_id', '=', 'products.id')
                ->join('categories', 'products.category_id', '=', 'categories.id')
                ->where('transactions.status', 'completed')
                ->select('categories.animal_type', DB::raw('SUM(transaction_items.quantity) as count'))
                ->groupBy('categories.animal_type')
                ->get();

            foreach ($cats as $cat) {
                $percentage = ($cat->count / $totalItemsAll) * 100;
                $catBreakdown[$cat->animal_type] = round($percentage, 1);
            }
        }

        // Fallbacks for categories breakdown if no data
        if (empty($catBreakdown)) {
            $catBreakdown = [
                'cat' => 0.0,
                'dog' => 0.0,
                'hamster' => 0.0,
                'other' => 0.0
            ];
        }

        $data = [
            'kpi' => [
                'today_sales' => $todaySales,
                'total_transactions_today' => $todayCount,
                'items_sold_today' => $todayItemsSold,
                'average_transaction_value' => round($avgTodayVal, 2),
                'yesterday_sales' => $yesterdaySales,
                'transactions_yesterday' => $yesterdayCount,
                'today_sales_change_percent' => $percentChange($todaySales, $yesterdaySales),
                'transactions_change' => $todayCount - $yesterdayCount,
                'monthly_revenue' => $monthlySales,
                'previous_monthly_revenue' => $previousMonthlySales,
                'monthly_revenue_change_percent' => $percentChange($monthlySales, $previousMonthlySales),
                'active_products' => $activeProducts,
                'low_stock_products' => $lowStockProducts,
            ],
            'sales_trend' => $trendData,
            'top_products' => $topProds->map(function ($item) {
                return [
                    'product_id' => $item->product_id,
                    'product_name' => $item->product_name,
                    'sku' => $item->sku,
                    'category' => $item->category_name ?? '-',
                    'quantity_sold' => intval($item->quantity_sold),
                    'total_revenue' => floatval($item->total_revenue),
                ];
            })->all(),
            'low_stock_alerts' => $lowStockAlerts->map(function ($item) {
                $stock = intval($item->offline_qty) + intval($item->online_qty);
                $minThreshold = intval($item->min_threshold);

                return [
                    'product_id' => $item->id,
                    'product_name' => $item->name,
                    'sku' => $item->sku,
                    'stock' => $stock,
                    'offline_qty' => intval($item->offline_qty),
                    'online_qty' => intval($item->online_qty),
                    'threshold' => $minThreshold,
                    'min_threshold' => $minThreshold,
                    'critical' => $stock <= max(1, intval(floor($minThreshold / 2))),
                ];
            })->all(),
            'monthly_revenue' => $monthlyRevenue,
            'category_breakdown' => $catBreakdown
        ];

        return response()->json([
            'status' => true,
            'message' => 'Analytics data retrieved',
            'data' => $data
        ], 200);
    }
}
