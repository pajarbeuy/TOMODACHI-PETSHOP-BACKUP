@extends('layout')

@section('title', 'Manajemen Stok')

@section('content')
<div class="page-header">
    <h1><i class="fas fa-warehouse"></i> Manajemen Stok</h1>
</div>

<div style="background: white; border-radius: var(--border-radius); box-shadow: var(--shadow); overflow: hidden;">
    <table>
        <thead>
            <tr>
                <th>Produk</th>
                <th>Stok Offline</th>
                <th>Stok Online</th>
                <th>Total Stok</th>
                <th>Status</th>
                <th>Aksi</th>
            </tr>
        </thead>
        <tbody>
            @foreach($produk as $p)
            @php
                $total = $p['stokOffline'] + $p['stokOnline'];
                $status = $total > 10 ? '<span style="color: var(--success);">✅ Aman</span>' : 
                          ($total > 5 ? '<span style="color: var(--warning);">⚠️ Menipis</span>' : 
                          '<span style="color: var(--danger);">❌ Rendah</span>');
            @endphp
            <tr>
                <td><strong>{{ $p['emoji'] }} {{ $p['nama'] }}</strong></td>
                <td>{{ $p['stokOffline'] }}</td>
                <td>{{ $p['stokOnline'] }}</td>
                <td><strong>{{ $total }}</strong></td>
                <td>{!! $status !!}</td>
                <td><button class="btn btn-sm" onclick="editStok({{ $p['id'] }})">Edit</button></td>
            </tr>
            @endforeach
        </tbody>
    </table>
</div>

<!-- MODAL EDIT STOK -->
<div class="modal" id="editStokModal">
    <div class="modal-content">
        <div class="modal-header">
            <h2>Edit Stok Produk</h2>
            <button class="close-btn" onclick="closeModal('editStokModal')">&times;</button>
        </div>

        <form id="formEditStok">
            @csrf
            <input type="hidden" id="stokId">
            
            <div class="form-group">
                <label for="stokEditOffline">Stok Offline</label>
                <input type="number" id="stokEditOffline" required>
            </div>

            <div class="form-group">
                <label for="stokEditOnline">Stok Online</label>
                <input type="number" id="stokEditOnline" required>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closeModal('editStokModal')">Batal</button>
                <button type="submit" class="btn">Simpan</button>
            </div>
        </form>
    </div>
</div>

@endsection

@section('extra-js')
<script>
    const produkList = @json($produk);

    function editStok(id) {
        const produk = produkList.find(p => p.id === id);
        if (produk) {
            document.getElementById('stokId').value = id;
            document.getElementById('stokEditOffline').value = produk.stokOffline;
            document.getElementById('stokEditOnline').value = produk.stokOnline;
            openModal('editStokModal');
        }
    }

    document.getElementById('formEditStok').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const id = document.getElementById('stokId').value;
        const stokOffline = document.getElementById('stokEditOffline').value;
        const stokOnline = document.getElementById('stokEditOnline').value;

        fetch('/api/stok/' + id, {
            method: 'POST',
            headers: {
                'X-CSRF-TOKEN': '{{ csrf_token() }}',
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                stokOffline: stokOffline,
                stokOnline: stokOnline
            })
        })
        .then(response => response.json())
        .then(data => {
            showNotification(data.message, 'success');
            closeModal('editStokModal');
            setTimeout(() => location.reload(), 500);
        });
    });
</script>
@endsection
