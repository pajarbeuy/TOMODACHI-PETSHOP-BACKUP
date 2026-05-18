<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Inventory;
use Illuminate\Http\Request;

class InventoryController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(Inventory::with('product')->get(), 200);
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
            'product_id' => 'required|exists:products,id',
            'location' => 'required|in:online,offline',
            'quantity' => 'required|integer|min:0',
        ]);

        $inventory = Inventory::create($validated);
        return response()->json($inventory->load('product'), 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $inventory = Inventory::with('product')->find($id);
        if (!$inventory) {
            return response()->json(['message' => 'Inventory not found'], 404);
        }
        return response()->json($inventory, 200);
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
        $inventory = Inventory::find($id);
        if (!$inventory) {
            return response()->json(['message' => 'Inventory not found'], 404);
        }

        $validated = $request->validate([
            'product_id' => 'required|exists:products,id',
            'location' => 'required|in:online,offline',
            'quantity' => 'required|integer|min:0',
        ]);

        $inventory->update($validated);
        return response()->json($inventory->load('product'), 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $inventory = Inventory::find($id);
        if (!$inventory) {
            return response()->json(['message' => 'Inventory not found'], 404);
        }

        $inventory->delete();
        return response()->json(['message' => 'Inventory deleted successfully'], 200);
    }
}
