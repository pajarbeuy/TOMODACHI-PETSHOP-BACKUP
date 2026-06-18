<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Support\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ProductController extends Controller
{
    private function publicImageUrl(Request $request, ?string $imageUrl): ?string
    {
        if (empty($imageUrl)) {
            return $imageUrl;
        }

        $path = parse_url($imageUrl, PHP_URL_PATH) ?: $imageUrl;

        if (str_starts_with($path, '/storage/')) {
            return $request->getSchemeAndHttpHost() . '/api/product-images/' . ltrim(substr($path, strlen('/storage/')), '/');
        }

        if (str_starts_with($path, 'storage/')) {
            return $request->getSchemeAndHttpHost() . '/api/product-images/' . ltrim(substr($path, strlen('storage/')), '/');
        }

        return $imageUrl;
    }

    private function attachPublicImageUrl(Request $request, Product $product): Product
    {
        $product->image_url = $this->publicImageUrl($request, $product->image_url);
        return $product;
    }

    public function image(string $path)
    {
        if (str_contains($path, '..') || !Storage::disk('public')->exists($path)) {
            return ApiResponse::error('Gambar produk tidak ditemukan', 404);
        }

        return response()->file(Storage::disk('public')->path($path), [
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Methods' => 'GET, OPTIONS',
            'Access-Control-Allow-Headers' => '*',
        ]);
    }

    /**
     * Display a listing of the resource.
     * GET /api/products
     */
    public function index(Request $request)
    {
        $products = Product::with(['category', 'stock']);

        // Search by name or SKU
        if ($request->has('search')) {
            $search = $request->query('search');
            if (!empty($search)) {
                $products->where(function ($q) use ($search) {
                    $q->where('name', 'like', '%' . $search . '%')
                      ->orWhere('sku', 'like', '%' . $search . '%');
                });
            }
        }

        // Filter by category_id
        if ($request->has('category_id')) {
            $products->where('category_id', $request->query('category_id'));
        }

        // Filter by animal_type or sub_category via categories relationship
        if ($request->has('animal_type') || $request->has('sub_category')) {
            $products->whereHas('category', function ($q) use ($request) {
                if ($request->has('animal_type') && !empty($request->query('animal_type'))) {
                    $q->where('animal_type', $request->query('animal_type'));
                }
                if ($request->has('sub_category') && !empty($request->query('sub_category'))) {
                    $q->where('sub_category', $request->query('sub_category'));
                }
            });
        }

        // Filter by in_stock = true
        if ($request->query('in_stock') === 'true') {
            $channel = $request->query('channel', 'offline');
            $products->whereHas('stock', function ($q) use ($channel) {
                if ($channel === 'online') {
                    $q->where('online_qty', '>', 0);
                } else {
                    $q->where('offline_qty', '>', 0);
                }
            });
        }

        // Handle pagination
        $perPage = $request->query('per_page', 15);
        $paginated = $products->latest()->paginate($perPage);

        // Role restriction check
        $user = auth()->user();
        $isOwner = $user && $user->role && $user->role->name === 'owner';

        $paginated->getCollection()->transform(function ($product) use ($isOwner, $request) {
            $buyPrice = floatval($product->buy_price);
            $sellPrice = floatval($product->sell_price);
            $margin = $buyPrice > 0 ? (($sellPrice - $buyPrice) / $buyPrice) * 100 : 0;

            // Set dynamic attributes
            $product->margin_percentage = round($margin, 2);

            // Fetch quantity info
            if ($product->stock) {
                $product->offline_qty = $product->stock->offline_qty;
                $product->online_qty = $product->stock->online_qty;
                $product->min_threshold = $product->stock->min_threshold;
            }

            $this->attachPublicImageUrl($request, $product);

            if (!$isOwner) {
                // Hide pricing margins and purchase costs for Cashier/others
                unset($product->buy_price);
                unset($product->margin_percentage);
            }
            return $product;
        });

        return response()->json([
            'status' => true,
            'message' => 'Products retrieved',
            'data' => $paginated->items(),
            'pagination' => [
                'current_page' => $paginated->currentPage(),
                'per_page' => $paginated->perPage(),
                'total' => $paginated->total(),
            ]
        ], 200);
    }

    /**
     * Store a newly created product in storage.
     * POST /api/products
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string',
            'category_id' => 'required|exists:categories,id',
            'buy_price' => 'required|numeric|min:0',
            'sell_price' => 'required|numeric|min:0',
            'sku' => 'required|string|unique:products,sku',
            'description' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
            'image_url' => 'nullable|string',
            'offline_qty' => 'nullable|integer|min:0',
            'online_qty' => 'nullable|integer|min:0',
            'min_threshold' => 'nullable|integer|min:0',
            'confirm_price_below_cost' => 'nullable',
        ]);

        $buyPrice = floatval($validated['buy_price']);
        $sellPrice = floatval($validated['sell_price']);

        // 1. Validation: Sell price must not be lower than Buy price
        $confirm = $validated['confirm_price_below_cost'] ?? false;
        // Handle post/form-data boolean checks
        if ($confirm === 'true' || $confirm === '1') {
            $confirm = true;
        }

        if ($sellPrice < $buyPrice && !$confirm) {
            return ApiResponse::error('Harga jual tidak boleh lebih rendah dari harga beli.', 422, [
                'sell_price' => ['Harga jual tidak boleh lebih rendah dari harga beli tanpa konfirmasi owner.'],
            ]);
        }

        // 2. Photo upload support (max 2MB validated in Laravel)
        $imageUrl = $validated['image_url'] ?? null;
        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('products', 'public');
            $imageUrl = '/storage/' . $path;
        }

        $marginPercentage = $buyPrice > 0 ? (($sellPrice - $buyPrice) / $buyPrice) * 100 : 0;

        $product = Product::create([
            'category_id' => $validated['category_id'],
            'name' => $validated['name'],
            'sku' => $validated['sku'],
            'buy_price' => $buyPrice,
            'sell_price' => $sellPrice,
            'margin_percentage' => round($marginPercentage, 2),
            'image_url' => $imageUrl,
            'description' => $validated['description'] ?? null,
        ]);

        $product->stock()->create([
            'offline_qty' => $validated['offline_qty'] ?? 0,
            'online_qty' => $validated['online_qty'] ?? 0,
            'min_threshold' => $validated['min_threshold'] ?? 0,
            'last_updated' => now(),
        ]);

        $product->load(['category', 'stock']);
        $this->attachPublicImageUrl($request, $product);

        return response()->json([
            'status' => true,
            'message' => 'Product created successfully',
            'data' => $product,
        ], 201);
    }

    /**
     * Display the specified resource.
     * GET /api/products/{id}
     */
    public function show(Request $request, string $id)
    {
        $product = Product::with(['category', 'stock'])->find($id);
        if (!$product) {
            return ApiResponse::error('Produk tidak ditemukan', 404);
        }

        $user = auth()->user();
        $isOwner = $user && $user->role && $user->role->name === 'owner';

        $buyPrice = floatval($product->buy_price);
        $sellPrice = floatval($product->sell_price);
        $margin = $buyPrice > 0 ? (($sellPrice - $buyPrice) / $buyPrice) * 100 : 0;

        $product->margin_percentage = round($margin, 2);

        if ($product->stock) {
            $product->offline_qty = $product->stock->offline_qty;
            $product->online_qty = $product->stock->online_qty;
            $product->min_threshold = $product->stock->min_threshold;
        }

        $this->attachPublicImageUrl($request, $product);

        if (!$isOwner) {
            unset($product->buy_price);
            unset($product->margin_percentage);
        }

        return response()->json([
            'status' => true,
            'message' => 'Detail produk berhasil diambil',
            'data' => $product
        ], 200);
    }

    /**
     * Update the specified resource in storage.
     * PUT /api/products/{id} (can also be POST with _method=PUT to support image upload)
     */
    public function update(Request $request, string $id)
    {
        $product = Product::find($id);
        if (!$product) {
            return ApiResponse::error('Produk tidak ditemukan', 404);
        }

        $validated = $request->validate([
            'name' => 'required|string',
            'category_id' => 'required|exists:categories,id',
            'buy_price' => 'required|numeric|min:0',
            'sell_price' => 'required|numeric|min:0',
            'sku' => 'required|string|unique:products,sku,' . $id,
            'description' => 'nullable|string',
            'image' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
            'image_url' => 'nullable|string',
            'offline_qty' => 'nullable|integer|min:0',
            'online_qty' => 'nullable|integer|min:0',
            'min_threshold' => 'nullable|integer|min:0',
            'confirm_price_below_cost' => 'nullable',
        ]);

        $buyPrice = floatval($validated['buy_price']);
        $sellPrice = floatval($validated['sell_price']);

        // Pricing safety validation
        $confirm = $validated['confirm_price_below_cost'] ?? false;
        if ($confirm === 'true' || $confirm === '1') {
            $confirm = true;
        }

        if ($sellPrice < $buyPrice && !$confirm) {
            return ApiResponse::error('Harga jual tidak boleh lebih rendah dari harga beli.', 422, [
                'sell_price' => ['Harga jual tidak boleh lebih rendah dari harga beli tanpa konfirmasi owner.'],
            ]);
        }

        // Photo upload support (max 2MB)
        $imageUrl = $validated['image_url'] ?? $product->image_url;
        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('products', 'public');
            $imageUrl = '/storage/' . $path;
        }

        $marginPercentage = $buyPrice > 0 ? (($sellPrice - $buyPrice) / $buyPrice) * 100 : 0;

        $product->update([
            'category_id' => $validated['category_id'],
            'name' => $validated['name'],
            'sku' => $validated['sku'],
            'buy_price' => $buyPrice,
            'sell_price' => $sellPrice,
            'margin_percentage' => round($marginPercentage, 2),
            'image_url' => $imageUrl,
            'description' => $validated['description'] ?? null,
        ]);

        $product->stock()->updateOrCreate(
            ['product_id' => $product->id],
            [
                'offline_qty' => $validated['offline_qty'] ?? $product->stock?->offline_qty ?? 0,
                'online_qty' => $validated['online_qty'] ?? $product->stock?->online_qty ?? 0,
                'min_threshold' => $validated['min_threshold'] ?? $product->stock?->min_threshold ?? 0,
                'last_updated' => now(),
            ]
        );

        $product->load(['category', 'stock']);
        $this->attachPublicImageUrl($request, $product);

        return response()->json([
            'status' => true,
            'message' => 'Product updated successfully',
            'data' => $product,
        ], 200);
    }

    /**
     * Remove the specified resource from storage.
     * DELETE /api/products/{id}
     */
    public function destroy(string $id)
    {
        $product = Product::find($id);
        if (!$product) {
            return ApiResponse::error('Produk tidak ditemukan', 404);
        }

        // Soft deletes in database (historical records kept intact)
        $product->delete();

        return response()->json([
            'status' => true,
            'message' => 'Product deleted successfully'
        ], 200);
    }
}
