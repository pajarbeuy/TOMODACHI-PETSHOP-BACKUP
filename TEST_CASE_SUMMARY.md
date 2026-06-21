# Test Case Summary - Tomodachi Pet Shop

## 📌 Apa Yang Sudah Dibuat

### 1. PHP Unit Tests (Backend Feature Tests)
**File:** `backend/tests/Feature/ReportApiTest.php`

Test methods:
- ✅ `test_owner_can_generate_sales_report_with_channel_filter()` - Validasi sales report dengan channel filter (offline/online)
- ✅ `test_owner_can_retrieve_sales_summary_grouped_by_day()` - Validasi daily sales summary grouping
- ✅ `test_owner_can_list_top_products_sorted_by_revenue()` - Validasi top products ranking & sorting
- ✅ `test_owner_dashboard_analytics_returns_expected_kpis()` - Validasi dashboard KPI structure & calculations

**Features:**
- Deterministic data setup dengan seeded transactions
- Tests untuk date-based queries (ensures query accuracy)
- Validasi response structure & field types
- Channel filtering tests (offline vs online stock)
- Category breakdown percentage validation

### 2. Postman Collection Enhancement  
**File:** `backend/Tomodachi-Pet-Shop.postman_collection.json`

Updated Requests dengan Test Scripts:
- **Get Sales Report** - Tests untuk summary fields, channel breakdown, numeric validation
- **Get Sales Summary** - Array validation, date format checks, sequential data
- **Get Top Products** - Ranking validation, sort order tests, sequential rank checks  
- **Get Dashboard Analytics** - KPI completeness, 7-day trend, category % validation

Features di setiap request:
- ✅ Status code validation (200 OK)
- ✅ Response structure assertions
- ✅ Field type validation
- ✅ Business logic validation (ranking, percentages, etc)
- ✅ Console logging untuk easy debugging

### 3. Postman Testing Guide
**File:** `backend/POSTMAN_TEST_GUIDE.md`

Dokumentasi lengkap:
- Setup awal & autentikasi flow
- Detail setiap endpoint testing
- Expected response structure
- Test cases yang berjalan
- Troubleshooting guide
- CLI testing dengan Newman

---

## 🎯 Test Coverage

### Endpoints Tested:
1. `GET /api/reports/sales` - Sales report dengan date range & channel filter
2. `GET /api/reports/sales/summary` - Daily/weekly/monthly sales summary
3. `GET /api/reports/top-products` - Top products ranking (quantity/revenue)
4. `GET /api/dashboard/analytics` - Dashboard KPI & metrics

### Test Scenarios:
- ✅ Authorization (owner-only endpoints)
- ✅ Date range filtering & query accuracy
- ✅ Channel filtering (offline/online stock deduction)
- ✅ Category breakdown calculations
- ✅ Response structure validation
- ✅ Ranking & sorting logic
- ✅ Numeric precision (revenue, counts, percentages)
- ✅ Time-series data (7-day trends)

---

## 🚀 Cara Menggunakan

### Run PHP Tests:
```bash
cd backend/
./vendor/bin/phpunit tests/Feature/ReportApiTest.php --testdox
```

### Run Postman Tests:
1. Import collection & environment ke Postman
2. Login terlebih dulu (Get Captcha → Login)
3. Run individual requests di folder "Reports & Dashboard"
4. View test results di "Test Results" tab

### Run via CLI (Newman):
```bash
npm install -g newman
newman run backend/Tomodachi-Pet-Shop.postman_collection.json \
  -e backend/Tomodachi-Pet-Shop-Environment.postman_environment.json \
  --folder "Reports & Dashboard"
```

---

## 📊 Test Data Structure

Tests menggunakan `BuildsPetShopData` trait untuk create:
- Multiple users (owner, kasir, admin)
- Multiple products dengan stock levels
- Multiple categories (cat, dog)
- Dated transactions (dengan created_at override)
- Transaction items dengan proper quantity/pricing

Ini memastikan tests terjalankan dalam terisolasi & repeatable environment.

---

## ✅ Validation Checklist

Setiap test memvalidasi:
- [ ] Response status code (200)
- [ ] Response structure (status, message, data keys)
- [ ] Data types (number, string, array, object)
- [ ] Required fields presence
- [ ] Business logic correctness (ranking, calculations, filtering)
- [ ] Edge cases (empty results, single item, large datasets)

---

## 📝 Next Steps (Optional)

1. **Integration Tests** - Test multiple endpoints dalam sequence
2. **Load Testing** - Performance testing dengan large datasets
3. **Edge Case Tests** - Null values, empty arrays, boundary conditions
4. **CI/CD Integration** - Run tests otomatis di GitHub Actions
5. **API Contract Validation** - Ensure response matches API contract exactly

---

**Created:** 2026-06-18  
**Test Framework:** PHPUnit + Postman  
**Coverage:** Reporting & Dashboard Endpoints
