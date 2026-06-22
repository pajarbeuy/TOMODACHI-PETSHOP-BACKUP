<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use App\Support\ApiResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class CategoryController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json([
            'status' => true,
            'message' => 'Daftar kategori berhasil diambil',
            'data' => Category::orderBy('animal_type')->orderBy('sub_category')->get(),
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
            'name' => [
                'required',
                'string',
                'max:255',
                Rule::unique('categories')->where(fn ($query) => $query
                    ->where('animal_type', strtolower(trim($request->input('animal_type', ''))))
                    ->where('sub_category', strtolower(trim($request->input('sub_category', ''))))),
            ],
            'animal_type' => 'required|string|max:100',
            'sub_category' => 'required|string|max:100',
            'description' => 'nullable|string',
        ]);

        $validated['animal_type'] = strtolower(trim($validated['animal_type']));
        $validated['sub_category'] = strtolower(trim($validated['sub_category']));

        $category = Category::create($validated);
        return response()->json(['status' => true, 'message' => 'Kategori berhasil dibuat', 'data' => $category], 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $category = Category::find($id);
        if (!$category) {
            return ApiResponse::error('Kategori tidak ditemukan', 404);
        }
        return response()->json(['status' => true, 'message' => 'Detail kategori berhasil diambil', 'data' => $category], 200);
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
        $category = Category::find($id);
        if (!$category) {
            return ApiResponse::error('Kategori tidak ditemukan', 404);
        }

        $validated = $request->validate([
            'name' => [
                'required',
                'string',
                'max:255',
                Rule::unique('categories')->ignore($category->id)->where(fn ($query) => $query
                    ->where('animal_type', strtolower(trim($request->input('animal_type', ''))))
                    ->where('sub_category', strtolower(trim($request->input('sub_category', ''))))),
            ],
            'animal_type' => 'required|string|max:100',
            'sub_category' => 'required|string|max:100',
            'description' => 'nullable|string',
        ]);

        $validated['animal_type'] = strtolower(trim($validated['animal_type']));
        $validated['sub_category'] = strtolower(trim($validated['sub_category']));

        $category->update($validated);
        return response()->json(['status' => true, 'message' => 'Kategori berhasil diperbarui', 'data' => $category], 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $category = Category::find($id);
        if (!$category) {
            return ApiResponse::error('Kategori tidak ditemukan', 404);
        }

        if ($category->products()->exists()) {
            return ApiResponse::error('Kategori masih digunakan oleh produk dan tidak dapat dihapus.', 409);
        }

        $category->delete();
        return response()->json(['status' => true, 'message' => 'Kategori berhasil dihapus'], 200);
    }

    /**
     * GET /api/products/categories
     * Return grouped list of animal categories and sub-categories
     */
    public function productCategories()
    {
        $categories = Category::all();
        $grouped = $categories->groupBy('animal_type');
        
        $formatted = [];
        $index = 1;
        foreach ($grouped as $animalType => $items) {
            $formatted[] = [
                'id' => $index++,
                'name' => ucfirst($animalType) . ' Products',
                'animal_type' => $animalType,
                'sub_categories' => $items->pluck('sub_category')->unique()->values()->all(),
                'categories' => $items->map(function($item) {
                    return [
                        'id' => $item->id,
                        'name' => $item->name,
                        'sub_category' => $item->sub_category,
                        'description' => $item->description
                    ];
                })->all()
            ];
        }

        return response()->json([
            'status' => true,
            'message' => 'Categories retrieved',
            'data' => $formatted
        ], 200);
    }
}
