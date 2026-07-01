<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\Response;

class SitemapController extends Controller
{
    public function index(): Response
    {
        // Untuk saat ini, kita gunakan data statis untuk mensimulasikan
        // struktur sitemap. Nanti bisa diganti dengan memanggil Model
        // misalnya Product::all() dan Article::all()

        $products = [
            ['slug' => 'royal-canin-kitten-2kg', 'updated_at' => date('Y-m-d\TH:i:sP', strtotime('-1 days'))],
            ['slug' => 'whiskas-tuna-1-2kg', 'updated_at' => date('Y-m-d\TH:i:sP', strtotime('-2 days'))],
            ['slug' => 'pasir-kucing-gumpal-wangi-10l', 'updated_at' => date('Y-m-d\TH:i:sP', strtotime('-3 days'))],
        ];

        $articles = [
            ['slug' => 'cara-merawat-bulu-kucing-agar-tidak-rontok', 'updated_at' => date('Y-m-d\TH:i:sP', strtotime('-4 days'))],
            ['slug' => 'panduan-memilih-makanan-anjing-yang-tepat', 'updated_at' => date('Y-m-d\TH:i:sP', strtotime('-5 days'))],
        ];

        $xml = '<?xml version="1.0" encoding="UTF-8"?>';
        $xml .= '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">';

        // Homepage
        $xml .= '<url>';
        $xml .= '<loc>' . url('/') . '</loc>';
        $xml .= '<lastmod>' . date('Y-m-d\TH:i:sP') . '</lastmod>';
        $xml .= '<changefreq>daily</changefreq>';
        $xml .= '<priority>1.0</priority>';
        $xml .= '</url>';

        // Products Index
        $xml .= '<url>';
        $xml .= '<loc>' . route('products.index') . '</loc>';
        $xml .= '<lastmod>' . date('Y-m-d\TH:i:sP') . '</lastmod>';
        $xml .= '<changefreq>daily</changefreq>';
        $xml .= '<priority>0.9</priority>';
        $xml .= '</url>';

        // Blog Index
        $xml .= '<url>';
        $xml .= '<loc>' . route('blog.index') . '</loc>';
        $xml .= '<lastmod>' . date('Y-m-d\TH:i:sP') . '</lastmod>';
        $xml .= '<changefreq>daily</changefreq>';
        $xml .= '<priority>0.9</priority>';
        $xml .= '</url>';

        // Dynamic Products
        foreach ($products as $product) {
            $xml .= '<url>';
            $xml .= '<loc>' . route('products.show', $product['slug']) . '</loc>';
            $xml .= '<lastmod>' . $product['updated_at'] . '</lastmod>';
            $xml .= '<changefreq>weekly</changefreq>';
            $xml .= '<priority>0.8</priority>';
            $xml .= '</url>';
        }

        // Dynamic Articles
        foreach ($articles as $article) {
            $xml .= '<url>';
            $xml .= '<loc>' . route('blog.show', $article['slug']) . '</loc>';
            $xml .= '<lastmod>' . $article['updated_at'] . '</lastmod>';
            $xml .= '<changefreq>monthly</changefreq>';
            $xml .= '<priority>0.7</priority>';
            $xml .= '</url>';
        }

        $xml .= '</urlset>';

        return response($xml)->header('Content-Type', 'text/xml');
    }
}
