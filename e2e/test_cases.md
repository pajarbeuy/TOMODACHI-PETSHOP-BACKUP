# Frontend E2E Test Cases (Step-by-Step) - Tomodachi Pet Shop

Dokumen ini berisi detail skenario kasus uji (*Test Cases*) dengan panduan **langkah-demi-langkah (step-by-step)** bergaya **Katalon Studio** untuk otomatisasi UI testing di Flutter Web menggunakan **Playwright**.

--- 

## Ringkasan Total Test Execution
* **Total E2E Spec Files:** 10 Files
* **Total E2E Test Cases:** **164 Test Cases** (Sesuai dengan spec files terbaru)
* **Format Pengujian:** Visual & Functional UI interaction (Interaksi form, button click, navigation, assertion semantic tree).

--- 

## Modul: Login (`01-login.spec.js`)

### TC-LOGIN-001 | Login dengan email & password valid (Role: Admin)
* **Test Case ID:** `TC-E2E-001`
* **Deskripsi:** UI test untuk skenario `Login dengan email & password valid (Role: Admin)` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Ketik email valid. | `Email sesuai Role` | Teks terisi di input email. |
| 3 | Ketik password valid. | `password123` | Teks terisi di input password. |
| 4 | Hitung dan isi jawaban captcha matematika. | `Hasil penjumlahan (misal: 10)` | Jawaban terisi di input captcha. |
| 5 | Klik tombol "Sign In". | `Tombol [Sign In]` | Halaman dialihkan ke Dashboard utama. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-001b | Login dengan email & password valid (Role: Kasir)
* **Test Case ID:** `TC-E2E-002`
* **Deskripsi:** UI test untuk skenario `Login dengan email & password valid (Role: Kasir)` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Ketik email valid. | `Email sesuai Role` | Teks terisi di input email. |
| 3 | Ketik password valid. | `password123` | Teks terisi di input password. |
| 4 | Hitung dan isi jawaban captcha matematika. | `Hasil penjumlahan (misal: 10)` | Jawaban terisi di input captcha. |
| 5 | Klik tombol "Sign In". | `Tombol [Sign In]` | Halaman dialihkan ke Dashboard utama. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-001c | Login dengan email & password valid (Role: Owner)
* **Test Case ID:** `TC-E2E-003`
* **Deskripsi:** UI test untuk skenario `Login dengan email & password valid (Role: Owner)` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Ketik email valid. | `Email sesuai Role` | Teks terisi di input email. |
| 3 | Ketik password valid. | `password123` | Teks terisi di input password. |
| 4 | Hitung dan isi jawaban captcha matematika. | `Hasil penjumlahan (misal: 10)` | Jawaban terisi di input captcha. |
| 5 | Klik tombol "Sign In". | `Tombol [Sign In]` | Halaman dialihkan ke Dashboard utama. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-002 | Password salah
* **Test Case ID:** `TC-E2E-004`
* **Deskripsi:** UI test untuk skenario `Password salah` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Masukkan data tidak valid / karakter aneh. | `Payload abnormal / password salah` | Teks terisi di input field. |
| 3 | Klik tombol "Sign In". | `Tombol [Sign In]` | Muncul pesan error "Login Error" atau "Captcha verification failed". |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-003 | Email salah
* **Test Case ID:** `TC-E2E-005`
* **Deskripsi:** UI test untuk skenario `Email salah` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Masukkan data tidak valid / karakter aneh. | `Payload abnormal / password salah` | Teks terisi di input field. |
| 3 | Klik tombol "Sign In". | `Tombol [Sign In]` | Muncul pesan error "Login Error" atau "Captcha verification failed". |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-004 | Email kosong
* **Test Case ID:** `TC-E2E-006`
* **Deskripsi:** UI test untuk skenario `Email kosong` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Kosongkan input yang diuji (Email/Password). | `Email / Password kosong` | Input terlihat kosong. |
| 3 | Klik tombol "Sign In". | `Tombol [Sign In]` | Muncul pesan error "Email and password are required". |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-005 | Password kosong
* **Test Case ID:** `TC-E2E-007`
* **Deskripsi:** UI test untuk skenario `Password kosong` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Kosongkan input yang diuji (Email/Password). | `Email / Password kosong` | Input terlihat kosong. |
| 3 | Klik tombol "Sign In". | `Tombol [Sign In]` | Muncul pesan error "Email and password are required". |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-006 | Email & password kosong
* **Test Case ID:** `TC-E2E-008`
* **Deskripsi:** UI test untuk skenario `Email & password kosong` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Kosongkan input yang diuji (Email/Password). | `Email / Password kosong` | Input terlihat kosong. |
| 3 | Klik tombol "Sign In". | `Tombol [Sign In]` | Muncul pesan error "Email and password are required". |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-007 | Format email invalid
* **Test Case ID:** `TC-E2E-009`
* **Deskripsi:** UI test untuk skenario `Format email invalid` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Ketik email valid. | `Email sesuai Role` | Teks terisi di input email. |
| 3 | Ketik password valid. | `password123` | Teks terisi di input password. |
| 4 | Hitung dan isi jawaban captcha matematika. | `Hasil penjumlahan (misal: 10)` | Jawaban terisi di input captcha. |
| 5 | Klik tombol "Sign In". | `Tombol [Sign In]` | Halaman dialihkan ke Dashboard utama. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-008 | Password kurang dari minimal
* **Test Case ID:** `TC-E2E-010`
* **Deskripsi:** UI test untuk skenario `Password kurang dari minimal` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Masukkan data tidak valid / karakter aneh. | `Payload abnormal / password salah` | Teks terisi di input field. |
| 3 | Klik tombol "Sign In". | `Tombol [Sign In]` | Muncul pesan error "Login Error" atau "Captcha verification failed". |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-009 | SQL Injection pada email
* **Test Case ID:** `TC-E2E-011`
* **Deskripsi:** UI test untuk skenario `SQL Injection pada email` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Masukkan data tidak valid / karakter aneh. | `Payload abnormal / password salah` | Teks terisi di input field. |
| 3 | Klik tombol "Sign In". | `Tombol [Sign In]` | Muncul pesan error "Login Error" atau "Captcha verification failed". |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-010 | SQL Injection password
* **Test Case ID:** `TC-E2E-012`
* **Deskripsi:** UI test untuk skenario `SQL Injection password` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Masukkan data tidak valid / karakter aneh. | `Payload abnormal / password salah` | Teks terisi di input field. |
| 3 | Klik tombol "Sign In". | `Tombol [Sign In]` | Muncul pesan error "Login Error" atau "Captcha verification failed". |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-011 | XSS input
* **Test Case ID:** `TC-E2E-013`
* **Deskripsi:** UI test untuk skenario `XSS input` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Masukkan data tidak valid / karakter aneh. | `Payload abnormal / password salah` | Teks terisi di input field. |
| 3 | Klik tombol "Sign In". | `Tombol [Sign In]` | Muncul pesan error "Login Error" atau "Captcha verification failed". |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-012 | Double click Login
* **Test Case ID:** `TC-E2E-014`
* **Deskripsi:** UI test untuk skenario `Double click Login` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Lakukan interaksi khusus (logout/session expired/double click). | `Aksi session/tombol` | Aksi tereksekusi. |
| 3 | Verifikasi status akhir sesi. | `-` | Sesi terhapus dan ter-redirect kembali ke halaman login. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-013 | Session expired
* **Test Case ID:** `TC-E2E-015`
* **Deskripsi:** UI test untuk skenario `Session expired` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Lakukan interaksi khusus (logout/session expired/double click). | `Aksi session/tombol` | Aksi tereksekusi. |
| 3 | Verifikasi status akhir sesi. | `-` | Sesi terhapus dan ter-redirect kembali ke halaman login. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-014 | Logout
* **Test Case ID:** `TC-E2E-016`
* **Deskripsi:** UI test untuk skenario `Logout` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Lakukan interaksi khusus (logout/session expired/double click). | `Aksi session/tombol` | Aksi tereksekusi. |
| 3 | Verifikasi status akhir sesi. | `-` | Sesi terhapus dan ter-redirect kembali ke halaman login. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-LOGIN-015 | Akses dashboard tanpa login
* **Test Case ID:** `TC-E2E-017`
* **Deskripsi:** UI test untuk skenario `Akses dashboard tanpa login` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Halaman Login terbuka di browser.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka browser dan navigasi ke URL. | `http://localhost:8080` | Halaman login ditampilkan. |
| 2 | Lakukan interaksi khusus (logout/session expired/double click). | `Aksi session/tombol` | Aksi tereksekusi. |
| 3 | Verifikasi status akhir sesi. | `-` | Sesi terhapus dan ter-redirect kembali ke halaman login. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

## Modul: Kasir Pos (`02-kasir-pos.spec.js`)

### TC-POS-001 | Cari produk
* **Test Case ID:** `TC-E2E-018`
* **Deskripsi:** UI test untuk skenario `Cari produk` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Ketik kata kunci produk pada kolom pencarian POS. | `Nama produk / Barcode (misal: "Food")` | Daftar produk POS memfilter dan menampilkan produk yang dicari. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-002 | Scan barcode
* **Test Case ID:** `TC-E2E-019`
* **Deskripsi:** UI test untuk skenario `Scan barcode` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Ketik kata kunci produk pada kolom pencarian POS. | `Nama produk / Barcode (misal: "Food")` | Daftar produk POS memfilter dan menampilkan produk yang dicari. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-003 | Tambah cart
* **Test Case ID:** `TC-E2E-020`
* **Deskripsi:** UI test untuk skenario `Tambah cart` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik produk untuk menambahkan ke keranjang belanja (Cart). | `Klik produk item` | Produk masuk ke daftar keranjang belanja. |
| 2 | Atur jumlah kuantitas produk (tambah/kurang/melebihi). | `Klik [+] / [-] atau input manual` | Jumlah kuantitas dan subtotal terupdate sesuai stok. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-004 | Tambah qty
* **Test Case ID:** `TC-E2E-021`
* **Deskripsi:** UI test untuk skenario `Tambah qty` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik produk untuk menambahkan ke keranjang belanja (Cart). | `Klik produk item` | Produk masuk ke daftar keranjang belanja. |
| 2 | Atur jumlah kuantitas produk (tambah/kurang/melebihi). | `Klik [+] / [-] atau input manual` | Jumlah kuantitas dan subtotal terupdate sesuai stok. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-005 | Kurangi qty
* **Test Case ID:** `TC-E2E-022`
* **Deskripsi:** UI test untuk skenario `Kurangi qty` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik produk untuk menambahkan ke keranjang belanja (Cart). | `Klik produk item` | Produk masuk ke daftar keranjang belanja. |
| 2 | Atur jumlah kuantitas produk (tambah/kurang/melebihi). | `Klik [+] / [-] atau input manual` | Jumlah kuantitas dan subtotal terupdate sesuai stok. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-006 | Qty melebihi stok
* **Test Case ID:** `TC-E2E-023`
* **Deskripsi:** UI test untuk skenario `Qty melebihi stok` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik produk untuk menambahkan ke keranjang belanja (Cart). | `Klik produk item` | Produk masuk ke daftar keranjang belanja. |
| 2 | Atur jumlah kuantitas produk (tambah/kurang/melebihi). | `Klik [+] / [-] atau input manual` | Jumlah kuantitas dan subtotal terupdate sesuai stok. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-007 | Hapus item
* **Test Case ID:** `TC-E2E-024`
* **Deskripsi:** UI test untuk skenario `Hapus item` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik produk untuk menambahkan ke keranjang belanja (Cart). | `Klik produk item` | Produk masuk ke daftar keranjang belanja. |
| 2 | Atur jumlah kuantitas produk (tambah/kurang/melebihi). | `Klik [+] / [-] atau input manual` | Jumlah kuantitas dan subtotal terupdate sesuai stok. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-008 | Cart kosong checkout
* **Test Case ID:** `TC-E2E-025`
* **Deskripsi:** UI test untuk skenario `Cart kosong checkout` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik produk untuk menambahkan ke keranjang belanja (Cart). | `Klik produk item` | Produk masuk ke daftar keranjang belanja. |
| 2 | Atur jumlah kuantitas produk (tambah/kurang/melebihi). | `Klik [+] / [-] atau input manual` | Jumlah kuantitas dan subtotal terupdate sesuai stok. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-009 | Diskon nominal
* **Test Case ID:** `TC-E2E-026`
* **Deskripsi:** UI test untuk skenario `Diskon nominal` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Masukkan input potongan/diskon/member. | `Diskon %, voucher code, atau ID member` | Total belanja terpotong sesuai kalkulasi diskon. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-010 | Diskon persen
* **Test Case ID:** `TC-E2E-027`
* **Deskripsi:** UI test untuk skenario `Diskon persen` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Masukkan input potongan/diskon/member. | `Diskon %, voucher code, atau ID member` | Total belanja terpotong sesuai kalkulasi diskon. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-011 | Voucher valid
* **Test Case ID:** `TC-E2E-028`
* **Deskripsi:** UI test untuk skenario `Voucher valid` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Masukkan input potongan/diskon/member. | `Diskon %, voucher code, atau ID member` | Total belanja terpotong sesuai kalkulasi diskon. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-012 | Voucher invalid
* **Test Case ID:** `TC-E2E-029`
* **Deskripsi:** UI test untuk skenario `Voucher invalid` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Masukkan input potongan/diskon/member. | `Diskon %, voucher code, atau ID member` | Total belanja terpotong sesuai kalkulasi diskon. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-013 | Bayar cash pas
* **Test Case ID:** `TC-E2E-030`
* **Deskripsi:** UI test untuk skenario `Bayar cash pas` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Pilih metode pembayaran dan masukkan nominal bayar. | `Nominal uang tunai / pilih QRIS / Transfer` | Metode terpilih. |
| 2 | Klik tombol "Bayar" atau "Selesaikan Transaksi". | `Klik [Bayar]` | Transaksi terproses, stok berkurang, struk belanja muncul. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-014 | Bayar cash lebih
* **Test Case ID:** `TC-E2E-031`
* **Deskripsi:** UI test untuk skenario `Bayar cash lebih` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Pilih metode pembayaran dan masukkan nominal bayar. | `Nominal uang tunai / pilih QRIS / Transfer` | Metode terpilih. |
| 2 | Klik tombol "Bayar" atau "Selesaikan Transaksi". | `Klik [Bayar]` | Transaksi terproses, stok berkurang, struk belanja muncul. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-015 | Bayar cash kurang
* **Test Case ID:** `TC-E2E-032`
* **Deskripsi:** UI test untuk skenario `Bayar cash kurang` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Pilih metode pembayaran dan masukkan nominal bayar. | `Nominal uang tunai / pilih QRIS / Transfer` | Metode terpilih. |
| 2 | Klik tombol "Bayar" atau "Selesaikan Transaksi". | `Klik [Bayar]` | Transaksi terproses, stok berkurang, struk belanja muncul. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-016 | QRIS
* **Test Case ID:** `TC-E2E-033`
* **Deskripsi:** UI test untuk skenario `QRIS` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Pilih metode pembayaran dan masukkan nominal bayar. | `Nominal uang tunai / pilih QRIS / Transfer` | Metode terpilih. |
| 2 | Klik tombol "Bayar" atau "Selesaikan Transaksi". | `Klik [Bayar]` | Transaksi terproses, stok berkurang, struk belanja muncul. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-017 | Transfer
* **Test Case ID:** `TC-E2E-034`
* **Deskripsi:** UI test untuk skenario `Transfer` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Pilih metode pembayaran dan masukkan nominal bayar. | `Nominal uang tunai / pilih QRIS / Transfer` | Metode terpilih. |
| 2 | Klik tombol "Bayar" atau "Selesaikan Transaksi". | `Klik [Bayar]` | Transaksi terproses, stok berkurang, struk belanja muncul. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-018 | Invoice muncul
* **Test Case ID:** `TC-E2E-035`
* **Deskripsi:** UI test untuk skenario `Invoice muncul` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan interaksi transaksi sesuai nama skenario. | `-` | Sistem mengevaluasi dan merespons transaksi. |
| 2 | Verifikasi integritas data POS. | `-` | Data transaksi terarsip di riwayat transaksi. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-019 | Print invoice
* **Test Case ID:** `TC-E2E-036`
* **Deskripsi:** UI test untuk skenario `Print invoice` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan interaksi transaksi sesuai nama skenario. | `-` | Sistem mengevaluasi dan merespons transaksi. |
| 2 | Verifikasi integritas data POS. | `-` | Data transaksi terarsip di riwayat transaksi. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-020 | Simpan transaksi
* **Test Case ID:** `TC-E2E-037`
* **Deskripsi:** UI test untuk skenario `Simpan transaksi` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan interaksi transaksi sesuai nama skenario. | `-` | Sistem mengevaluasi dan merespons transaksi. |
| 2 | Verifikasi integritas data POS. | `-` | Data transaksi terarsip di riwayat transaksi. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-021 | Refresh sebelum bayar
* **Test Case ID:** `TC-E2E-038`
* **Deskripsi:** UI test untuk skenario `Refresh sebelum bayar` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Pilih metode pembayaran dan masukkan nominal bayar. | `Nominal uang tunai / pilih QRIS / Transfer` | Metode terpilih. |
| 2 | Klik tombol "Bayar" atau "Selesaikan Transaksi". | `Klik [Bayar]` | Transaksi terproses, stok berkurang, struk belanja muncul. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-022 | Network timeout
* **Test Case ID:** `TC-E2E-039`
* **Deskripsi:** UI test untuk skenario `Network timeout` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan interaksi transaksi sesuai nama skenario. | `-` | Sistem mengevaluasi dan merespons transaksi. |
| 2 | Verifikasi integritas data POS. | `-` | Data transaksi terarsip di riwayat transaksi. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-023 | API gagal
* **Test Case ID:** `TC-E2E-040`
* **Deskripsi:** UI test untuk skenario `API gagal` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan interaksi transaksi sesuai nama skenario. | `-` | Sistem mengevaluasi dan merespons transaksi. |
| 2 | Verifikasi integritas data POS. | `-` | Data transaksi terarsip di riwayat transaksi. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-024 | Stock berubah saat checkout
* **Test Case ID:** `TC-E2E-041`
* **Deskripsi:** UI test untuk skenario `Stock berubah saat checkout` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan interaksi transaksi sesuai nama skenario. | `-` | Sistem mengevaluasi dan merespons transaksi. |
| 2 | Verifikasi integritas data POS. | `-` | Data transaksi terarsip di riwayat transaksi. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-025 | Double click Bayar
* **Test Case ID:** `TC-E2E-042`
* **Deskripsi:** UI test untuk skenario `Double click Bayar` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Pilih metode pembayaran dan masukkan nominal bayar. | `Nominal uang tunai / pilih QRIS / Transfer` | Metode terpilih. |
| 2 | Klik tombol "Bayar" atau "Selesaikan Transaksi". | `Klik [Bayar]` | Transaksi terproses, stok berkurang, struk belanja muncul. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-026 | Cancel transaksi
* **Test Case ID:** `TC-E2E-043`
* **Deskripsi:** UI test untuk skenario `Cancel transaksi` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan interaksi transaksi sesuai nama skenario. | `-` | Sistem mengevaluasi dan merespons transaksi. |
| 2 | Verifikasi integritas data POS. | `-` | Data transaksi terarsip di riwayat transaksi. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-027 | Customer member
* **Test Case ID:** `TC-E2E-044`
* **Deskripsi:** UI test untuk skenario `Customer member` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Masukkan input potongan/diskon/member. | `Diskon %, voucher code, atau ID member` | Total belanja terpotong sesuai kalkulasi diskon. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-028 | Customer umum
* **Test Case ID:** `TC-E2E-045`
* **Deskripsi:** UI test untuk skenario `Customer umum` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan interaksi transaksi sesuai nama skenario. | `-` | Sistem mengevaluasi dan merespons transaksi. |
| 2 | Verifikasi integritas data POS. | `-` | Data transaksi terarsip di riwayat transaksi. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-029 | Refund
* **Test Case ID:** `TC-E2E-046`
* **Deskripsi:** UI test untuk skenario `Refund` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan interaksi transaksi sesuai nama skenario. | `-` | Sistem mengevaluasi dan merespons transaksi. |
| 2 | Verifikasi integritas data POS. | `-` | Data transaksi terarsip di riwayat transaksi. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-POS-030 | History transaksi
* **Test Case ID:** `TC-E2E-047`
* **Deskripsi:** UI test untuk skenario `History transaksi` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Kasir berhasil login dan berada di halaman POS Kasir.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan interaksi transaksi sesuai nama skenario. | `-` | Sistem mengevaluasi dan merespons transaksi. |
| 2 | Verifikasi integritas data POS. | `-` | Data transaksi terarsip di riwayat transaksi. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

## Modul: Admin Products (`03-admin-products.spec.js`)

### TC-PRODUCT-001 | Tambah produk valid
* **Test Case ID:** `TC-E2E-048`
* **Deskripsi:** UI test untuk skenario `Tambah produk valid` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik tombol "Tambah Produk". | `-` | Form tambah produk ditampilkan. |
| 2 | Isi form lengkap (Nama, SKU, kategori, harga beli, harga jual, stok awal). | `Data produk valid` | Form terisi. |
| 3 | Klik "Simpan". | `-` | Muncul dialog sukses, produk baru tampil di daftar produk. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-002 | Nama kosong
* **Test Case ID:** `TC-E2E-049`
* **Deskripsi:** UI test untuk skenario `Nama kosong` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik tombol "Tambah Produk". | `-` | Form tambah produk ditampilkan. |
| 2 | Isi form dengan data tidak valid (kosong/negatif/duplikat SKU). | `Data invalid` | Form terisi. |
| 3 | Klik "Simpan". | `-` | Pendaftaran ditolak dan pesan validasi error ditampilkan. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-003 | Harga kosong
* **Test Case ID:** `TC-E2E-050`
* **Deskripsi:** UI test untuk skenario `Harga kosong` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik tombol "Tambah Produk". | `-` | Form tambah produk ditampilkan. |
| 2 | Isi form dengan data tidak valid (kosong/negatif/duplikat SKU). | `Data invalid` | Form terisi. |
| 3 | Klik "Simpan". | `-` | Pendaftaran ditolak dan pesan validasi error ditampilkan. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-004 | Harga negatif
* **Test Case ID:** `TC-E2E-051`
* **Deskripsi:** UI test untuk skenario `Harga negatif` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik tombol "Tambah Produk". | `-` | Form tambah produk ditampilkan. |
| 2 | Isi form dengan data tidak valid (kosong/negatif/duplikat SKU). | `Data invalid` | Form terisi. |
| 3 | Klik "Simpan". | `-` | Pendaftaran ditolak dan pesan validasi error ditampilkan. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-005 | Stok negatif
* **Test Case ID:** `TC-E2E-052`
* **Deskripsi:** UI test untuk skenario `Stok negatif` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik tombol "Tambah Produk". | `-` | Form tambah produk ditampilkan. |
| 2 | Isi form dengan data tidak valid (kosong/negatif/duplikat SKU). | `Data invalid` | Form terisi. |
| 3 | Klik "Simpan". | `-` | Pendaftaran ditolak dan pesan validasi error ditampilkan. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-006 | Upload gambar valid
* **Test Case ID:** `TC-E2E-053`
* **Deskripsi:** UI test untuk skenario `Upload gambar valid` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik tombol "Tambah Produk". | `-` | Form tambah produk ditampilkan. |
| 2 | Isi form lengkap (Nama, SKU, kategori, harga beli, harga jual, stok awal). | `Data produk valid` | Form terisi. |
| 3 | Klik "Simpan". | `-` | Muncul dialog sukses, produk baru tampil di daftar produk. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-007 | Upload file non-image
* **Test Case ID:** `TC-E2E-054`
* **Deskripsi:** UI test untuk skenario `Upload file non-image` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan aksi manajemen produk sesuai nama skenario. | `-` | Halaman memproses produk. |
| 2 | Verifikasi hasil akhir produk di tabel. | `-` | Data produk konsisten dengan hasil tes. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-008 | SKU duplicate
* **Test Case ID:** `TC-E2E-055`
* **Deskripsi:** UI test untuk skenario `SKU duplicate` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik tombol "Tambah Produk". | `-` | Form tambah produk ditampilkan. |
| 2 | Isi form dengan data tidak valid (kosong/negatif/duplikat SKU). | `Data invalid` | Form terisi. |
| 3 | Klik "Simpan". | `-` | Pendaftaran ditolak dan pesan validasi error ditampilkan. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-009 | Data tampil
* **Test Case ID:** `TC-E2E-056`
* **Deskripsi:** UI test untuk skenario `Data tampil` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan aksi manajemen produk sesuai nama skenario. | `-` | Halaman memproses produk. |
| 2 | Verifikasi hasil akhir produk di tabel. | `-` | Data produk konsisten dengan hasil tes. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-010 | Search produk
* **Test Case ID:** `TC-E2E-057`
* **Deskripsi:** UI test untuk skenario `Search produk` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan aksi manajemen produk sesuai nama skenario. | `-` | Halaman memproses produk. |
| 2 | Verifikasi hasil akhir produk di tabel. | `-` | Data produk konsisten dengan hasil tes. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-011 | Filter kategori
* **Test Case ID:** `TC-E2E-058`
* **Deskripsi:** UI test untuk skenario `Filter kategori` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan aksi manajemen produk sesuai nama skenario. | `-` | Halaman memproses produk. |
| 2 | Verifikasi hasil akhir produk di tabel. | `-` | Data produk konsisten dengan hasil tes. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-012 | Pagination
* **Test Case ID:** `TC-E2E-059`
* **Deskripsi:** UI test untuk skenario `Pagination` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan aksi manajemen produk sesuai nama skenario. | `-` | Halaman memproses produk. |
| 2 | Verifikasi hasil akhir produk di tabel. | `-` | Data produk konsisten dengan hasil tes. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-013 | Sorting
* **Test Case ID:** `TC-E2E-060`
* **Deskripsi:** UI test untuk skenario `Sorting` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan aksi manajemen produk sesuai nama skenario. | `-` | Halaman memproses produk. |
| 2 | Verifikasi hasil akhir produk di tabel. | `-` | Data produk konsisten dengan hasil tes. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-014 | Edit nama
* **Test Case ID:** `TC-E2E-061`
* **Deskripsi:** UI test untuk skenario `Edit nama` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Pilih produk dan klik tombol "Edit". | `Klik produk item` | Form edit produk ditampilkan berisi data saat ini. |
| 2 | Ubah nilai kolom produk. | `Data edit baru` | Data form terubah. |
| 3 | Klik "Update / Simpan". | `-` | Data produk terupdate dan muncul di tabel produk. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-015 | Edit harga
* **Test Case ID:** `TC-E2E-062`
* **Deskripsi:** UI test untuk skenario `Edit harga` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Pilih produk dan klik tombol "Edit". | `Klik produk item` | Form edit produk ditampilkan berisi data saat ini. |
| 2 | Ubah nilai kolom produk. | `Data edit baru` | Data form terubah. |
| 3 | Klik "Update / Simpan". | `-` | Data produk terupdate dan muncul di tabel produk. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-016 | Edit stok
* **Test Case ID:** `TC-E2E-063`
* **Deskripsi:** UI test untuk skenario `Edit stok` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Pilih produk dan klik tombol "Edit". | `Klik produk item` | Form edit produk ditampilkan berisi data saat ini. |
| 2 | Ubah nilai kolom produk. | `Data edit baru` | Data form terubah. |
| 3 | Klik "Update / Simpan". | `-` | Data produk terupdate dan muncul di tabel produk. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-017 | Edit gambar
* **Test Case ID:** `TC-E2E-064`
* **Deskripsi:** UI test untuk skenario `Edit gambar` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Pilih produk dan klik tombol "Edit". | `Klik produk item` | Form edit produk ditampilkan berisi data saat ini. |
| 2 | Ubah nilai kolom produk. | `Data edit baru` | Data form terubah. |
| 3 | Klik "Update / Simpan". | `-` | Data produk terupdate dan muncul di tabel produk. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-018 | Delete produk
* **Test Case ID:** `TC-E2E-065`
* **Deskripsi:** UI test untuk skenario `Delete produk` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan aksi manajemen produk sesuai nama skenario. | `-` | Halaman memproses produk. |
| 2 | Verifikasi hasil akhir produk di tabel. | `-` | Data produk konsisten dengan hasil tes. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-019 | Cancel Delete
* **Test Case ID:** `TC-E2E-066`
* **Deskripsi:** UI test untuk skenario `Cancel Delete` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan aksi manajemen produk sesuai nama skenario. | `-` | Halaman memproses produk. |
| 2 | Verifikasi hasil akhir produk di tabel. | `-` | Data produk konsisten dengan hasil tes. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-020 | Delete produk dipakai transaksi
* **Test Case ID:** `TC-E2E-067`
* **Deskripsi:** UI test untuk skenario `Delete produk dipakai transaksi` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan aksi manajemen produk sesuai nama skenario. | `-` | Halaman memproses produk. |
| 2 | Verifikasi hasil akhir produk di tabel. | `-` | Data produk konsisten dengan hasil tes. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-021 | Nama 255 karakter
* **Test Case ID:** `TC-E2E-068`
* **Deskripsi:** UI test untuk skenario `Nama 255 karakter` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik tombol "Tambah Produk". | `-` | Form tambah produk ditampilkan. |
| 2 | Isi form dengan data tidak valid (kosong/negatif/duplikat SKU). | `Data invalid` | Form terisi. |
| 3 | Klik "Simpan". | `-` | Pendaftaran ditolak dan pesan validasi error ditampilkan. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-022 | Nama 256 karakter
* **Test Case ID:** `TC-E2E-069`
* **Deskripsi:** UI test untuk skenario `Nama 256 karakter` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Klik tombol "Tambah Produk". | `-` | Form tambah produk ditampilkan. |
| 2 | Isi form dengan data tidak valid (kosong/negatif/duplikat SKU). | `Data invalid` | Form terisi. |
| 3 | Klik "Simpan". | `-` | Pendaftaran ditolak dan pesan validasi error ditampilkan. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-023 | Harga sangat besar
* **Test Case ID:** `TC-E2E-070`
* **Deskripsi:** UI test untuk skenario `Harga sangat besar` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan aksi manajemen produk sesuai nama skenario. | `-` | Halaman memproses produk. |
| 2 | Verifikasi hasil akhir produk di tabel. | `-` | Data produk konsisten dengan hasil tes. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-024 | Refresh saat edit
* **Test Case ID:** `TC-E2E-071`
* **Deskripsi:** UI test untuk skenario `Refresh saat edit` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Pilih produk dan klik tombol "Edit". | `Klik produk item` | Form edit produk ditampilkan berisi data saat ini. |
| 2 | Ubah nilai kolom produk. | `Data edit baru` | Data form terubah. |
| 3 | Klik "Update / Simpan". | `-` | Data produk terupdate dan muncul di tabel produk. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-PRODUCT-025 | Double submit
* **Test Case ID:** `TC-E2E-072`
* **Deskripsi:** UI test untuk skenario `Double submit` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Admin/Owner login dan berada di halaman Manajemen Produk.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Lakukan aksi manajemen produk sesuai nama skenario. | `-` | Halaman memproses produk. |
| 2 | Verifikasi hasil akhir produk di tabel. | `-` | Data produk konsisten dengan hasil tes. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

## Modul: Owner Dashboard (`04-owner-dashboard.spec.js`)

### TC-OWNER-001 | Dashboard tampil
* **Test Case ID:** `TC-E2E-073`
* **Deskripsi:** UI test untuk skenario `Dashboard tampil` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-OWNER-002 | Total Sales tampil
* **Test Case ID:** `TC-E2E-074`
* **Deskripsi:** UI test untuk skenario `Total Sales tampil` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-OWNER-003 | Total Product tampil
* **Test Case ID:** `TC-E2E-075`
* **Deskripsi:** UI test untuk skenario `Total Product tampil` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-OWNER-004 | Total Customer tampil
* **Test Case ID:** `TC-E2E-076`
* **Deskripsi:** UI test untuk skenario `Total Customer tampil` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-OWNER-005 | Grafik tampil
* **Test Case ID:** `TC-E2E-077`
* **Deskripsi:** UI test untuk skenario `Grafik tampil` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-OWNER-006 | Filter Today
* **Test Case ID:** `TC-E2E-078`
* **Deskripsi:** UI test untuk skenario `Filter Today` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-OWNER-007 | Filter Weekly
* **Test Case ID:** `TC-E2E-079`
* **Deskripsi:** UI test untuk skenario `Filter Weekly` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-OWNER-008 | Filter Monthly
* **Test Case ID:** `TC-E2E-080`
* **Deskripsi:** UI test untuk skenario `Filter Monthly` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-OWNER-009 | Refresh Dashboard
* **Test Case ID:** `TC-E2E-081`
* **Deskripsi:** UI test untuk skenario `Refresh Dashboard` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-OWNER-010 | Unauthorized Access
* **Test Case ID:** `TC-E2E-082`
* **Deskripsi:** UI test untuk skenario `Unauthorized Access` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-OWNER-011 | Widget Loading
* **Test Case ID:** `TC-E2E-083`
* **Deskripsi:** UI test untuk skenario `Widget Loading` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-OWNER-012 | API Error
* **Test Case ID:** `TC-E2E-084`
* **Deskripsi:** UI test untuk skenario `API Error` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-OWN-02 | Tambah Akun Baru (Manajemen Akun)
* **Test Case ID:** `TC-E2E-085`
* **Deskripsi:** UI test untuk skenario `Tambah Akun Baru (Manajemen Akun)` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-OWN-03 | AI Chatbot Interaction
* **Test Case ID:** `TC-E2E-086`
* **Deskripsi:** UI test untuk skenario `AI Chatbot Interaction` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

## Modul: Reports (`05-reports.spec.js`)

### TC-REPORT-001 | Report harian
* **Test Case ID:** `TC-E2E-087`
* **Deskripsi:** UI test untuk skenario `Report harian` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-REPORT-002 | Report mingguan
* **Test Case ID:** `TC-E2E-088`
* **Deskripsi:** UI test untuk skenario `Report mingguan` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-REPORT-003 | Report bulanan
* **Test Case ID:** `TC-E2E-089`
* **Deskripsi:** UI test untuk skenario `Report bulanan` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-REPORT-004 | Export PDF
* **Test Case ID:** `TC-E2E-090`
* **Deskripsi:** UI test untuk skenario `Export PDF` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-REPORT-005 | Export Excel
* **Test Case ID:** `TC-E2E-091`
* **Deskripsi:** UI test untuk skenario `Export Excel` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-REPORT-006 | Filter tanggal
* **Test Case ID:** `TC-E2E-092`
* **Deskripsi:** UI test untuk skenario `Filter tanggal` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-REPORT-007 | Total sesuai transaksi
* **Test Case ID:** `TC-E2E-093`
* **Deskripsi:** UI test untuk skenario `Total sesuai transaksi` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-REPORT-008 | Empty report
* **Test Case ID:** `TC-E2E-094`
* **Deskripsi:** UI test untuk skenario `Empty report` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-REPORT-009 | Print report
* **Test Case ID:** `TC-E2E-095`
* **Deskripsi:** UI test untuk skenario `Print report` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-REPORT-010 | Download report
* **Test Case ID:** `TC-E2E-096`
* **Deskripsi:** UI test untuk skenario `Download report` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-REPORT-011 | Unauthorized access
* **Test Case ID:** `TC-E2E-097`
* **Deskripsi:** UI test untuk skenario `Unauthorized access` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-REPORT-012 | Pagination
* **Test Case ID:** `TC-E2E-098`
* **Deskripsi:** UI test untuk skenario `Pagination` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-REPORT-013 | Sorting
* **Test Case ID:** `TC-E2E-099`
* **Deskripsi:** UI test untuk skenario `Sorting` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-REPORT-014 | Search report
* **Test Case ID:** `TC-E2E-100`
* **Deskripsi:** UI test untuk skenario `Search report` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-REPORT-015 | API Error
* **Test Case ID:** `TC-E2E-101`
* **Deskripsi:** UI test untuk skenario `API Error` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

## Modul: Authorization (`06-authorization.spec.js`)

### TC-AUTH-001 | Owner akses Owner Page
* **Test Case ID:** `TC-E2E-102`
* **Deskripsi:** UI test untuk skenario `Owner akses Owner Page` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-AUTH-002 | Admin akses Owner Page
* **Test Case ID:** `TC-E2E-103`
* **Deskripsi:** UI test untuk skenario `Admin akses Owner Page` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-AUTH-003 | Kasir akses Product
* **Test Case ID:** `TC-E2E-104`
* **Deskripsi:** UI test untuk skenario `Kasir akses Product` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-AUTH-004 | Admin akses Product
* **Test Case ID:** `TC-E2E-105`
* **Deskripsi:** UI test untuk skenario `Admin akses Product` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-AUTH-005 | Owner akses Report
* **Test Case ID:** `TC-E2E-106`
* **Deskripsi:** UI test untuk skenario `Owner akses Report` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-AUTH-006 | Kasir akses Report
* **Test Case ID:** `TC-E2E-107`
* **Deskripsi:** UI test untuk skenario `Kasir akses Report` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-AUTH-007 | Direct URL Owner
* **Test Case ID:** `TC-E2E-108`
* **Deskripsi:** UI test untuk skenario `Direct URL Owner` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-AUTH-008 | Direct API Owner
* **Test Case ID:** `TC-E2E-109`
* **Deskripsi:** UI test untuk skenario `Direct API Owner` pada browser Desktop Chrome.
* **Aktor Utama:** Owner
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-AUTH-009 | JWT Invalid
* **Test Case ID:** `TC-E2E-110`
* **Deskripsi:** UI test untuk skenario `JWT Invalid` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-AUTH-010 | JWT Expired
* **Test Case ID:** `TC-E2E-111`
* **Deskripsi:** UI test untuk skenario `JWT Expired` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-AUTH-011 | Refresh Token
* **Test Case ID:** `TC-E2E-112`
* **Deskripsi:** UI test untuk skenario `Refresh Token` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-AUTH-012 | Logout
* **Test Case ID:** `TC-E2E-113`
* **Deskripsi:** UI test untuk skenario `Logout` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-AUTH-013 | Session Timeout
* **Test Case ID:** `TC-E2E-114`
* **Deskripsi:** UI test untuk skenario `Session Timeout` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-AUTH-014 | Multi Login
* **Test Case ID:** `TC-E2E-115`
* **Deskripsi:** UI test untuk skenario `Multi Login` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-AUTH-015 | Access after Logout
* **Test Case ID:** `TC-E2E-116`
* **Deskripsi:** UI test untuk skenario `Access after Logout` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

## Modul: Admin Dashboard (`07-admin-dashboard.spec.js`)

### TC-ADMDASH-001 | Dashboard Admin tampil
* **Test Case ID:** `TC-E2E-117`
* **Deskripsi:** UI test untuk skenario `Dashboard Admin tampil` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-002 | Widget ringkasan stok tampil
* **Test Case ID:** `TC-E2E-118`
* **Deskripsi:** UI test untuk skenario `Widget ringkasan stok tampil` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-003 | Widget status transaksi admin
* **Test Case ID:** `TC-E2E-119`
* **Deskripsi:** UI test untuk skenario `Widget status transaksi admin` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-004 | Widget notifikasi stok rendah
* **Test Case ID:** `TC-E2E-120`
* **Deskripsi:** UI test untuk skenario `Widget notifikasi stok rendah` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-005 | Grafik kategori produk terlaris
* **Test Case ID:** `TC-E2E-121`
* **Deskripsi:** UI test untuk skenario `Grafik kategori produk terlaris` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-006 | Filter data dashboard admin harian
* **Test Case ID:** `TC-E2E-122`
* **Deskripsi:** UI test untuk skenario `Filter data dashboard admin harian` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-007 | Filter data dashboard admin mingguan
* **Test Case ID:** `TC-E2E-123`
* **Deskripsi:** UI test untuk skenario `Filter data dashboard admin mingguan` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-008 | Filter data dashboard admin bulanan
* **Test Case ID:** `TC-E2E-124`
* **Deskripsi:** UI test untuk skenario `Filter data dashboard admin bulanan` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-009 | Refresh dashboard admin
* **Test Case ID:** `TC-E2E-125`
* **Deskripsi:** UI test untuk skenario `Refresh dashboard admin` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-010 | Keamanan akses unauthorized dashboard admin
* **Test Case ID:** `TC-E2E-126`
* **Deskripsi:** UI test untuk skenario `Keamanan akses unauthorized dashboard admin` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-011 | Indikator loading data widget admin
* **Test Case ID:** `TC-E2E-127`
* **Deskripsi:** UI test untuk skenario `Indikator loading data widget admin` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-012 | Penanganan error data API dashboard admin
* **Test Case ID:** `TC-E2E-128`
* **Deskripsi:** UI test untuk skenario `Penanganan error data API dashboard admin` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-013 | Widget total produk aktif admin
* **Test Case ID:** `TC-E2E-129`
* **Deskripsi:** UI test untuk skenario `Widget total produk aktif admin` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-014 | Widget kategori terpopuler admin
* **Test Case ID:** `TC-E2E-130`
* **Deskripsi:** UI test untuk skenario `Widget kategori terpopuler admin` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-015 | Pengurutan daftar barang kritis di dashboard
* **Test Case ID:** `TC-E2E-131`
* **Deskripsi:** UI test untuk skenario `Pengurutan daftar barang kritis di dashboard` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-016 | Ekspor data ringkasan admin
* **Test Case ID:** `TC-E2E-132`
* **Deskripsi:** UI test untuk skenario `Ekspor data ringkasan admin` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-017 | Peringatan kedaluwarsa produk
* **Test Case ID:** `TC-E2E-133`
* **Deskripsi:** UI test untuk skenario `Peringatan kedaluwarsa produk` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-ADMDASH-018 | Verifikasi sinkronisasi data widget
* **Test Case ID:** `TC-E2E-134`
* **Deskripsi:** UI test untuk skenario `Verifikasi sinkronisasi data widget` pada browser Desktop Chrome.
* **Aktor Utama:** Admin
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

## Modul: Category (`08-category.spec.js`)

### TC-CAT-001 | Tambah Kategori valid
* **Test Case ID:** `TC-E2E-135`
* **Deskripsi:** UI test untuk skenario `Tambah Kategori valid` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CAT-002 | Validasi form kategori kosong
* **Test Case ID:** `TC-E2E-136`
* **Deskripsi:** UI test untuk skenario `Validasi form kategori kosong` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CAT-003 | Update Kategori
* **Test Case ID:** `TC-E2E-137`
* **Deskripsi:** UI test untuk skenario `Update Kategori` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CAT-004 | Hapus Kategori
* **Test Case ID:** `TC-E2E-138`
* **Deskripsi:** UI test untuk skenario `Hapus Kategori` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CAT-005 | Cari Kategori
* **Test Case ID:** `TC-E2E-139`
* **Deskripsi:** UI test untuk skenario `Cari Kategori` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CAT-006 | Duplikat kategori ditolak
* **Test Case ID:** `TC-E2E-140`
* **Deskripsi:** UI test untuk skenario `Duplikat kategori ditolak` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CAT-007 | Filter kategori di produk
* **Test Case ID:** `TC-E2E-141`
* **Deskripsi:** UI test untuk skenario `Filter kategori di produk` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CAT-008 | Input nama kategori terlalu panjang
* **Test Case ID:** `TC-E2E-142`
* **Deskripsi:** UI test untuk skenario `Input nama kategori terlalu panjang` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CAT-009 | Pembatalan hapus kategori
* **Test Case ID:** `TC-E2E-143`
* **Deskripsi:** UI test untuk skenario `Pembatalan hapus kategori` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CAT-010 | Integrasi kategori pada dropdown produk
* **Test Case ID:** `TC-E2E-144`
* **Deskripsi:** UI test untuk skenario `Integrasi kategori pada dropdown produk` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

## Modul: Supplier (`09-supplier.spec.js`)

### TC-SUP-001 | Tambah supplier valid
* **Test Case ID:** `TC-E2E-145`
* **Deskripsi:** UI test untuk skenario `Tambah supplier valid` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-SUP-002 | Validasi form supplier kosong
* **Test Case ID:** `TC-E2E-146`
* **Deskripsi:** UI test untuk skenario `Validasi form supplier kosong` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-SUP-003 | Update supplier
* **Test Case ID:** `TC-E2E-147`
* **Deskripsi:** UI test untuk skenario `Update supplier` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-SUP-004 | Hapus supplier
* **Test Case ID:** `TC-E2E-148`
* **Deskripsi:** UI test untuk skenario `Hapus supplier` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-SUP-005 | Cari supplier
* **Test Case ID:** `TC-E2E-149`
* **Deskripsi:** UI test untuk skenario `Cari supplier` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-SUP-006 | Buat Purchase Order (PO)
* **Test Case ID:** `TC-E2E-150`
* **Deskripsi:** UI test untuk skenario `Buat Purchase Order (PO)` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-SUP-007 | Validasi nominal PO negatif
* **Test Case ID:** `TC-E2E-151`
* **Deskripsi:** UI test untuk skenario `Validasi nominal PO negatif` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-SUP-008 | Konfirmasi PO diterima
* **Test Case ID:** `TC-E2E-152`
* **Deskripsi:** UI test untuk skenario `Konfirmasi PO diterima` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-SUP-009 | Batal Purchase Order
* **Test Case ID:** `TC-E2E-153`
* **Deskripsi:** UI test untuk skenario `Batal Purchase Order` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-SUP-010 | Laporan riwayat transaksi supplier
* **Test Case ID:** `TC-E2E-154`
* **Deskripsi:** UI test untuk skenario `Laporan riwayat transaksi supplier` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

## Modul: Customer (`10-customer.spec.js`)

### TC-CUST-001 | Registrasi pelanggan baru
* **Test Case ID:** `TC-E2E-155`
* **Deskripsi:** UI test untuk skenario `Registrasi pelanggan baru` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CUST-002 | Validasi form pelanggan kosong
* **Test Case ID:** `TC-E2E-156`
* **Deskripsi:** UI test untuk skenario `Validasi form pelanggan kosong` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CUST-003 | Update profil pelanggan
* **Test Case ID:** `TC-E2E-157`
* **Deskripsi:** UI test untuk skenario `Update profil pelanggan` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CUST-004 | Hapus pelanggan
* **Test Case ID:** `TC-E2E-158`
* **Deskripsi:** UI test untuk skenario `Hapus pelanggan` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CUST-005 | Cari pelanggan
* **Test Case ID:** `TC-E2E-159`
* **Deskripsi:** UI test untuk skenario `Cari pelanggan` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CUST-006 | Upgrade status member
* **Test Case ID:** `TC-E2E-160`
* **Deskripsi:** UI test untuk skenario `Upgrade status member` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CUST-007 | Downgrade/batal member
* **Test Case ID:** `TC-E2E-161`
* **Deskripsi:** UI test untuk skenario `Downgrade/batal member` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CUST-008 | Integrasi diskon member di POS
* **Test Case ID:** `TC-E2E-162`
* **Deskripsi:** UI test untuk skenario `Integrasi diskon member di POS` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CUST-009 | Verifikasi nomor kartu member
* **Test Case ID:** `TC-E2E-163`
* **Deskripsi:** UI test untuk skenario `Verifikasi nomor kartu member` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CUST-010 | Penanganan duplikat email pelanggan
* **Test Case ID:** `TC-E2E-164`
* **Deskripsi:** UI test untuk skenario `Penanganan duplikat email pelanggan` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CUST-011 | Laporan riwayat transaksi pelanggan
* **Test Case ID:** `TC-E2E-165`
* **Deskripsi:** UI test untuk skenario `Laporan riwayat transaksi pelanggan` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

### TC-CUST-012 | Poin loyalitas member
* **Test Case ID:** `TC-E2E-166`
* **Deskripsi:** UI test untuk skenario `Poin loyalitas member` pada browser Desktop Chrome.
* **Aktor Utama:** Kasir / Staf
* **Prasyarat (Pre-conditions):**
  * Aplikasi Flutter Web sedang berjalan di `http://localhost:8080` dan koneksi backend terhubung.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Tombol | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Buka halaman / menu modul terkait. | `Navigasi ke menu` | Halaman modul ditampilkan. |
| 2 | Lakukan interaksi UI sesuai dengan skenario. | `Klik filter / isi form / ekspor data` | Sistem memproses aksi. |
| 3 | Verifikasi perubahan data secara visual pada layar web. | `-` | Data terupdate secara real-time. |

* **Kondisi Pasca-tes (Post-conditions):** Halaman web berada pada kondisi stabil dan database sinkron dengan state UI.

---

