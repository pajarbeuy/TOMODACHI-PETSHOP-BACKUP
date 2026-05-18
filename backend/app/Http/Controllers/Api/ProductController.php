<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json([
            'status' => true,
            'message' => 'Daftar produk berhasil diambil',
            'data' => Product::with(['category', 'stock'])
                ->latest()
                ->get(),
        ], 200);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'category_id' => 'required|exists:categories,id',
            'buy_price' => 'required|numeric|min:0',
            'sell_price' => 'required|numeric|min:0',
            'sku' => 'required|string|unique:products',
            'description' => 'nullable|string',
            'image_url' => 'nullable|string',
            'offline_qty' => 'nullable|integer|min:0',
            'online_qty' => 'nullable|integer|min:0',
            'min_threshold' => 'nullable|integer|min:0',
        ]);

        $stockData = [
            'offline_qty' => $validated['offline_qty'] ?? 0,
            'online_qty' => $validated['online_qty'] ?? 0,
            'min_threshold' => $validated['min_threshold'] ?? 0,
            'last_updated' => now(),
        ];
        unset($validated['offline_qty'], $validated['online_qty'], $validated['min_threshold']);

        $validated['margin_percentage'] = $validated['buy_price'] > 0
            ? (($validated['sell_price'] - $validated['buy_price']) / $validated['buy_price']) * 100
            : 0;

        $product = Product::create($validated);
        $product->stock()->create($stockData);

        return response()->json([
            'status' => true,
            'message' => 'Produk berhasil dibuat',
            'data' => $product->load(['category', 'stock']),
        ], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $product = Product::with(['category', 'stock'])->find($id);
        if (!$product) {
            return response()->json(['status' => false, 'message' => 'Produk tidak ditemukan'], 404);
        }
        return response()->json(['status' => true, 'message' => 'Detail produk berhasil diambil', 'data' => $product], 200);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $product = Product::find($id);
        if (!$product) {
            return response()->json(['message' => 'Product not found'], 404);
        }

        $validated = $request->validate([
            'name' => 'required|string',
            'category_id' => 'required|exists:categories,id',
            'buy_price' => 'required|numeric|min:0',
            'sell_price' => 'required|numeric|min:0',
            'sku' => 'required|string|unique:products,sku,' . $id,
            'description' => 'nullable|string',
            'image_url' => 'nullable|string',
            'offline_qty' => 'nullable|integer|min:0',
            'online_qty' => 'nullable|integer|min:0',
            'min_threshold' => 'nullable|integer|min:0',
        ]);

        $stockData = [
            'offline_qty' => $validated['offline_qty'] ?? $product->stock?->offline_qty ?? 0,
            'online_qty' => $validated['online_qty'] ?? $product->stock?->online_qty ?? 0,
            'min_threshold' => $validated['min_threshold'] ?? $product->stock?->min_threshold ?? 0,
            'last_updated' => now(),
        ];
        unset($validated['offline_qty'], $validated['online_qty'], $validated['min_threshold']);

        $validated['margin_percentage'] = $validated['buy_price'] > 0
            ? (($validated['sell_price'] - $validated['buy_price']) / $validated['buy_price']) * 100
            : 0;

        $product->update($validated);
        $product->stock()->updateOrCreate(
            ['product_id' => $product->id],
            $stockData
        );

        return response()->json([
            'status' => true,
            'message' => 'Produk berhasil diperbarui',
            'data' => $product->load(['category', 'stock']),
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $product = Product::find($id);
        if (!$product) {
            return response()->json(['status' => false, 'message' => 'Produk tidak ditemukan'], 404);
        }

        $product->delete();
        return response()->json(['status' => true, 'message' => 'Produk berhasil dihapus'], 200);
    }
}
