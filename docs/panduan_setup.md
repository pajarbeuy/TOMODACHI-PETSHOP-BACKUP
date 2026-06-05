# 🚀 Setup Guide - Complete Installation Guide

## Table of Contents
1. [System Requirements](#system-requirements)
2. [Prerequisites Installation](#prerequisites-installation)
3. [Backend Setup](#backend-setup)
4. [Frontend Setup](#frontend-setup)
5. [Database Setup](#database-setup)
6. [Configuration](#configuration)
7. [Running the Application](#running-the-application)
8. [Verification](#verification)
9. [Troubleshooting](#troubleshooting)

---

## System Requirements

### Windows

- **OS**: Windows 7 or later
- **RAM**: Minimum 4GB (8GB recommended)
- **Disk**: 10GB free space
- **Processor**: Intel or AMD x64 processor

### macOS

- **OS**: macOS 10.13 or later
- **RAM**: Minimum 4GB (8GB recommended)
- **Disk**: 10GB free space
- **Processor**: Intel or Apple Silicon

### Linux

- **OS**: Ubuntu 18.04 or later (or equivalent)
- **RAM**: Minimum 4GB (8GB recommended)
- **Disk**: 10GB free space
- **Processor**: x64 processor

---

## Prerequisites Installation

### 1. Install PHP 8.1+

#### Windows
```bash
# Option A: Using Laragon (Recommended)
1. Download Laragon from https://laragon.org
2. Run installer
3. PHP is included
4. Start Laragon

# Option B: Using XAMPP
1. Download XAMPP from https://www.apachefriends.org
2. Run installer
3. Select PHP 8.1+
4. Start Apache & MySQL
```

#### macOS
```bash
# Using Homebrew
brew install php@8.1
brew services start php@8.1

# Verify
php -v
```

#### Linux
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install php8.1 php8.1-cli php8.1-mysql php8.1-xml php8.1-curl php8.1-mbstring

# Verify
php -v
```

### 2. Install Composer

**Windows/macOS/Linux**:
```bash
# Download from https://getcomposer.org
# Or using package manager:

# macOS with Homebrew
brew install composer

# Linux
sudo apt install composer

# Windows (Scoop)
scoop install composer

# Verify
composer --version
```

### 3. Install MySQL/MariaDB

#### Windows
```bash
# Option A: Laragon (included)
# Already included in Laragon setup

# Option B: XAMPP (included)
# Already included in XAMPP setup

# Option C: Standalone MySQL
# Download from https://dev.mysql.com/downloads/mysql/
# Run installer and follow wizard
```

#### macOS
```bash
# Using Homebrew
brew install mysql@8.0
brew services start mysql@8.0

# Or using Docker
docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=password mysql:8.0
```

#### Linux
```bash
# Ubuntu/Debian
sudo apt install mysql-server
sudo mysql_secure_installation
sudo service mysql start

# Or Docker
docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=password mysql:8.0
```

### 4. Install Git

#### Windows
```bash
# Download from https://git-scm.com/download/win
# Run installer
# Select "Use Git from the command line"
```

#### macOS
```bash
# Using Homebrew
brew install git

# Or Xcode Command Line Tools
xcode-select --install
```

#### Linux
```bash
# Ubuntu/Debian
sudo apt install git
```

**Verify**:
```bash
git --version
```

### 5. Install Flutter & Dart

#### Windows
```bash
# 1. Download Flutter SDK from https://flutter.dev/docs/get-started/install
# 2. Extract to C:\src\flutter (or preferred location)
# 3. Add to PATH:
#    - Settings → System → Advanced system settings
#    - Environment Variables → Path → Add C:\src\flutter\bin
# 4. Verify
flutter doctor
```

#### macOS
```bash
# Using Homebrew
brew install flutter

# Or Manual Installation
# 1. Download from https://flutter.dev/docs/get-started/install
# 2. Extract to ~/Development/flutter
# 3. Add to PATH:
#    echo "export PATH=\"\$HOME/Development/flutter/bin:\$PATH\"" >> ~/.zshrc
#    source ~/.zshrc

flutter doctor
```

#### Linux
```bash
# 1. Download from https://flutter.dev/docs/get-started/install
# 2. Extract to ~/Development/flutter
# 3. Add to PATH:
#    echo "export PATH=\"\$HOME/Development/flutter/bin:\$PATH\"\" >> ~/.bashrc
#    source ~/.bashrc
# 4. Verify
flutter doctor
```

### 6. Setup Flutter Development Environment

After installing Flutter:

```bash
# Accept Android licenses
flutter doctor --android-licenses

# Check status
flutter doctor

# You should see:
# ✓ Flutter 3.x.x
# ✓ Dart SDK version 3.x.x
# ✓ Android SDK (if developing for Android)
# ✓ Xcode (if on macOS/iOS)
```

---

## Backend Setup

### Step 1: Clone Repository

```bash
# Clone the repository
git clone https://github.com/your-org/Project-Tomodachi-Pet-Shop.git

# Navigate to project
cd Project-Tomodachi-Pet-Shop
```

### Step 2: Setup Backend Files

```bash
# Navigate to backend folder
cd backend

# Install PHP dependencies
composer install

# Create environment file
# Windows
copy .env.example .env

# macOS/Linux
cp .env.example .env
```

### Step 3: Configure Environment

Edit `backend/.env`:

```env
APP_NAME="Tomodachi Pet Shop"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost:8000

# Database Configuration
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=tomodachi_petshop
DB_USERNAME=root
DB_PASSWORD=

# If using XAMPP/Laragon default credentials:
# DB_USERNAME=root
# DB_PASSWORD=

# Sanctum/JWT
SANCTUM_STATEFUL_DOMAINS=localhost:3000,10.0.2.2:3000

# Midtrans Configuration (optional for testing)
MIDTRANS_MERCHANT_ID=M123456
MIDTRANS_CLIENT_KEY=your_client_key
MIDTRANS_SERVER_KEY=your_server_key
MIDTRANS_IS_PRODUCTION=false
```

### Step 4: Generate Application Key

```bash
php artisan key:generate

# Output should show:
# Application key set successfully.
```

### Step 5: Create Database

```bash
# Method 1: MySQL CLI
mysql -u root
CREATE DATABASE tomodachi_petshop;
EXIT;

# Method 2: PHPMyAdmin (if using XAMPP/Laragon)
# 1. Open http://localhost/phpmyadmin
# 2. Click "New"
# 3. Database name: tomodachi_petshop
# 4. Collation: utf8mb4_unicode_ci
# 5. Create
```

### Step 6: Run Migrations & Seeds

```bash
# Run migrations
php artisan migrate

# Seed database with initial data
php artisan db:seed

# Or seed specific tables
php artisan db:seed --class=RoleSeeder
php artisan db:seed --class=UserSeeder
```

---

## Frontend Setup

### Step 1: Navigate to Frontend

```bash
# From project root
cd frontend

# Get Flutter dependencies
flutter pub get

# Clean build
flutter clean
flutter pub get
```

### Step 2: Configure API Base URL

Edit `lib/main.dart` or create `lib/config/api_config.dart`:

```dart
// For Android Emulator
const String apiBaseUrl = 'http://10.0.2.2:8000';

// For iOS Simulator
const String apiBaseUrl = 'http://localhost:8000';

// For Web
const String apiBaseUrl = 'http://localhost:8000';

// For Physical Device (replace with your machine IP)
const String apiBaseUrl = 'http://192.168.x.x:8000';
```

### Step 3: Verify Flutter Setup

```bash
# Check Flutter installation
flutter doctor

# All checks should show green checkmarks (✓)
# If any issues, follow Flutter's recommendations

# Get device ID
flutter devices

# You should see at least one device/emulator available
```

---

## Database Setup

### Initial Data

#### Roles
```sql
INSERT INTO roles (id, name, description) VALUES
(1, 'owner', 'Owner of the pet shop'),
(2, 'manager', 'Manager - can manage products'),
(3, 'cashier', 'Cashier - POS operator');
```

#### Demo Users
```sql
INSERT INTO users (name, email, password, role_id, is_active) VALUES
('Owner User', 'owner@tomodachi.com', bcrypt('password'), 1, true),
('Manager User', 'manager@tomodachi.com', bcrypt('password'), 2, true),
('Cashier User', 'cashier@tomodachi.com', bcrypt('password'), 3, true);
```

#### Demo Categories
```sql
INSERT INTO categories (animal_type, sub_category) VALUES
('dog', 'food'),
('dog', 'accessories'),
('cat', 'food'),
('cat', 'toys'),
('bird', 'food'),
('fish', 'food');
```

### Running Seeders

```bash
cd backend

# Run all seeders
php artisan db:seed

# Run specific seeder
php artisan db:seed --class=CategorySeeder

# Reset and seed
php artisan migrate:fresh --seed
```

---

## Configuration

### Backend Configuration Files

#### config/app.php
```php
'name' => env('APP_NAME', 'Tomodachi Pet Shop'),
'debug' => env('APP_DEBUG', false),
'timezone' => 'Asia/Jakarta',
```

#### config/cors.php
```php
'paths' => ['api/*'],
'allowed_methods' => ['*'],
'allowed_origins' => ['*'],
'supports_credentials' => true,
```

#### config/sanctum.php
```php
'stateful' => explode(',', env('SANCTUM_STATEFUL_DOMAINS', 'localhost')),
'expiration' => null,  // No expiration
```

### Frontend Configuration Files

#### pubspec.yaml
Key packages:
```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.3.0
  provider: ^6.0.0
  flutter_secure_storage: ^9.2.2
  google_fonts: ^6.2.1
  url_launcher: ^6.3.1
```

---

## Running the Application

### Terminal Setup

You need **2 terminal windows**:

#### Terminal 1: Backend Server

```bash
cd backend

# Start Laravel development server
php artisan serve

# Output should show:
# INFO Server running on [http://127.0.0.1:8000]
# Listening on: http://127.0.0.1:8000
```

#### Terminal 2: Flutter App

```bash
cd frontend

# For Android Emulator
flutter run -d emulator-5554

# For iOS Simulator
flutter run -d iphone

# For Chrome Web
flutter run -d chrome

# For Physical Device
flutter run -d <device_id>

# Or just
flutter run
# (If only one device connected)
```

### Full Startup Checklist

- [ ] MySQL server running
- [ ] PHP environment available
- [ ] Backend: `php artisan serve` running
- [ ] Frontend: device/emulator ready
- [ ] Flutter: `flutter run` started
- [ ] API base URL configured correctly
- [ ] Database migrations completed
- [ ] Seeders executed

---

## Verification

### Backend Verification

```bash
# Test API health endpoint
curl http://localhost:8000/api/health

# Expected response:
{
  "status": true,
  "message": "Tomodachi Pet Shop API connected",
  "data": {
    "app": "Tomodachi Pet Shop",
    "environment": "local",
    "time": "2024-06-05T10:30:00+07:00"
  }
}
```

### Test Login

```bash
# Send login request
curl -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "owner@tomodachi.com",
    "password": "password"
  }'

# Expected response:
{
  "status": true,
  "message": "Login successful",
  "data": {
    "user": { ... },
    "token": "eyJhbGciOiJIUzI1NiI..."
  }
}
```

### Frontend Verification

1. **Launch the app**
   - Should show login screen
   - No error messages

2. **Test Login**
   - Email: `owner@tomodachi.com`
   - Password: `password`
   - Should navigate to home screen

3. **Navigate Tabs**
   - Dashboard: Should load analytics
   - POS: Should load products
   - Products: Should show product list
   - Reports: Should show sales data

---

## Troubleshooting

### Database Connection Issues

**Error**: `SQLSTATE[HY000] [1045] Access denied for user 'root'@'localhost'`

**Solution**:
```bash
# Check database credentials in .env
# Verify MySQL is running
# Reset MySQL password if needed
mysql -u root

# Or if using password
mysql -u root -p
```

### Cannot Connect to API

**Error**: Connection refused / Cannot reach API

**Solution**:
```bash
# 1. Verify backend is running
# Terminal should show: "Server running on http://127.0.0.1:8000"

# 2. Check API base URL in frontend
# Android: http://10.0.2.2:8000
# iOS: http://localhost:8000

# 3. Verify CORS settings
# Check config/cors.php

# 4. Test API manually
curl http://localhost:8000/api/health
```

### Flutter Build Issues

**Error**: `Exception: No devices found`

**Solution**:
```bash
# List available devices
flutter devices

# If none available:
# - Start Android emulator via Android Studio
# - Or connect physical device via USB
# - Run: flutter run
```

### Database Migrations Failed

**Error**: `SQLSTATE[42S02]: Table not found`

**Solution**:
```bash
# Drop all tables and re-run migrations
php artisan migrate:fresh --seed

# Or manually:
php artisan migrate:reset
php artisan migrate
php artisan db:seed
```

### Port Already in Use

**Error**: `The port 8000 is already in use`

**Solution**:
```bash
# Use different port
php artisan serve --port=8001

# Or kill process using port 8000
# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F

# macOS/Linux
lsof -i :8000
kill -9 <PID>
```

### CORS Errors in Frontend

**Error**: Cross-Origin Request Blocked

**Solution**:
1. Verify backend CORS config
2. Check SANCTUM_STATEFUL_DOMAINS in .env
3. Verify frontend base URL matches allowed origins

---

## Next Steps

1. **User Account Setup**
   - Create more user accounts via register endpoint
   - Assign roles appropriately

2. **Product Data**
   - Add initial products via POS app or API
   - Upload product images
   - Set prices and stock levels

3. **Payment Integration**
   - Get Midtrans credentials
   - Configure in .env
   - Test payment flow

4. **Deployment**
   - Follow deployment guide
   - Setup production database
   - Configure environment

---

**Last Updated**: 2024-06-05
**Version**: 1.0.0
