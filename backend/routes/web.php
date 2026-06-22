<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('landing');
});

Route::get('/status', function () {
    return response()->json([
        'status' => true,
        'message' => 'Tomodachi Pet Shop backend is running',
        'data' => [
            'api_health' => url('/api/health'),
            'products' => url('/api/products'),
            'categories' => url('/api/categories'),
        ],
    ]);
});