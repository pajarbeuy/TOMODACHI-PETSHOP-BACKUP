# Tomodachi Pet Shop - Laravel Management System

UI Laravel untuk sistem manajemen toko hewan peliharaan tanpa database.

## Features

- ✅ Dashboard dengan overview penjualan & stok
- ✅ Manajemen Produk (CRUD)
- ✅ Kasir/POS System
- ✅ Manajemen Stok
- ✅ Laporan Penjualan
- ✅ Data disimpan di Session (tanpa database)
- ✅ Responsive Design dengan Orange Theme

## Requirements

- PHP 8.1+
- Composer
- Laravel 10.x

## Instalasi & Running

### 1. Clone/Extract project ke folder

```bash
cd laravel
```

### 2. Install dependencies

```bash
composer install
```

### 3. Setup .env

```bash
cp .env.example .env
php artisan key:generate
```

### 4. Jalankan Laravel

```bash
php artisan serve
```

Aplikasi akan berjalan di `http://localhost:8000`

## Login

- **Email**: Gunakan email apapun (contoh: admin@petshop.com)
- **Password**: Gunakan password apapun (minimal 3 karakter)
- Demo mode - tidak ada validasi backend yang ketat

## File Structure

```
laravel/
├── app/
│   └── Http/
│       └── Controllers/
│           └── PetshopController.php    # Main controller
├── resources/
│   └── views/
│       ├── layout.blade.php              # Base layout
│       ├── auth/login.blade.php          # Login page
│       ├── dashboard.blade.php           # Dashboard
│       ├── produk.blade.php              # Product management
│       ├── pos.blade.php                 # POS/Cashier
│       ├── stok.blade.php                # Stock management
│       └── laporan.blade.php             # Reports
├── public/
│   ├── css/style.css                     # Main stylesheet
│   ├── js/app.js                         # Global functions
│   └── images/logo.svg                   # Tomodachi logo
├── routes/
│   └── web.php                           # Route definitions
└── .env.example                          # Environment template
```

## Routes

| Halaman | URL | Deskripsi |
|---------|-----|-----------|
| Login | `/` | Halaman login |
| Dashboard | `/dashboard` | Dashboard utama |
| Produk | `/produk` | Manajemen produk |
| Kasir | `/pos` | Sistem POS |
| Stok | `/stok` | Manajemen stok |
| Laporan | `/laporan` | Laporan penjualan |

## Data Storage

Semua data disimpan di session (temporary). Data akan hilang jika:
- Browser cache dibersihkan
- User logout
- Browser ditutup

Untuk persistensi data, tambahkan database MySQL/SQLite.

## Development Notes

- UI sudah responsive untuk mobile
- Menggunakan Font Awesome 6.4.0 untuk icons
- Orange color scheme (#F4A460, #FF8C42)
- Session-based authentication (demo only)

## Next Steps (Optional)

Untuk production:
1. Tambahkan real database (MySQL/SQLite)
2. Implement proper authentication (Laravel Sanctum/Passport)
3. Tambahkan validation layer
4. Setup CSRF protection lebih ketat
5. Tambahkan file upload untuk product images
6. Export PDF functionality untuk laporan

---

**Version**: 1.0.0  
**Author**: Tomodachi Pet Shop Development  
**Last Updated**: 2026-04-30
