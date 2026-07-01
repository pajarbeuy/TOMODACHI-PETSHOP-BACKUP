@extends('layouts.seo')

@section('title', 'Blog & Edukasi - Tomodachi Pet Shop')

@section('meta')
    <meta name="description" content="Baca berbagai artikel informatif, tips perawatan hewan, dan rekomendasi nutrisi untuk anjing dan kucing kesayangan Anda di Blog Tomodachi.">
    <link rel="canonical" href="{{ url('/blog') }}">
    <meta property="og:title" content="Blog & Edukasi - Tomodachi Pet Shop">
    <meta property="og:description" content="Kumpulan artikel edukasi dan tips merawat hewan peliharaan.">
    <meta property="og:url" content="{{ url('/blog') }}">
    <meta property="og:type" content="website">
@endsection

@section('styles')
<style>
    .page-title { font-size: 36px; margin-bottom: 20px; color: var(--orange-light); }
    .page-desc { color: var(--muted); margin-bottom: 40px; font-size: 16px; max-width: 600px; }
    
    .blog-grid {
        display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 30px;
    }
    .blog-card {
        background: var(--glass); border: 1px solid var(--glass-border);
        border-radius: var(--radius); overflow: hidden; transition: var(--transition);
        text-decoration: none; color: var(--text); display: flex; flex-direction: column;
    }
    .blog-card:hover { transform: translateY(-5px); border-color: rgba(255,138,0,0.3); box-shadow: 0 10px 30px rgba(0,0,0,0.5); }
    .blog-img { width: 100%; height: 200px; object-fit: cover; background: #1a1d24; }
    .blog-content { padding: 24px; flex: 1; display: flex; flex-direction: column; }
    .blog-meta { font-size: 13px; color: var(--orange); font-weight: 600; margin-bottom: 12px; }
    .blog-title { font-size: 20px; font-weight: 800; margin-bottom: 12px; line-height: 1.4; }
    .blog-excerpt { font-size: 14px; color: var(--muted); line-height: 1.6; margin-bottom: 20px; flex: 1; }
    .read-more { font-size: 14px; font-weight: 700; color: var(--orange-light); display: inline-flex; align-items: center; gap: 4px; }
</style>
@endsection

@section('content')
    <h1 class="page-title">Blog & Edukasi</h1>
    <p class="page-desc">Tingkatkan pengetahuan Anda tentang perawatan, kesehatan, dan kebahagiaan hewan peliharaan bersama tim Tomodachi.</p>
    
    <div class="blog-grid">
        <!-- Contoh Data Statis untuk Template -->
        <a href="{{ route('blog.show', 'cara-merawat-bulu-kucing-agar-tidak-rontok') }}" class="blog-card">
            <div class="blog-img"></div>
            <div class="blog-content">
                <div class="blog-meta">TIPS KUCING &bull; 24 Jun 2026</div>
                <h2 class="blog-title">Cara Merawat Bulu Kucing Agar Tidak Mudah Rontok</h2>
                <p class="blog-excerpt">Bulu kucing yang rontok bisa jadi tanda kurang nutrisi atau stres. Pelajari cara merawatnya dengan benar di sini.</p>
                <div class="read-more">Baca Selengkapnya &rarr;</div>
            </div>
        </a>
        <a href="{{ route('blog.show', 'panduan-memilih-makanan-anjing-yang-tepat') }}" class="blog-card">
            <div class="blog-img"></div>
            <div class="blog-content">
                <div class="blog-meta">NUTRISI ANJING &bull; 20 Jun 2026</div>
                <h2 class="blog-title">Panduan Memilih Makanan Anjing yang Tepat Sesuai Usia</h2>
                <p class="blog-excerpt">Puppy, Adult, dan Senior memiliki kebutuhan nutrisi yang berbeda. Pastikan Anda tidak salah pilih.</p>
                <div class="read-more">Baca Selengkapnya &rarr;</div>
            </div>
        </a>
    </div>
@endsection
