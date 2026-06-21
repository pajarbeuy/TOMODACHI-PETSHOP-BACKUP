# ERD Tomodachi Pet Shop

File ini dibuat ulang berdasarkan SRS `SRS_Tomodachi_Petshop_v1.0 2 (1).docx`, terutama bagian:

- `3.5 API Contract`
- `4.1 Autentikasi & Manajemen Pengguna`
- `4.2 Manajemen Produk`
- `4.3 Point of Sale (POS)`
- `4.4 Dashboard Analitik & Laporan Penjualan`
- `6. Other Requirements`
- `Appendix B.4 Entity Relationship Diagram (ERD)`

Dashboard dan laporan tidak dibuat sebagai tabel terpisah karena pada SRS keduanya berupa hasil agregasi dari `transactions`, `transaction_items`, `products`, `categories`, dan `stocks`.

```mermaid
erDiagram
    ROLES ||--o{ USERS : "assigned to"
    USERS ||--o{ PERSONAL_ACCESS_TOKENS : "owns"
    USERS ||--o{ TRANSACTIONS : "handles as cashier"

    CATEGORIES ||--o{ PRODUCTS : "groups"
    PRODUCTS ||--|| STOCKS : "has"
    PRODUCTS ||--o{ TRANSACTION_ITEMS : "sold as"
    PRODUCTS ||--o{ PURCHASE_ORDER_ITEMS : "ordered as"

    TRANSACTIONS ||--|{ TRANSACTION_ITEMS : "contains"
    PURCHASE_ORDERS ||--|{ PURCHASE_ORDER_ITEMS : "contains"

    ROLES {
        bigint id PK
        varchar name "owner|kasir|admin"
        timestamp created_at
        timestamp updated_at
    }

    USERS {
        bigint id PK
        bigint role_id FK
        varchar name
        varchar email UK
        varchar password
        timestamp email_verified_at
        varchar remember_token
        timestamp created_at
        timestamp updated_at
    }

    PERSONAL_ACCESS_TOKENS {
        bigint id PK
        varchar tokenable_type
        bigint tokenable_id
        varchar name
        varchar token UK
        text abilities
        timestamp last_used_at
        timestamp expires_at
        timestamp created_at
        timestamp updated_at
    }

    CATEGORIES {
        bigint id PK
        varchar name
        varchar animal_type "cat|dog|hamster|rabbit|bird|fish|reptile|etc"
        varchar sub_category "food|medicine_vitamin|equipment"
        text description
        timestamp created_at
        timestamp updated_at
    }

    PRODUCTS {
        bigint id PK
        bigint category_id FK
        varchar name
        varchar sku UK
        decimal buy_price
        decimal sell_price
        decimal margin_percentage
        varchar image_url
        text description
        timestamp deleted_at
        timestamp created_at
        timestamp updated_at
    }

    STOCKS {
        bigint id PK
        bigint product_id FK
        int offline_qty
        int online_qty
        int min_threshold
        timestamp last_updated
        timestamp created_at
        timestamp updated_at
    }

    TRANSACTIONS {
        bigint id PK
        bigint kasir_id FK
        varchar transaction_code UK "TRX-YYYYMMDD-XXXXX"
        enum channel "offline|online"
        decimal subtotal
        decimal tax
        decimal total
        enum payment_method "cash|qris|transfer"
        decimal amount_paid
        decimal change_amount
        enum status "pending|completed|cancelled"
        timestamp created_at
        timestamp updated_at
    }

    TRANSACTION_ITEMS {
        bigint id PK
        bigint transaction_id FK
        bigint product_id FK
        int quantity
        decimal unit_price
        decimal subtotal
        timestamp created_at
        timestamp updated_at
    }

    PURCHASE_ORDERS {
        bigint id PK
        varchar po_number UK
        varchar supplier_name
        enum status "draft|ordered|received|cancelled"
        decimal total
        date order_date
        date received_date
        timestamp created_at
        timestamp updated_at
    }

    PURCHASE_ORDER_ITEMS {
        bigint id PK
        bigint purchase_order_id FK
        bigint product_id FK
        int quantity
        decimal unit_cost
        decimal subtotal
        timestamp created_at
        timestamp updated_at
    }
```

## Catatan Implementasi

- `roles` mengikuti RBAC pada SRS: owner, kasir, dan admin.
- `personal_access_tokens` mengikuti pilihan autentikasi Laravel Sanctum yang disebutkan di SRS.
- `stocks` memisahkan stok `offline_qty` dan `online_qty`, sesuai kebutuhan POS offline dan rekonsiliasi online.
- `transactions.kasir_id` mengarah ke `users.id`.
- `products.deleted_at` disediakan untuk soft delete produk.
- `purchase_orders` dan `purchase_order_items` dimasukkan karena disebutkan pada relasi ERD di Appendix B.4 SRS.
