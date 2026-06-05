# 📱 Tomodachi Pet Shop - Dokumentasi Proyek

## Ringkasan Proyek

**Tomodachi Pet Shop** adalah sistem informasi manajemen untuk pet shop yang lengkap dengan fitur inventory, penjualan, laporan, dan manajemen pengguna. Proyek ini dibangun menggunakan **Laravel 10** untuk backend dan **Flutter** untuk aplikasi mobile.

### Visi & Misi

**Visi**: Menyediakan sistem manajemen pet shop yang modern, efisien, dan mudah digunakan.

**Misi**: 
- Mengelola inventory produk dengan mudah
- Mencatat setiap transaksi penjualan
- Mengintegrasikan payment gateway (Midtrans)
- Memberikan laporan penjualan yang akurat
- Mendukung akses multi-user dengan role berbeda

---

## 🏗 Arsitektur Sistem

### Gambaran Umum

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Mobile App                        │
│              (Android, iOS, Web, Linux, Windows)             │
└────────────────────┬────────────────────────────────────────┘
                     │
              HTTP/REST API
                     │
┌────────────────────▼────────────────────────────────────────┐
│              Laravel 10 REST API Backend                      │
│  (Authentication, Product, Category, Transaction, Report)   │
└────────────────────┬────────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────────┐
│                    MySQL Database                            │
│ (Users, Products, Categories, Stock, Transactions, Reports) │
└─────────────────────────────────────────────────────────────┘

        ┌───────────────────────────────────┐
        │    Third-Party Services            │
        │  - Midtrans (Payment Gateway)     │
        │  - JWT (Authentication)            │
        └───────────────────────────────────┘
```

### Teknologi & Stack

#### Backend
- **Framework**: Laravel 10
- **Database**: MySQL/MariaDB
- **Authentication**: Laravel Sanctum (JWT)
- **Payment Gateway**: Midtrans
- **API Documentation**: RESTful JSON API
- **Web Server**: PHP 8.1+

#### Frontend
- **Framework**: Flutter 3.x
- **State Management**: Provider/Notifier
- **HTTP Client**: Dio/http
- **Local Storage**: flutter_secure_storage
- **Platform Support**: Android, iOS, Web, Linux, Windows

#### Development Tools
- **Version Control**: Git
- **Package Manager**: Composer (PHP), pub (Dart)
- **Environment**: Laragon, XAMPP, atau Docker

---

## 📊 Fitur Utama

### 1. **Authentication & Authorization**
- Login dengan email dan password
- Role-based access control (Owner, Manager, Cashier)
- Token-based authentication (Sanctum)
- Logout dengan token invalidation

### 2. **Manajemen Produk**
- CRUD produk dengan kategori
- Tracking stok online dan offline
- Margin pricing calculation
- Multi-image support
- Filter dan search produk

### 3. **Manajemen Kategori**
- Organisasi produk berdasarkan tipe hewan
- Sub-kategori untuk setiap tipe hewan
- Breakdown kategori di dashboard

### 4. **Penjualan & POS**
- Point of Sale (POS) system
- Cart management
- Multiple payment methods (Cash, E-wallet, Bank Transfer)
- Integration dengan Midtrans
- Order confirmation dan receipt

### 5. **Laporan & Analytics**
- Dashboard dengan KPI (Key Performance Indicators)
- Sales trending
- Top products report
- Category breakdown analysis
- Transaction history

### 6. **Manajemen Stok**
- Real-time inventory tracking
- Online vs Offline quantity
- Minimum threshold alerts
- Stock adjustment

---

## 👥 User Roles & Permissions

### Owner
- Akses penuh ke semua fitur
- Lihat pricing dan margin
- Buat user baru
- Akses laporan lengkap

### Manager
- Manajemen produk & kategori
- Lihat laporan penjualan
- Tidak bisa melihat harga beli

### Cashier
- Akses POS system
- Input penjualan
- Tidak bisa melihat harga beli
- Tidak bisa manajemen produk

---

## 🗂 Struktur Folder

```
Project-Tomodachi-Pet-Shop/
├── backend/                    # Laravel API
│   ├── app/
│   │   ├── Http/
│   │   │   ├── Controllers/   # API Controllers
│   │   │   └── Middleware/    # Auth & Custom Middleware
│   │   ├── Models/            # Database Models
│   │   └── Exceptions/        # Custom Exceptions
│   ├── database/
│   │   ├── migrations/        # Database Schema
│   │   └── seeders/          # Database Seeds
│   ├── routes/
│   │   └── api.php           # API Routes
│   ├── config/               # Configuration Files
│   └── storage/              # File uploads
│
├── frontend/                  # Flutter App
│   ├── lib/
│   │   ├── api_client*.dart  # HTTP Clients
│   │   ├── screens/          # UI Screens
│   │   ├── services/         # Business Logic
│   │   └── widgets/          # Reusable Widgets
│   ├── pubspec.yaml          # Dependencies
│   └── test/                 # Unit Tests
│
├── docs/                      # Documentation
│   ├── api-contract/         # API Specifications
│   ├── diagrams/             # ERD & Architecture
│   └── *.md                  # Documentation Files
│
└── docker-compose.yml        # Docker Configuration
```

---

## 🚀 Quick Start

### Prerequisites
- PHP 8.1+
- Composer
- Flutter 3.x
- MySQL/MariaDB
- Git

### Setup Backend

```bash
# Navigate to backend folder
cd backend

# Install dependencies
composer install

# Setup environment
cp .env.example .env

# Generate app key
php artisan key:generate

# Run migrations
php artisan migrate

# (Optional) Seed database
php artisan db:seed
```

### Setup Frontend

```bash
# Navigate to frontend folder
cd frontend

# Get Flutter dependencies
flutter pub get

# Run app
flutter run
```

---

## 📱 Base URLs

### Development

- **Android Emulator**: `http://10.0.2.2:8000`
- **iOS Simulator**: `http://localhost:8000`
- **Web**: `http://localhost:8000`
- **Linux/Windows**: `http://localhost:8000`

### Production

Configure via environment variables atau config files.

---

## 🔐 Security Features

1. **Authentication**: Sanctum Token-based JWT
2. **CORS**: Configured untuk secure cross-origin requests
3. **Password Hashing**: Bcrypt
4. **Request Validation**: Input validation di setiap endpoint
5. **File Upload Security**: Restricted file types
6. **Soft Deletes**: Data tidak langsung dihapus
7. **Secure Storage**: flutter_secure_storage untuk credentials

---

## 📋 Development Workflow

1. **Create a feature branch**
   ```bash
   git checkout -b feature/feature-name
   ```

2. **Make changes** di backend atau frontend

3. **Test locally**
   ```bash
   # Backend
   php artisan test
   
   # Frontend
   flutter test
   ```

4. **Commit dengan pesan yang jelas**
   ```bash
   git commit -m "feat: add new feature description"
   ```

5. **Push ke repository**
   ```bash
   git push origin feature/feature-name
   ```

6. **Create Pull Request** untuk review

---

## 🐛 Troubleshooting

### Backend Issues

- **Connection Refused**: Pastikan Laravel server berjalan (`php artisan serve`)
- **CORS Error**: Check CORS configuration di `config/cors.php`
- **Database Error**: Verify MySQL connection di `.env`

### Frontend Issues

- **Cannot Connect to API**: Verify API base URL (10.0.2.2 untuk emulator)
- **Build Error**: Run `flutter clean` dan `flutter pub get`
- **State Management**: Check Provider initialization

---

## 📚 Documentation Files

- `SETUP_GUIDE.md` - Panduan instalasi lengkap
- `BACKEND_DOCUMENTATION.md` - Dokumentasi backend
- `FRONTEND_DOCUMENTATION.md` - Dokumentasi frontend
- `DATABASE_SCHEMA.md` - Struktur database
- `API_REFERENCE.md` - Referensi API endpoints
- `DEVELOPMENT_GUIDE.md` - Panduan development
- `PROJECT_STRUCTURE.md` - Struktur proyek detail

---

## 📞 Support & Contact

Untuk pertanyaan atau issues, silakan buat issue di repository atau hubungi tim development.

---

## 📄 License

Tomodachi Pet Shop © 2024. All rights reserved.

---

**Last Updated**: 2024-06-05
**Version**: 1.0.0
