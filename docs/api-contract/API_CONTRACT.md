# API Contract - Petshop Tomodachi Management System
**Version:** 1.0  
**Last Updated:** 2026-05-18  
**Base URL:** `https://[domain]/api`

---

## Table of Contents
1. [Overview](#overview)
2. [Authentication](#authentication)
3. [Response Format](#response-format)
4. [Endpoints](#endpoints)
   - [Authentication Endpoints](#authentication-endpoints)
   - [Product Management Endpoints](#product-management-endpoints)
   - [Point of Sale (POS) Endpoints](#point-of-sale-pos-endpoints)
   - [Dashboard & Report Endpoints](#dashboard--report-endpoints)
5. [Error Handling](#error-handling)
6. [Rate Limiting](#rate-limiting)
7. [Security Requirements](#security-requirements)

---

## Overview

This API serves the Petshop Tomodachi Management System, a digital solution for managing pet shop operations including:
- Authentication & User Management
- Product Management (Categories, Stock)
- Point of Sale (POS) Transactions
- Stock Management (Dual-Channel: Offline/Online)
- Sales Reports & Analytics

**Communication Protocol:** HTTPS (TLS 1.2+)  
**Data Format:** JSON  
**Content-Type:** `application/json`

---

## Authentication

All endpoints (except `/auth/register` and `/auth/login`) require Bearer Token authentication.

### Authentication Header
```
Authorization: Bearer {token}
```

### Token Types
- **JWT (JSON Web Token)** or **Laravel Sanctum**
- Token validity:
  - Kasir: 24 hours
  - Owner: 7 days
  - Admin Online: 7 days

### Rate Limiting on Login
- **Maximum attempts:** 5 per minute per IP address
- **Response:** 429 Too Many Requests if limit exceeded

---

## Response Format

### Success Response (200, 201)
```json
{
  "status": true,
  "message": "Success message description",
  "data": {
    "key": "value"
  }
}
```

### Error Response (4xx, 5xx)
```json
{
  "status": false,
  "message": "Error description",
  "data": null
}
```

---

## Endpoints

### AUTHENTICATION ENDPOINTS

#### 1. Register User
```
POST /api/auth/register
```
**Auth Required:** No  
**Role Required:** -

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "role": "kasir"
}
```

**Response (201 Created):**
```json
{
  "status": true,
  "message": "User registered successfully",
  "data": {
    "user_id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "role": "kasir"
  }
}
```

**Status Codes:** 201, 400, 422

---

#### 2. Login
```
POST /api/auth/login
```
**Auth Required:** No  
**Role Required:** -

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "status": true,
  "message": "Login successful",
  "data": {
    "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "user": {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "role": "kasir"
    }
  }
}
```

**Status Codes:** 200, 401, 422

---

#### 3. Logout
```
POST /api/auth/logout
```
**Auth Required:** Yes  
**Role Required:** -

**Response (200 OK):**
```json
{
  "status": true,
  "message": "Logout successful"
}
```

**Status Codes:** 200, 401

---

#### 4. Get Current User Profile
```
GET /api/auth/me
```
**Auth Required:** Yes  
**Role Required:** -

**Response (200 OK):**
```json
{
  "status": true,
  "message": "User profile retrieved",
  "data": {
    "id": 1,
    "name": "John Doe",
    "email": "john@example.com",
    "role": "kasir",
    "created_at": "2026-05-18T10:30:00Z"
  }
}
```

**Status Codes:** 200, 401

---

### PRODUCT MANAGEMENT ENDPOINTS

#### 1. Get All Products
```
GET /api/products
```
**Auth Required:** Yes  
**Role Required:** -

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| category_id | integer | No | Filter by category |
| animal_type | string | No | Filter by animal type (cat, dog, etc) |
| sub_category | string | No | Filter by sub-category |
| search | string | No | Search by name or SKU |
| page | integer | No | Page number (default: 1) |
| per_page | integer | No | Items per page (default: 15) |

**Example Request:**
```
GET /api/products?category_id=1&search=makanan&page=1
```

**Response (200 OK):**
```json
{
  "status": true,
  "message": "Products retrieved",
  "data": [
    {
      "id": 1,
      "name": "Royal Canin Cat",
      "sku": "RC-CAT-001",
      "category_id": 1,
      "animal_type": "cat",
      "sub_category": "makanan",
      "buy_price": 50000,
      "sell_price": 75000,
      "margin_percentage": 50.00,
      "image_url": "https://domain.com/images/product-1.jpg",
      "created_at": "2026-05-18T09:00:00Z"
    }
  ],
  "pagination": {
    "current_page": 1,
    "per_page": 15,
    "total": 45
  }
}
```

**Status Codes:** 200, 401

---

#### 2. Create Product
```
POST /api/products
```
**Auth Required:** Yes  
**Role Required:** owner

**Request Body (form-data):**
```
name: "Royal Canin Cat"
sku: "RC-CAT-001"
category_id: 1
animal_type: "cat"
sub_category: "makanan"
buy_price: 50000
sell_price: 75000
image: <file.jpg> (max 2MB, JPEG/PNG)
```

**Response (201 Created):**
```json
{
  "status": true,
  "message": "Product created successfully",
  "data": {
    "id": 1,
    "name": "Royal Canin Cat",
    "sku": "RC-CAT-001",
    "image_url": "https://domain.com/images/product-1.jpg"
  }
}
```

**Status Codes:** 201, 401, 403, 422

---

#### 3. Get Product Detail
```
GET /api/products/{id}
```
**Auth Required:** Yes  
**Role Required:** -

**URL Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| id | integer | Product ID |

**Response (200 OK):**
```json
{
  "status": true,
  "message": "Product detail retrieved",
  "data": {
    "id": 1,
    "name": "Royal Canin Cat",
    "sku": "RC-CAT-001",
    "category_id": 1,
    "buy_price": 50000,
    "sell_price": 75000,
    "margin_percentage": 50.00,
    "image_url": "https://domain.com/images/product-1.jpg",
    "stock": {
      "offline_qty": 20,
      "online_qty": 30,
      "min_threshold": 5
    }
  }
}
```

**Status Codes:** 200, 401, 404

---

#### 4. Update Product
```
PUT /api/products/{id}
```
**Auth Required:** Yes  
**Role Required:** owner

**Request Body (JSON):**
```json
{
  "name": "Royal Canin Cat Premium",
  "category_id": 1,
  "buy_price": 52000,
  "sell_price": 78000
}
```

**Response (200 OK):**
```json
{
  "status": true,
  "message": "Product updated successfully",
  "data": {
    "id": 1,
    "updated_at": "2026-05-18T14:30:00Z"
  }
}
```

**Status Codes:** 200, 401, 403, 404, 422

---

#### 5. Delete Product
```
DELETE /api/products/{id}
```
**Auth Required:** Yes  
**Role Required:** owner

**Response (200 OK):**
```json
{
  "status": true,
  "message": "Product deleted successfully"
}
```

**Note:** Uses soft delete; data is retained for historical transaction records.

**Status Codes:** 200, 401, 403, 404

---

#### 6. Get Product Categories
```
GET /api/products/categories
```
**Auth Required:** Yes  
**Role Required:** -

**Response (200 OK):**
```json
{
  "status": true,
  "message": "Categories retrieved",
  "data": [
    {
      "id": 1,
      "name": "Cat Products",
      "animal_type": "cat",
      "sub_categories": ["makanan", "obat", "perlengkapan"]
    },
    {
      "id": 2,
      "name": "Dog Products",
      "animal_type": "dog",
      "sub_categories": ["makanan", "obat", "perlengkapan"]
    }
  ]
}
```

**Status Codes:** 200, 401

---

### POINT OF SALE (POS) ENDPOINTS

#### 1. Create Transaction
```
POST /api/transactions
```
**Auth Required:** Yes  
**Role Required:** kasir

**Request Body:**
```json
{
  "channel": "offline",
  "items": [
    {
      "product_id": 1,
      "quantity": 2,
      "unit_price": 75000
    },
    {
      "product_id": 3,
      "quantity": 1,
      "unit_price": 35000
    }
  ],
  "payment_method": "cash",
  "amount_paid": 200000
}
```

**Response (201 Created):**
```json
{
  "status": true,
  "message": "Transaction created successfully",
  "data": {
    "transaction_id": "TRX-20260518-001",
    "total": 185000,
    "change": 15000,
    "created_at": "2026-05-18T14:45:00Z"
  }
}
```

**Note:** Offline stock will be automatically deducted upon successful transaction.

**Status Codes:** 201, 401, 403, 422

---

#### 2. Get All Transactions
```
GET /api/transactions
```
**Auth Required:** Yes  
**Role Required:** -

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| channel | string | No | Filter by channel (offline/online) |
| start_date | date | No | Format: YYYY-MM-DD |
| end_date | date | No | Format: YYYY-MM-DD |
| page | integer | No | Page number |
| per_page | integer | No | Items per page (default: 15) |

**Response (200 OK):**
```json
{
  "status": true,
  "message": "Transactions retrieved",
  "data": [
    {
      "id": 1,
      "transaction_id": "TRX-20260518-001",
      "channel": "offline",
      "total": 185000,
      "payment_method": "cash",
      "created_at": "2026-05-18T14:45:00Z"
    }
  ],
  "pagination": {
    "current_page": 1,
    "per_page": 15,
    "total": 120
  }
}
```

**Status Codes:** 200, 401

---

#### 3. Get Transaction Detail
```
GET /api/transactions/{id}
```
**Auth Required:** Yes  
**Role Required:** -

**Response (200 OK):**
```json
{
  "status": true,
  "message": "Transaction detail retrieved",
  "data": {
    "id": 1,
    "transaction_id": "TRX-20260518-001",
    "kasir_id": 2,
    "channel": "offline",
    "total": 185000,
    "payment_method": "cash",
    "amount_paid": 200000,
    "change": 15000,
    "items": [
      {
        "product_id": 1,
        "product_name": "Royal Canin Cat",
        "quantity": 2,
        "unit_price": 75000,
        "subtotal": 150000
      },
      {
        "product_id": 3,
        "product_name": "Whiskas Can",
        "quantity": 1,
        "unit_price": 35000,
        "subtotal": 35000
      }
    ],
    "created_at": "2026-05-18T14:45:00Z"
  }
}
```

**Status Codes:** 200, 401, 404

---

#### 4. Get Transaction Receipt
```
GET /api/transactions/{id}/receipt
```
**Auth Required:** Yes  
**Role Required:** -

**Response (200 OK):**
```json
{
  "status": true,
  "message": "Receipt data retrieved",
  "data": {
    "transaction_id": "TRX-20260518-001",
    "transaction_date": "2026-05-18T14:45:00Z",
    "kasir_name": "Budi",
    "items": [
      {
        "product_name": "Royal Canin Cat",
        "quantity": 2,
        "unit_price": 75000,
        "subtotal": 150000
      },
      {
        "product_name": "Whiskas Can",
        "quantity": 1,
        "unit_price": 35000,
        "subtotal": 35000
      }
    ],
    "subtotal": 185000,
    "tax": 0,
    "total": 185000,
    "payment_method": "cash",
    "amount_paid": 200000,
    "change": 15000
  }
}
```

**Status Codes:** 200, 401, 404

---

### DASHBOARD & REPORT ENDPOINTS

#### 1. Get Sales Report
```
GET /api/reports/sales
```
**Auth Required:** Yes  
**Role Required:** owner

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| start_date | date | Yes | Format: YYYY-MM-DD |
| end_date | date | Yes | Format: YYYY-MM-DD |
| channel | string | No | Filter: offline/online/all |
| category | string | No | Filter by product category |

**Response (200 OK):**
```json
{
  "status": true,
  "message": "Sales report retrieved",
  "data": {
    "period": {
      "start_date": "2026-05-01",
      "end_date": "2026-05-18"
    },
    "summary": {
      "total_transactions": 280,
      "total_revenue": 8500000,
      "total_items_sold": 450,
      "average_transaction_value": 30357
    },
    "by_channel": {
      "offline": {
        "total_transactions": 200,
        "total_revenue": 6000000
      },
      "online": {
        "total_transactions": 80,
        "total_revenue": 2500000
      }
    }
  }
}
```

**Status Codes:** 200, 401, 403, 422

---

#### 2. Get Sales Summary
```
GET /api/reports/sales/summary
```
**Auth Required:** Yes  
**Role Required:** owner

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| period | string | Yes | daily/weekly/monthly |
| month | integer | No | Month (1-12), required if period=monthly |
| year | integer | Yes | Year (e.g., 2026) |

**Example Request:**
```
GET /api/reports/sales/summary?period=daily&year=2026&month=5
```

**Response (200 OK):**
```json
{
  "status": true,
  "message": "Sales summary retrieved",
  "data": [
    {
      "date": "2026-05-18",
      "total_revenue": 450000,
      "transaction_count": 12,
      "items_sold": 35
    },
    {
      "date": "2026-05-17",
      "total_revenue": 420000,
      "transaction_count": 10,
      "items_sold": 32
    }
  ]
}
```

**Status Codes:** 200, 401, 403, 422

---

#### 3. Get Top Products
```
GET /api/reports/top-products
```
**Auth Required:** Yes  
**Role Required:** owner

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| sort_by | string | Yes | quantity or revenue |
| limit | integer | No | Default: 10 |
| start_date | date | No | Format: YYYY-MM-DD |
| end_date | date | No | Format: YYYY-MM-DD |

**Response (200 OK):**
```json
{
  "status": true,
  "message": "Top products retrieved",
  "data": [
    {
      "rank": 1,
      "product_id": 1,
      "product_name": "Royal Canin Cat",
      "sku": "RC-CAT-001",
      "quantity_sold": 85,
      "total_revenue": 6375000
    },
    {
      "rank": 2,
      "product_id": 5,
      "product_name": "Whiskas Can",
      "sku": "WC-001",
      "quantity_sold": 120,
      "total_revenue": 4200000
    }
  ]
}
```

**Status Codes:** 200, 401, 403, 422

---

#### 4. Get Dashboard Analytics
```
GET /api/dashboard/analytics
```
**Auth Required:** Yes  
**Role Required:** owner

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| period | string | Yes | 7d (7 days) / 30d (30 days) / 3m (3 months) |
| start_date | date | No | Override period, format: YYYY-MM-DD |
| end_date | date | No | Override period, format: YYYY-MM-DD |

**Response (200 OK):**
```json
{
  "status": true,
  "message": "Analytics data retrieved",
  "data": {
    "kpi": {
      "today_sales": 450000,
      "total_transactions_today": 12,
      "items_sold_today": 35,
      "average_transaction_value": 37500
    },
    "sales_trend": [
      {
        "date": "2026-05-18",
        "revenue": 450000,
        "transactions": 12
      },
      {
        "date": "2026-05-17",
        "revenue": 420000,
        "transactions": 10
      }
    ],
    "top_products": [
      {
        "product_name": "Royal Canin Cat",
        "quantity_sold": 85
      },
      {
        "product_name": "Whiskas Can",
        "quantity_sold": 120
      }
    ],
    "category_breakdown": {
      "cat": 45.5,
      "dog": 35.2,
      "hamster": 10.8,
      "other": 8.5
    },
    "channel_comparison": {
      "offline": 70.6,
      "online": 29.4
    },
    "low_stock_alerts": [
      {
        "product_id": 8,
        "product_name": "Bolt Food",
        "current_stock": 3,
        "min_threshold": 5
      }
    ]
  }
}
```

**Status Codes:** 200, 401, 403

---

## Error Handling

### HTTP Status Codes
| Code | Meaning | Example |
|------|---------|---------|
| 200 | OK - Request successful | Successful GET request |
| 201 | Created - Resource created | Successful POST request |
| 400 | Bad Request - Invalid input | Missing required fields |
| 401 | Unauthorized - Invalid/missing token | No token in header |
| 403 | Forbidden - Insufficient permissions | Kasir trying to access owner endpoints |
| 404 | Not Found - Resource doesn't exist | Accessing non-existent product ID |
| 422 | Unprocessable Entity - Validation failed | Invalid stock quantity |
| 429 | Too Many Requests - Rate limit exceeded | Too many login attempts |
| 500 | Internal Server Error | Server error |

### Error Response Example
```json
{
  "status": false,
  "message": "Insufficient stock for this product",
  "data": null
}
```

---

## Rate Limiting

### Login Endpoint Protection
- **Limit:** 5 login attempts per minute per IP address
- **Response Code:** 429 Too Many Requests
- **Retry-After Header:** Time in seconds before next attempt allowed

### General API Rate Limiting
- **Target:** 50 requests per second during peak hours
- **Implementation:** Per-user token basis (may vary by role)

---

## Security Requirements

### HTTPS/SSL
- **Protocol:** HTTPS (TLS 1.2 or higher)
- **Port:** 443
- **Certificate:** Valid SSL certificate (Let's Encrypt or commercial)

### Password Security
- **Algorithm:** bcrypt (cost factor 10+)
- **Minimum Length:** 8 characters
- **Storage:** Hashed in database, never stored in plain text

### Token Security
- **Expiry:** Configurable per role (see Authentication section)
- **Revocation:** Tokens invalidated on logout
- **Storage (Client):** Secure storage on mobile device (Flutter Secure Storage)

### Data Validation
- **Input Sanitization:** All user inputs validated and sanitized
- **Prevention:** SQL Injection, XSS, and other OWASP Top 10 vulnerabilities
- **Validation Rules:** Server-side validation (client-side optional for UX)

### CORS Policy
- **Configuration:** CORS enabled for Flutter mobile app domain
- **Allowed Methods:** GET, POST, PUT, DELETE, OPTIONS
- **Allowed Headers:** Content-Type, Authorization

---

## Integration Notes

### For Flutter App Developers
1. Store token in secure storage after login
2. Include token in Authorization header for all authenticated requests
3. Implement token refresh logic before expiry
4. Handle 401 responses by redirecting to login
5. Implement offline queue for transactions (Phase 2)

### For Testing
- **Tools:** Postman, Insomnia, cURL
- **Base URL Format:** `https://[domain]/api`
- **Example Header:** `Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGc...`

### For Backend Developers
- Base URL in documentation: `https://[domain]/api`
- Replace `[domain]` with actual domain at deployment
- All endpoints must validate JWT/Sanctum token
- All responses must follow standard format
- All timestamps in ISO 8601 format (UTC)

---

**End of API Contract Document**
