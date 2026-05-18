<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;

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
            'name' => 'required|string',
            'animal_type' => 'required|string',
            'sub_category' => 'required|string',
            'description' => 'nullable|string',
        ]);

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
            return response()->json(['status' => false, 'message' => 'Kategori tidak ditemukan'], 404);
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
            return response()->json(['message' => 'Category not found'], 404);
        }

        $validated = $request->validate([
            'name' => 'required|string',
            'animal_type' => 'required|string',
            'sub_category' => 'required|string',
            'description' => 'nullable|string',
        ]);

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
            return response()->json(['status' => false, 'message' => 'Kategori tidak ditemukan'], 404);
        }

        $category->delete();
        return response()->json(['status' => true, 'message' => 'Kategori berhasil dihapus'], 200);
    }
}
