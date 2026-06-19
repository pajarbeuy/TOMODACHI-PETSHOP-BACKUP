# Flutter Prompt: Layout Responsif Mobile — Tomodachi Pet Shop AI Asisten

## Konteks Fitur
Halaman **AI Asisten** di aplikasi Tomodachi Pet Shop saat ini memiliki layout web (desktop) dengan panel **Analisis Restock** di sisi kanan layar. Di tampilan **mobile**, panel Analisis Restock harus dipindahkan ke bawah area header Tommi AI Assistant dan disusun secara **vertikal (scrollable)**.

---

## Prompt untuk Flutter Developer

```
Buat widget Flutter untuk halaman AI Asisten pada aplikasi Tomodachi Pet Shop dengan ketentuan layout responsif berikut:

### Struktur Layout

**Desktop/Tablet (lebar layar >= 768px):**
- Gunakan Row sebagai container utama
- Kolom kiri (flex: 2): Area chat Tommi AI Assistant (header + bubble percakapan + input field)
- Kolom kanan (lebar tetap 320px): Panel Analisis Restock (scrollable vertikal secara independen)

**Mobile (lebar layar < 768px):**
- Gunakan Column sebagai container utama di dalam SingleChildScrollView
- Urutan dari atas ke bawah:
  1. Header Tommi AI Assistant (nama, status "Online • Powered by OpenRouter", tombol Restock & Reset)
  2. Panel Analisis Restock (tampil penuh lebar, TIDAK collapsed/hidden)
  3. Area chat (bubble percakapan)
  4. Input field "Tanya seputar inventaris..." (sticky di bagian bawah layar)

### Deteksi Responsif
Gunakan LayoutBuilder atau MediaQuery.of(context).size.width untuk mendeteksi breakpoint.

Contoh:
\`\`\`dart
LayoutBuilder(
  builder: (context, constraints) {
    final isMobile = constraints.maxWidth < 768;
    return isMobile ? _buildMobileLayout() : _buildDesktopLayout();
  },
)
\`\`\`

### Widget Struktur Mobile (_buildMobileLayout)

\`\`\`dart
Widget _buildMobileLayout() {
  return Scaffold(
    backgroundColor: const Color(0xFF1A1A2E),
    body: Column(
      children: [
        // 1. Header Tommi AI Assistant
        _buildChatHeader(),

        // 2. Panel Analisis Restock (vertikal, full width)
        _buildRestockAnalysisPanel(),

        // 3. Area percakapan (scrollable)
        Expanded(
          child: _buildChatMessages(),
        ),

        // 4. Input field sticky di bawah
        _buildChatInput(),
      ],
    ),
  );
}
\`\`\`

### Widget: _buildChatHeader
- Row berisi:
  - Avatar ikon Tommi (lingkaran oranye dengan paw print)
  - Column: teks "Tommi AI Assistant" (bold putih) + status "Online • Powered by OpenRouter" (hijau + abu)
  - Spacer
  - Tombol "Restock" (outlined, ikon box)
  - Tombol "Reset" (outlined, ikon refresh)

### Widget: _buildRestockAnalysisPanel (Mobile)
- Container dengan background #252540, padding 16, border-radius 12
- Header: Row ikon 📊 + teks "Analisis Restock" (putih bold) + ikon ✕
- Kartu ringkasan: Row dua kartu:
  - Kartu kiri (background coklat gelap): ikon ⚠️ oranye + angka + label "Perlu Restock"
  - Kartu kanan (background hijau gelap): ikon ✅ hijau + angka + label "Stok Aman"
- Section "Harus Direstock": daftar produk dengan badge RESTOCK oranye
- Section "Stok Aman": daftar produk dengan badge SAFE hijau
- Setiap item produk menampilkan: nama produk, SKU, Kategori, Stok saat ini, Rata-rata jual/hari, Perkiraan kebutuhan 7 hari

### Widget: _buildRestockItem (per item produk)
\`\`\`dart
Widget _buildRestockItem({
  required String nama,
  required String sku,
  required String kategori,
  required String stok,
  required String rataJual,
  required String perkiraan,
  required bool perluRestock,
}) {
  // Card dengan background #2E2E4E
  // Badge status di pojok kanan atas
  // Grid 2 kolom untuk detail info
}
\`\`\`

### Styling & Tema
- Background utama: #1A1A2E (navy gelap)
- Surface card: #252540
- Aksen utama: #FF8C00 (oranye Tomodachi)
- Teks utama: #FFFFFF
- Teks sekunder: #9999BB
- Warna warning/restock: #FF6B35 dengan background #3D2010
- Warna safe/aman: #22C55E dengan background #0D2E1A
- Font: gunakan Google Fonts 'Inter' atau system default
- Border radius umum: 12px pada card, 8px pada badge

### State Management
- Gunakan StatefulWidget atau Provider/Riverpod untuk:
  - List pesan chat (messages)
  - Data produk restock (dari API atau mock data)
  - Status loading saat fetch data AI
  - Visibility panel restock (bisa di-toggle via tombol ✕)

### Animasi Panel Restock (Mobile)
Tambahkan AnimatedContainer atau SizeTransition agar panel Analisis Restock bisa:
- Expand/collapse ketika user tap header panel
- Default state: expanded (tampil penuh)
- Durasi animasi: 300ms dengan Curves.easeInOut

### Input Field (Sticky Bottom)
\`\`\`dart
Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  color: const Color(0xFF1A1A2E),
  child: Row(
    children: [
      Expanded(
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Tanya seputar inventaris...',
            filled: true,
            fillColor: Color(0xFF252540),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      FloatingActionButton.small(
        onPressed: _sendMessage,
        backgroundColor: Color(0xFF FF8C00),
        child: const Icon(Icons.send, color: Colors.white),
      ),
    ],
  ),
)
\`\`\`

### Dependensi pubspec.yaml yang dibutuhkan
\`\`\`yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0       # Untuk font Inter
  provider: ^6.1.1           # State management (opsional)
  http: ^1.1.0               # Untuk API call ke AI
\`\`\`
```

---

## Catatan Tambahan
- Panel Analisis Restock di mobile **tidak** perlu di-hide. Tampilkan langsung di bawah header.
- Gunakan `SingleChildScrollView` + `Column` untuk mobile agar seluruh konten (header + panel + chat) bisa di-scroll jika overflow.
- Input field sebaiknya menggunakan `SafeArea` di bawah agar tidak tertutup keyboard atau notch.
- Pertimbangkan `resizeToAvoidBottomInset: true` di Scaffold agar keyboard tidak menimpa input.