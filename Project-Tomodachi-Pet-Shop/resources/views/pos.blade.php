@extends('layout')

@section('title', 'Kasir')

@section('content')
<div class="page-header">
    <h1><i class="fas fa-cash-register"></i> Kasir</h1>
</div>

<div style="display: grid; grid-template-columns: 1fr 350px; gap: 20px;">
    <div>
        <h3>Pilih Produk</h3>
        <div class="products-grid" id="produkPos">
            @foreach($produk as $p)
            @if(($p['stokOffline'] + $p['stokOnline']) > 0)
            <div class="product-card" onclick="tambahKeKeranjang({{ $p['id'] }}, '{{ $p['nama'] }}', {{ $p['harga'] }})">
                <div class="product-image">{{ $p['emoji'] }}</div>
                <div class="product-body">
                    <div class="product-name">{{ $p['nama'] }}</div>
                    <div class="product-price">Rp {{ number_format($p['harga'], 0, ',', '.') }}</div>
                    <div style="font-size: 13px; color: var(--gray);">Klik untuk tambah</div>
                </div>
            </div>
            @endif
            @endforeach
        </div>
    </div>

    <div class="cart-section">
        <h3 style="margin-top: 0;">🛒 Keranjang</h3>
        <div id="cartItems"></div>
        <div class="cart-summary">
            <div class="summary-row">
                <span>Subtotal:</span>
                <span>Rp <span id="subtotal">0</span></span>
            </div>
            <div class="summary-row">
                <span>Pajak (10%):</span>
                <span>Rp <span id="pajak">0</span></span>
            </div>
            <div class="summary-row total">
                <span>Total:</span>
                <span>Rp <span id="total">0</span></span>
            </div>
            <button class="btn" onclick="bayar()" style="width: 100%; justify-content: center; margin-top: 15px;">
                <i class="fas fa-money-bill-wave"></i> Bayar Sekarang
            </button>
            <button class="btn-secondary" onclick="resetCart()" style="width: 100%; justify-content: center; margin-top: 10px;">
                <i class="fas fa-redo"></i> Reset
            </button>
        </div>
    </div>
</div>
@endsection

@section('extra-js')
<script>
    let keranjang = [];

    function tambahKeKeranjang(id, nama, harga) {
        const existing = keranjang.find(k => k.id === id);
        if (existing) {
            existing.qty++;
        } else {
            keranjang.push({id, nama, harga, qty: 1});
        }
        updateCart();
    }

    function tambahQty(index) {
        keranjang[index].qty++;
        updateCart();
    }

    function kurangQty(index) {
        if (keranjang[index].qty > 1) {
            keranjang[index].qty--;
        } else {
            keranjang.splice(index, 1);
        }
        updateCart();
    }

    function hapusKeranjang(index) {
        keranjang.splice(index, 1);
        updateCart();
    }

    function updateCart() {
        let html = '';
        if (keranjang.length === 0) {
            html = '<div style="text-align: center; color: var(--gray); padding: 20px;">Keranjang kosong</div>';
        } else {
            keranjang.forEach((item, index) => {
                const subtotal = item.harga * item.qty;
                html += `
                    <div class="cart-item">
                        <div class="cart-item-info">
                            <div class="cart-item-name">${item.nama}</div>
                            <div class="cart-item-qty">
                                <button class="btn-secondary btn-sm" onclick="kurangQty(${index})" style="padding: 4px 8px;">-</button>
                                ${item.qty}
                                <button class="btn-secondary btn-sm" onclick="tambahQty(${index})" style="padding: 4px 8px;">+</button>
                            </div>
                        </div>
                        <div class="cart-item-price">Rp ${subtotal.toLocaleString('id-ID')}</div>
                        <button class="btn-danger btn-sm" onclick="hapusKeranjang(${index})" style="padding: 8px;">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                `;
            });
        }
        document.getElementById('cartItems').innerHTML = html;

        const subtotal = keranjang.reduce((sum, item) => sum + (item.harga * item.qty), 0);
        const pajakAmount = Math.round(subtotal * 0.1);
        const total = subtotal + pajakAmount;

        document.getElementById('subtotal').innerText = subtotal.toLocaleString('id-ID');
        document.getElementById('pajak').innerText = pajakAmount.toLocaleString('id-ID');
        document.getElementById('total').innerText = total.toLocaleString('id-ID');
    }

    function resetCart() {
        if (confirm('Apakah Anda ingin mereset keranjang?')) {
            keranjang = [];
            updateCart();
        }
    }

    function bayar() {
        if (keranjang.length === 0) {
            alert('Keranjang kosong!');
            return;
        }

        const total = keranjang.reduce((sum, item) => sum + (item.harga * item.qty), 0);
        const pajak = Math.round(total * 0.1);

        alert(`✅ Pembayaran Berhasil!\n\nTotal: Rp ${(total + pajak).toLocaleString('id-ID')}\n\nSilakan ambil kembalian.`);
        keranjang = [];
        updateCart();
    }

    // Init
    updateCart();
</script>
@endsection
