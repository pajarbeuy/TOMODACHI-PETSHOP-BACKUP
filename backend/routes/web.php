<?php

use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Backend Tomodachi dipakai sebagai REST API untuk Flutter. Root web dibuat
| sebagai halaman status sederhana supaya akses http://localhost:8000 tidak
| lagi diarahkan ke controller/view dummy yang belum tersedia.
|
*/

Route::get('/', function () {
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
