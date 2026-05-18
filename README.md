# Tomodachi Pet Shop

Sistem Informasi Manajemen Tomodachi Pet Shop terdiri dari:

- `backend`: Laravel 10 REST API
- `frontend`: Flutter mobile app
- `docs`: SRS, API contract, dan diagram pendukung

Backend menyimpan data di MySQL dan menyediakan API untuk produk, kategori, stok, dan transaksi. Frontend Flutter membaca API Laravel melalui base URL seperti `http://10.0.2.2:8000/api` untuk Android emulator.

## Prasyarat

Pastikan sudah terpasang:

- PHP 8.1 atau lebih baru
- Composer
- MySQL atau MariaDB
- Flutter SDK
- Git
- Laragon, XAMPP, atau environment server lokal sejenis

## Instalasi Setelah Clone

Clone repository, lalu masuk ke folder project:

```bash
git clone <url-repository>
cd Project-Tomodachi-Pet-Shop
```

## Setup Backend Laravel

Masuk ke folder backend:

```bash
cd backend
composer install
```

Buat file `.env`. Jika belum ada `backend/.env.example`, gunakan file `.env.example` dari root project:

```bash
copy ..\.env.example .env
```

Untuk Git Bash atau Linux/macOS:

```bash
cp ../.env.example .env
```

Generate application key:

```bash
php artisan key:generate
```

Atur koneksi database di `backend/.env`, contoh untuk Laragon:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=tomodachi_petshop
DB_USERNAME=root
DB_PASSWORD=
```

Buat database `tomodachi_petshop` di MySQL, lalu jalankan migration dan seeder:

```bash
php artisan migrate --seed
```

Jika ingin reset database dari awal:

```bash
php artisan migrate:fresh --seed
```

Jalankan backend:

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

Endpoint penting:

- Root status: `http://127.0.0.1:8000`
- API health: `http://127.0.0.1:8000/api/health`
- Produk: `http://127.0.0.1:8000/api/products`
- Kategori: `http://127.0.0.1:8000/api/categories`

## Setup Frontend Flutter

Buka terminal baru dari root project, lalu masuk ke folder frontend:

```bash
cd frontend
flutter pub get
flutter run
```

Base URL API yang digunakan di aplikasi:

- Android emulator: `http://10.0.2.2:8000/api`
- Windows desktop / iOS simulator: `http://127.0.0.1:8000/api`
- HP fisik: gunakan IP laptop di jaringan yang sama, contoh `http://192.168.1.10:8000/api`

Jika menggunakan HP fisik, jalankan backend dengan:

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

Pastikan firewall mengizinkan akses ke port `8000`.

## Verifikasi

Cek backend:

```bash
cd backend
php artisan route:list --path=api
```

Cek frontend:

```bash
cd frontend
flutter analyze
flutter test
```

## Struktur Project

```text
Project-Tomodachi-Pet-Shop/
├── backend/
│   ├── app/
│   ├── database/
│   ├── routes/
│   └── composer.json
├── frontend/
│   ├── lib/
│   ├── android/
│   ├── test/
│   └── pubspec.yaml
├── docs/
│   ├── api-contract/
│   └── diagrams/
└── README.md
```
+-- backend/
|   +-- app/
|   +-- database/
|   +-- routes/
|   +-- composer.json
+-- frontend/
|   +-- lib/
|   +-- android/
|   +-- test/
|   +-- pubspec.yaml
+-- docs/
|   +-- api-contract/
|   +-- diagrams/
+-- README.md

```