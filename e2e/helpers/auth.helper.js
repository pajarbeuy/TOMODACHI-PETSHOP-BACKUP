// helpers/auth.helper.js
// Reusable helper untuk login & navigasi di Tomodachi Pet Shop

const BASE_URL = 'http://localhost:8080';
const API_URL  = 'http://localhost:8000';

/**
 * Credentials yang tersedia di aplikasi.
 * Sesuai dengan _demoRoles di login_screen.dart
 */
const CREDENTIALS = {
  admin: {
    email: 'admin@tomodachi.com',
    password: 'password123',
    role: 'admin',
    name: 'Admin',
  },
  kasir: {
    email: 'kasir@tomodachi.com',
    password: 'password123',
    role: 'kasir',
    name: 'Kasir',
  },
  owner: {
    email: 'owner@tomodachi.com',
    password: 'password123',
    role: 'owner',
    name: 'Owner',
  },
};

/**
 * Tunggu hingga Flutter Web selesai di-load (canvas atau konten UI muncul).
 * Flutter Web membutuhkan waktu lebih lama dari SPA biasa.
 *
 * @param {import('@playwright/test').Page} page
 */
async function waitForFlutterApp(page) {
  // Tunggu hingga halaman tidak dalam loading state
  await page.waitForLoadState('networkidle', { timeout: 30_000 });

  // Tunggu engine canvas atau semantics flutter terbentuk
  await page.waitForSelector('flt-glass-pane', { timeout: 30_000 }).catch(() => {});
  await page.waitForTimeout(3000); // Beri jeda animasi / fetching api
}

/**
 * Ambil captcha challenge dari backend (untuk dilewati — karena bypass aktif,
 * kita tetap perlu memanggil endpoint ini untuk mendapat captcha_key).
 *
 * @returns {{ key: string, question: string }}
 */
async function fetchCaptchaChallenge() {
  const response = await fetch(`${API_URL}/api/auth/captcha`);
  const json = await response.json();
  if (!json.status) throw new Error('Gagal fetch captcha: ' + JSON.stringify(json));
  return {
    key: json.data.captcha_key,
    question: json.data.question,
  };
}

/**
 * Selesaikan soal captcha matematis sederhana (format: "a + b").
 * Digunakan jika CAPTCHA_BYPASS_TESTING=false (mode non-bypass).
 *
 * @param {string} question  Contoh: "3 + 5"
 * @returns {string}         Jawaban: "8"
 */
function solveCaptcha(question) {
  const parts = question.split('+');
  if (parts.length !== 2) return '0';
  const left  = parseInt(parts[0].trim(), 10) || 0;
  const right = parseInt(parts[1].trim(), 10) || 0;
  return String(left + right);
}

/**
 * Login melalui UI Flutter Web.
 * Mengisi form email, password, dan captcha, lalu klik Sign In.
 *
 * @param {import('@playwright/test').Page} page
 * @param {{ email: string, password: string }} credentials
 */
/**
 * Robust helper untuk mengisi input di Flutter Web dengan simulasi keyboard.
 * Flutter Web CanvasKit membutuhkan focus dan key events asli agar tersinkronisasi.
 */
async function fillFlutterInput(page, locator, text) {
  await locator.waitFor({ state: 'attached', timeout: 15_000 });
  await locator.click({ force: true });
  await page.waitForTimeout(300);
  // Select all & delete untuk membersihkan input sebelumnya
  await page.keyboard.press('Control+A');
  await page.keyboard.press('Backspace');
  await page.waitForTimeout(100);
  await page.keyboard.type(text, { delay: 50 });
  await page.waitForTimeout(300);
}

async function loginViaUI(page, { email, password }) {
  await page.goto(BASE_URL, { waitUntil: 'domcontentloaded' });
  await waitForFlutterApp(page);

  // Isi email (tunggu hingga 30 detik untuk loading awal flutter)
  const emailField = page.locator('input[aria-label*="you@example.com" i], input[aria-label*="Email" i]').first();
  await emailField.waitFor({ state: 'attached', timeout: 30_000 });
  await fillFlutterInput(page, emailField, email);

  // Isi password
  const passwordField = page.locator('input[aria-label*="password" i]').first();
  await fillFlutterInput(page, passwordField, password);

  // Ambil captcha langsung dari aria-label input di screen
  const captchaField = page.locator('input[aria-label*="Answer:" i], input[aria-label*="Captcha" i]').first();
  await captchaField.waitFor({ state: 'visible', timeout: 15_000 });
  
  const ariaLabel = await captchaField.getAttribute('aria-label');
  let answer = '0';
  if (ariaLabel) {
    const match = ariaLabel.match(/Answer:\s*(\d+)\s*\+\s*(\d+)/i);
    if (match) {
      const left = parseInt(match[1], 10);
      const right = parseInt(match[2], 10);
      answer = String(left + right);
    }
  }
  
  // Isi captcha
  await fillFlutterInput(page, captchaField, answer);

  // Klik tombol Sign In
  const signInBtn = page.locator('flt-semantics[role="button"]', { hasText: 'Sign In' }).first();
  await signInBtn.click();

  // Tunggu masuk ke layar berikutnya (bisa berupa POS Kasir, Dasbor, dll)
  const homeScreenElement = page.locator('flt-semantics', { hasText: 'POS Kasir' })
    .or(page.locator('flt-semantics', { hasText: 'Dasbor' }))
    .or(page.locator('flt-semantics', { hasText: 'Manajemen Produk' }));
  await homeScreenElement.first().waitFor({ state: 'attached', timeout: 30_000 });
}

/**
 * Login via API langsung (lebih cepat, untuk test yang tidak perlu test UI login).
 * Mengembalikan token Bearer.
 *
 * @param {{ email: string, password: string }} credentials
 * @returns {Promise<string>} auth token
 */
async function loginViaAPI({ email, password }) {
  // 1. Ambil captcha challenge
  const captchaRes = await fetch(`${API_URL}/api/auth/captcha`);
  const captchaJson = await captchaRes.json();
  const captchaKey  = captchaJson.data.captcha_key;
  const answer      = solveCaptcha(captchaJson.data.question);

  // 2. Login
  const loginRes = await fetch(`${API_URL}/api/auth/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
    body: JSON.stringify({
      email,
      password,
      captcha_key: captchaKey,
      captcha_answer: answer,
    }),
  });

  const loginJson = await loginRes.json();
  if (!loginJson.status) {
    throw new Error('Login API gagal: ' + JSON.stringify(loginJson));
  }

  return loginJson.data.token;
}

/**
 * Logout dari UI (klik ikon logout di AppBar).
 *
 * @param {import('@playwright/test').Page} page
 */
async function logoutViaUI(page) {
  // Klik tombol/ikon logout
  const logoutBtn = page.getByRole('button', { name: /logout/i });
  if (await logoutBtn.isVisible()) {
    await logoutBtn.click();
  }
  // Tunggu kembali ke halaman login
  await page.waitForFunction(
    () => document.body.innerText.includes('Welcome back') || document.body.innerText.includes('Sign In'),
    { timeout: 20_000 }
  );
}

module.exports = {
  CREDENTIALS,
  BASE_URL,
  API_URL,
  waitForFlutterApp,
  fetchCaptchaChallenge,
  solveCaptcha,
  loginViaUI,
  loginViaAPI,
  logoutViaUI,
  fillFlutterInput,
};
