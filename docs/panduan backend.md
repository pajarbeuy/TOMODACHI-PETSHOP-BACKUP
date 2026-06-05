# 🔧 Backend Documentation - Laravel API

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Project Structure](#project-structure)
3. [Models & Relationships](#models--relationships)
4. [API Endpoints](#api-endpoints)
5. [Authentication](#authentication)
6. [Database Schema](#database-schema)
7. [Configuration](#configuration)
8. [Development Guide](#development-guide)

---

## Architecture Overview

### Layered Architecture

```
┌─────────────────────────────────────┐
│      Routes (API Endpoints)         │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│      Controllers (Business Logic)   │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│      Models (Data & Relationships)  │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│      Database (MySQL)               │
└─────────────────────────────────────┘
```

### Design Patterns

- **MVC Pattern**: Model-View-Controller
- **Repository Pattern**: Centralized data access
- **Service Layer**: Business logic separation
- **RESTful API**: Standard HTTP methods

---

## Project Structure

```
backend/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   ├── Api/
│   │   │   │   ├── AuthController.php
│   │   │   │   ├── CategoryController.php
│   │   │   │   ├── ProductController.php
│   │   │   │   ├── TransactionController.php
│   │   │   │   └── ReportController.php
│   │   │   └── Controller.php
│   │   ├── Middleware/
│   │   │   └── Authentication middleware
│   │   └── Requests/
│   │       └── Form request validations
│   │
│   ├── Models/
│   │   ├── User.php
│   │   ├── Product.php
│   │   ├── Category.php
│   │   ├── Stock.php
│   │   ├── Transaction.php
│   │   ├── TransactionDetail.php
│   │   └── Role.php
│   │
│   ├── Exceptions/
│   │   └── CustomExceptions.php
│   │
│   └── Providers/
│       └── Service Providers
│
├── database/
│   ├── migrations/
│   │   ├── create_users_table.php
│   │   ├── create_roles_table.php
│   │   ├── create_categories_table.php
│   │   ├── create_products_table.php
│   │   ├── create_stocks_table.php
│   │   ├── create_transactions_table.php
│   │   └── create_transaction_details_table.php
│   │
│   └── seeders/
│       ├── RoleSeeder.php
│       ├── UserSeeder.php
│       └── CategorySeeder.php
│
├── routes/
│   ├── api.php               # Main API routes
│   ├── web.php               # Web routes (if needed)
│   └── channels.php          # WebSocket channels
│
├── config/
│   ├── app.php              # App configuration
│   ├── database.php         # DB connection
│   ├── sanctum.php          # Auth config
│   ├── cors.php             # CORS settings
│   └── midtrans.php         # Payment gateway
│
├── storage/
│   ├── app/                 # File storage
│   ├── framework/
│   └── logs/
│
├── tests/
│   ├── Feature/
│   │   └── API endpoint tests
│   └── Unit/
│       └── Model & service tests
│
├── .env                     # Environment variables
├── .env.example            # Example env file
├── composer.json           # Dependencies
└── artisan                 # Artisan CLI
```

---

## Models & Relationships

### 1. User Model
```php
// Attributes
- id: bigint (Primary Key)
- name: string
- email: string (unique)
- password: string (hashed)
- role_id: bigint (Foreign Key)
- phone: string (nullable)
- is_active: boolean
- created_at, updated_at: timestamp

// Relationships
- role(): BelongsTo
- transactions(): HasMany
```

### 2. Role Model
```php
// Attributes
- id: bigint (Primary Key)
- name: string (owner, manager, cashier)
- description: string
- created_at, updated_at: timestamp

// Relationships
- users(): HasMany
```

### 3. Product Model
```php
// Attributes
- id: bigint (Primary Key)
- category_id: bigint (Foreign Key)
- name: string
- sku: string (unique)
- description: text (nullable)
- buy_price: decimal(12,2)
- sell_price: decimal(12,2)
- margin_percentage: decimal(5,2)
- image_url: string (nullable)
- created_at, updated_at: timestamp
- deleted_at: timestamp (soft delete)

// Relationships
- category(): BelongsTo
- stock(): HasOne
- transactionDetails(): HasMany
```

### 4. Category Model
```php
// Attributes
- id: bigint (Primary Key)
- animal_type: string (dog, cat, bird, etc)
- sub_category: string
- created_at, updated_at: timestamp

// Relationships
- products(): HasMany
```

### 5. Stock Model
```php
// Attributes
- id: bigint (Primary Key)
- product_id: bigint (Foreign Key - unique)
- offline_qty: integer (default: 0)
- online_qty: integer (default: 0)
- min_threshold: integer (default: 5)
- last_updated: timestamp
- created_at, updated_at: timestamp

// Relationships
- product(): BelongsTo
```

### 6. Transaction Model
```php
// Attributes
- id: bigint (Primary Key)
- user_id: bigint (Foreign Key)
- invoice_number: string (unique)
- total_amount: decimal(12,2)
- payment_method: enum (cash, card, e-wallet)
- payment_status: enum (pending, paid, failed)
- midtrans_transaction_id: string (nullable)
- notes: text (nullable)
- transaction_date: timestamp
- created_at, updated_at: timestamp

// Relationships
- user(): BelongsTo
- details(): HasMany
```

### 7. TransactionDetail Model
```php
// Attributes
- id: bigint (Primary Key)
- transaction_id: bigint (Foreign Key)
- product_id: bigint (Foreign Key)
- quantity: integer
- unit_price: decimal(12,2)
- subtotal: decimal(12,2)
- created_at, updated_at: timestamp

// Relationships
- transaction(): BelongsTo
- product(): BelongsTo
```

### 8. Relationship Diagram

```
User (1) ──────→ (Many) Transaction
    ↓
Role (1) ←────── (Many) User

Product (1) ────→ (Many) TransactionDetail
    ↓
Category (1) ←── (Many) Product
    │
    └─→ Stock (1-1)

Transaction (1) ─→ (Many) TransactionDetail
```

---

## API Endpoints

### Base URL
```
Development: http://localhost:8000/api
Production: https://api.tomodachi-petshop.com/api
```

### Authentication Endpoints

#### Login
```
POST /auth/login
Content-Type: application/json

Request Body:
{
  "email": "user@example.com",
  "password": "password123"
}

Response (200):
{
  "status": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": 1,
      "name": "John Owner",
      "email": "owner@tomodachi.com",
      "role": {
        "id": 1,
        "name": "owner"
      }
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

#### Logout
```
POST /auth/logout
Authorization: Bearer {token}

Response (200):
{
  "status": true,
  "message": "Logout successful"
}
```

#### Get Current User
```
GET /auth/me
Authorization: Bearer {token}

Response (200):
{
  "status": true,
  "message": "User retrieved",
  "data": { ... user data ... }
}
```

#### Register User (Owner only)
```
POST /auth/register
Authorization: Bearer {token}
Content-Type: application/json

Request Body:
{
  "name": "New Manager",
  "email": "manager@tomodachi.com",
  "password": "password123",
  "role_id": 2
}

Response (201):
{ ... user data ... }
```

### Product Endpoints

#### Get All Products
```
GET /products?page=1&per_page=15&search=dog&category_id=1
Authorization: Bearer {token}

Response (200):
{
  "status": true,
  "message": "Products retrieved",
  "data": [ ... products ... ],
  "pagination": {
    "current_page": 1,
    "per_page": 15,
    "total": 50
  }
}
```

#### Get Single Product
```
GET /products/{id}
Authorization: Bearer {token}

Response (200):
{
  "status": true,
  "data": { ... product with relations ... }
}
```

#### Create Product (Manager/Owner)
```
POST /products
Authorization: Bearer {token}
Content-Type: application/json

Request Body:
{
  "category_id": 1,
  "name": "Dog Food Premium",
  "sku": "DF-001",
  "description": "High quality dog food",
  "buy_price": 50000,
  "sell_price": 75000
}

Response (201):
{ ... created product ... }
```

#### Update Product (Manager/Owner)
```
PUT /products/{id}
Authorization: Bearer {token}
Content-Type: application/json

Request Body:
{
  "name": "Dog Food Premium Updated",
  "sell_price": 80000
}

Response (200):
{ ... updated product ... }
```

#### Delete Product (Manager/Owner)
```
DELETE /products/{id}
Authorization: Bearer {token}

Response (200):
{
  "status": true,
  "message": "Product deleted"
}
```

### Category Endpoints

#### Get All Categories
```
GET /categories
Authorization: Bearer {token}

Response (200):
{
  "status": true,
  "data": [
    {
      "id": 1,
      "animal_type": "dog",
      "sub_category": "food",
      "products": [ ... ]
    }
  ]
}
```

#### Create Category (Owner only)
```
POST /categories
Authorization: Bearer {token}

Request Body:
{
  "animal_type": "cat",
  "sub_category": "food"
}
```

### Transaction Endpoints

#### Get All Transactions
```
GET /transactions?page=1&per_page=15&date_from=2024-01-01&date_to=2024-12-31
Authorization: Bearer {token}

Response (200):
{
  "status": true,
  "data": [ ... transactions ... ],
  "pagination": { ... }
}
```

#### Create Transaction (POS)
```
POST /transactions
Authorization: Bearer {token}
Content-Type: application/json

Request Body:
{
  "payment_method": "cash",
  "items": [
    {
      "product_id": 1,
      "quantity": 2,
      "unit_price": 75000
    }
  ],
  "total_amount": 150000,
  "amount_paid": 200000
}

Response (201):
{
  "status": true,
  "data": {
    "transaction_id": "TRX-001",
    "total_amount": 150000,
    "payment_status": "paid"
  }
}
```

#### Midtrans Notification Webhook
```
POST /midtrans/notification
Content-Type: application/json

Receives transaction status updates from Midtrans payment gateway
```

### Report Endpoints

#### Get Dashboard Analytics
```
GET /reports/dashboard
Authorization: Bearer {token}

Response (200):
{
  "status": true,
  "data": {
    "kpi": {
      "today_sales": 5000000,
      "today_transactions": 25,
      "monthly_sales": 150000000
    },
    "top_products": [ ... ],
    "category_breakdown": { ... },
    "sales_trend": [ ... ]
  }
}
```

#### Get Sales Report
```
GET /reports/sales?date_from=2024-01-01&date_to=2024-12-31
Authorization: Bearer {token}
```

---

## Authentication

### Sanctum Token-based Authentication

#### How it Works

1. **Login**: User sends credentials → Server validates → Returns token
2. **Request**: Client includes token in Authorization header
3. **Verification**: Server validates token → Proceeds if valid
4. **Logout**: Server invalidates token

#### Token Format

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

#### Token Expiration

- Default: No expiration (can be configured)
- Revocation: On logout

#### Middleware

```php
// In routes/api.php
Route::middleware('auth:sanctum')->group(function () {
    // Protected routes
});
```

---

## Database Schema

### Users Table
```sql
CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  role_id BIGINT NOT NULL,
  phone VARCHAR(20),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (role_id) REFERENCES roles(id)
);
```

### Roles Table
```sql
CREATE TABLE roles (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
```

### Products Table
```sql
CREATE TABLE products (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  category_id BIGINT NOT NULL,
  name VARCHAR(255) NOT NULL,
  sku VARCHAR(100) UNIQUE NOT NULL,
  description TEXT,
  buy_price DECIMAL(12,2) NOT NULL,
  sell_price DECIMAL(12,2) NOT NULL,
  margin_percentage DECIMAL(5,2),
  image_url VARCHAR(255),
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  deleted_at TIMESTAMP NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id),
  INDEX idx_sku (sku),
  INDEX idx_category (category_id)
);
```

### Categories Table
```sql
CREATE TABLE categories (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  animal_type VARCHAR(100) NOT NULL,
  sub_category VARCHAR(100) NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  UNIQUE KEY unique_animal_subcategory (animal_type, sub_category)
);
```

### Stock Table
```sql
CREATE TABLE stocks (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  product_id BIGINT UNIQUE NOT NULL,
  offline_qty INT DEFAULT 0,
  online_qty INT DEFAULT 0,
  min_threshold INT DEFAULT 5,
  last_updated TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id),
  INDEX idx_product (product_id)
);
```

### Transactions Table
```sql
CREATE TABLE transactions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,
  invoice_number VARCHAR(100) UNIQUE NOT NULL,
  total_amount DECIMAL(12,2) NOT NULL,
  payment_method VARCHAR(50) NOT NULL,
  payment_status VARCHAR(50) DEFAULT 'pending',
  midtrans_transaction_id VARCHAR(100),
  notes TEXT,
  transaction_date TIMESTAMP,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  INDEX idx_user (user_id),
  INDEX idx_invoice (invoice_number)
);
```

### TransactionDetails Table
```sql
CREATE TABLE transaction_details (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  transaction_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(12,2) NOT NULL,
  subtotal DECIMAL(12,2) NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP,
  FOREIGN KEY (transaction_id) REFERENCES transactions(id),
  FOREIGN KEY (product_id) REFERENCES products(id),
  INDEX idx_transaction (transaction_id)
);
```

---

## Configuration

### Environment Variables (.env)

```env
APP_NAME="Tomodachi Pet Shop"
APP_ENV=local
APP_KEY=base64:...
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=tomodachi_petshop
DB_USERNAME=root
DB_PASSWORD=

SANCTUM_STATEFUL_DOMAINS=localhost:3000,localhost:8000

MIDTRANS_MERCHANT_ID=your_merchant_id
MIDTRANS_CLIENT_KEY=your_client_key
MIDTRANS_SERVER_KEY=your_server_key
MIDTRANS_IS_PRODUCTION=false
```

### CORS Configuration (config/cors.php)

```php
'paths' => ['api/*'],
'allowed_methods' => ['*'],
'allowed_origins' => ['*'],
'allowed_origins_patterns' => [],
'allowed_headers' => ['*'],
'exposed_headers' => [],
'max_age' => 0,
'supports_credentials' => true,
```

---

## Development Guide

### Running Backend

```bash
cd backend

# Install dependencies
composer install

# Setup environment
cp .env.example .env
php artisan key:generate

# Run migrations
php artisan migrate

# Seed database (optional)
php artisan db:seed

# Start server
php artisan serve
```

### Available Artisan Commands

```bash
# Database
php artisan migrate               # Run migrations
php artisan migrate:rollback     # Rollback migrations
php artisan db:seed              # Seed database
php artisan db:seed --class=RoleSeeder

# Cache
php artisan cache:clear
php artisan config:cache
php artisan route:cache

# Development
php artisan tinker               # Interactive shell
php artisan make:controller      # Create controller
php artisan make:model           # Create model
php artisan make:migration       # Create migration

# Testing
php artisan test
php artisan test --filter=MethodName
```

### Common Issues & Solutions

1. **CORS Error**
   - Check CORS config in `config/cors.php`
   - Verify frontend URL is allowed

2. **Token Invalid**
   - Clear application cache: `php artisan cache:clear`
   - Regenerate tokens

3. **Database Connection Failed**
   - Verify MySQL is running
   - Check DB credentials in `.env`
   - Run `php artisan migrate`

4. **Undefined Variable $request**
   - Ensure controller method has `Request $request` parameter
   - Use dependency injection properly

---

**Last Updated**: 2024-06-05
**Version**: 1.0.0
