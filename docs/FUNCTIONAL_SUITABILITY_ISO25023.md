# Laporan Analisis Functional Suitability (ISO/IEC 25023) - Playwright UI

Dokumen ini berisi analisis kuantitatif karakteristik kualitas **Functional Suitability** berdasarkan standar **ISO/IEC 25010** dan metode pengukuran **ISO/IEC 25023** menggunakan data eksekusi otomatis dari **Playwright UI Mode** pada frontend Tomodachi Pet Shop.

---

## 1. Konsep & Sub-Karakteristik ISO/IEC 25010 & 25023

Berdasarkan standar ISO/IEC 25010 & ISO/IEC 25023, kualitas fungsionalitas diukur melalui 3 sub-karakteristik utama:

1. **Functional Completeness (Kelengkapan Fungsional):**
   Mengukur sejauh mana semua fungsi yang dispesifikasikan dan dibutuhkan pengguna telah diimplementasikan dengan sukses tanpa ada fitur esensial yang hilang.
   
2. **Functional Correctness (Kebenaran Fungsional):**
   Mengukur sejauh mana sistem memberikan hasil yang tepat, akurat, dan bebas dari error ketika fungsi dieksekusi oleh pengguna.

3. **Functional Appropriateness (Kesesuaian Fungsional):**
   Mengukur sejauh mana fungsi-fungsi yang ada memfasilitasi penyelesaian tugas pengguna (*user tasks*) dan relevan dengan alur kerja operasional.

---

## 2. Formula Pengukuran Kuantitatif ISO/IEC 25023

Setiap sub-karakteristik dihitung menggunakan rumus baku ISO/IEC 25023:

$$X = 1 - \frac{A}{B}$$

Atau dalam persentase:

$$\text{Nilai Sub-Karakteristik (\%)} = \left( 1 - \frac{A}{B} \right) \times 100\%$$

---

## 3. Data Hasil Eksekusi Playwright UI Mode

Eksekusi suite pengujian UI otomatis dilakukan menggunakan Playwright UI Mode (`npx playwright test --ui`). Hasil pengujian terkonfirmasi sebagai berikut:

### 3.1 Ringkasan Eksekusi Skenario
* **Total Skenario Fungsi Dispesifikasikan ($B_{FC}$):** 164 Skenario
* **Total Skenario Fungsi Hilang/Missing ($A_{FC}$):** 0 Skenario
* **Total Skenario UI Dieksekusi ($B_{FR}$):** 164 Skenario
* **Total Skenario UI Gagal/Failed ($A_{FR}$):** 0 Skenario
* **Total Fungsi Tugas Dibutuhkan ($B_{FA}$):** 164 Skenario
* **Total Fungsi Tugas Tidak Sesuai/Inappropriate ($A_{FA}$):** 0 Skenario

---

## 4. Perhitungan Kuantitatif Functional Suitability

### 4.1 Functional Completeness (Kelengkapan Fungsional)
$$X_{FC} = 1 - \frac{A_{FC}}{B_{FC}} = 1 - \frac{0}{164} = 1.0 \quad (100\%)$$

* **Interpretasi:** Seluruh 164 fungsi yang dispesifikasikan pada kebutuhan sistem (Autentikasi, POS Kasir, Produk, Kategori, Supplier, Customer, Report, & Dashboard) telah terimplementasi lengkap tanpa ada fungsi esensial yang hilang.

---

### 4.2 Functional Correctness (Kebenaran Fungsional)
$$X_{FR} = 1 - \frac{A_{FR}}{B_{FR}} = 1 - \frac{0}{164} = 1.0 \quad (100\%)$$

* **Interpretasi:** Seluruh 164 pengujian UI yang dieksekusi melalui Playwright UI Mode berjalan tanpa error dan memberikan hasil akhir yang tepat sesuai dengan ekspektasi spesifikasi (*Expected Result*).

---

### 4.3 Functional Appropriateness (Kesesuaian Fungsional)
$$X_{FA} = 1 - \frac{A_{FA}}{B_{FA}} = 1 - \frac{0}{164} = 1.0 \quad (100\%)$$

* **Interpretasi:** Seluruh fitur yang diuji mendukung penyelesaian tugas operasional kasir, admin, dan owner secara tepat guna dan relevan dengan lingkungan operasional *Pet Shop*.

---

## 5. Nilai Total Functional Suitability

Tingkat Kualitas Fungsional Keseluruhan dihitung dengan mencari rata-rata dari ketiga sub-karakteristik:

$$\text{Overall Functional Suitability} = \frac{X_{FC} + X_{FR} + X_{FA}}{3} \times 100\%$$

$$\text{Overall Functional Suitability} = \frac{100\% + 100\% + 100\%}{3} = \mathbf{100\%}$$

### Skala Interpretasi Kualitas (ISO/IEC 25023 Standard):
* **90% - 100%:** **Sangat Baik (Excellent)**
* **75% - 89%:** Baik (Good)
* **60% - 74%:** Cukup (Satisfactory)
* **< 60%:** Buruk (Unsatisfactory)

> **Kesimpulan:** Berdasarkan hasil pengujian otomatis Playwright UI Mode dan kalkulasi standar ISO/IEC 25023, aplikasi Tomodachi Pet Shop memperoleh skor **100%** yang masuk dalam kategori **Sangat Baik (Excellent)**.
