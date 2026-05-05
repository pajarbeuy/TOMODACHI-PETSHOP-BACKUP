@extends('layout')

@section('title', 'Dashboard')

@section('content')
<div class="page-header">
    <h1><i class="fas fa-chart-line"></i> Dashboard</h1>
</div>

<div class="dashboard-grid">
    <div class="card">
        <div class="card-icon">💰</div>
        <div class="card-label">Total Penjualan Hari Ini</div>
        <div class="card-value">Rp 1.500.000</div>
        <div class="card-subtext">↑ 12% dari kemarin</div>
    </div>

    <div class="card" style="border-left-color: #FF8C42;">
        <div class="card-icon">🛒</div>
        <div class="card-label">Total Transaksi</div>
        <div class="card-value">25</div>
        <div class="card-subtext">Hari ini</div>
    </div>

    <div class="card" style="border-left-color: #2ecc71;">
        <div class="card-icon">📦</div>
        <div class="card-label">Total Produk</div>
        <div class="card-value">{{ $totalProduk }}</div>
        <div class="card-subtext">Produk tersedia</div>
    </div>

    <div class="card" style="border-left-color: #FF6B35;">
        <div class="card-icon">⚠️</div>
        <div class="card-label">Stok Rendah</div>
        <div class="card-value">{{ $stokRendah }}</div>
        <div class="card-subtext">Produk perlu restock</div>
    </div>
</div>

<div style="background: white; padding: 25px; border-radius: var(--border-radius); box-shadow: var(--shadow); margin-top: 20px;">
    <h3 style="margin-top: 0;">📊 Daftar Produk</h3>
    <table style="width: 100%; margin-top: 20px;">
        <thead>
            <tr style="background: var(--light);">
                <th style="padding: 12px; text-align: left;">Produk</th>
                <th style="padding: 12px; text-align: left;">Kategori</th>
                <th style="padding: 12px; text-align: left;">Harga</th>
                <th style="padding: 12px; text-align: left;">Total Stok</th>
                <th style="padding: 12px; text-align: left;">Status</th>
            </tr>
        </thead>
        <tbody>
            @foreach($produk as $p)
            <tr style="border-bottom: 1px solid var(--light);">
                <td style="padding: 12px;">{{ $p['emoji'] }} {{ $p['nama'] }}</td>
                <td style="padding: 12px;">{{ $p['kategori'] }}</td>
                <td style="padding: 12px;">Rp {{ number_format($p['harga'], 0, ',', '.') }}</td>
                <td style="padding: 12px;"><strong>{{ $p['stokOffline'] + $p['stokOnline'] }}</strong></td>
                <td style="padding: 12px;">
                    @if(($p['stokOffline'] + $p['stokOnline']) > 10)
                        <span style="color: var(--success);">✅ Aman</span>
                    @elseif(($p['stokOffline'] + $p['stokOnline']) > 5)
                        <span style="color: var(--warning);">⚠️ Menipis</span>
                    @else
                        <span style="color: var(--danger);">❌ Rendah</span>
                    @endif
                </td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>
@endsection
