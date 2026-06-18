# Docker Deployment Guide

Panduan ini menjelaskan cara menjalankan stack Tomodachi Pet Shop dengan Docker, lalu menyiapkan image untuk production lewat Docker Hub.

## Isi Folder

- `docker-compose.yml`: untuk development/local. Image backend dan frontend dibuild dari source lokal.
- `docker-compose.prod.yml`: untuk production/server backend API. Image backend dipull dari Docker Hub.
- `.env.laravel`: environment Laravel yang dimount ke container.
- `nginx/conf.d/default.conf`: Nginx reverse proxy untuk Laravel API dan storage.

## Arsitektur

```text
Browser / Mobile App
-> Nginx
-> Laravel PHP-FPM
-> MySQL
```

Flutter mobile tidak berjalan di Docker. Docker hanya menjadi backend public yang diakses oleh aplikasi HP.

## Environment Yang Dibutuhkan

Compose membaca variable dari shell atau file `.env` di folder `docker`.

Minimal variable:

```env
APP_KEY=base64:your-laravel-app-key
DB_ROOT_PASSWORD=strong-root-password
DB_DATABASE=tomodachi
DB_USERNAME=tomodachi_user
DB_PASSWORD=strong-db-password
NGINX_PORT=80
```

Untuk production image backend:

```env
BACKEND_IMAGE=dockerhubusername/tomodachi-backend:latest
```

Pastikan `.env.laravel` production berisi:

```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://domain-kamu.com

MIDTRANS_IS_PRODUCTION=true
MIDTRANS_SERVER_KEY=your-production-server-key
MIDTRANS_CLIENT_KEY=your-production-client-key
```

Jangan commit key production, password database, atau secret lain ke repository public.

## Local Run

Dari folder `docker`:

```powershell
docker compose up -d --build
```

Build Flutter Web ke volume `flutter_web`:

```powershell
docker compose --profile build up --build flutter_builder
docker compose up -d
```

Cek API:

```powershell
curl.exe http://localhost/api/health
```

Jalankan seeder user demo:

```powershell
docker compose exec laravel php artisan db:seed --force
```

Login demo:

```text
admin@tomodachi.com
password123
```

## Build dan Push ke Docker Hub

Dari root project:

```powershell
docker login
```

Build image backend:

```powershell
docker build -t dockerhubusername/tomodachi-backend:latest ./backend
```

Push image:

```powershell
docker push dockerhubusername/tomodachi-backend:latest
```

Atau dari folder `docker`, gunakan compose local:

```powershell
$env:BACKEND_IMAGE="dockerhubusername/tomodachi-backend:latest"

docker compose build laravel
docker compose push laravel
```

## Production Run di Server

Di server/VPS, siapkan folder `docker` beserta:

- `docker-compose.prod.yml`
- `.env.laravel`
- `nginx/conf.d/default.conf`
- file `.env` untuk variable compose

Contoh `.env` di folder `docker`:

```env
APP_KEY=base64:your-laravel-app-key
DB_ROOT_PASSWORD=strong-root-password
DB_DATABASE=tomodachi
DB_USERNAME=tomodachi_user
DB_PASSWORD=strong-db-password
NGINX_PORT=80
BACKEND_IMAGE=dockerhubusername/tomodachi-backend:latest
```

Pull image:

```powershell
docker compose -f docker-compose.prod.yml pull
```

Jalankan stack:

```powershell
docker compose -f docker-compose.prod.yml up -d
```

Jalankan migration dan seeder bila perlu:

```powershell
docker compose -f docker-compose.prod.yml exec laravel php artisan migrate --force
docker compose -f docker-compose.prod.yml exec laravel php artisan db:seed --force
```

Catatan: entrypoint Laravel sudah menjalankan migration otomatis saat container start. Seeder tetap dijalankan manual agar tidak menimpa data production tanpa sadar.

## HTTPS dan Domain

Untuk production, gunakan HTTPS. Pilihan umum:

- Cloudflare + reverse proxy
- Caddy
- Traefik
- Nginx + Certbot

Jika memakai reverse proxy di depan compose, Nginx container tetap bisa expose port internal/server seperti `80`, lalu proxy public menangani TLS `443`.

## Midtrans Callback

Set Notification URL di dashboard Midtrans:

```text
https://domain-kamu.com/api/midtrans/notification
```

Untuk development dengan ngrok:

```powershell
ngrok http 80
```

Lalu gunakan:

```text
https://url-ngrok-kamu/api/midtrans/notification
```

Tes API lewat domain/ngrok:

```powershell
curl.exe https://domain-kamu.com/api/health
```

## Flutter Mobile

Build APK/AAB dengan API production:

```powershell
cd ../frontend
flutter build apk --release --dart-define=API_BASE_URL=https://domain-kamu.com
```

Untuk Play Store:

```powershell
flutter build appbundle --release --dart-define=API_BASE_URL=https://domain-kamu.com
```

## Troubleshooting

Jika login `401 Invalid credentials`:

```powershell
docker compose exec laravel php artisan db:seed --force
```

Jika callback Midtrans `404`:

```powershell
docker compose exec laravel php artisan route:list --path=midtrans
curl.exe -i -X POST http://localhost/api/midtrans/notification -H "Content-Type: application/json" -d "{}"
```

Endpoint yang benar akan merespons `422` untuk payload kosong, bukan Nginx `404`.

Jika image salah tag:

```powershell
docker rmi dockerhubusername/tomodachi-backend:latest
```

## Data Persisten

Volume penting:

- `mysql_data`: data database.
- `laravel_public_storage`: file public storage Laravel, misalnya gambar produk.

Hati-hati dengan:

```powershell
docker compose down -v
```

Command itu menghapus volume, termasuk database lokal.
