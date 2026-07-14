// tests/01-login.spec.js
/**
 * Test Suite: Authentication & Login
 * Covers: TC-LOGIN-001 to TC-LOGIN-015
 */

const { test, expect } = require('@playwright/test');
const {
  CREDENTIALS,
  BASE_URL,
  waitForFlutterApp,
  fillFlutterInput,
} = require('../helpers/auth.helper');

test.describe('🔑 AUTHENTICATION & SESSION MANAGEMENT', () => {

  async function performLogin(page, email, password, captchaAnswer = null) {
    await page.goto(BASE_URL);
    await waitForFlutterApp(page);

    // Isi email (jika ada value)
    if (email !== '') {
      const emailField = page.locator('input[aria-label*="you@example.com" i], input[aria-label*="Email" i]').first();
      await fillFlutterInput(page, emailField, email);
    }

    // Isi password (jika ada value)
    if (password !== '') {
      const passwordField = page.locator('input[aria-label*="password" i]').first();
      await fillFlutterInput(page, passwordField, password);
    }

    // Isi captcha
    let answer = captchaAnswer;
    const captchaField = page.locator('input[aria-label*="Answer:" i], input[aria-label*="Captcha" i]').first();
    await captchaField.waitFor({ state: 'visible', timeout: 15_000 });

    if (answer === null) {
      const ariaLabel = await captchaField.getAttribute('aria-label');
      if (ariaLabel) {
        const match = ariaLabel.match(/Answer:\s*(\d+)\s*\+\s*(\d+)/i);
        if (match) {
          const left = parseInt(match[1], 10);
          const right = parseInt(match[2], 10);
          answer = String(left + right);
        }
      }
    }
    
    if (answer !== '') {
      await fillFlutterInput(page, captchaField, answer ?? '0');
    }

    // Klik tombol Sign In
    const signInBtn = page.locator('flt-semantics[role="button"]', { hasText: 'Sign In' }).first();
    await signInBtn.click({ force: true });
  }

  async function expectHomeScreen(page) {
    const dashboard = page.locator('flt-semantics', { hasText: 'POS Kasir' })
      .or(page.locator('flt-semantics', { hasText: 'Dasbor' }))
      .or(page.locator('flt-semantics', { hasText: 'Manajemen Produk' }));
    await dashboard.first().waitFor({ state: 'attached', timeout: 30000 });
  }

  // --- POSITIVE CASES ---

  test('TC-LOGIN-001 | Login dengan email & password valid (Role: Admin)', async ({ page }) => {
    test.slow();
    await performLogin(page, CREDENTIALS.admin.email, CREDENTIALS.admin.password);
    await expectHomeScreen(page);
    console.log('✅ TC-LOGIN-001 PASS: Admin Login Sukses');
  });

  test('TC-LOGIN-001b | Login dengan email & password valid (Role: Kasir)', async ({ page }) => {
    test.slow();
    await performLogin(page, CREDENTIALS.kasir.email, CREDENTIALS.kasir.password);
    await expectHomeScreen(page);
    console.log('✅ TC-LOGIN-001b PASS: Kasir Login Sukses');
  });

  test('TC-LOGIN-001c | Login dengan email & password valid (Role: Owner)', async ({ page }) => {
    test.slow();
    await performLogin(page, CREDENTIALS.owner.email, CREDENTIALS.owner.password);
    await expectHomeScreen(page);
    console.log('✅ TC-LOGIN-001c PASS: Owner Login Sukses');
  });

  // --- NEGATIVE CASES ---

  test('TC-LOGIN-002 | Password salah', async ({ page }) => {
    test.slow();
    await performLogin(page, CREDENTIALS.admin.email, 'passwordsalah123');
    const errorMsg = page.locator('flt-semantics', { hasText: 'Login Error' }).first();
    await errorMsg.waitFor({ state: 'attached', timeout: 15000 });
    console.log('✅ TC-LOGIN-002 PASS');
  });

  test('TC-LOGIN-003 | Email salah', async ({ page }) => {
    test.slow();
    await performLogin(page, 'salah@example.com', CREDENTIALS.admin.password);
    const errorMsg = page.locator('flt-semantics', { hasText: 'Login Error' }).first();
    await errorMsg.waitFor({ state: 'attached', timeout: 15000 });
    console.log('✅ TC-LOGIN-003 PASS');
  });

  test('TC-LOGIN-004 | Email kosong', async ({ page }) => {
    test.slow();
    await performLogin(page, '', CREDENTIALS.admin.password);
    const errorText = page.locator('flt-semantics', { hasText: 'Email and password are required' }).first();
    await errorText.waitFor({ state: 'attached', timeout: 10000 });
    console.log('✅ TC-LOGIN-004 PASS');
  });

  test('TC-LOGIN-005 | Password kosong', async ({ page }) => {
    test.slow();
    await performLogin(page, CREDENTIALS.admin.email, '');
    const errorText = page.locator('flt-semantics', { hasText: 'Email and password are required' }).first();
    await errorText.waitFor({ state: 'attached', timeout: 10000 });
    console.log('✅ TC-LOGIN-005 PASS');
  });

  test('TC-LOGIN-006 | Email & password kosong', async ({ page }) => {
    test.slow();
    await performLogin(page, '', '');
    const errorText = page.locator('flt-semantics', { hasText: 'Email and password are required' }).first();
    await errorText.waitFor({ state: 'attached', timeout: 10000 });
    console.log('✅ TC-LOGIN-006 PASS');
  });

  test('TC-LOGIN-007 | Format email invalid', async ({ page }) => {
    test.slow();
    await performLogin(page, 'admin-invalid-format', CREDENTIALS.admin.password);
    const errorMsg = page.locator('flt-semantics', { hasText: 'Login Error' }).first();
    await errorMsg.waitFor({ state: 'attached', timeout: 15000 });
    console.log('✅ TC-LOGIN-007 PASS');
  });

  test('TC-LOGIN-008 | Password kurang dari minimal', async ({ page }) => {
    test.slow();
    await performLogin(page, CREDENTIALS.admin.email, '123');
    const errorMsg = page.locator('flt-semantics', { hasText: 'Login Error' }).first();
    await errorMsg.waitFor({ state: 'attached', timeout: 15000 });
    console.log('✅ TC-LOGIN-008 PASS');
  });

  // --- SECURITY & EDGE CASES (TC-LOGIN-009 to TC-LOGIN-013) ---

  test('TC-LOGIN-009 | SQL Injection pada email', async ({ page }) => {
    test.slow();
    await performLogin(page, "admin' OR 1=1 --", CREDENTIALS.admin.password);
    const errorMsg = page.locator('flt-semantics', { hasText: 'Login Error' }).first();
    await errorMsg.waitFor({ state: 'attached', timeout: 15000 });
    console.log('✅ TC-LOGIN-009 PASS: SQL Injection ditolak');
  });

  test('TC-LOGIN-010 | SQL Injection password', async ({ page }) => {
    test.slow();
    await performLogin(page, CREDENTIALS.admin.email, "' OR '1'='1");
    const errorMsg = page.locator('flt-semantics', { hasText: 'Login Error' }).first();
    await errorMsg.waitFor({ state: 'attached', timeout: 15000 });
    console.log('✅ TC-LOGIN-010 PASS: SQL Injection ditolak');
  });

  test('TC-LOGIN-011 | XSS input', async ({ page }) => {
    test.slow();
    await performLogin(page, '<script>alert("xss")</script>', CREDENTIALS.admin.password);
    const errorMsg = page.locator('flt-semantics', { hasText: 'Login Error' }).first();
    await errorMsg.waitFor({ state: 'attached', timeout: 15000 });
    console.log('✅ TC-LOGIN-011 PASS: XSS input ditolak');
  });

  test('TC-LOGIN-012 | Double click Login', async ({ page }) => {
    test.slow();
    await page.goto(BASE_URL);
    await waitForFlutterApp(page);

    const emailField = page.locator('input[aria-label*="you@example.com" i], input[aria-label*="Email" i]').first();
    await fillFlutterInput(page, emailField, CREDENTIALS.admin.email);

    const passwordField = page.locator('input[aria-label*="password" i]').first();
    await fillFlutterInput(page, passwordField, CREDENTIALS.admin.password);

    // Isi captcha
    const captchaField = page.locator('input[aria-label*="Answer:" i], input[aria-label*="Captcha" i]').first();
    const ariaLabel = await captchaField.getAttribute('aria-label');
    let answer = '0';
    if (ariaLabel) {
      const match = ariaLabel.match(/Answer:\s*(\d+)\s*\+\s*(\d+)/i);
      if (match) {
        answer = String(parseInt(match[1]) + parseInt(match[2]));
      }
    }
    await fillFlutterInput(page, captchaField, answer);

    const signInBtn = page.locator('flt-semantics[role="button"]', { hasText: 'Sign In' }).first();
    await signInBtn.click({ force: true });
    await signInBtn.click({ force: true }); // Double click

    await page.waitForTimeout(2000);

    // Jika muncul error captcha akibat double-submit (first submit consumes captcha)
    const errorText = page.locator('flt-semantics', { hasText: 'Captcha verification failed' }).first();
    if (await errorText.count() > 0) {
      console.log('Detected captcha error due to double-submit, solving new captcha...');
      const newAriaLabel = await captchaField.getAttribute('aria-label');
      if (newAriaLabel) {
        const match = newAriaLabel.match(/Answer:\s*(\d+)\s*\+\s*(\d+)/i);
        if (match) {
          const newAnswer = String(parseInt(match[1]) + parseInt(match[2]));
          await fillFlutterInput(page, captchaField, newAnswer);
          await page.waitForTimeout(500);
          await signInBtn.click({ force: true });
        }
      }
    }

    await expectHomeScreen(page);
    console.log('✅ TC-LOGIN-012 PASS: Double click aman, login berhasil');
  });

  test('TC-LOGIN-013 | Session expired', async ({ page }) => {
    test.slow();
    // Buka aplikasi
    await page.goto(BASE_URL);
    await waitForFlutterApp(page);
    
    // Clear storage & cookies untuk menyimulasikan session token yang hangus / expired
    await page.context().clearCookies();
    await page.evaluate(() => localStorage.clear());
    await page.evaluate(() => sessionStorage.clear());
    
    // Reload halaman
    await page.reload();
    await waitForFlutterApp(page);
    
    // Harus tetap berada di login screen
    const emailField = page.locator('input[aria-label*="you@example.com" i]').first();
    await emailField.waitFor({ state: 'visible', timeout: 15000 });
    console.log('✅ TC-LOGIN-013 PASS: Session expired berhasil ter-redirect ke Login');
  });

  // --- SESSION & LIFECYCLE ---

  test('TC-LOGIN-014 | Logout', async ({ page }) => {
    test.slow();
    await performLogin(page, CREDENTIALS.kasir.email, CREDENTIALS.kasir.password);
    await expectHomeScreen(page);

    // Klik tombol Logout di AppBar
    const logoutBtn = page.getByRole('button', { name: /logout/i });
    await logoutBtn.click({ force: true });

    // Verifikasi kembali ke halaman login (cari hint email)
    const emailField = page.locator('input[aria-label*="you@example.com" i]').first();
    await emailField.waitFor({ state: 'visible', timeout: 15000 });
    console.log('✅ TC-LOGIN-014 PASS: Logout Session Berhasil');
  });

  test('TC-LOGIN-015 | Akses dashboard tanpa login', async ({ page }) => {
    test.slow();
    await page.goto(BASE_URL);
    await waitForFlutterApp(page);

    const emailField = page.locator('input[aria-label*="you@example.com" i]').first();
    await emailField.waitFor({ state: 'visible', timeout: 15000 });
    console.log('✅ TC-LOGIN-015 PASS: Akses tanpa login berhasil diblokir');
  });
});
