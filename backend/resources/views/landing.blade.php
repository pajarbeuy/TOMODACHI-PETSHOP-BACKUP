```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Tomodachi Pet Shop POS</title>

<link rel="icon" type="image/png" href="{{ asset('images/logo.png') }}">

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>

*{
    margin:0;
    padding:0;
    box-sizing:border-box;
    font-family:'Poppins',sans-serif;
    scroll-behavior:smooth;
}

body{
    background:#FFF9F4;
    color:#333;
}

header{
    position:fixed;
    top:0;
    width:100%;
    background:white;
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:18px 8%;
    box-shadow:0 2px 15px rgba(0,0,0,.08);
    z-index:1000;
}

.logo{
    display:flex;
    align-items:center;
    gap:12px;
    font-size:24px;
    font-weight:700;
    color:#FF8A00;
}

.logo img{
    width:50px;
    height:50px;
    border-radius:50%;
    object-fit:cover;
}

nav a{
    text-decoration:none;
    color:#444;
    margin-left:25px;
    font-weight:500;
}

nav a:hover{
    color:#FF8A00;
}

.hero{
    min-height:100vh;
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:0 8%;
    background:linear-gradient(135deg,#FFF9F4,#FFE9D0);
}

.hero-content{
    max-width:650px;
}

.hero-content h1{
    font-size:60px;
    line-height:1.2;
    margin-bottom:20px;
}

.hero-content h1 span{
    color:#FF8A00;
}

.hero-content p{
    font-size:18px;
    color:#666;
    line-height:1.8;
    margin-bottom:30px;
}

.btn{
    display:inline-block;
    padding:15px 30px;
    background:#FF8A00;
    color:white;
    text-decoration:none;
    border-radius:12px;
    font-weight:600;
}

.btn:hover{
    background:#f57c00;
}

.hero-image{
    display:flex;
    justify-content:center;
    align-items:center;
}
.hero-image img{
    width:350px;
    height:auto;
    object-fit:contain;
    filter:drop-shadow(0 15px 30px rgba(255,138,0,.25));
}


section{
    padding:100px 8%;
}

.section-title{
    text-align:center;
    margin-bottom:50px;
}

.section-title h2{
    font-size:40px;
    color:#FF8A00;
}

.section-title p{
    color:#666;
    margin-top:10px;
}

.cards{
    display:grid;
    grid-template-columns:repeat(auto-fit,minmax(260px,1fr));
    gap:25px;
}

.card{
    background:white;
    padding:30px;
    border-radius:20px;
    box-shadow:0 5px 20px rgba(0,0,0,.08);
    transition:.3s;
}

.card:hover{
    transform:translateY(-8px);
}

.card h3{
    color:#FF8A00;
    margin-bottom:15px;
}

.about{
    text-align:center;
    max-width:900px;
    margin:auto;
    line-height:2;
    color:#555;
}

.roles{
    background:white;
}

.stats{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:20px;
}

.stat{
    background:white;
    padding:25px;
    text-align:center;
    border-radius:20px;
    box-shadow:0 5px 20px rgba(0,0,0,.08);
}

.stat h2{
    color:#FF8A00;
    font-size:42px;
}

.tech{
    background:white;
}

footer{
    background:#FF8A00;
    color:white;
    text-align:center;
    padding:40px;
}

footer h3{
    margin-bottom:10px;
}

@media(max-width:768px){

    nav{
        display:none;
    }

    .hero{
        flex-direction:column;
        text-align:center;
        padding-top:140px;
    }

    .hero-content h1{
        font-size:40px;
    }

    .stats{
        grid-template-columns:1fr;
    }
}

</style>

</head>
<body>

<header>

<div class="logo">
    <img src="{{ asset('images/logo.png') }}" alt="Tomodachi Logo">
    <span>Tomodachi Pet Shop</span>
</div>

<nav>
    <a href="#about">About</a>
    <a href="#features">Features</a>
    <a href="#roles">Roles</a>
    <a href="#technology">Technology</a>
</nav>

</header>

<section class="hero">

<div class="hero-content">

<h1>
Smart <span>Pet Shop POS</span><br>
Management System
</h1>

<p>
Tomodachi Pet Shop POS adalah sistem informasi manajemen berbasis Laravel dan Flutter yang membantu pengelolaan produk, kategori, stok, transaksi penjualan, laporan bisnis, dashboard analytics, serta AI Assistant dalam satu platform terintegrasi.
</p>

<a href="#features" class="btn">
Explore Features
</a>

</div>

<div class="hero-image">
    <img src="{{ asset('images/cat.png') }}" alt="Cat">
</div>

</section>

<section id="about">

<div class="section-title">
<h2>About System</h2>
<p>Integrated Pet Shop Management Solution</p>
</div>

<div class="about">
Tomodachi Pet Shop POS dirancang untuk membantu operasional pet shop secara modern dan efisien. Sistem menyediakan fitur manajemen produk, kategori, stok, transaksi penjualan, laporan bisnis, dashboard analytics, serta AI Assistant.
</div>

</section>

<section id="features">

<div class="section-title">
<h2>Main Features</h2>
<p>Fitur utama sistem</p>
</div>

<div class="cards">

<div class="card">
<h3>📦 Product Management</h3>
<p>Mengelola produk dan stok barang.</p>
</div>

<div class="card">
<h3>🏷 Category Management</h3>
<p>Mengelola kategori produk.</p>
</div>

<div class="card">
<h3>💳 POS Transactions</h3>
<p>Transaksi penjualan cepat dan akurat.</p>
</div>

<div class="card">
<h3>📊 Analytics Dashboard</h3>
<p>Monitoring performa bisnis.</p>
</div>

<div class="card">
<h3>📈 Sales Reports</h3>
<p>Laporan penjualan lengkap.</p>
</div>

<div class="card">
<h3>🤖 AI Assistant</h3>
<p>Rekomendasi dan chatbot AI.</p>
</div>

</div>

</section>

<section id="roles" class="roles">

<div class="section-title">
<h2>User Roles</h2>
</div>

<div class="cards">

<div class="card">
<h3>👑 Owner</h3>
<p>Mengakses laporan dan analytics.</p>
</div>

<div class="card">
<h3>⚙️ Admin</h3>
<p>Mengelola produk, kategori dan stok.</p>
</div>

<div class="card">
<h3>🛒 Cashier</h3>
<p>Melakukan transaksi penjualan.</p>
</div>

</div>

</section>

<section>

<div class="section-title">
<h2>System Statistics</h2>
</div>

<div class="stats">

<div class="stat">
<h2>3</h2>
<p>User Roles</p>
</div>

<div class="stat">
<h2>6+</h2>
<p>Main Features</p>
</div>

<div class="stat">
<h2>24/7</h2>
<p>System Access</p>
</div>

<div class="stat">
<h2>100%</h2>
<p>Integrated Platform</p>
</div>

</div>

</section>

<section id="technology" class="tech">

<div class="section-title">
<h2>Technology Stack</h2>
</div>

<div class="cards">

<div class="card">
<h3>Laravel 10</h3>
<p>REST API Backend.</p>
</div>

<div class="card">
<h3>Flutter</h3>
<p>Mobile Application.</p>
</div>

<div class="card">
<h3>MySQL</h3>
<p>Database System.</p>
</div>

<div class="card">
<h3>Laravel Sanctum</h3>
<p>Authentication & Security.</p>
</div>

</div>

</section>

<footer>

<h3>🐾 Tomodachi Pet Shop POS</h3>

<p>
Laravel REST API • Flutter Mobile App • AI Assistant
</p>

</footer>

</body>
</html>
```
