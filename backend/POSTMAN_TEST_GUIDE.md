# Postman Testing Guide - Tomodachi Pet Shop API

## 📋 Daftar Isi
1. [Setup Awal](#setup-awal)
2. [Testing Reports & Dashboard](#testing-reports--dashboard)
3. [Test Scripts & Validasi](#test-scripts--validasi)
4. [Tips & Troubleshooting](#tips--troubleshooting)

---

## 🚀 Setup Awal

### Langkah 1: Import Collection & Environment
```
1. Buka Postman
2. Klik "Import" di atas
3. Pilih tab "Folder"
4. Masukkan path: c:\laragon\www\nEW\Project-Tomodachi-Pet-Shop\backend\
   - Select: Tomodachi-Pet-Shop.postman_collection.json
   - Select: Tomodachi-Pet-Shop-Environment.postman_environment.json
5. Klik Import
```

### Langkah 2: Autentikasi (Wajib Dilakukan Lebih Dulu)
```
1. Buka folder "Authentication"
2. Click request "1. Get Captcha (LAKUKAN DULU)"
   - Klik SEND
   - Lihat Console (Ctrl+Alt+C) untuk pertanyaan soal
   - Contoh: "5 + 3 = ?" → Jawaban: "8"

3. Click request "2. Login (SETELAH GET CAPTCHA)"
   - Paste jawaban dari captcha ke field "captcha_answer"
   - Ubah email/password sesuai user yang ingin login
   - Klik SEND
   - Token akan tersimpan otomatis di environment variable

✅ Sekarang Anda siap test API endpoints lainnya!
```

---

## 📊 Testing Reports & Dashboard

Folder "Reports & Dashboard" berisi 4 endpoint utama untuk testing reporting system:

### 1️⃣ Get Sales Report
**Endpoint:** `GET /api/reports/sales`

**Parameter Wajib:**
- `start_date` - Format: YYYY-MM-DD
- `end_date` - Format: YYYY-MM-DD
- `channel` - Nilai: `offline`, `online`, atau `all`

**Test Cases yang Dijalankan:**
```javascript
✅ Status Code 200 OK
✅ Response structure valid (status, data, summary, by_channel)
✅ Summary fields lengkap (total_transactions, total_revenue, total_items_sold, avg_transaction_value)
✅ Channel breakdown includes offline & online data
✅ Numeric validasi untuk revenue dan count
```

**Contoh Response:**
```json
{
  "status": true,
  "message": "Sales report retrieved",
  "data": {
    "period": {
      "start_date": "2026-06-01",
      "end_date": "2026-06-18"
    },
    "summary": {
      "total_transactions": 42,
      "total_revenue": 1250000.00,
      "total_items_sold": 156,
      "average_transaction_value": 29761.90
    },
    "by_channel": {
      "offline": {
        "total_transactions": 28,
        "total_revenue": 850000.00
      },
      "online": {
        "total_transactions": 14,
        "total_revenue": 400000.00
      }
    }
  }
}
```

---

### 2️⃣ Get Sales Summary
**Endpoint:** `GET /api/reports/sales/summary`

**Parameter Wajib:**
- `period` - Nilai: `daily`, `weekly`, atau `monthly`
- `year` - Format: YYYY (contoh: 2026)
- `month` - Optional, untuk filter bulan tertentu

**Test Cases yang Dijalankan:**
```javascript
✅ Status Code 200 OK
✅ Response returns array of summaries
✅ Setiap item memiliki date, total_revenue, transaction_count, items_sold
✅ Date format valid (YYYY-MM-DD)
✅ Numeric validation untuk revenue & counts
```

**Contoh Response:**
```json
{
  "status": true,
  "message": "Sales summary retrieved",
  "data": [
    {
      "date": "2026-06-18",
      "total_revenue": 150000.00,
      "transaction_count": 5,
      "items_sold": 12
    },
    {
      "date": "2026-06-17",
      "total_revenue": 120000.00,
      "transaction_count": 4,
      "items_sold": 9
    }
  ]
}
```

---

### 3️⃣ Get Top Products
**Endpoint:** `GET /api/reports/top-products`

**Parameter:**
- `sort_by` - Default: `quantity`, Alternative: `revenue`
- `limit` - Default: 10 (max ranking)
- `start_date` - Optional filter
- `end_date` - Optional filter

**Test Cases yang Dijalankan:**
```javascript
✅ Status Code 200 OK
✅ Response returns ranked array
✅ Products properly ranked (rank 1, 2, 3, ...)
✅ Setiap item memiliki rank, product_id, product_name, sku, quantity_sold, total_revenue
✅ Sequential ranking validation
✅ Sort order sesuai parameter (by quantity atau by revenue)
```

**Contoh Response:**
```json
{
  "status": true,
  "message": "Top products retrieved",
  "data": [
    {
      "rank": 1,
      "product_id": 5,
      "product_name": "Royal Canin Cat",
      "sku": "RC-CAT-001",
      "quantity_sold": 45,
      "total_revenue": 675000.00
    },
    {
      "rank": 2,
      "product_id": 8,
      "product_name": "Whiskas Dog Food",
      "sku": "WD-DOG-002",
      "quantity_sold": 38,
      "total_revenue": 570000.00
    }
  ]
}
```

---

### 4️⃣ Get Dashboard Analytics
**Endpoint:** `GET /api/dashboard/analytics`

**Parameter:** 
- Optional filters (dashboard akan auto-calculate current period)

**Test Cases yang Dijalankan:**
```javascript
✅ Status Code 200 OK
✅ Dashboard sections present (kpi, sales_trend, top_products, category_breakdown)
✅ KPI contains all required metrics:
   - Today sales & yesterday sales
   - Transaction counts & changes
   - Monthly revenue & YoY comparison
   - Active products & low stock alerts
✅ Sales trend has exactly 7 days of data
✅ Category breakdown percentages sum to 100%
✅ All numeric values properly typed
```

**Contoh Response:**
```json
{
  "status": true,
  "message": "Analytics data retrieved",
  "data": {
    "kpi": {
      "today_sales": 180000.00,
      "total_transactions_today": 5,
      "items_sold_today": 12,
      "average_transaction_value": 36000.00,
      "yesterday_sales": 120000.00,
      "transactions_yesterday": 4,
      "today_sales_change_percent": 50.0,
      "transactions_change": 1,
      "monthly_revenue": 1500000.00,
      "previous_monthly_revenue": 1200000.00,
      "monthly_revenue_change_percent": 25.0,
      "active_products": 28,
      "low_stock_products": 3
    },
    "sales_trend": [
      {
        "date": "2026-06-12",
        "revenue": 95000.00,
        "transactions": 3
      }
      // ... 7 hari data
    ],
    "top_products": [
      {
        "product_name": "Royal Canin Cat",
        "quantity_sold": 45
      },
      // ... top 5 products
    ],
    "category_breakdown": {
      "cat": 45.5,
      "dog": 35.2,
      "hamster": 15.3,
      "other": 4.0
    }
  }
}
```

---

## 🧪 Test Scripts & Validasi

### Console Output
Setelah menjalankan setiap request, buka **Console** (Ctrl+Alt+C) untuk melihat output test:

**Sales Report:**
```
📊 Sales Report - Total Revenue: 1250000
🎫 Transactions Count: 42
✅ All assertions passed
```

**Dashboard Analytics:**
```
📊 Dashboard Analytics - Today Sales: 180000
📈 Sales Change: 50%
⚠️ Low Stock Products: 3
🎯 Top Product: Royal Canin Cat
✅ All assertions passed
```

### Cara Membaca Test Results
```
✅ = Test PASSED (hijau)
❌ = Test FAILED (merah) - Klik untuk detail error
```

---

## 💡 Tips & Troubleshooting

### Problem: "Unauthorized" (401)
**Solution:**
- Pastikan token sudah di-set dengan login terlebih dulu
- Check environment variable `token` via (Ctrl+Shift+E)
- Token mungkin expired, lakukan login ulang

### Problem: "Forbidden" (403)
**Solution:**
- Login user harus role "owner" untuk access reporting endpoints
- Check user role di response `/api/auth/me`
- Gunakan owner account untuk testing

### Problem: Test Assertions FAILED
**Solution:**
- Check response body di tab "Response" (bukan Preview)
- Lihat detail error di Console
- Pastikan date range parameter valid
- Verify database memiliki transaction data di range tersebut

### Tips Testing Flow:
```
1. Run "Get Sales Report" dengan date range yang ada transaksi
2. Run "Get Sales Summary" untuk validasi daily grouping
3. Run "Get Top Products" dengan sort_by=quantity
4. Run "Get Dashboard Analytics" untuk full KPI view
5. Change parameters dan observe behavior
```

### Testing dari CLI (Optional):
```bash
# Install Newman (CLI runner untuk Postman)
npm install -g newman

# Run collection dengan environment
newman run Tomodachi-Pet-Shop.postman_collection.json \
  -e Tomodachi-Pet-Shop-Environment.postman_environment.json \
  --folder "Reports & Dashboard"

# Export test report ke HTML
newman run Tomodachi-Pet-Shop.postman_collection.json \
  -e Tomodachi-Pet-Shop-Environment.postman_environment.json \
  --reporters html,json \
  --reporter-html-export test-report.html
```

---

## 📝 Testing Checklist

- [ ] Setup environment & import collection
- [ ] Run "Get Captcha" dan login berhasil
- [ ] Token tersimpan di environment variable
- [ ] Get Sales Report - All tests passed ✅
- [ ] Get Sales Summary - Data returned as array ✅  
- [ ] Get Top Products - Ranking valid ✅
- [ ] Get Dashboard Analytics - KPI complete ✅
- [ ] Console output menampilkan metrics dengan benar
- [ ] Filter parameters working (date range, channel, sort_by)
- [ ] Response structure validated per API contract

---

## 🔗 Related Files
- API Contract: `docs/api-contract/API_CONTRACT.md`
- Feature Tests: `backend/tests/Feature/ReportApiTest.php`
- Controller: `backend/app/Http/Controllers/Api/ReportController.php`

**Last Updated:** 2026-06-18
