// playwright.config.js
// Konfigurasi utama Playwright untuk Tomodachi Pet Shop E2E Tests

const { defineConfig, devices } = require('@playwright/test');

module.exports = defineConfig({
  // Direktori tempat test files berada
  testDir: './tests',

  // Timeout per test (60 detik — cukup untuk Flutter Web yang membutuhkan
  // waktu load lebih lama dari SPA biasa)
  timeout: 60_000,

  // Timeout untuk assertion (expect)
  expect: {
    timeout: 15_000,
  },

  // Jalankan test secara sequential (bukan parallel) untuk menghindari
  // konflik session di browser yang sama
  fullyParallel: false,
  workers: 1,

  // Retry test yang gagal (1x) untuk mengatasi flakiness karena network
  retries: 1,

  // Reporter — keduanya aktif: list di terminal + HTML report
  reporter: [
    ['list'],
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
  ],

  // Konfigurasi shared untuk semua project browser
  use: {
    // URL Flutter Web (jalankan: flutter run -d chrome --web-port 8080)
    baseURL: 'http://localhost:8080',

    // Screenshot hanya saat gagal
    screenshot: 'only-on-failure',

    // Video hanya saat gagal
    video: 'retain-on-failure',

    // Trace saat retry (berguna untuk debug)
    trace: 'on-first-retry',

    // Viewport default 1280x720
    viewport: { width: 1280, height: 720 },

    // Tambahkan sedikit jeda natural agar test tidak terlalu cepat
    // (opsional, hapus jika tidak perlu)
    actionTimeout: 15_000,
    navigationTimeout: 30_000,
  },

  // Konfigurasi per-browser
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    // Uncomment untuk test di Firefox:
    // {
    //   name: 'firefox',
    //   use: { ...devices['Desktop Firefox'] },
    // },
  ],

  // Output folder untuk artifacts (screenshot, video, trace)
  outputDir: 'test-results/',
});
