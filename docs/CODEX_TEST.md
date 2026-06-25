Test-03 Pengujian endpoint POS — transaksi, validasi stok, dan struk digital

Test case untuk alur transaksi kasir secara menyeluruh: membuat transaksi baru, validasi stok, format ID transaksi, perhitungan kembalian, dan pengambilan data struk digital. Langkah Pengujian
GET /api/products?channel=offline&in_stock=true → cek hanya produk stok > 0 POST /api/transactions dengan stok produk cukup POST /api/transactions dengan qty melebihi stok yang tersedia Cek format ID transaksi pada response Cek stok produk berkurang di database setelah transaksi GET /api/transactions/{id}/receipt → cek semua field struk

[TEST-04] Pengujian endpoint dashboard dan laporan penjualan

Test case untuk semua endpoint laporan dan analitik: KPI dashboard, tren penjualan per periode, produk terlaris, filter laporan berdasarkan tanggal/kanal/kategori, dan perbandingan penjualan per kategori hewan. Langkah Pengujian
GET /api/dashboard/analytics → cek 4 KPI ada GET /api/reports/sales/summary?period=7d → cek data 7 hari terakhir GET /api/reports/sales/summary?period=30d dan ?period=90d GET /api/reports/top-products → cek 10 produk teratas GET /api/reports/sales?from=YYYY-MM-DD&to=YYYY-MM-DD → cek filter tanggal GET /api/reports/sales?channel=offline → cek hanya transaksi offline Cek akses endpoint laporan oleh role kasir → harus ditolak

[TEST-05] Pengujian performa API — response time dan beban 50 req/detik

Uji waktu respons API untuk operasi CRUD biasa (maks 2 detik) dan endpoint halaman POS (maks 3 detik). Simulasikan beban 50 request/detik menggunakan Apache JMeter atau k6 untuk memastikan tidak ada degradasi performa. Langkah Pengujian
Ukur response time GET/POST/PUT/DELETE endpoint CRUD pada koneksi normal Ukur response time GET /api/products (endpoint POS) Jalankan load test 50 req/detik selama minimal 1 menit menggunakan k6 atau JMeter Masukkan 10.000+ record transaksi dummy ke database, ulangi pengujian query

[TEST-06] Pengujian keamanan — HTTPS, bcrypt, rate limiting, SQL injection, XSS 

Verifikasi seluruh implementasi keamanan sistem: HTTPS enforced, password di-hash bcrypt, token expiry sesuai role, rate limiting login, proteksi SQL injection dan XSS pada semua input user. Langkah Pengujian
Akses http://[domain] (tanpa S) → cek redirect ke HTTPS Cek kolom password di tabel users → harus hash bcrypt, bukan plaintext Login sebagai kasir → tunggu 24 jam atau manipulasi waktu, cek token expired POST /api/auth/login lebih dari 5x dalam 1 menit → cek 429 Kirim payload ' OR 1=1 -- ke field input → cek database tidak terpengaruh Kirim <script>alert(1)</script> ke field nama produk → cek tidak dieksekusi

[TEST-07] Pengujian Flutter — alur login sampai transaksi POS end-to-end

Pengujian manual end-to-end di device Android dan iOS: mulai dari login, navigasi dashboard, tambah produk, transaksi POS, melihat struk, hingga logout. Dokumentasikan dengan screenshot atau rekaman layar. Langkah Pengujian
Buka aplikasi → tampil halaman login Login dengan akun kasir valid → redirect ke dashboard Navigasi ke tab Produk → cek daftar produk tampil Tambah produk baru → cek muncul di daftar Navigasi ke tab POS → pilih produk, atur qty, input nominal bayar Tekan Bayar → cek struk digital tampil Logout → cek redirect ke halaman login

[TEST-08] Pengujian navigasi Flutter — Bottom Navigation Bar dan UI 

Verifikasi navigasi utama aplikasi Flutter: 3 tab Bottom Navigation Bar (Dashboard, Produk, POS), loading indicator saat menunggu respons API, dan pesan error yang tepat via SnackBar atau Dialog. Langkah Pengujian
Tap tab Dashboard → halaman dashboard tampil Tap tab Produk → halaman daftar produk tampil Tap tab POS → halaman kasir tampil Matikan internet sementara → buka halaman → cek loading dan pesan error Cek POS: ada grid produk, keranjang, dan form pembayaran

[TEST-09] Pengujian RBAC Flutter — pembatasan fitur berdasarkan role

Verifikasi bahwa tampilan UI Flutter berubah sesuai role pengguna yang login: kasir tidak melihat laporan dan margin, owner melihat semua fitur, dan admin hanya bisa rekonsiliasi stok. Langkah Pengujian
Login sebagai kasir → cek menu yang tersedia Login sebagai owner → cek semua menu tersedia Login sebagai admin → cek menu yang tersedia Sebagai kasir, coba akses endpoint laporan langsung → cek error ditangani di UI

[TEST-10] Pengujian dashboard Flutter — grafik dan filter periode

Verifikasi tampilan halaman dashboard Flutter: KPI cards, line chart tren penjualan menggunakan fl_chart, daftar produk terlaris, dan toggle filter periode (7/30/90 hari) berfungsi dengan benar. Langkah Pengujian
Buka halaman Dashboard → cek 4 KPI cards tampil dengan angka Cek line chart tren penjualan tampil Toggle filter 7 hari → 30 hari → 3 bulan → cek grafik berubah Scroll ke bawah → cek daftar 10 produk terlaris tampil

[TEST-11] Pengujian backup database otomatis setiap 24 jam

Verifikasi bahwa backup database MySQL berjalan otomatis setiap 24 jam dan file backup dapat digunakan untuk proses restore data yang berhasil. Langkah Pengujian
Cek konfigurasi cron job di VPS → pastikan jadwal backup 24 jam Trigger backup manual untuk verifikasi Cek file backup tersimpan di direktori yang benar Lakukan restore dari file backup ke database test Verifikasi data hasil restore konsisten

[TEST-12] Pengujian format response JSON standar semua endpoint

Verifikasi bahwa semua endpoint API selalu menggunakan format response standar yang telah ditetapkan di SRS: { "status": true/false, "message": "...", "data": {...} } dengan Content-Type application/json. Langkah Pengujian
Hit setiap endpoint → cek struktur response Trigger error (404, 422, 401, 500) → cek format response tetap standar Cek header Content-Type di setiap response

[TEST-13] Dokumentasi hasil pengujian dan bug report
Buat laporan pengujian lengkap yang mencakup semua test case yang dijalankan, hasil (pass/fail), bug yang ditemukan, dan status perbaikan. Simpan di folder /docs/test-reports/ di repository GitHub.Format LaporanSetiap test case memiliki kolom: ID | Deskripsi | Langkah | Expected Result | Actual Result | Status (Pass/Fail)