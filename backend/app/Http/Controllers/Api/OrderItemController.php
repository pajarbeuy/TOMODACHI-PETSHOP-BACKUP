<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\OrderItem;
use Illuminate\Http\Request;

class OrderItemController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(OrderItem::with('order', 'product')->get(), 200);
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
            'order_id' => 'required|exists:orders,id',
            'product_id' => 'required|exists:products,id',
            'quantity' => 'required|integer|min:1',
            'unit_price' => 'required|numeric|min:0',
            'subtotal' => 'required|numeric|min:0',
        ]);

        $orderItem = OrderItem::create($validated);
        return response()->json($orderItem->load('order', 'product'), 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $orderItem = OrderItem::with('order', 'product')->find($id);
        if (!$orderItem) {
            return response()->json(['message' => 'Order item not found'], 404);
        }
        return response()->json($orderItem, 200);
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
        $orderItem = OrderItem::find($id);
        if (!$orderItem) {
            return response()->json(['message' => 'Order item not found'], 404);
        }

        $validated = $request->validate([
            'order_id' => 'required|exists:orders,id',
            'product_id' => 'required|exists:products,id',
            'quantity' => 'required|integer|min:1',
            'unit_price' => 'required|numeric|min:0',
            'subtotal' => 'required|numeric|min:0',
        ]);

        $orderItem->update($validated);
        return response()->json($orderItem->load('order', 'product'), 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $orderItem = OrderItem::find($id);
        if (!$orderItem) {
            return response()->json(['message' => 'Order item not found'], 404);
        }

        $orderItem->delete();
        return response()->json(['message' => 'Order item deleted successfully'], 200);
    }
}
