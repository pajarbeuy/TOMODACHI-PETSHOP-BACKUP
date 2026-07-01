@extends('layouts.seo')

@php
    // Simulasi data produk berdasarkan slug (Nantinya dari Controller/Database)
    $productName = ucwords(str_replace('-', ' ', $slug));
    $productPrice = 150000;
    $productDesc = "Deskripsi lengkap untuk produk " . $productName . ". Produk ini sangat direkomendasikan untuk kesehatan dan kebahagiaan hewan peliharaan Anda. Tersedia secara eksklusif di Tomodachi Pet Shop.";
    $productImage = asset('images/cat.png'); // fallback
@endphp

@section('title', $productName . ' - Tomodachi Pet Shop')

@section('meta')
    <meta name="description" content="{{ Str::limit($productDesc, 150) }}">
    <link rel="canonical" href="{{ url('/products/'.$slug) }}">
    <meta property="og:title" content="{{ $productName }} - Tomodachi Pet Shop">
    <meta property="og:description" content="{{ Str::limit($productDesc, 150) }}">
    <meta property="og:url" content="{{ url('/products/'.$slug) }}">
    <meta property="og:image" content="{{ $productImage }}">
    <meta property="og:type" content="product">
    
    <!-- Schema.org Product JSON-LD -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org/",
      "@type": "Product",
      "name": "{{ $productName }}",
      "image": [
        "{{ $productImage }}"
      ],
      "description": "{{ $productDesc }}",
      "sku": "{{ strtoupper(substr($slug, 0, 8)) }}",
      "brand": {
        "@type": "Brand",
        "name": "Tomodachi"
      },
      "offers": {
        "@type": "Offer",
        "url": "{{ url('/products/'.$slug) }}",
        "priceCurrency": "IDR",
        "price": "{{ $productPrice }}",
        "availability": "https://schema.org/InStock",
        "seller": {
          "@type": "Organization",
          "name": "Tomodachi Pet Shop"
        }
      }
    }
    </script>
@endsection

@section('styles')
<style>
    .product-detail { display: flex; gap: 40px; flex-wrap: wrap; margin-top: 20px; }
    .product-image-box { flex: 1; min-width: 300px; max-width: 500px; background: var(--glass); border-radius: var(--radius); padding: 40px; display: flex; align-items: center; justify-content: center; }
    .product-image-box img { max-width: 100%; height: auto; border-radius: 12px; }
    .product-info { flex: 1; min-width: 300px; }
    .breadcrumb { margin-bottom: 20px; color: var(--muted); font-size: 14px; }
    .breadcrumb a { color: var(--orange); text-decoration: none; }
    .p-title { font-size: 42px; font-weight: 800; margin-bottom: 16px; line-height: 1.2; }
    .p-price { font-size: 28px; color: var(--orange); font-weight: 700; margin-bottom: 24px; }
    .p-desc { font-size: 16px; color: var(--muted); line-height: 1.8; margin-bottom: 32px; }
    .btn-buy { display: inline-block; background: linear-gradient(135deg, var(--orange), var(--orange-deep)); color: white; padding: 16px 32px; border-radius: 12px; font-weight: 700; text-decoration: none; transition: var(--transition); }
    .btn-buy:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(255,138,0,0.3); }
</style>
@endsection

@section('content')
    <div class="breadcrumb">
        <a href="{{ url('/') }}">Home</a> &raquo; <a href="{{ route('products.index') }}">Products</a> &raquo; {{ $productName }}
    </div>

    <div class="product-detail">
        <div class="product-image-box">
            <img src="{{ $productImage }}" alt="{{ $productName }}">
        </div>
        <div class="product-info">
            <h1 class="p-title">{{ $productName }}</h1>
            <div class="p-price">Rp {{ number_format($productPrice, 0, ',', '.') }}</div>
            <p class="p-desc">{{ $productDesc }}</p>
            
            <a href="#" class="btn-buy">Beli Sekarang via WhatsApp</a>
        </div>
    </div>
@endsection
