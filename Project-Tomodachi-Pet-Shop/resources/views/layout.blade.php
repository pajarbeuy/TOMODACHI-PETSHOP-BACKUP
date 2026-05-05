<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Tomodachi Petshop') - Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="{{ asset('css/style.css') }}">
    @yield('extra-css')
</head>
<body>

@if(session()->has('admin'))
    <!-- NAVBAR -->
    <div class="navbar">
        <div class="navbar-brand">
            <img src="{{ asset('images/logo.png') }}" alt="Logo" class="logo-img" style="width: 50px; height: 50px; border-radius: 50%; object-fit: cover;">
            <div>Tomodachi<br><span style="font-size: 12px; font-weight: 300;">Petshop</span></div>
        </div>

        <div class="navbar-menu">
            <a href="{{ route('dashboard') }}" class="nav-item @if(Route::currentRouteName() == 'dashboard') active @endif">
                <i class="fas fa-chart-line"></i> Dashboard
            </a>
            <a href="{{ route('produk') }}" class="nav-item @if(Route::currentRouteName() == 'produk') active @endif">
                <i class="fas fa-box"></i> Produk
            </a>
            <a href="{{ route('pos') }}" class="nav-item @if(Route::currentRouteName() == 'pos') active @endif">
                <i class="fas fa-cash-register"></i> Kasir
            </a>
            <a href="{{ route('stok') }}" class="nav-item @if(Route::currentRouteName() == 'stok') active @endif">
                <i class="fas fa-warehouse"></i> Stok
            </a>
            <a href="{{ route('laporan') }}" class="nav-item @if(Route::currentRouteName() == 'laporan') active @endif">
                <i class="fas fa-chart-bar"></i> Laporan
            </a>
        </div>

        <div class="navbar-right">
            <div class="user-profile">
                <div class="avatar">👤</div>
                <div>
                    <div style="font-size: 13px; opacity: 0.8;">Admin</div>
                    <a href="{{ route('logout') }}" style="font-size: 11px; opacity: 0.7; color: white; text-decoration: none;">Logout</a>
                </div>
            </div>
        </div>
    </div>

    <!-- MAIN CONTAINER -->
    <div class="container">
        <div class="main-content">
            @yield('content')
        </div>
    </div>
@else
    @yield('content')
@endif

<script src="{{ asset('js/app.js') }}"></script>
@yield('extra-js')

</body>
</html>
