# Test Case Document

Project : Tomodachi Petshop POS
Automation : Playwright
Version : 1.0
Environment : Staging
Prepared By : Beuys

---

# Summary

| Module | Total Test Case |
|----------|---------------:|
| Authentication | 15 |
| Dashboard Owner | 12 |
| Dashboard Admin | 18 |
| Product | 25 |
| Category | 10 |
| Supplier | 10 |
| Customer | 12 |
| POS Transaction | 30 |
| Report | 15 |
| Authorization | 15 |
| TOTAL | 162 |

---

# AUTHENTICATION

## Login

| ID | Scenario | Expected |
|-----|----------|-----------|
| TC-LOGIN-001 | Login dengan email & password valid | Berhasil masuk Dashboard |
| TC-LOGIN-002 | Password salah | Error password |
| TC-LOGIN-003 | Email salah | Error email |
| TC-LOGIN-004 | Email kosong | Required validation |
| TC-LOGIN-005 | Password kosong | Required validation |
| TC-LOGIN-006 | Email & password kosong | Validation muncul |
| TC-LOGIN-007 | Format email invalid | Validation email |
| TC-LOGIN-008 | Password kurang dari minimal | Validation password |
| TC-LOGIN-009 | SQL Injection pada email | Ditolak |
| TC-LOGIN-010 | SQL Injection password | Ditolak |
| TC-LOGIN-011 | XSS input | Ditolak |
| TC-LOGIN-012 | Double click Login | Hanya login sekali |
| TC-LOGIN-013 | Session expired | Redirect Login |
| TC-LOGIN-014 | Logout | Session terhapus |
| TC-LOGIN-015 | Akses dashboard tanpa login | Redirect Login |

---

# OWNER DASHBOARD

| ID | Scenario | Expected |
|-----|----------|-----------|
| TC-OWNER-001 | Dashboard tampil | Semua widget muncul |
| TC-OWNER-002 | Total Sales tampil | Nilai benar |
| TC-OWNER-003 | Total Product tampil | Nilai benar |
| TC-OWNER-004 | Total Customer tampil | Nilai benar |
| TC-OWNER-005 | Grafik tampil | Tidak kosong |
| TC-OWNER-006 | Filter Today | Data berubah |
| TC-OWNER-007 | Filter Weekly | Data berubah |
| TC-OWNER-008 | Filter Monthly | Data berubah |
| TC-OWNER-009 | Refresh Dashboard | Data terbaru |
| TC-OWNER-010 | Unauthorized Access | Ditolak |
| TC-OWNER-011 | Widget Loading | Loading muncul |
| TC-OWNER-012 | API Error | Error Handling tampil |

---

# ADMIN PRODUCT

## Create

| ID | Scenario | Expected |
|-----|----------|-----------|
| TC-PRODUCT-001 | Tambah produk valid | Produk berhasil dibuat |
| TC-PRODUCT-002 | Nama kosong | Validation |
| TC-PRODUCT-003 | Harga kosong | Validation |
| TC-PRODUCT-004 | Harga negatif | Ditolak |
| TC-PRODUCT-005 | Stok negatif | Ditolak |
| TC-PRODUCT-006 | Upload gambar valid | Berhasil |
| TC-PRODUCT-007 | Upload file non-image | Ditolak |
| TC-PRODUCT-008 | SKU duplicate | Ditolak |

## Read

| ID | Scenario | Expected |
|-----|----------|-----------|
| TC-PRODUCT-009 | Data tampil | Semua data tampil |
| TC-PRODUCT-010 | Search produk | Hasil sesuai |
| TC-PRODUCT-011 | Filter kategori | Data sesuai |
| TC-PRODUCT-012 | Pagination | Berfungsi |
| TC-PRODUCT-013 | Sorting | Berfungsi |

## Update

| ID | Scenario | Expected |
|-----|----------|-----------|
| TC-PRODUCT-014 | Edit nama | Berhasil |
| TC-PRODUCT-015 | Edit harga | Berhasil |
| TC-PRODUCT-016 | Edit stok | Berhasil |
| TC-PRODUCT-017 | Edit gambar | Berhasil |

## Delete

| ID | Scenario | Expected |
|-----|----------|-----------|
| TC-PRODUCT-018 | Delete produk | Berhasil |
| TC-PRODUCT-019 | Cancel Delete | Tidak terhapus |
| TC-PRODUCT-020 | Delete produk dipakai transaksi | Ditolak |

## Edge Case

| ID | Scenario | Expected |
|-----|----------|-----------|
| TC-PRODUCT-021 | Nama 255 karakter | Berhasil |
| TC-PRODUCT-022 | Nama 256 karakter | Ditolak |
| TC-PRODUCT-023 | Harga sangat besar | Berhasil |
| TC-PRODUCT-024 | Refresh saat edit | Tidak corrupt |
| TC-PRODUCT-025 | Double submit | Tidak duplicate |

---

# POS TRANSACTION

| ID | Scenario | Expected |
|-----|----------|-----------|
| TC-POS-001 | Cari produk | Berhasil |
| TC-POS-002 | Scan barcode | Berhasil |
| TC-POS-003 | Tambah cart | Berhasil |
| TC-POS-004 | Tambah qty | Qty bertambah |
| TC-POS-005 | Kurangi qty | Qty berkurang |
| TC-POS-006 | Qty melebihi stok | Ditolak |
| TC-POS-007 | Hapus item | Berhasil |
| TC-POS-008 | Cart kosong checkout | Ditolak |
| TC-POS-009 | Diskon nominal | Berhasil |
| TC-POS-010 | Diskon persen | Berhasil |
| TC-POS-011 | Voucher valid | Berhasil |
| TC-POS-012 | Voucher invalid | Ditolak |
| TC-POS-013 | Bayar cash pas | Berhasil |
| TC-POS-014 | Bayar cash lebih | Kembalian benar |
| TC-POS-015 | Bayar cash kurang | Ditolak |
| TC-POS-016 | QRIS | Berhasil |
| TC-POS-017 | Transfer | Berhasil |
| TC-POS-018 | Invoice muncul | Berhasil |
| TC-POS-019 | Print invoice | Berhasil |
| TC-POS-020 | Simpan transaksi | Berhasil |
| TC-POS-021 | Refresh sebelum bayar | Cart tetap |
| TC-POS-022 | Network timeout | Retry |
| TC-POS-023 | API gagal | Error tampil |
| TC-POS-024 | Stock berubah saat checkout | Update stok |
| TC-POS-025 | Double click Bayar | Tidak double transaksi |
| TC-POS-026 | Cancel transaksi | Berhasil |
| TC-POS-027 | Customer member | Diskon member |
| TC-POS-028 | Customer umum | Tanpa diskon |
| TC-POS-029 | Refund | Berhasil |
| TC-POS-030 | History transaksi | Data muncul |

---

# REPORT

| ID | Scenario | Expected |
|-----|----------|-----------|
| TC-REPORT-001 | Report harian | Tampil |
| TC-REPORT-002 | Report mingguan | Tampil |
| TC-REPORT-003 | Report bulanan | Tampil |
| TC-REPORT-004 | Export PDF | Berhasil |
| TC-REPORT-005 | Export Excel | Berhasil |
| TC-REPORT-006 | Filter tanggal | Berhasil |
| TC-REPORT-007 | Total sesuai transaksi | Valid |
| TC-REPORT-008 | Empty report | Empty state |
| TC-REPORT-009 | Print report | Berhasil |
| TC-REPORT-010 | Download report | Berhasil |
| TC-REPORT-011 | Unauthorized access | Ditolak |
| TC-REPORT-012 | Pagination | Berfungsi |
| TC-REPORT-013 | Sorting | Berfungsi |
| TC-REPORT-014 | Search report | Berhasil |
| TC-REPORT-015 | API Error | Error Handling |

---

# AUTHORIZATION

| ID | Scenario | Expected |
|-----|----------|-----------|
| TC-AUTH-001 | Owner akses Owner Page | Berhasil |
| TC-AUTH-002 | Admin akses Owner Page | Ditolak |
| TC-AUTH-003 | Kasir akses Product | Ditolak |
| TC-AUTH-004 | Admin akses Product | Berhasil |
| TC-AUTH-005 | Owner akses Report | Berhasil |
| TC-AUTH-006 | Kasir akses Report | Ditolak |
| TC-AUTH-007 | Direct URL Owner | Redirect |
| TC-AUTH-008 | Direct API Owner | 403 Forbidden |
| TC-AUTH-009 | JWT Invalid | Redirect Login |
| TC-AUTH-010 | JWT Expired | Redirect Login |
| TC-AUTH-011 | Refresh Token | Berhasil |
| TC-AUTH-012 | Logout | Token terhapus |
| TC-AUTH-013 | Session Timeout | Redirect |
| TC-AUTH-014 | Multi Login | Session valid |
| TC-AUTH-015 | Access after Logout | Ditolak |

---

# Acceptance Criteria

- Semua test case PASS
- Tidak ada bug Critical
- Tidak ada bug High
- Coverage minimal 90%
- Regression Test PASS