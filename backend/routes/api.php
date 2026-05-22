<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\ProductController;

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

// ── Protected Auth Routes ───────────────────────────────────────────────────

Route::middleware('auth:sanctum')->group(function () {
    // Auth endpoints
    Route::post('/auth/logout', [AuthController::class, 'logout']);
    Route::get('/auth/me', [AuthController::class, 'me']);
    Route::post('/auth/register', [AuthController::class, 'register']);
    
    // Get current user
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
});

// ── Product Routes (Protected) ──────────────────────────────────────────────

Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('categories', CategoryController::class);
    Route::apiResource('products', ProductController::class);
});

