# Product Requirements Document (PRD)

# Feature: Barcode Scanner Integration
Project: Tomodachi Pet Shop POS
Version: 1.0
Status: Draft
Author: Pajar
Date: July 2026

---

# 1. Background

Saat ini proses pencarian produk pada halaman Point of Sale (POS) masih dilakukan secara manual menggunakan:

- Search nama produk
- Scroll daftar produk

Metode ini memperlambat transaksi terutama ketika jumlah produk semakin banyak.

Sebagian besar produk pet shop sudah memiliki barcode (EAN-13 / UPC), sehingga sistem perlu mampu melakukan pencarian produk secara instan menggunakan barcode scanner maupun kamera perangkat.

---

# 2. Goals

Tujuan fitur ini adalah:

- Mempercepat proses checkout
- Mengurangi human error saat mencari produk
- Mendukung barcode scanner USB (Keyboard HID)
- Mendukung scan melalui kamera smartphone
- Mengurangi waktu transaksi

---

# 3. Success Metrics

| Metric | Target |
|---------|---------|
| Waktu pencarian produk | < 1 detik |
| Tingkat keberhasilan scan | >95% |
| Penambahan produk ke cart | Otomatis |
| Error barcode tidak ditemukan | Ditampilkan <500 ms |

---

# 4. Scope

## In Scope

✔ Scan barcode menggunakan scanner USB

✔ Scan barcode menggunakan kamera

✔ Auto search produk

✔ Auto add ke cart

✔ Jika produk sudah ada pada cart

- quantity bertambah 1

✔ Feedback suara

✔ Feedback visual

✔ Error handling

---

## Out of Scope

❌ Generate barcode

❌ Print barcode

❌ QR Code pembayaran

❌ Inventory barcode printing

---

# 5. User Story

### Kasir

Sebagai kasir,

Saya ingin cukup melakukan scan barcode,

Agar produk langsung masuk ke keranjang tanpa harus mencarinya secara manual.

---

# 6. Functional Requirements

## FR-01 Barcode Input

Sistem harus menerima input barcode dari:

- USB Barcode Scanner
- Kamera smartphone
- Kamera laptop

---

## FR-02 Barcode Search

Setelah barcode diterima:

```
barcode

↓

Cari produk

↓

Jika ditemukan

↓

Tambahkan ke cart
```

Response maksimal:

< 1 detik

---

## FR-03 Existing Product

Jika produk sudah ada di cart:

```
Qty +1

Subtotal diperbarui

Total diperbarui
```

Tidak membuat item baru.

---

## FR-04 Product Not Found

Jika barcode tidak ditemukan:

Tampilkan dialog

```
Produk tidak ditemukan

Barcode:
8991234567890
```

Tersedia tombol:

- Tutup

---

## FR-05 Stock Validation

Jika stok habis:

```
Stok produk habis
```

Produk tidak boleh masuk cart.

---

## FR-06 Feedback

Scan berhasil:

- Suara beep
- Snackbar hijau
- Highlight produk

Scan gagal:

- Suara error
- Snackbar merah

---

## FR-07 Manual Search

Fitur lama tetap tersedia.

---

# 7. Non Functional Requirements

## Performance

Response pencarian:

< 1 detik

Scan consecutive:

10 scan dalam 5 detik

tanpa crash.

---

## Reliability

Tidak boleh duplicate request.

Tidak boleh race condition ketika scan cepat.

---

## Compatibility

Support:

- Chrome Desktop
- Edge
- Firefox
- Android Chrome
- iOS Safari

---

# 8. Technical Requirements

## Backend

Laravel

Endpoint:

```
GET /api/products/barcode/{barcode}
```

Response:

```json
{
    "success": true,
    "data": {
        "id": 14,
        "barcode": "8991234567890",
        "sku": "DOG001",
        "name": "Royal Canin Mini Adult",
        "price": 85000,
        "stock": 18,
        "image": "...",
        "category": "Dog Food"
    }
}
```

---

Jika tidak ditemukan

```json
{
    "success": false,
    "message": "Product not found"
}
```

---

## Database

Pastikan tabel products memiliki:

```
barcode
```

Type:

```
VARCHAR(50)
```

Unique Index:

```
UNIQUE(barcode)
```

---

Migration

```php
$table->string('barcode')->nullable()->unique();
```

---

Validation

Barcode tidak boleh duplicate.

---

# 9. Frontend Requirements

Flutter Web

Tambahkan:

```
Icon Scan Barcode
```

pada halaman POS.

---

Flow:

```
Klik tombol Scan

↓

Aktifkan kamera

↓

Deteksi barcode

↓

Request API

↓

Produk ditemukan

↓

Auto Add Cart

↓

Scanner tetap aktif
```

---

Scanner dapat ditutup manual.

---

# 10. Hardware Support

Harus support:

USB Barcode Scanner

Contoh:

- Zebra
- Honeywell
- Symbol
- Generic HID Scanner

Scanner bertindak sebagai keyboard.

Contoh input:

```
8991234567890 + ENTER
```

Sistem harus otomatis membaca input tersebut.

---

# 11. Camera Scanner

Menggunakan library:

Flutter:

- mobile_scanner

atau

- barcode_scan2

Web:

ZXing

atau

html5-qrcode

---

Scanner harus:

Auto focus

Continuous scanning

Pause 1 detik setelah scan sukses

Lalu aktif kembali.

---

# 12. Error Handling

Case

Barcode kosong

Response

Tidak melakukan request.

---

Case

Internet putus

Response

```
Tidak dapat terhubung ke server
```

---

Case

API timeout

Response

```
Request timeout
```

---

Case

Barcode invalid

Response

```
Barcode tidak valid
```

---

# 13. Security

Barcode harus divalidasi.

Tidak boleh SQL Injection.

Rate limit endpoint.

Gunakan authentication yang sudah ada.

---

# 14. UX Requirements

Scanner harus dapat digunakan hanya dengan:

Scan

tanpa klik tambahan.

Target maksimal:

```
Scan

↓

Produk muncul

↓

Kasir lanjut scan berikutnya
```

Kurang dari:

1 detik.

---

# 15. Acceptance Criteria

## AC-01

Given

Kasir membuka halaman POS

When

Melakukan scan barcode valid

Then

Produk otomatis masuk cart.

---

## AC-02

Given

Produk sudah ada di cart

When

Barcode yang sama discan lagi

Then

Quantity bertambah 1.

---

## AC-03

Given

Barcode tidak ada

When

Scan dilakukan

Then

Muncul pesan:

Produk tidak ditemukan.

---

## AC-04

Given

Stok = 0

When

Scan dilakukan

Then

Produk tidak ditambahkan.

---

## AC-05

Given

Scanner USB

When

Scan barcode

Then

Produk langsung masuk cart tanpa klik apapun.

---

## AC-06

Given

Kamera smartphone

When

Barcode terdeteksi

Then

Produk langsung masuk cart.

---

# 16. Future Enhancements

- Generate barcode
- Print barcode
- Multiple barcode per produk
- Batch barcode
- Scan QR Product
- Offline barcode cache
- Scan menggunakan Bluetooth Scanner
- Scan barcode saat stock opname