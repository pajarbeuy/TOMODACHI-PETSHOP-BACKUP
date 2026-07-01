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

// SEO Routes for Web Catalog & Blog
Route::get('/products', function () {
    return view('products.index');
})->name('products.index');

Route::get('/products/{slug}', function ($slug) {
    return view('products.show', compact('slug'));
})->name('products.show');

Route::get('/blog', function () {
    return view('blog.index');
})->name('blog.index');

Route::get('/blog/{slug}', function ($slug) {
    return view('blog.show', compact('slug'));
})->name('blog.show');

Route::get('/sitemap.xml', [\App\Http\Controllers\SitemapController::class, 'index'])->name('sitemap');