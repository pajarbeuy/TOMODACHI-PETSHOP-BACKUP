@extends('layout')

@section('title', 'Manajemen Produk')

@section('content')
<div class="page-header">
    <h1><i class="fas fa-box"></i> Manajemen Produk</h1>
    <div class="btn-group">
        <button class="btn btn-sm" onclick="openModal('tambahProdukModal')">
            <i class="fas fa-plus"></i> Tambah Produk
        </button>
    </div>
</div>

<div class="products-grid" id="listProduk">
    @foreach($produk as $p)
    <div class="product-card">
        <div class="product-image">{{ $p['emoji'] }}</div>
        <div class="product-body">
            <div class="product-name">{{ $p['nama'] }}</div>
            <div class="product-category">{{ $p['kategori'] }}</div>
            <div class="product-price">Rp {{ number_format($p['harga'], 0, ',', '.') }}</div>
            <div class="product-stock">Stok: {{ $p['stokOffline'] + $p['stokOnline'] }}</div>
            <div class="product-actions">
                <button class="btn btn-sm" onclick="editProduk({{ $p['id'] }})">Edit</button>
                <button class="btn-danger btn-sm" onclick="hapusProduk({{ $p['id'] }})">Hapus</button>
            </div>
        </div>
    </div>
    @endforeach
</div>

<!-- MODAL TAMBAH PRODUK -->
<div class="modal" id="tambahProdukModal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>Tambah Produk Baru</h2>
            <button class="close-btn" onclick="closeModal('tambahProdukModal')">&times;</button>
        </div>

        <form id="formTambahProduk">
            @csrf
            <div class="form-group">
                <label for="produkNama">Nama Produk</label>
                <input type="text" id="produkNama" name="nama" placeholder="Contoh: Makanan Kucing Premium" required>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="produkKategori">Kategori</label>
                    <select id="produkKategori" name="kategori" required>
                        <option value="Makanan">Makanan</option>
                        <option value="Vitamin">Vitamin</option>
                        <option value="Aksesoris">Aksesoris</option>
                        <option value="Obat">Obat</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="produkHarga">Harga (Rp)</label>
                    <input type="number" id="produkHarga" name="harga" placeholder="50000" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="produkStokOffline">Stok Offline</label>
                    <input type="number" id="produkStokOffline" name="stokOffline" placeholder="10" value="10" required>
                </div>

                <div class="form-group">
                    <label for="produkStokOnline">Stok Online</label>
                    <input type="number" id="produkStokOnline" name="stokOnline" placeholder="5" value="5" required>
                </div>
            </div>

            <div class="form-group">
                <label for="produkDeskripsi">Deskripsi</label>
                <textarea id="produkDeskripsi" name="deskripsi" placeholder="Deskripsi produk..." rows="3"></textarea>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal('tambahProdukModal')">Batal</button>
                <button type="submit" class="btn">Simpan Produk</button>
            </div>
        </form>
    </div>
</div>

@endsection

@section('extra-js')
<script>
    document.getElementById('formTambahProduk').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const formData = new FormData(this);
        
        fetch('{{ route("store-produk") }}', {
            method: 'POST',
            headers: {
                'X-CSRF-TOKEN': '{{ csrf_token() }}'
            },
            body: formData
        })
        .then(response => response.json())
        .then(data => {
            showNotification(data.message, 'success');
            closeModal('tambahProdukModal');
            setTimeout(() => location.reload(), 500);
        })
        .catch(error => {
            showNotification('Terjadi kesalahan', 'danger');
            console.error(error);
        });
    });

    function hapusProduk(id) {
        if (confirm('Apakah Anda yakin ingin menghapus produk ini?')) {
            fetch('/api/produk/' + id, {
                method: 'DELETE',
                headers: {
                    'X-CSRF-TOKEN': '{{ csrf_token() }}'
                }
            })
            .then(response => response.json())
            .then(data => {
                showNotification(data.message, 'success');
                setTimeout(() => location.reload(), 500);
            });
        }
    }

    function editProduk(id) {
        alert('Fitur edit akan segera tersedia!');
    }
</script>
@endsection
