# 📊 Database Schema Documentation

## Table of Contents
1. [Entity Relationship Diagram (ERD)](#entity-relationship-diagram)
2. [Database Tables](#database-tables)
3. [Data Relationships](#data-relationships)
4. [Sample Data](#sample-data)
5. [Indexes & Performance](#indexes--performance)
6. [Backup & Recovery](#backup--recovery)

---

## Entity Relationship Diagram

### Visual ERD

```
┌──────────────────┐
│     Roles        │
│──────────────────│
│ id (PK)          │
│ name             │
│ description      │
└────────┬─────────┘
         │ (1:Many)
         │
┌────────▼──────────┐          ┌──────────────┐
│     Users        │          │ Transactions │
│──────────────────│          │──────────────│
│ id (PK)          │◄─────────│ user_id (FK) │
│ name             │ (1:Many) │──────────────│
│ email (UNIQUE)   │          │ id (PK)      │
│ password         │          │ invoice_num  │
│ role_id (FK)     │          │ total_amount │
│ phone            │          │ pay_method   │
│ is_active        │          │ pay_status   │
│ created_at       │          │ created_at   │
│ updated_at       │          └──────┬───────┘
└──────────────────┘                 │ (1:Many)
                                     │
         ┌──────────────────────────┘
         │
    ┌────▼──────────────────────┐
    │ TransactionDetails        │
    │──────────────────────────│
    │ id (PK)                   │
    │ transaction_id (FK)       │
    │ product_id (FK)          │
    │ quantity                  │
    │ unit_price                │
    │ subtotal                  │
    │ created_at                │
    └────────────┬──────────────┘
                 │ (Many:1)
                 │
         ┌───────▼────────────┐
         │  Products          │
         │──────────────────│
         │ id (PK)           │
         │ category_id (FK)  │
         │ name              │
         │ sku (UNIQUE)      │
         │ description       │
         │ buy_price         │
         │ sell_price        │
         │ margin_%          │
         │ image_url         │
         │ deleted_at        │
         │ created_at        │
         └────────┬──────────┘
                  │ (Many:1)
                  │
         ┌────────▼────────────┐      ┌─────────┐
         │  Categories        │      │ Stock   │
         │──────────────────│      │─────────│
         │ id (PK)           │◄─────│ prod_id │
         │ animal_type       │      │ off_qty │
         │ sub_category      │      │ on_qty  │
         │ created_at        │      └─────────┘
         └───────────────────┘
```

---

## Database Tables

### 1. roles Table

**Purpose**: Define user roles and permissions

```sql
CREATE TABLE `roles` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(100) NOT NULL UNIQUE,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  KEY `idx_name` (`name`)
);
```

**Sample Data**:
| id | name | description |
|----|------|---|
| 1 | owner | Owner of the pet shop |
| 2 | manager | Manager - can manage products |
| 3 | cashier | Cashier - POS operator |

---

### 2. users Table

**Purpose**: Store user accounts and authentication info

```sql
CREATE TABLE `users` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL UNIQUE,
  `email_verified_at` timestamp NULL,
  `password` varchar(255) NOT NULL,
  `role_id` bigint unsigned NOT NULL,
  `phone` varchar(20),
  `is_active` boolean DEFAULT TRUE,
  `remember_token` varchar(100),
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT `users_role_id_foreign` 
    FOREIGN KEY (`role_id`) 
    REFERENCES `roles` (`id`) 
    ON DELETE CASCADE,
  
  KEY `idx_email` (`email`),
  KEY `idx_role` (`role_id`)
);
```

**Columns**:
- `id`: Unique user identifier
- `name`: User's full name
- `email`: Unique email address (used for login)
- `password`: Hashed password (bcrypt)
- `role_id`: Foreign key to roles table
- `phone`: Phone number (optional)
- `is_active`: Account status

---

### 3. categories Table

**Purpose**: Organize products by animal type and sub-category

```sql
CREATE TABLE `categories` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `animal_type` varchar(100) NOT NULL,
  `sub_category` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  UNIQUE KEY `unique_animal_subcategory` (`animal_type`, `sub_category`),
  KEY `idx_animal_type` (`animal_type`)
);
```

**Columns**:
- `animal_type`: Type of pet (dog, cat, bird, fish, rabbit, etc.)
- `sub_category`: Product category (food, toys, accessories, etc.)

**Sample Data**:
| id | animal_type | sub_category |
|----|---|---|
| 1 | dog | food |
| 2 | dog | toys |
| 3 | dog | accessories |
| 4 | cat | food |
| 5 | cat | toys |
| 6 | bird | food |

---

### 4. products Table

**Purpose**: Store product information with pricing

```sql
CREATE TABLE `products` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `category_id` bigint unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `sku` varchar(100) NOT NULL UNIQUE,
  `description` text,
  `buy_price` decimal(12,2) NOT NULL,
  `sell_price` decimal(12,2) NOT NULL,
  `margin_percentage` decimal(5,2),
  `image_url` varchar(255),
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL,
  
  CONSTRAINT `products_category_id_foreign` 
    FOREIGN KEY (`category_id`) 
    REFERENCES `categories` (`id`) 
    ON DELETE CASCADE,
  
  KEY `idx_sku` (`sku`),
  KEY `idx_category` (`category_id`),
  KEY `idx_name` (`name`)
);
```

**Columns**:
- `sku`: Stock Keeping Unit (unique identifier for inventory)
- `buy_price`: Cost price from supplier
- `sell_price`: Selling price to customer
- `margin_percentage`: Profit margin calculated automatically
- `image_url`: URL to product image
- `deleted_at`: Soft delete timestamp (for data recovery)

**Indexes**:
- Primary key on `id` for quick lookups
- Unique index on `sku` for inventory tracking
- Foreign key index on `category_id` for category queries
- Name index for product search

---

### 5. stocks Table

**Purpose**: Track inventory levels for products

```sql
CREATE TABLE `stocks` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `product_id` bigint unsigned NOT NULL UNIQUE,
  `offline_qty` int NOT NULL DEFAULT 0,
  `online_qty` int NOT NULL DEFAULT 0,
  `min_threshold` int NOT NULL DEFAULT 5,
  `last_updated` timestamp NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT `stocks_product_id_foreign` 
    FOREIGN KEY (`product_id`) 
    REFERENCES `products` (`id`) 
    ON DELETE CASCADE,
  
  KEY `idx_product` (`product_id`)
);
```

**Columns**:
- `offline_qty`: Quantity in physical store
- `online_qty`: Quantity available for online orders
- `min_threshold`: Alert threshold for low stock
- `last_updated`: Last inventory update timestamp

**Business Logic**:
- Total available = `offline_qty` + `online_qty`
- Alert when total < `min_threshold`

---

### 6. transactions Table

**Purpose**: Record all sales transactions

```sql
CREATE TABLE `transactions` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `user_id` bigint unsigned NOT NULL,
  `invoice_number` varchar(100) NOT NULL UNIQUE,
  `total_amount` decimal(12,2) NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `payment_status` varchar(50) NOT NULL DEFAULT 'pending',
  `midtrans_transaction_id` varchar(100),
  `notes` text,
  `transaction_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT `transactions_user_id_foreign` 
    FOREIGN KEY (`user_id`) 
    REFERENCES `users` (`id`) 
    ON DELETE CASCADE,
  
  KEY `idx_user` (`user_id`),
  KEY `idx_invoice` (`invoice_number`),
  KEY `idx_transaction_date` (`transaction_date`)
);
```

**Columns**:
- `invoice_number`: Unique receipt number (e.g., TRX-20240605-001)
- `payment_method`: cash, card, e-wallet, bank_transfer
- `payment_status`: pending, paid, failed, cancelled
- `midtrans_transaction_id`: Reference to payment gateway transaction

**Indexes**:
- User index for quick lookup by cashier
- Invoice index for receipt search
- Date index for sales report filtering

---

### 7. transaction_details Table

**Purpose**: Store line items for each transaction

```sql
CREATE TABLE `transaction_details` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `transaction_id` bigint unsigned NOT NULL,
  `product_id` bigint unsigned NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  CONSTRAINT `details_transaction_id_foreign` 
    FOREIGN KEY (`transaction_id`) 
    REFERENCES `transactions` (`id`) 
    ON DELETE CASCADE,
  
  CONSTRAINT `details_product_id_foreign` 
    FOREIGN KEY (`product_id`) 
    REFERENCES `products` (`id`) 
    ON DELETE CASCADE,
  
  KEY `idx_transaction` (`transaction_id`),
  KEY `idx_product` (`product_id`)
);
```

**Columns**:
- `quantity`: Number of items sold
- `unit_price`: Price at time of sale
- `subtotal`: quantity × unit_price

**Calculation**:
- Transaction total = SUM(subtotal) for all details

---

### 8. personal_access_tokens Table

**Purpose**: Store authentication tokens (Laravel Sanctum)

```sql
CREATE TABLE `personal_access_tokens` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `token` varchar(64) NOT NULL UNIQUE,
  `abilities` text,
  `last_used_at` timestamp NULL,
  `expires_at` timestamp NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  
  KEY `idx_tokenable` (`tokenable_type`, `tokenable_id`),
  KEY `idx_token` (`token`)
);
```

---

## Data Relationships

### User → Transactions (1:Many)
```
One user creates many transactions
- user.id → transaction.user_id
- Used to track which cashier made the sale
```

### Product → TransactionDetails (1:Many)
```
One product appears in many transactions
- product.id → transaction_detail.product_id
- Used for sales history per product
```

### Transaction → TransactionDetails (1:Many)
```
One transaction has many line items
- transaction.id → transaction_detail.transaction_id
- Forms the complete receipt
```

### Category → Products (1:Many)
```
One category contains many products
- category.id → product.category_id
- Used for product filtering
```

### Product → Stock (1:1)
```
One product has one stock record
- product.id = stock.product_id (unique)
- Tracks inventory for each product
```

### Role → Users (1:Many)
```
One role assigned to many users
- role.id → user.role_id
- Manages user permissions
```

---

## Sample Data

### Insert Sample Users

```sql
-- Insert roles
INSERT INTO roles (name, description) VALUES
('owner', 'Owner of the pet shop'),
('manager', 'Manager - can manage products'),
('cashier', 'Cashier - POS operator');

-- Insert users
INSERT INTO users (name, email, password, role_id, phone, is_active) VALUES
('Owner User', 'owner@tomodachi.com', '$2y$10$...', 1, '081234567890', TRUE),
('Manager User', 'manager@tomodachi.com', '$2y$10$...', 2, '081234567891', TRUE),
('Cashier 1', 'cashier1@tomodachi.com', '$2y$10$...', 3, '081234567892', TRUE);
```

### Insert Sample Categories

```sql
INSERT INTO categories (animal_type, sub_category) VALUES
('dog', 'food'),
('dog', 'toys'),
('dog', 'accessories'),
('cat', 'food'),
('cat', 'toys'),
('bird', 'food'),
('fish', 'food'),
('rabbit', 'food');
```

### Insert Sample Products

```sql
INSERT INTO products (category_id, name, sku, description, buy_price, sell_price) VALUES
(1, 'Dog Food Premium 5kg', 'DF-5KG-001', 'High quality dog food', 150000, 225000),
(1, 'Dog Food Economy 3kg', 'DF-3KG-001', 'Budget friendly dog food', 80000, 120000),
(2, 'Rope Toy', 'TOY-ROPE-001', 'Cotton rope toy for dogs', 20000, 35000),
(4, 'Cat Food Premium 2kg', 'CF-2KG-001', 'Premium cat food', 100000, 150000),
(5, 'Cat Ball Toy', 'TOY-BALL-CAT-001', 'Interactive ball for cats', 15000, 25000);
```

### Insert Stock Records

```sql
INSERT INTO stocks (product_id, offline_qty, online_qty, min_threshold) VALUES
(1, 50, 30, 10),
(2, 100, 50, 15),
(3, 200, 100, 20),
(4, 75, 40, 10),
(5, 150, 75, 20);
```

### Insert Sample Transaction

```sql
-- Create transaction
INSERT INTO transactions (user_id, invoice_number, total_amount, payment_method, payment_status, transaction_date) 
VALUES (3, 'TRX-20240605-001', 560000, 'cash', 'paid', NOW());

-- Add transaction details
INSERT INTO transaction_details (transaction_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 2, 225000, 450000),
(1, 3, 4, 35000, 140000),
(1, 5, 2, 25000, 50000);
-- Total: 640000 (but recorded as 560000, meaning discount applied)
```

---

## Indexes & Performance

### Primary Indexes

```sql
-- Already defined in table creation

-- User lookups
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role_id ON users(role_id);

-- Product searches
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_name ON products(name);

-- Transaction queries
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_invoice ON transactions(invoice_number);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);

-- Category queries
CREATE INDEX idx_categories_animal_type ON categories(animal_type);
```

### Query Performance Tips

1. **Product Search**
   - Use `WHERE sku = ?` or `WHERE name LIKE ?`
   - Indexed columns for fast lookup

2. **Sales Reports**
   - Use date range on `transaction_date`
   - Join with `transaction_details` for products sold

3. **Inventory Status**
   - Query `stocks` table for threshold alerts
   - Join with `products` for details

4. **User Transactions**
   - Use `user_id` for filtering
   - Sort by `transaction_date DESC` for history

---

## Backup & Recovery

### Backup Commands

```bash
# Backup entire database
mysqldump -u root -p tomodachi_petshop > backup.sql

# Backup with date
mysqldump -u root -p tomodachi_petshop > backup_$(date +%Y%m%d_%H%M%S).sql

# Backup with compression
mysqldump -u root -p tomodachi_petshop | gzip > backup.sql.gz
```

### Restore from Backup

```bash
# Restore database
mysql -u root -p tomodachi_petshop < backup.sql

# Restore from compressed file
gunzip < backup.sql.gz | mysql -u root -p tomodachi_petshop
```

### Database Maintenance

```sql
-- Check table for errors
CHECK TABLE products;

-- Repair table if needed
REPAIR TABLE products;

-- Optimize tables for performance
OPTIMIZE TABLE products, categories, stocks, transactions;

-- Analyze table statistics
ANALYZE TABLE products;
```

---

## Data Integrity

### Constraints

1. **Referential Integrity**
   - Foreign keys prevent orphaned records
   - `ON DELETE CASCADE` removes related records

2. **Unique Constraints**
   - `email` in users table
   - `sku` in products table
   - `invoice_number` in transactions table

3. **Check Constraints** (Business Rules)
   ```sql
   -- Buy price should be positive
   ALTER TABLE products ADD CONSTRAINT check_buy_price 
     CHECK (buy_price > 0);
   
   -- Sell price should be greater than buy price
   ALTER TABLE products ADD CONSTRAINT check_sell_price 
     CHECK (sell_price > buy_price);
   
   -- Quantity should be non-negative
   ALTER TABLE transaction_details ADD CONSTRAINT check_qty 
     CHECK (quantity > 0);
   ```

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2024-06-05 | Initial schema |

---

**Last Updated**: 2024-06-05
**Database Version**: 1.0.0
