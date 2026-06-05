<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\ProductController;
use App\Http\Controllers\Api\TransactionController;
use App\Http\Controllers\Api\ReportController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

// ── Public Auth Routes ──────────────────────────────────────────────────────

Route::post('/auth/login', [AuthController::class, 'login']);
Route::get('/health', function () {
    return response()->json([
        'status' => true,
        'message' => 'Tomodachi Pet Shop API connected',
        'data' => [
            'app' => config('app.name'),
            'environment' => app()->environment(),
            'time' => now()->toIso8601String(),
        ],
    ]);
});

Route::post('/midtrans/notification', [TransactionController::class, 'midtransNotification']);
Route::get('/product-images/{path}', [ProductController::class, 'image'])->where('path', '.*');

// ── Protected Auth & User Routes ─────────────────────────────────────────────

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/auth/me', [AuthController::class, 'me']);
    
    // Registering new users is restricted to owner
    Route::post('/auth/register', [AuthController::class, 'register']);
    
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
});

// ── Protected POS & Product Features Routes ───────────────────────────────────

Route::middleware('auth:sanctum')->group(function () {
    
    // 1. Categories
    Route::apiResource('categories', CategoryController::class);
    
    // Grouped categories endpoint (required before products show route)
    Route::get('products/categories', [CategoryController::class, 'productCategories']);

    // 2. Products general (accessible by both kasir and owner)
    Route::get('products', [ProductController::class, 'index']);
    Route::get('products/{product}', [ProductController::class, 'show']);

    // 3. Products modification (Owner and Admin only)
    Route::middleware('check.role:owner,admin')->group(function () {
        Route::post('products', [ProductController::class, 'store']);
        // Use POST with _method=PUT on client to support multipart uploads in PHP/Laravel
        Route::post('products/{product}/update', [ProductController::class, 'update']);
        Route::put('products/{product}', [ProductController::class, 'update']);
        Route::delete('products/{product}', [ProductController::class, 'destroy']);
    });

    // 4. POS Transactions (Checkout for kasir & owner, history for all auth)
    Route::post('transactions', [TransactionController::class, 'store'])->middleware('check.role:kasir,owner');
    Route::get('transactions', [TransactionController::class, 'index']);
    Route::get('transactions/{id}', [TransactionController::class, 'show']);
    Route::get('transactions/{id}/receipt', [TransactionController::class, 'receipt']);

    // 5. Reports & Dashboard Analytics (Owner only)
    Route::middleware('check.role:owner')->group(function () {
        Route::get('reports/sales', [ReportController::class, 'salesReport']);
        Route::get('reports/sales/summary', [ReportController::class, 'salesSummary']);
        Route::get('reports/top-products', [ReportController::class, 'topProducts']);
        Route::get('dashboard/analytics', [ReportController::class, 'analytics']);
    });
});
