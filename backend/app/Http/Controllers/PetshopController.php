<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class PetshopController extends Controller
{
    // Data produk default (simulasi database)
    private function getProdukDefault()
    {
        return [
            ['id' => 1, 'nama' => 'Makanan Kucing Premium', 'kategori' => 'Makanan', 'harga' => 50000, 'stokOffline' => 15, 'stokOnline' => 8, 'deskripsi' => 'Makanan bergizi untuk kucing', 'emoji' => '🐱'],
            ['id' => 2, 'nama' => 'Vitamin Anjing', 'kategori' => 'Vitamin', 'harga' => 30000, 'stokOffline' => 12, 'stokOnline' => 20, 'deskripsi' => 'Vitamin lengkap untuk anjing', 'emoji' => '🐕'],
            ['id' => 3, 'nama' => 'Mainan Kucing', 'kategori' => 'Aksesoris', 'harga' => 25000, 'stokOffline' => 8, 'stokOnline' => 15, 'deskripsi' => 'Mainan interaktif untuk kucing', 'emoji' => '🎾'],
            ['id' => 4, 'nama' => 'Obat Cacing', 'kategori' => 'Obat', 'harga' => 40000, 'stokOffline' => 5, 'stokOnline' => 3, 'deskripsi' => 'Obat cacing untuk hewan peliharaan', 'emoji' => '💊']
        ];
    }

    // Get produk dari session atau gunakan default
    private function getProduk()
    {
        if (!session()->has('produk')) {
            session(['produk' => $this->getProdukDefault()]);
        }
        return session('produk');
    }

    // Simpan produk ke session
    private function setProduk($produk)
    {
        session(['produk' => $produk]);
    }

    // Login page
    public function login()
    {
        if (session()->has('admin')) {
            return redirect()->route('dashboard');
        }
        return view('auth.login');
    }

    // Process login
    public function doLogin(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:3'
        ]);

        session(['admin' => true, 'admin_email' => $request->email]);
        return redirect()->route('dashboard');
    }

    // Logout
    public function logout()
    {
        session()->flush();
        return redirect()->route('login');
    }

    // Dashboard
    public function dashboard()
    {
        if (!session()->has('admin')) {
            return redirect()->route('login');
        }
        
        $produk = $this->getProduk();
        $totalProduk = count($produk);
        $totalStok = array_reduce($produk, function($sum, $p) {
            return $sum + $p['stokOffline'] + $p['stokOnline'];
        }, 0);
        $stokRendah = array_reduce($produk, function($count, $p) {
            return ($p['stokOffline'] + $p['stokOnline']) <= 5 ? $count + 1 : $count;
        }, 0);

        return view('dashboard', compact('totalProduk', 'totalStok', 'stokRendah', 'produk'));
    }

    // Halaman Produk
    public function produk()
    {
        if (!session()->has('admin')) {
            return redirect()->route('login');
        }
        
        $produk = $this->getProduk();
        return view('produk', compact('produk'));
    }

    // Halaman POS
    public function pos()
    {
        if (!session()->has('admin')) {
            return redirect()->route('login');
        }
        
        $produk = $this->getProduk();
        return view('pos', compact('produk'));
    }

    // Halaman Stok
    public function stok()
    {
        if (!session()->has('admin')) {
            return redirect()->route('login');
        }
        
        $produk = $this->getProduk();
        return view('stok', compact('produk'));
    }

    // Halaman Laporan
    public function laporan()
    {
        if (!session()->has('admin')) {
            return redirect()->route('login');
        }
        
        $produk = $this->getProduk();
        return view('laporan', compact('produk'));
    }

    // Store produk baru
    public function storeProduk(Request $request)
    {
        if (!session()->has('admin')) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }
        
        $produk = $this->getProduk();
        
        $emojis = [
            'Makanan' => '🍖',
            'Vitamin' => '💊',
            'Aksesoris' => '🎾',
            'Obat' => '💉'
        ];

        $id = max(array_column($produk, 'id')) + 1;
        
        $produk[] = [
            'id' => $id,
            'nama' => $request->nama,
            'kategori' => $request->kategori,
            'harga' => (int)$request->harga,
            'stokOffline' => (int)$request->stokOffline ?? 10,
            'stokOnline' => (int)$request->stokOnline ?? 5,
            'deskripsi' => $request->deskripsi,
            'emoji' => $emojis[$request->kategori] ?? '📦'
        ];

        $this->setProduk($produk);
        return response()->json(['message' => 'Produk berhasil ditambahkan!']);
    }

    // Delete produk
    public function deleteProduk($id)
    {
        if (!session()->has('admin')) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }
        
        $produk = $this->getProduk();
        $produk = array_filter($produk, fn($p) => $p['id'] != $id);
        $this->setProduk(array_values($produk));
        return response()->json(['message' => 'Produk berhasil dihapus!']);
    }

    // Update stok
    public function updateStok(Request $request, $id)
    {
        if (!session()->has('admin')) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }
        
        $produk = $this->getProduk();
        foreach ($produk as &$p) {
            if ($p['id'] == $id) {
                $p['stokOffline'] = (int)$request->stokOffline;
                $p['stokOnline'] = (int)$request->stokOnline;
                break;
            }
        }
        $this->setProduk($produk);
        return response()->json(['message' => 'Stok berhasil diupdate!']);
    }
}
