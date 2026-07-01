@extends('layouts.seo')

@php
    // Simulasi data artikel (Nantinya dari Controller/Database)
    $articleTitle = ucwords(str_replace('-', ' ', $slug));
    $articleDate = date('c', strtotime('-2 days')); // format ISO 8601
    $articleDateHuman = date('d M Y', strtotime('-2 days'));
    $articleDesc = "Ini adalah artikel tentang " . $articleTitle . ". Membahas panduan lengkap dan tips terbaik untuk menjaga kesehatan hewan peliharaan Anda.";
    $articleImage = asset('images/cat.png'); // fallback
    $authorName = "Tim Dokter Hewan Tomodachi";
@endphp

@section('title', $articleTitle . ' - Blog Tomodachi')

@section('meta')
    <meta name="description" content="{{ Str::limit($articleDesc, 150) }}">
    <link rel="canonical" href="{{ url('/blog/'.$slug) }}">
    <meta property="og:title" content="{{ $articleTitle }} - Blog Tomodachi">
    <meta property="og:description" content="{{ Str::limit($articleDesc, 150) }}">
    <meta property="og:url" content="{{ url('/blog/'.$slug) }}">
    <meta property="og:image" content="{{ $articleImage }}">
    <meta property="og:type" content="article">
    <meta property="article:published_time" content="{{ $articleDate }}">
    
    <!-- Schema.org Article JSON-LD -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "Article",
      "headline": "{{ $articleTitle }}",
      "image": [
        "{{ $articleImage }}"
      ],
      "datePublished": "{{ $articleDate }}",
      "dateModified": "{{ $articleDate }}",
      "author": [{
          "@type": "Person",
          "name": "{{ $authorName }}",
          "url": "{{ url('/about') }}"
        }],
      "publisher": {
        "@type": "Organization",
        "name": "Tomodachi Pet Shop",
        "logo": {
          "@type": "ImageObject",
          "url": "{{ asset('images/logo.png') }}"
        }
      },
      "description": "{{ $articleDesc }}"
    }
    </script>
@endsection

@section('styles')
<style>
    .article-container { max-width: 800px; margin: 0 auto; background: var(--glass); border: 1px solid var(--glass-border); border-radius: var(--radius); padding: 40px; }
    .breadcrumb { margin-bottom: 24px; color: var(--muted); font-size: 14px; }
    .breadcrumb a { color: var(--orange); text-decoration: none; }
    .a-title { font-size: 40px; font-weight: 900; margin-bottom: 16px; line-height: 1.3; }
    .a-meta { font-size: 14px; color: var(--muted); margin-bottom: 32px; display: flex; align-items: center; gap: 12px; }
    .a-meta-badge { background: rgba(255,138,0,0.15); color: var(--orange); padding: 4px 12px; border-radius: 99px; font-weight: 700; font-size: 12px; }
    .a-img { width: 100%; max-height: 400px; object-fit: cover; border-radius: 16px; margin-bottom: 40px; }
    
    .a-content { font-size: 17px; line-height: 1.9; color: var(--text); }
    .a-content p { margin-bottom: 20px; }
    .a-content h2 { font-size: 28px; margin: 40px 0 20px; font-weight: 800; color: var(--orange-light); }
    .a-content ul { margin: 0 0 20px 24px; }
    .a-content li { margin-bottom: 10px; }
</style>
@endsection

@section('content')
    <div class="article-container">
        <div class="breadcrumb">
            <a href="{{ url('/') }}">Home</a> &raquo; <a href="{{ route('blog.index') }}">Blog</a> &raquo; Artikel
        </div>

        <h1 class="a-title">{{ $articleTitle }}</h1>
        
        <div class="a-meta">
            <span class="a-meta-badge">EDUKASI</span>
            <span>Ditulis oleh <strong>{{ $authorName }}</strong></span>
            <span>&bull;</span>
            <span>{{ $articleDateHuman }}</span>
        </div>

        <img src="{{ $articleImage }}" alt="{{ $articleTitle }}" class="a-img">

        <div class="a-content">
            <p>{{ $articleDesc }}</p>
            
            <h2>Mengapa Ini Penting?</h2>
            <p>Kesehatan hewan peliharaan adalah prioritas utama. Dengan memberikan perawatan yang tepat, Anda dapat memperpanjang usia dan meningkatkan kualitas hidup mereka.</p>
            
            <ul>
                <li>Pastikan makanan sesuai dengan usia dan ras.</li>
                <li>Lakukan grooming secara berkala.</li>
                <li>Rutin cek kesehatan ke dokter hewan terdekat.</li>
            </ul>

            <p>Terus pantau blog Tomodachi untuk mendapatkan update dan tips terbaru seputar dunia hewan peliharaan!</p>
        </div>
    </div>
@endsection
