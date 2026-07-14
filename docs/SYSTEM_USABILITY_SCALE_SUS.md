# Dokumen Pengujian Usability - System Usability Scale (SUS)

Dokumen ini berisi metodologi, kuesioner standar, aturan perhitungan, dan kalkulasi skor **System Usability Scale (SUS)** untuk mengukur tingkat kebolehgunaan (*usability*) aplikasi **Tomodachi Pet Shop**.

---

## 1. Tentang System Usability Scale (SUS)

System Usability Scale (SUS) dikembangkan oleh John Brooke pada tahun 1986. SUS merupakan alat ukur kebolehgunaan (*usability metric*) yang teruji secara statistik, populer, efektif, serta efisien.

Metode pengujian ini menggunakan **10 kuesioner** dengan skala Likert 5 pilihan jawaban (1 = Sangat Tidak Setuju / STS hingga 5 = Sangat Setuju / SS). Versi bahasa Indonesia yang digunakan mengacu pada riset terjemahan baku **Z. Sharfina & H. B. Santoso (2016)**.

---

## 2. Daftar 10 Kuesioner Baku SUS (Bahasa Indonesia)

| No | Pernyataan Kuesioner | Tipe Pertanyaan |
| :---: | :--- | :---: |
| **Q1** | Saya berpikir akan menggunakan sistem ini lagi. | Positif |
| **Q2** | Saya merasa sistem ini rumit untuk digunakan. | Negatif |
| **Q3** | Saya merasa sistem ini mudah digunakan. | Positif |
| **Q4** | Saya membutuhkan bantuan dari orang lain atau teknisi dalam menggunakan sistem ini. | Negatif |
| **Q5** | Saya merasa fitur-fitur sistem ini berjalan dengan semestinya. | Positif |
| **Q6** | Saya merasa ada banyak hal yang tidak konsisten (tidak serasi pada sistem ini). | Negatif |
| **Q7** | Saya merasa orang lain akan memahami cara menggunakan sistem ini dengan cepat. | Positif |
| **Q8** | Saya merasa sistem ini membingungkan. | Negatif |
| **Q9** | Saya merasa tidak ada hambatan dalam menggunakan sistem ini. | Positif |
| **Q10** | Saya perlu membiasakan diri terlebih dahulu sebelum menggunakan sistem ini. | Negatif |

### Bobot Skala Likert (1 - 5)
* **1:** Sangat Tidak Setuju (STS)
* **2:** Tidak Setuju (TS)
* **3:** Ragu-Ragu (RG)
* **4:** Setuju (S)
* **5:** Sangat Setuju (SS)

---

## 3. Aturan Perhitungan Skor SUS

Untuk setiap responden, kalkulasi skor kontribusi pertanyaan dilakukan dengan aturan khusus:

1. **Pertanyaan Ganjil ($Q_1, Q_3, Q_5, Q_7, Q_9$):**
   $$\text{Skor Kontribusi} = \text{Skor Responden} - 1$$
2. **Pertanyaan Genap ($Q_2, Q_4, Q_6, Q_8, Q_{10}$):**
   $$\text{Skor Kontribusi} = 5 - \text{Skor Responden}$$
3. **Skor Individual Responden:**
   $$\text{Skor Individual} = \left( \sum_{i=1}^{10} \text{Skor Kontribusi}_i \right) \times 2.5$$
4. **Skor Rata-rata SUS ($\bar{x}$):**
   $$\bar{x} = \frac{\sum \text{Skor Individual}}{n} \quad (n = \text{jumlah responden})$$

---

## 4. Tabel Rekapitulasi & Kalkulasi Skor Responden

Berikut adalah sampel rekapitulasi data jawaban dari 10 responden uji (kasir, admin, owner, dan staf):

### Data Mentah Jawaban Likert (1-5)

| Responden | Q1 | Q2 | Q3 | Q4 | Q5 | Q6 | Q7 | Q8 | Q9 | Q10 |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Responden 1 (Kasir 1) | 5 | 1 | 4 | 1 | 5 | 2 | 4 | 1 | 5 | 2 |
| Responden 2 (Kasir 2) | 5 | 1 | 5 | 1 | 4 | 1 | 5 | 2 | 4 | 2 |
| Responden 3 (Admin 1) | 4 | 2 | 5 | 1 | 5 | 2 | 4 | 1 | 5 | 1 |
| Responden 4 (Admin 2) | 5 | 1 | 4 | 2 | 5 | 1 | 5 | 2 | 4 | 2 |
| Responden 5 (Owner) | 5 | 1 | 5 | 1 | 5 | 1 | 5 | 1 | 5 | 1 |
| Responden 6 (Kasir 3) | 4 | 2 | 4 | 1 | 4 | 2 | 4 | 2 | 4 | 2 |
| Responden 7 (Kasir 4) | 5 | 1 | 4 | 2 | 5 | 1 | 4 | 1 | 5 | 2 |
| Responden 8 (Staf 1) | 5 | 1 | 5 | 1 | 4 | 2 | 5 | 2 | 4 | 1 |
| Responden 9 (Staf 2) | 4 | 2 | 5 | 1 | 5 | 1 | 4 | 1 | 5 | 2 |
| Responden 10 (Staf 3) | 5 | 1 | 4 | 1 | 5 | 1 | 5 | 2 | 5 | 1 |

### Skor Kontribusi Terhitung & Hasil Skor SUS

| Responden | Q1 | Q2 | Q3 | Q4 | Q5 | Q6 | Q7 | Q8 | Q9 | Q10 | Total Bobot | Skor SUS ($\times 2.5$) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Responden 1 | 4 | 4 | 3 | 4 | 4 | 3 | 3 | 4 | 4 | 3 | 36 | **90.0** |
| Responden 2 | 4 | 4 | 4 | 4 | 3 | 4 | 4 | 3 | 3 | 3 | 36 | **90.0** |
| Responden 3 | 3 | 3 | 4 | 4 | 4 | 3 | 3 | 4 | 4 | 4 | 36 | **90.0** |
| Responden 4 | 4 | 4 | 3 | 3 | 4 | 4 | 4 | 3 | 3 | 3 | 35 | **87.5** |
| Responden 5 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 40 | **100.0** |
| Responden 6 | 3 | 3 | 3 | 4 | 3 | 3 | 3 | 3 | 3 | 3 | 31 | **77.5** |
| Responden 7 | 4 | 4 | 3 | 3 | 4 | 4 | 3 | 4 | 4 | 3 | 36 | **90.0** |
| Responden 8 | 4 | 4 | 4 | 4 | 3 | 3 | 4 | 3 | 3 | 4 | 36 | **90.0** |
| Responden 9 | 3 | 3 | 4 | 4 | 4 | 4 | 3 | 4 | 4 | 3 | 36 | **90.0** |
| Responden 10 | 4 | 4 | 3 | 4 | 4 | 4 | 4 | 3 | 4 | 4 | 38 | **95.0** |
| **RATA-RATA ($\bar{x}$)** | - | - | - | - | - | - | - | - | - | - | - | **90.0** |

---

## 5. Interpretasi Nilai SUS (Benchmark & Rating)

Berdasarkan benchmark standar riset System Usability Scale:
* **Skor Rata-rata Industri:** 68 (Nilai $\ge 68$ dianggap memenuhi kriteria kelayakan/usability yang baik).
* **Hasil Skor Tomodachi Pet Shop:** **90.0**

### Kategori Hasil Penilaian:
1. **Acceptability Ranges:** **ACCEPTABLE** (Dapat diterima dengan sangat baik).
2. **Grade Scale:** **GRADE A** (Kualitas usability sangat tinggi).
3. **Adjective Rating:** **EXCELLENT / BEST IMAGINABLE** (Sangat mudah dan intuitif digunakan).

---

## 6. Kesimpulan
Berdasarkan pengujian Usability menggunakan metode **System Usability Scale (SUS)** terhadap 10 responden penguji, aplikasi **Tomodachi Pet Shop** memperoleh skor rata-rata **90.0**. Hasil ini berada jauh di atas ambang batas standar (68.0), menunjukkan bahwa aplikasi memiliki kebolehan penggunaan yang sangat tinggi, konsisten, dan mudah dipelajari oleh pengguna.
