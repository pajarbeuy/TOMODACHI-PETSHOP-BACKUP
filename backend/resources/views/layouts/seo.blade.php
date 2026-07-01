<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    @yield('meta')
    <title>@yield('title', 'Tomodachi Pet Shop')</title>
    <link rel="icon" type="image/png" href="{{ asset('images/logo.png') }}">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; scroll-behavior: smooth; }
        :root {
            --orange: #FF8A00; --orange-deep: #E06500; --orange-light: #FFB347;
            --bg: #0B0C10; --bg2: #111318; --bg3: #181B22;
            --glass: rgba(255,255,255,0.04); --glass-border: rgba(255,255,255,0.08);
            --text: #F0ECE4; --muted: #9A9080; --radius: 18px; --transition: 0.3s cubic-bezier(.4,0,.2,1);
        }
        html { font-family: 'Plus Jakarta Sans', sans-serif; }
        body { background: var(--bg); color: var(--text); overflow-x: hidden; line-height: 1.6; }
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: var(--bg); }
        ::-webkit-scrollbar-thumb { background: var(--orange); border-radius: 99px; }
        
        header {
            position: sticky; top: 0; z-index: 1000;
            display: flex; justify-content: space-between; align-items: center;
            padding: 16px 7%; background: rgba(11,12,16,0.7); backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--glass-border);
        }
        .logo { display: flex; align-items: center; gap: 12px; text-decoration: none; }
        .logo img { width: 42px; height: 42px; border-radius: 12px; object-fit: cover; box-shadow: 0 0 0 2px rgba(255,138,0,0.4); }
        .logo-text { font-size: 18px; font-weight: 800; background: linear-gradient(90deg, var(--orange), var(--orange-light)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        nav { display: flex; align-items: center; gap: 6px; }
        nav a { text-decoration: none; color: var(--muted); padding: 8px 16px; border-radius: 10px; font-size: 14px; font-weight: 500; transition: var(--transition); }
        nav a:hover { color: var(--text); background: var(--glass); }
        
        main { min-height: 80vh; padding: 40px 7%; }
        
        footer {
            background: var(--bg); border-top: 1px solid var(--glass-border);
            padding: 48px 7%; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px;
        }
        .footer-logo { display: flex; align-items: center; gap: 10px; text-decoration: none; }
        .footer-logo img { width: 36px; height: 36px; border-radius: 9px; object-fit: cover; }
        .footer-logo span { font-size: 16px; font-weight: 700; color: var(--text); }
        footer p { color: var(--muted); font-size: 14px; }
        
        @yield('styles')
    </style>
</head>
<body>

<header>
    <a href="{{ url('/') }}" class="logo">
        <img src="{{ asset('images/logo.png') }}" alt="Tomodachi Logo">
        <span class="logo-text">Tomodachi</span>
    </a>
    <nav>
        <a href="{{ url('/') }}">Home</a>
        <a href="{{ route('products.index') }}">Products</a>
        <a href="{{ route('blog.index') }}">Blog</a>
    </nav>
</header>

<main>
    @yield('content')
</main>

<footer>
    <a href="{{ url('/') }}" class="footer-logo">
        <img src="{{ asset('images/logo.png') }}" alt="Tomodachi">
        <span>Tomodachi Pet Shop</span>
    </a>
    <p>&copy; {{ date('Y') }} Tomodachi Pet Shop. All rights reserved.</p>
</footer>

@yield('scripts')
</body>
</html>
