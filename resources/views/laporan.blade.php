@extends('layout')

@section('title', 'Laporan Penjualan')

@section('content')
<div class="page-header">
    <h1><i class="fas fa-chart-bar"></i> Laporan Penjualan</h1>
    <div class="btn-group">
        <button class="btn btn-sm" onclick="exportLaporan()">
            <i class="fas fa-download"></i> Export PDF
        </button>
    </div>
</div>

<div style="background: white; border-radius: var(--border-radius); box-shadow: var(--shadow); padding: 25px;">
    <h3>Laporan Periode Bulan Ini</h3>
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-top: 20px;">
        <div style="padding: 20px; background: var(--light); border-radius: 8px; border-left: 4px solid #F4A460;">
            <div style="color: var(--gray); font-size: 13px;">Total Penjualan</div>
            <div style="font-size: 24px; font-weight: bold; color: #F4A460;">Rp 45.000.000</div>
        </div>

        <div style="padding: 20px; background: var(--light); border-radius: 8px; border-left: 4px solid #FF8C42;">
            <div style="color: var(--gray); font-size: 13px;">Total Transaksi</div>
            <div style="font-size: 24px; font-weight: bold; color: #FF8C42;">750</div>
        </div>

        <div style="padding: 20px; background: var(--light); border-radius: 8px; border-left: 4px solid #2ecc71;">
            <div style="color: var(--gray); font-size: 13px;">Rata-rata Transaksi</div>
            <div style="font-size: 24px; font-weight: bold; color: #2ecc71;">Rp 60.000</div>
        </div>

        <div style="padding: 20px; background: var(--light); border-radius: 8px; border-left: 4px solid #FF6B35;">
            <div style="color: var(--gray); font-size: 13px;">Produk Terlaris</div>
            <div style="font-size: 24px; font-weight: bold; color: #FF6B35;">Makanan Kucing</div>
        </div>
    </div>

    <h3 style="margin-top: 40px;">Ringkasan Produk</h3>
    <table style="width: 100%; margin-top: 20px;">
        <thead>
            <tr style="background: var(--light);">
                <th style="padding: 12px; text-align: left;">Produk</th>
                <th style="padding: 12px; text-align: left;">Kategori</th>
                <th style="padding: 12px; text-align: left;">Harga</th>
                <th style="padding: 12px; text-align: left;">Stok Saat Ini</th>
            </tr>
        </thead>
        <tbody>
            @foreach($produk as $p)
            <tr style="border-bottom: 1px solid var(--light);">
                <td style="padding: 12px;">{{ $p['emoji'] }} {{ $p['nama'] }}</td>
                <td style="padding: 12px;">{{ $p['kategori'] }}</td>
                <td style="padding: 12px;">Rp {{ number_format($p['harga'], 0, ',', '.') }}</td>
                <td style="padding: 12px;"><strong>{{ $p['stokOffline'] + $p['stokOnline'] }}</strong></td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>

@endsection

@section('extra-js')
<script>
    function exportLaporan() {
        alert('Fitur export PDF akan segera tersedia!');
    }
</script>
@endsection
