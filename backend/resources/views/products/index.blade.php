@extends('layouts.seo')

@section('title', 'Katalog Produk - Tomodachi Pet Shop')

@section('meta')
    <meta name="description" content="Jelajahi berbagai kebutuhan hewan peliharaan terbaik di Tomodachi Pet Shop. Makanan, mainan, perawatan, dan aksesoris lengkap untuk anjing dan kucing.">
    <link rel="canonical" href="{{ url('/products') }}">
    <meta property="og:title" content="Katalog Produk - Tomodachi Pet Shop">
    <meta property="og:description" content="Dapatkan makanan dan perlengkapan hewan peliharaan berkualitas tinggi hanya di Tomodachi Pet Shop.">
    <meta property="og:url" content="{{ url('/products') }}">
    <meta property="og:type" content="website">
@endsection

@section('styles')
<style>
    .page-title { font-size: 36px; margin-bottom: 20px; color: var(--orange-light); }
    .page-desc { color: var(--muted); margin-bottom: 40px; font-size: 16px; max-width: 600px; }
    
    .product-grid {
        display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 24px;
    }
    .product-card {
        background: var(--glass); border: 1px solid var(--glass-border);
        border-radius: var(--radius); padding: 20px; transition: var(--transition);
        text-decoration: none; color: var(--text); display: block;
    }
    .product-card:hover { transform: translateY(-5px); border-color: rgba(255,138,0,0.3); }
    .product-img { width: 100%; height: 200px; object-fit: cover; border-radius: 12px; margin-bottom: 16px; background: #1a1d24; }
    .product-name { font-size: 18px; font-weight: 700; margin-bottom: 8px; }
    .product-price { color: var(--orange); font-size: 16px; font-weight: 800; }
</style>
@endsection

@section('content')
    <h1 class="page-title">Katalog Produk</h1>
    <p class="page-desc">Temukan berbagai makanan, mainan, dan perlengkapan terbaik untuk hewan peliharaan kesayangan Anda.</p>
    
    <div class="product-grid">
        <!-- Contoh Data Statis untuk Template -->
        <a href="{{ route('products.show', 'royal-canin-kitten-2kg') }}" class="product-card">
            <div class="product-img"></div>
            <h2 class="product-name">Royal Canin Kitten 2kg</h2>
            <div class="product-price">Rp 285.000</div>
        </a>
        <a href="{{ route('products.show', 'whiskas-tuna-1-2kg') }}" class="product-card">
            <div class="product-img"></div>
            <h2 class="product-name">Whiskas Tuna 1.2kg</h2>
            <div class="product-price">Rp 65.000</div>
        </a>
        <a href="{{ route('products.show', 'pasir-kucing-gumpal-wangi-10l') }}" class="product-card">
            <div class="product-img"></div>
            <h2 class="product-name">Pasir Kucing Gumpal Wangi 10L</h2>
            <div class="product-price">Rp 55.000</div>
        </a>
    </div>
@endsection
