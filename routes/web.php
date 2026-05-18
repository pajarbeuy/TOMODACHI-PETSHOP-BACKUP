<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PetshopController;

Route::get('/', [PetshopController::class, 'login'])->name('login');
Route::post('/login', [PetshopController::class, 'doLogin'])->name('do-login');
Route::get('/logout', [PetshopController::class, 'logout'])->name('logout');

// Protected routes - check admin session manually in controller
Route::get('/dashboard', [PetshopController::class, 'dashboard'])->name('dashboard');
Route::get('/produk', [PetshopController::class, 'produk'])->name('produk');
Route::get('/pos', [PetshopController::class, 'pos'])->name('pos');
Route::get('/stok', [PetshopController::class, 'stok'])->name('stok');
Route::get('/laporan', [PetshopController::class, 'laporan'])->name('laporan');

// API routes untuk AJAX
Route::post('/api/produk', [PetshopController::class, 'storeProduk'])->name('store-produk');
Route::delete('/api/produk/{id}', [PetshopController::class, 'deleteProduk'])->name('delete-produk');
Route::post('/api/stok/{id}', [PetshopController::class, 'updateStok'])->name('update-stok');
