# 🐾 Tomodachi Pet Shop

Sistem Informasi Manajemen **Tomodachi Pet Shop** — aplikasi kasir & manajemen stok untuk toko hewan peliharaan.

| Layer | Teknologi |
|---|---|
| **Backend** | Laravel 10 (REST API) |
| **Frontend** | Flutter (Android, Web) |
| **Database** | MySQL 8.0 |
| **Reverse Proxy** | Nginx (Docker) |
| **Pembayaran** | Midtrans Snap |
| **AI Assistant** | OpenRouter (Qwen / GPT) |

---

## 📋 Daftar Isi

- [Prasyarat](#prasyarat)
- [Akun Default (Seeder)](#akun-default-seeder)
- [Instalasi Lokal (Laragon/XAMPP)](#instalasi-lokal-laragonxampp)
- [Deployment Docker](#deployment-docker)
- [Konfigurasi Environment Variables](#konfigurasi-environment-variables)
- [Setup Flutter Frontend](#setup-flutter-frontend)
- [Struktur Project](#struktur-project)
- [Troubleshooting](#troubleshooting)

---

## Prasyarat

### Untuk Instalasi Lokal
- PHP 8.1+
- Composer
- MySQL 8.0 / MariaDB 10.6+
- Flutter SDK 3.x
- Git
- Laragon, XAMPP, atau environment server lokal sejenis

### Untuk Deployment Docker
- Docker Engine 24+
- Docker Compose v2+
- (Production) Akun Docker Hub

---

## Akun Default (Seeder)

Setelah menjalankan `php artisan migrate --seed`, akun berikut tersedia:

---

## Instalasi Lokal (Laragon/XAMPP)

### 1. Clone Repository

```bash
git clone <url-repository>
cd Project-Tomodachi-Pet-Shop
```

### 2. Setup Backend Laravel

```bash
cd backend
composer install
```

Buat file `.env` dari contoh:

```bash
# Windows (Command Prompt / PowerShell)
copy .env.example .env

# Git Bash / Linux / macOS
cp .env.example .env
```

Generate application key:

```bash
php artisan key:generate
```

Atur koneksi database di `backend/.env`:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=tomodachi_petshop
DB_USERNAME=root
DB_PASSWORD=
```

Isi juga variabel API pihak ketiga (lihat [seksi env vars](#konfigurasi-environment-variables)).

Buat database `tomodachi_petshop` di MySQL, lalu jalankan migration dan seeder:

```bash
php artisan migrate --seed
```

Untuk reset database dari awal:

```bash
php artisan migrate:fresh --seed
```

Jalankan backend:

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

### 3. Verifikasi Backend

```bash
# Cek semua route API
php artisan route:list --path=api

# Cek health endpoint
curl http://127.0.0.1:8000/api/health
```

---

## Deployment Docker

### Struktur Docker

```
docker/
├── docker-compose.yml          # Development stack
├── docker-compose.prod.yml     # Production stack (image dari Docker Hub)
├── .env.example                # Template env untuk Docker
├── backup.sh                   # Script backup MySQL otomatis
├── Makefile                    # Shortcut command
└── nginx/conf.d/default.conf   # Konfigurasi Nginx
```

### Setup Awal

```bash
cd docker

# Salin env template
cp .env.example .env

# Edit .env sesuai kebutuhan (wajib isi semua nilai yang bertanda replace-with-...)
```

### Development (Build Lokal)

```bash
# Jalankan semua service (Nginx, Laravel, MySQL, Backup)
make up

# Atau tanpa Makefile:
docker compose up -d

# Lihat logs
make logs

# Masuk ke shell Laravel container
make shell

# Jalankan migration
make migrate

# Reset database (HAPUS semua data!)
make fresh
```

### Production (Image dari Docker Hub)

**Langkah 1 — Build & push image backend** (dari laptop developer):

```bash
cd docker

# Set BACKEND_IMAGE di .env terlebih dahulu, contoh:
# BACKEND_IMAGE=dockerhubusername/tomodachi-backend:latest

make build-backend
```

**Langkah 2 — Deploy di VPS:**

```bash
# Pull repository terbaru
git pull

cd docker

# Pastikan .env sudah terisi lengkap
cp .env.example .env && nano .env

# Jalankan production stack
make prod-up

# Jalankan migration pertama kali
docker exec tomodachi_laravel php artisan migrate --seed
```

**Langkah 3 — Verifikasi:**

```bash
# Cek semua container berjalan
docker ps

# Cek logs Laravel
make prod-logs

# Cek backup MySQL berjalan
make prod-backup-list
```

### Perintah Backup MySQL

Backup berjalan **otomatis setiap 24 jam** dan menyimpan file `.sql.gz` selama 7 hari.

```bash
# Trigger backup manual sekarang
make backup          # (dev)
make prod-backup     # (production)

# Lihat log backup
make backup-logs

# Lihat daftar file backup tersimpan
make backup-list
```

---

## Konfigurasi Environment Variables

### Docker `.env` (di folder `docker/`)

| Variable | Keterangan | Contoh |
|---|---|---|
| `APP_KEY` | Laravel app key (generate: `php artisan key:generate --show`) | `base64:xxx...` |
| `DB_ROOT_PASSWORD` | Password root MySQL | `super_secret_root` |
| `DB_DATABASE` | Nama database | `tomodachi_petshop` |
| `DB_USERNAME` | User database | `tomodachi_user` |
| `DB_PASSWORD` | Password user database | `secret_db_pass` |
| `BACKEND_IMAGE` | Docker Hub image backend | `user/tomodachi-backend:latest` |
| `NGINX_PORT` | Port yang diekspos Nginx | `80` |
| `APP_URL` | URL publik aplikasi | `https://tomodachi-petshop.xyz` |
| `BACKUP_RETAIN_DAYS` | Lama penyimpanan backup (hari) | `7` |

### Midtrans (Payment Gateway)

Daftar di [dashboard.midtrans.com](https://dashboard.midtrans.com):

| Variable | Keterangan |
|---|---|
| `MIDTRANS_SERVER_KEY` | Server key dari Midtrans dashboard |
| `MIDTRANS_CLIENT_KEY` | Client key dari Midtrans dashboard |
| `MIDTRANS_IS_PRODUCTION` | `false` untuk sandbox, `true` untuk production |

### OpenRouter (AI Assistant)

Daftar di [openrouter.ai](https://openrouter.ai) dan buat API key gratis:

| Variable | Keterangan |
|---|---|
| `OPENROUTER_API_KEY` | API key dari OpenRouter |
| `OPENROUTER_MODEL` | Model utama (contoh: `qwen/qwen3-next-80b-a3b-instruct:free`) |
| `OPENROUTER_FALLBACK_MODELS` | Model cadangan dipisah koma |

---

## Setup Flutter Frontend

### Instalasi Dependensi

```bash
cd frontend
flutter pub get
```

### Jalankan di Emulator / Device

```bash
# Android emulator (backend di localhost)
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000

# HP fisik (ganti IP dengan IP laptop di jaringan yang sama)
flutter run --dart-define=MOBILE_API_BASE_URL=http://192.168.1.10:8000

# Chrome (web)
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000

# Menggunakan ngrok (untuk HP fisik tanpa satu jaringan)
flutter run --dart-define=MOBILE_API_BASE_URL=https://xxxx.ngrok-free.app
```

### Build Release APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build Web (untuk Docker)

Web build dikerjakan oleh `flutter_builder` container secara otomatis saat `docker compose up --profile build`.

---

## Struktur Project

```
Project-Tomodachi-Pet-Shop/
├── backend/                    # Laravel 10 REST API
│   ├── app/
│   │   ├── Http/Controllers/Api/
│   │   ├── Models/
│   │   ├── Providers/          # RouteServiceProvider (rate limiting)
│   │   └── Services/           # AiService, RestockAnalysisService
│   ├── database/
│   │   ├── migrations/
│   │   └── seeders/
│   ├── routes/api.php
│   └── .env.example
├── frontend/                   # Flutter app
│   ├── lib/
│   │   ├── screens/
│   │   ├── models/
│   │   ├── services/
│   │   └── widgets/
│   └── pubspec.yaml
├── docker/                     # Docker & deployment config
│   ├── docker-compose.yml
│   ├── docker-compose.prod.yml
│   ├── backup.sh               # Script backup MySQL otomatis
│   ├── Makefile
│   └── nginx/
├── docs/                       # Dokumentasi tambahan
│   ├── api-contract/
│   └── diagrams/
└── README.md
```

---

## Troubleshooting

### ❌ `SQLSTATE[HY000] [2002] Connection refused`
Database MySQL belum berjalan. Jalankan Laragon/XAMPP terlebih dahulu, atau `make up` jika pakai Docker.

### ❌ `php artisan key:generate` gagal
Pastikan file `.env` sudah ada (`cp .env.example .env`).

### ❌ Flutter: `SocketException: Connection refused`
- Emulator Android → gunakan `10.0.2.2` bukan `localhost`
- HP fisik → pastikan backend dijalankan dengan `--host=0.0.0.0` dan firewall mengizinkan port 8000

### ❌ Login gagal di aplikasi (HTTP 429)
Rate limiting aktif. Tunggu 1 menit setelah 5 kali percobaan login gagal.

### ❌ AI Assistant tidak merespons
Periksa `OPENROUTER_API_KEY` di `.env`. Bisa didapat gratis di [openrouter.ai](https://openrouter.ai).

### ❌ Midtrans payment error
Pastikan `MIDTRANS_SERVER_KEY` dan `MIDTRANS_CLIENT_KEY` sesuai dengan environment (`sandbox` vs `production`).

### ❌ Docker container backup tidak muncul di `docker ps`
Pastikan `backup.sh` ada di folder `docker/` dan memiliki izin eksekusi:
```bash
# Di Linux/macOS
chmod +x docker/backup.sh

# Restart container backup
docker compose restart mysql_backup
```