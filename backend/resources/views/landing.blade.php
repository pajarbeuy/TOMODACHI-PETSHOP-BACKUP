<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Tomodachi Pet Shop POS — Sistem manajemen toko hewan peliharaan modern berbasis Laravel & Flutter dengan AI Assistant.">
    <title>Tomodachi Pet Shop POS - Sistem Manajemen Cerdas</title>

    <!-- Canonical URL -->
    <link rel="canonical" href="{{ url('/') }}">

    <!-- Open Graph / Facebook -->
    <meta property="og:type" content="website">
    <meta property="og:url" content="{{ url('/') }}">
    <meta property="og:title" content="Tomodachi Pet Shop POS - Sistem Manajemen Cerdas">
    <meta property="og:description" content="Sistem manajemen toko hewan peliharaan modern berbasis Laravel & Flutter. Mengelola produk, stok, transaksi, dan analytics secara terpusat dengan dukungan AI.">
    <meta property="og:image" content="{{ asset('images/cat.png') }}">

    <!-- Twitter -->
    <meta property="twitter:card" content="summary_large_image">
    <meta property="twitter:url" content="{{ url('/') }}">
    <meta property="twitter:title" content="Tomodachi Pet Shop POS">
    <meta property="twitter:description" content="Sistem manajemen toko hewan peliharaan modern berbasis Laravel & Flutter.">
    <meta property="twitter:image" content="{{ asset('images/cat.png') }}">

    <!-- Schema.org JSON-LD -->
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@graph": [
        {
          "@type": "Organization",
          "@id": "{{ url('/') }}#organization",
          "name": "Tomodachi Pet Shop",
          "url": "{{ url('/') }}",
          "logo": {
            "@type": "ImageObject",
            "url": "{{ asset('images/logo.png') }}"
          },
          "contactPoint": {
            "@type": "ContactPoint",
            "telephone": "+62-123-4567-8910",
            "contactType": "customer service",
            "areaServed": "ID",
            "availableLanguage": "Indonesian"
          }
        },
        {
          "@type": "WebSite",
          "@id": "{{ url('/') }}#website",
          "url": "{{ url('/') }}",
          "name": "Tomodachi Pet Shop POS",
          "description": "Sistem manajemen toko hewan peliharaan modern.",
          "publisher": {
            "@id": "{{ url('/') }}#organization"
          }
        }
      ]
    }
    </script>
<link rel="icon" type="image/png" href="{{ asset('images/logo.png') }}">
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

<style>
/* ── Reset & Base ─────────────────────────────────────────────────────────── */
*, *::before, *::after {
    margin: 0; padding: 0;
    box-sizing: border-box;
    scroll-behavior: smooth;
}

:root {
    --orange:       #FF8A00;
    --orange-deep:  #E06500;
    --orange-light: #FFB347;
    --bg:           #0B0C10;
    --bg2:          #111318;
    --bg3:          #181B22;
    --glass:        rgba(255,255,255,0.04);
    --glass-border: rgba(255,255,255,0.08);
    --text:         #F0ECE4;
    --muted:        #9A9080;
    --radius:       18px;
    --transition:   0.3s cubic-bezier(.4,0,.2,1);
}

html { font-family: 'Plus Jakarta Sans', sans-serif; }

body {
    background: var(--bg);
    color: var(--text);
    overflow-x: hidden;
}

/* ── Scrollbar ────────────────────────────────────────────────────────────── */
::-webkit-scrollbar { width: 6px; }
::-webkit-scrollbar-track { background: var(--bg); }
::-webkit-scrollbar-thumb { background: var(--orange); border-radius: 99px; }

/* ── Paw Decorations ─────────────────────────────────────────────────────── */
.paw-bg {
    position: fixed; inset: 0; pointer-events: none;
    overflow: hidden; z-index: 0;
}
.paw {
    position: absolute;
    font-size: clamp(40px, 5vw, 80px);
    opacity: 0.03;
    animation: floatPaw 12s ease-in-out infinite;
    user-select: none;
}
.paw:nth-child(1) { top: 8%;  left: 5%;   animation-delay: 0s;   animation-duration: 14s; }
.paw:nth-child(2) { top: 30%; right: 4%;  animation-delay: 2s;   animation-duration: 11s; }
.paw:nth-child(3) { top: 65%; left: 2%;   animation-delay: 5s;   animation-duration: 16s; }
.paw:nth-child(4) { top: 80%; right: 10%; animation-delay: 1s;   animation-duration: 13s; }
.paw:nth-child(5) { top: 50%; left: 50%;  animation-delay: 3.5s; animation-duration: 18s; }

@keyframes floatPaw {
    0%, 100% { transform: translateY(0) rotate(0deg); }
    50%       { transform: translateY(-20px) rotate(8deg); }
}

/* ── Header ──────────────────────────────────────────────────────────────── */
header {
    position: fixed; top: 0; left: 0; right: 0;
    z-index: 1000;
    display: flex; justify-content: space-between; align-items: center;
    padding: 16px 7%;
    background: rgba(11,12,16,0.7);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-bottom: 1px solid var(--glass-border);
    transition: var(--transition);
}

.logo {
    display: flex; align-items: center; gap: 12px;
    text-decoration: none;
}
.logo img {
    width: 42px; height: 42px;
    border-radius: 12px; object-fit: cover;
    box-shadow: 0 0 0 2px rgba(255,138,0,0.4);
}
.logo-text {
    font-size: 18px; font-weight: 800;
    background: linear-gradient(90deg, var(--orange), var(--orange-light));
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
}

nav { display: flex; align-items: center; gap: 6px; }
nav a {
    text-decoration: none; color: var(--muted);
    padding: 8px 16px; border-radius: 10px;
    font-size: 14px; font-weight: 500;
    transition: var(--transition);
}
nav a:hover { color: var(--text); background: var(--glass); }

.nav-cta {
    background: linear-gradient(135deg, var(--orange), var(--orange-deep)) !important;
    color: white !important;
    font-weight: 700 !important;
    padding: 10px 22px !important;
}
.nav-cta:hover { opacity: 0.88; transform: translateY(-1px); }

/* Hamburger */
.hamburger {
    display: none;
    flex-direction: column; gap: 5px;
    cursor: pointer; padding: 4px;
    background: none; border: none;
}
.hamburger span {
    display: block; width: 24px; height: 2px;
    background: var(--text); border-radius: 2px;
    transition: var(--transition);
}
.hamburger.open span:nth-child(1) { transform: rotate(45deg) translate(5px, 5px); }
.hamburger.open span:nth-child(2) { opacity: 0; }
.hamburger.open span:nth-child(3) { transform: rotate(-45deg) translate(5px, -5px); }

.mobile-nav {
    display: none;
    position: fixed; top: 73px; left: 0; right: 0;
    background: rgba(11,12,16,0.97);
    backdrop-filter: blur(20px);
    padding: 20px 7%;
    border-bottom: 1px solid var(--glass-border);
    z-index: 999;
    flex-direction: column; gap: 4px;
}
.mobile-nav.open { display: flex; }
.mobile-nav a {
    text-decoration: none; color: var(--muted);
    padding: 12px 16px; border-radius: 10px;
    font-size: 16px; font-weight: 500;
    transition: var(--transition);
}
.mobile-nav a:hover { color: var(--text); background: var(--glass); }

/* ── Hero ────────────────────────────────────────────────────────────────── */
.hero {
    min-height: 100vh;
    display: flex; align-items: center; justify-content: space-between;
    padding: 120px 7% 80px;
    position: relative; overflow: hidden;
}

.hero::before {
    content: '';
    position: absolute; top: -40%; left: -10%;
    width: 600px; height: 600px;
    background: radial-gradient(circle, rgba(255,138,0,0.12) 0%, transparent 70%);
    pointer-events: none;
}
.hero::after {
    content: '';
    position: absolute; bottom: -20%; right: -5%;
    width: 400px; height: 400px;
    background: radial-gradient(circle, rgba(255,183,71,0.07) 0%, transparent 70%);
    pointer-events: none;
}

.hero-content { max-width: 580px; position: relative; z-index: 1; }

.hero-badge {
    display: inline-flex; align-items: center; gap: 8px;
    background: rgba(255,138,0,0.1);
    border: 1px solid rgba(255,138,0,0.25);
    color: var(--orange-light);
    padding: 6px 14px; border-radius: 99px;
    font-size: 13px; font-weight: 600;
    margin-bottom: 24px;
}
.badge-dot {
    width: 7px; height: 7px;
    background: #4ADE80; border-radius: 50%;
    animation: pulse 2s infinite;
}
@keyframes pulse {
    0%, 100% { box-shadow: 0 0 0 0 rgba(74,222,128,0.6); }
    50%       { box-shadow: 0 0 0 6px rgba(74,222,128,0); }
}

.hero-content h1 {
    font-size: clamp(38px, 5.5vw, 68px);
    font-weight: 900;
    line-height: 1.1;
    margin-bottom: 20px;
    letter-spacing: -2px;
}
.hero-content h1 .grad {
    background: linear-gradient(90deg, var(--orange), var(--orange-light), #FFD580);
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
}

.hero-content p {
    font-size: 17px; color: var(--muted);
    line-height: 1.8; margin-bottom: 36px;
    max-width: 500px;
}

.hero-actions { display: flex; flex-wrap: wrap; gap: 14px; align-items: center; }

.btn-primary {
    display: inline-flex; align-items: center; gap: 10px;
    padding: 15px 30px;
    background: linear-gradient(135deg, var(--orange), var(--orange-deep));
    color: white; text-decoration: none;
    border-radius: var(--radius); font-weight: 700; font-size: 15px;
    box-shadow: 0 8px 32px rgba(255,138,0,0.35);
    transition: var(--transition);
    position: relative; overflow: hidden;
}
.btn-primary::after {
    content: '';
    position: absolute; inset: 0;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent);
    transform: translateX(-100%);
    animation: shimmer 2.5s infinite;
}
@keyframes shimmer {
    100% { transform: translateX(100%); }
}
.btn-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 12px 40px rgba(255,138,0,0.5);
}

.btn-download {
    display: inline-flex; align-items: center; gap: 10px;
    padding: 14px 28px;
    background: var(--glass);
    color: var(--text); text-decoration: none;
    border-radius: var(--radius); font-weight: 600; font-size: 15px;
    border: 1px solid var(--glass-border);
    backdrop-filter: blur(10px);
    transition: var(--transition);
}
.btn-download:hover {
    border-color: rgba(255,138,0,0.4);
    background: rgba(255,138,0,0.08);
    transform: translateY(-2px);
}

.hero-visual {
    position: relative; z-index: 1;
    display: flex; justify-content: center; align-items: center;
    flex-shrink: 0;
}
.hero-img-wrap {
    position: relative; width: 340px; height: 340px;
}
.hero-img-wrap::before {
    content: '';
    position: absolute; inset: -3px;
    background: linear-gradient(135deg, var(--orange), transparent, var(--orange-light));
    border-radius: 50%; animation: spin 8s linear infinite; opacity: 0.5;
}
@keyframes spin { to { transform: rotate(360deg); } }

.hero-img-wrap img {
    position: relative; width: 100%; height: 100%;
    object-fit: contain; border-radius: 50%;
    background: radial-gradient(circle, rgba(255,138,0,0.08), transparent);
    z-index: 1;
    filter: drop-shadow(0 20px 40px rgba(255,138,0,0.3));
    animation: float 6s ease-in-out infinite;
}
@keyframes float {
    0%, 100% { transform: translateY(0); }
    50%       { transform: translateY(-16px); }
}

.hero-stats {
    display: flex; gap: 32px;
    margin-top: 40px;
}
.hero-stat { text-align: left; }
.hero-stat .num {
    font-size: 28px; font-weight: 900;
    background: linear-gradient(90deg, var(--orange), var(--orange-light));
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
}
.hero-stat .lbl { font-size: 12px; color: var(--muted); font-weight: 500; }

/* ── Section Base ────────────────────────────────────────────────────────── */
section { padding: 100px 7%; position: relative; z-index: 1; }

.section-label {
    display: inline-block;
    background: rgba(255,138,0,0.1);
    border: 1px solid rgba(255,138,0,0.2);
    color: var(--orange);
    padding: 4px 14px; border-radius: 99px;
    font-size: 12px; font-weight: 700; letter-spacing: 1px;
    text-transform: uppercase; margin-bottom: 16px;
}
.section-title {
    font-size: clamp(28px, 4vw, 44px);
    font-weight: 800; letter-spacing: -1px;
    margin-bottom: 12px;
}
.section-sub { color: var(--muted); font-size: 16px; max-width: 520px; }
.section-head { margin-bottom: 56px; }

/* ── Features ────────────────────────────────────────────────────────────── */
#features { background: var(--bg2); }

.features-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 20px;
}

.feature-card {
    background: var(--glass);
    border: 1px solid var(--glass-border);
    border-radius: var(--radius);
    padding: 28px;
    transition: var(--transition);
    backdrop-filter: blur(10px);
    position: relative; overflow: hidden;
}
.feature-card::before {
    content: '';
    position: absolute; top: 0; left: 0; right: 0; height: 2px;
    background: linear-gradient(90deg, var(--orange), transparent);
    opacity: 0; transition: var(--transition);
}
.feature-card:hover {
    border-color: rgba(255,138,0,0.25);
    transform: translateY(-6px);
    box-shadow: 0 20px 40px rgba(0,0,0,0.3);
}
.feature-card:hover::before { opacity: 1; }

.feature-icon {
    font-size: 36px; margin-bottom: 16px;
    display: block;
}
.feature-card h3 {
    font-size: 17px; font-weight: 700; margin-bottom: 8px; color: var(--text);
}
.feature-card p { font-size: 14px; color: var(--muted); line-height: 1.7; }

/* ── Roles ───────────────────────────────────────────────────────────────── */
#roles { background: var(--bg3); }

.roles-grid {
    display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px;
}

.role-card {
    background: var(--glass);
    border: 1px solid var(--glass-border);
    border-radius: var(--radius);
    padding: 36px 28px; text-align: center;
    transition: var(--transition);
    position: relative; overflow: hidden;
}
.role-card::after {
    content: '';
    position: absolute; bottom: -40px; left: 50%;
    transform: translateX(-50%);
    width: 120px; height: 120px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(255,138,0,0.15), transparent);
    transition: var(--transition);
}
.role-card:hover { border-color: rgba(255,138,0,0.3); transform: translateY(-6px); }
.role-card:hover::after { opacity: 0; }

.role-emoji { font-size: 48px; display: block; margin-bottom: 16px; }
.role-card h3 { font-size: 20px; font-weight: 800; margin-bottom: 10px; }
.role-card p { color: var(--muted); font-size: 14px; line-height: 1.7; }
.role-tag {
    display: inline-block; margin-top: 16px;
    padding: 4px 12px; border-radius: 99px;
    font-size: 11px; font-weight: 700; letter-spacing: 0.5px;
    background: rgba(255,138,0,0.12); color: var(--orange);
    border: 1px solid rgba(255,138,0,0.2);
}

/* ── Stats ───────────────────────────────────────────────────────────────── */
#stats { background: var(--bg2); }

.stats-grid {
    display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px;
}
.stat-card {
    background: var(--glass);
    border: 1px solid var(--glass-border);
    border-radius: var(--radius);
    padding: 32px 24px; text-align: center;
    transition: var(--transition);
}
.stat-card:hover { border-color: rgba(255,138,0,0.3); transform: translateY(-4px); }
.stat-card .num {
    font-size: 48px; font-weight: 900; line-height: 1;
    background: linear-gradient(135deg, var(--orange), var(--orange-light));
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    margin-bottom: 8px;
}
.stat-card p { color: var(--muted); font-size: 14px; font-weight: 500; }

/* ── Tech Stack ──────────────────────────────────────────────────────────── */
#technology { background: var(--bg3); }

.tech-grid {
    display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px;
}
.tech-pill {
    background: var(--glass);
    border: 1px solid var(--glass-border);
    border-radius: 14px; padding: 20px;
    display: flex; align-items: center; gap: 14px;
    transition: var(--transition);
}
.tech-pill:hover { border-color: rgba(255,138,0,0.3); transform: translateY(-3px); }
.tech-pill .tech-icon { font-size: 28px; }
.tech-pill .tech-info { }
.tech-pill .tech-name { font-size: 14px; font-weight: 700; }
.tech-pill .tech-desc { font-size: 12px; color: var(--muted); }

/* ── Download CTA ────────────────────────────────────────────────────────── */
#download { background: var(--bg2); text-align: center; }

.download-box {
    background: var(--glass);
    border: 1px solid var(--glass-border);
    border-radius: 28px; padding: 64px 48px;
    max-width: 700px; margin: auto;
    position: relative; overflow: hidden;
}
.download-box::before {
    content: '';
    position: absolute; top: -50%; left: -50%;
    width: 200%; height: 200%;
    background: radial-gradient(circle at center, rgba(255,138,0,0.06), transparent 60%);
    pointer-events: none;
}
.download-box h2 { font-size: clamp(28px, 4vw, 42px); font-weight: 900; margin-bottom: 16px; }
.download-box p { color: var(--muted); font-size: 16px; margin-bottom: 36px; }
.download-box .btn-primary { font-size: 17px; padding: 18px 40px; margin: auto; }

.btn-whatsapp {
    display: inline-flex; align-items: center; gap: 10px;
    padding: 15px 30px;
    background: #25D366;
    color: white; text-decoration: none;
    border-radius: var(--radius); font-weight: 700; font-size: 15px;
    box-shadow: 0 8px 32px rgba(37,211,102,0.3);
    transition: var(--transition);
}
.btn-whatsapp:hover {
    background: #128C7E;
    transform: translateY(-2px);
    box-shadow: 0 12px 40px rgba(37,211,102,0.4);
}

/* ── Footer ──────────────────────────────────────────────────────────────── */
footer {
    background: var(--bg);
    border-top: 1px solid var(--glass-border);
    padding: 48px 7%;
    display: flex; justify-content: space-between; align-items: center;
    flex-wrap: wrap; gap: 20px;
}
.footer-logo {
    display: flex; align-items: center; gap: 10px; text-decoration: none;
}
.footer-logo img { width: 36px; height: 36px; border-radius: 9px; object-fit: cover; }
.footer-logo span { font-size: 16px; font-weight: 700; color: var(--text); }
footer p { color: var(--muted); font-size: 14px; }
.footer-links { display: flex; gap: 20px; }
.footer-links a { color: var(--muted); text-decoration: none; font-size: 14px; transition: var(--transition); }
.footer-links a:hover { color: var(--orange); }

/* ── Scroll Reveal ───────────────────────────────────────────────────────── */
.reveal {
    opacity: 0; transform: translateY(32px);
    transition: opacity 0.7s ease, transform 0.7s ease;
}
.reveal.visible { opacity: 1; transform: none; }
.reveal-delay-1 { transition-delay: 0.1s; }
.reveal-delay-2 { transition-delay: 0.2s; }
.reveal-delay-3 { transition-delay: 0.3s; }
.reveal-delay-4 { transition-delay: 0.4s; }
.reveal-delay-5 { transition-delay: 0.5s; }

/* ── Responsive ──────────────────────────────────────────────────────────── */
@media (max-width: 1024px) {
    .roles-grid { grid-template-columns: 1fr 1fr; }
    .stats-grid { grid-template-columns: 1fr 1fr; }
}

@media (max-width: 768px) {
    nav { display: none; }
    .hamburger { display: flex; }

    .hero {
        flex-direction: column-reverse; text-align: center;
        padding-top: 120px; gap: 40px;
    }
    .hero-actions { justify-content: center; }
    .hero-stats { justify-content: center; }
    .hero-img-wrap { width: 240px; height: 240px; }

    .roles-grid { grid-template-columns: 1fr; }
    .stats-grid { grid-template-columns: 1fr 1fr; }

    .download-box { padding: 40px 24px; }

    footer { flex-direction: column; text-align: center; }
    .footer-links { flex-wrap: wrap; justify-content: center; }
}

@media (max-width: 480px) {
    .stats-grid { grid-template-columns: 1fr; }
    .hero-stats { flex-direction: column; align-items: center; gap: 16px; }
}
</style>
</head>
<body>

<!-- Floating paw prints (SVG) -->
<div class="paw-bg" aria-hidden="true">
    <svg class="paw" viewBox="0 0 64 64" fill="currentColor"><ellipse cx="12" cy="18" rx="7" ry="9"/><ellipse cx="32" cy="10" rx="7" ry="9"/><ellipse cx="52" cy="18" rx="7" ry="9"/><ellipse cx="22" cy="26" rx="7" ry="9"/><path d="M32 30c-10 0-18 6-18 16 0 7 4 12 10 13 3 1 5 3 8 3s5-2 8-3c6-1 10-6 10-13 0-10-8-16-18-16z"/></svg>
    <svg class="paw" viewBox="0 0 64 64" fill="currentColor"><ellipse cx="12" cy="18" rx="7" ry="9"/><ellipse cx="32" cy="10" rx="7" ry="9"/><ellipse cx="52" cy="18" rx="7" ry="9"/><ellipse cx="22" cy="26" rx="7" ry="9"/><path d="M32 30c-10 0-18 6-18 16 0 7 4 12 10 13 3 1 5 3 8 3s5-2 8-3c6-1 10-6 10-13 0-10-8-16-18-16z"/></svg>
    <svg class="paw" viewBox="0 0 64 64" fill="currentColor"><ellipse cx="12" cy="18" rx="7" ry="9"/><ellipse cx="32" cy="10" rx="7" ry="9"/><ellipse cx="52" cy="18" rx="7" ry="9"/><ellipse cx="22" cy="26" rx="7" ry="9"/><path d="M32 30c-10 0-18 6-18 16 0 7 4 12 10 13 3 1 5 3 8 3s5-2 8-3c6-1 10-6 10-13 0-10-8-16-18-16z"/></svg>
    <svg class="paw" viewBox="0 0 64 64" fill="currentColor"><ellipse cx="12" cy="18" rx="7" ry="9"/><ellipse cx="32" cy="10" rx="7" ry="9"/><ellipse cx="52" cy="18" rx="7" ry="9"/><ellipse cx="22" cy="26" rx="7" ry="9"/><path d="M32 30c-10 0-18 6-18 16 0 7 4 12 10 13 3 1 5 3 8 3s5-2 8-3c6-1 10-6 10-13 0-10-8-16-18-16z"/></svg>
    <svg class="paw" viewBox="0 0 64 64" fill="currentColor"><ellipse cx="12" cy="18" rx="7" ry="9"/><ellipse cx="32" cy="10" rx="7" ry="9"/><ellipse cx="52" cy="18" rx="7" ry="9"/><ellipse cx="22" cy="26" rx="7" ry="9"/><path d="M32 30c-10 0-18 6-18 16 0 7 4 12 10 13 3 1 5 3 8 3s5-2 8-3c6-1 10-6 10-13 0-10-8-16-18-16z"/></svg>
</div>

<!-- ── Header ────────────────────────────────────────────────────────────── -->
<header id="top">
    <a href="#top" class="logo">
        <img src="{{ asset('images/logo.png') }}" alt="Tomodachi Logo">
        <span class="logo-text">Tomodachi</span>
    </a>

    <nav>
        <a href="#about">About</a>
        <a href="#features">Features</a>
        <a href="#roles">Roles</a>
        <a href="#technology">Tech</a>
        <a href="#contact">Contact</a>
        <a href="#download" class="nav-cta">Download APK</a>
    </nav>

    <button class="hamburger" id="hamburgerBtn" aria-label="Toggle menu">
        <span></span><span></span><span></span>
    </button>
</header>

<div class="mobile-nav" id="mobileNav">
    <a href="#about"      onclick="closeMobileNav()">About</a>
    <a href="#features"   onclick="closeMobileNav()">Features</a>
    <a href="#roles"      onclick="closeMobileNav()">Roles</a>
    <a href="#technology" onclick="closeMobileNav()">Technology</a>
    <a href="#contact"    onclick="closeMobileNav()">Contact Us</a>
    <a href="#download"   onclick="closeMobileNav()">Download APK</a>
</div>

<!-- ── Hero ──────────────────────────────────────────────────────────────── -->
<section class="hero" id="hero">
    <div class="hero-content">
        <div class="hero-badge reveal">
            <span class="badge-dot"></span>
            Sistem Aktif & Online
        </div>

        <h1 class="reveal reveal-delay-1">
            Smart <span class="grad">Pet Shop</span><br>
            Management System
        </h1>

        <p class="reveal reveal-delay-2">
            Kelola produk, stok, transaksi, laporan bisnis, dan AI assistant dalam satu platform modern.
            Dibangun dengan Laravel & Flutter untuk pengalaman terbaik.
        </p>

        <div class="hero-actions reveal reveal-delay-3">
            <a href="#features" class="btn-primary">
                <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M13 7l5 5-5 5M6 12h12"/>
                </svg>
                Explore Features
            </a>
            <a href="#download" class="btn-download">
                <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2M7 10l5 5 5-5M12 15V3"/>
                </svg>
                Download APK
            </a>
        </div>

        <div class="hero-stats reveal reveal-delay-4">
            <div class="hero-stat">
                <div class="num">3</div>
                <div class="lbl">User Roles</div>
            </div>
            <div class="hero-stat">
                <div class="num">6+</div>
                <div class="lbl">Fitur Utama</div>
            </div>
            <div class="hero-stat">
                <div class="num">24/7</div>
                <div class="lbl">Akses Penuh</div>
            </div>
        </div>
    </div>

    <div class="hero-visual reveal reveal-delay-2">
        <div class="hero-img-wrap">
            <img src="{{ asset('images/cat.png') }}" alt="Tomodachi Pet Shop mascot">
        </div>
    </div>
</section>

<!-- ── About ──────────────────────────────────────────────────────────────── -->
<section id="about">
    <div class="section-head reveal">
        <div class="section-label">About</div>
        <h2 class="section-title">Kenapa Tomodachi?</h2>
        <p class="section-sub">
            Solusi manajemen pet shop yang modern, cepat, dan mudah digunakan — dari kasir hingga owner, semua terkontrol dalam satu sistem.
        </p>
    </div>
</section>

<!-- ── Features ──────────────────────────────────────────────────────────── -->
<section id="features">
    <div class="section-head reveal">
        <div class="section-label">Features</div>
        <h2 class="section-title">Fitur Lengkap untuk Pet Shop Modern</h2>
        <p class="section-sub">Semua yang kamu butuhkan untuk mengelola bisnis pet shop secara efisien.</p>
    </div>

    <div class="features-grid">
        <div class="feature-card reveal reveal-delay-1">
            <div class="feature-icon">
                <svg width="28" height="28" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 10V11"/></svg>
            </div>
            <h3>Product Management</h3>
            <p>Kelola produk, harga, SKU, dan gambar dengan mudah. Sinkron antara stok offline dan online.</p>
        </div>
        <div class="feature-card reveal reveal-delay-2">
            <div class="feature-icon">
                <svg width="28" height="28" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A2 2 0 013 12V7a4 4 0 014-4z"/></svg>
            </div>
            <h3>Category Management</h3>
            <p>Kategorisasi produk berdasarkan jenis hewan dan sub-kategori untuk pencarian yang lebih cepat.</p>
        </div>
        <div class="feature-card reveal reveal-delay-3">
            <div class="feature-icon">
                <svg width="28" height="28" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
            </div>
            <h3>POS Transactions</h3>
            <p>Transaksi kasir cepat dengan dukungan pembayaran tunai, QRIS, dan transfer via Midtrans.</p>
        </div>
        <div class="feature-card reveal reveal-delay-4">
            <div class="feature-icon">
                <svg width="28" height="28" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/></svg>
            </div>
            <h3>Analytics Dashboard</h3>
            <p>Pantau performa bisnis real-time: pendapatan, transaksi, produk terlaris, dan alert stok.</p>
        </div>
        <div class="feature-card reveal reveal-delay-5">
            <div class="feature-icon">
                <svg width="28" height="28" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><polyline points="22 7 13.5 15.5 8.5 10.5 2 17"/><polyline points="16 7 22 7 22 13"/></svg>
            </div>
            <h3>Sales Reports</h3>
            <p>Laporan penjualan harian, mingguan, dan bulanan yang dapat difilter dan diekspor.</p>
        </div>
        <div class="feature-card reveal reveal-delay-1">
            <div class="feature-icon">
                <svg width="28" height="28" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path stroke-linecap="round" stroke-linejoin="round" d="M12 1v4M12 19v4M4.22 4.22l2.83 2.83M16.95 16.95l2.83 2.83M1 12h4M19 12h4M4.22 19.78l2.83-2.83M16.95 7.05l2.83-2.83"/></svg>
            </div>
            <h3>AI Assistant</h3>
            <p>Tommi AI siap bantu analisis stok, rekomendasi restock, dan insight bisnis berbasis data nyata.</p>
        </div>
    </div>
</section>

<!-- ── Roles ──────────────────────────────────────────────────────────────── -->
<section id="roles">
    <div class="section-head reveal">
        <div class="section-label">User Roles</div>
        <h2 class="section-title">Tiga Level Akses</h2>
        <p class="section-sub">Setiap peran punya akses yang tepat sesuai tanggung jawabnya.</p>
    </div>

    <div class="roles-grid">
        <div class="role-card reveal reveal-delay-1">
            <div class="role-emoji">
                <svg width="36" height="36" fill="none" stroke="currentColor" stroke-width="1.6" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 2l2.4 7.4H22l-6.2 4.5 2.4 7.4L12 17l-6.2 4.3 2.4-7.4L2 9.4h7.6L12 2z"/></svg>
            </div>
            <h3>Owner</h3>
            <p>Akses penuh ke laporan bisnis, analytics dashboard, manajemen akun, dan seluruh data penjualan.</p>
            <span class="role-tag">Full Analytics Access</span>
        </div>
        <div class="role-card reveal reveal-delay-2">
            <div class="role-emoji">
                <svg width="36" height="36" fill="none" stroke="currentColor" stroke-width="1.6" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path stroke-linecap="round" stroke-linejoin="round" d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z"/></svg>
            </div>
            <h3>Admin</h3>
            <p>Mengelola produk, kategori, dan stok barang. Dapat memperbarui data produk dan harga.</p>
            <span class="role-tag">Product & Stock</span>
        </div>
        <div class="role-card reveal reveal-delay-3">
            <div class="role-emoji">
                <svg width="36" height="36" fill="none" stroke="currentColor" stroke-width="1.6" viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"/><circle cx="20" cy="21" r="1"/><path stroke-linecap="round" stroke-linejoin="round" d="M1 1h4l2.68 13.39a2 2 0 002 1.61h9.72a2 2 0 001.97-1.67L23 6H6"/></svg>
            </div>
            <h3>Kasir</h3>
            <p>Melakukan transaksi penjualan, mencetak struk, dan mengelola pembayaran pelanggan.</p>
            <span class="role-tag">POS & Transactions</span>
        </div>
    </div>
</section>

<!-- ── Stats ──────────────────────────────────────────────────────────────── -->
<section id="stats">
    <div class="stats-grid">
        <div class="stat-card reveal reveal-delay-1">
            <div class="num">3</div>
            <p>User Roles</p>
        </div>
        <div class="stat-card reveal reveal-delay-2">
            <div class="num">6+</div>
            <p>Fitur Utama</p>
        </div>
        <div class="stat-card reveal reveal-delay-3">
            <div class="num">24/7</div>
            <p>System Access</p>
        </div>
        <div class="stat-card reveal reveal-delay-4">
            <div class="num">100%</div>
            <p>Integrated</p>
        </div>
    </div>
</section>

<!-- ── Technology ─────────────────────────────────────────────────────────── -->
<section id="technology">
    <div class="section-head reveal">
        <div class="section-label">Tech Stack</div>
        <h2 class="section-title">Dibangun dengan Teknologi Modern</h2>
        <p class="section-sub">Stack yang battle-tested untuk performa dan skalabilitas terbaik.</p>
    </div>

    <div class="tech-grid">
        <div class="tech-pill reveal reveal-delay-1">
            <div class="tech-icon tech-badge" style="background:rgba(255,69,0,0.15);color:#FF4500; display:flex; align-items:center; justify-content:center;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M22.046 7.422c-.053-.298-.246-.548-.521-.676l-8.877-4.148c-.413-.193-.892-.193-1.305 0l-8.875 4.148c-.276.129-.469.379-.522.677-.053.298.04.606.252.831l4.757 5.048c.189.2.457.315.733.315h4.636c.552 0 1-.448 1-1s-.448-1-1-1h-3.951l-3.32-3.523 7.394-3.456 7.394 3.456-3.87 4.106h-2.18c-.552 0-1 .448-1 1s.448 1 1 1h2.862c.277 0 .545-.116.734-.316l4.409-4.679c.211-.225.304-.533.25-.831zM12.871 16.486l-2.454 2.604-5.342-2.497c-.275-.129-.468-.379-.521-.677-.053-.298.04-.606.251-.83l1.83-1.942 2.658 2.82c.189.201.458.316.734.316h5.836l1.326-1.408h1.835l-2.617 2.778c-.189.2-.457.315-.733.315h-2.803z"/></svg>
            </div>
            <div class="tech-info">
                <div class="tech-name">Laravel 10</div>
                <div class="tech-desc">REST API Backend</div>
            </div>
        </div>
        <div class="tech-pill reveal reveal-delay-2">
            <div class="tech-icon tech-badge" style="background:rgba(70,150,255,0.15);color:#4696FF; display:flex; align-items:center; justify-content:center;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor"><path d="M14.314 0L2.3 12 6 15.7 21.684.01h-7.37z"/><path d="M10.791 15.518l-3.2 3.2.001.001 3.2 3.271H18.17l-6.443-6.471z"/><path d="M10.791 15.518l3.19 3.19 6.443-6.472h-7.37z"/></svg>
            </div>
            <div class="tech-info">
                <div class="tech-name">Flutter</div>
                <div class="tech-desc">Mobile & Web App</div>
            </div>
        </div>
        <div class="tech-pill reveal reveal-delay-3">
            <div class="tech-icon tech-badge" style="background:rgba(0,130,200,0.15);color:#0082C8">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/></svg>
            </div>
            <div class="tech-info">
                <div class="tech-name">MySQL 8</div>
                <div class="tech-desc">Database System</div>
            </div>
        </div>
        <div class="tech-pill reveal reveal-delay-4">
            <div class="tech-icon tech-badge" style="background:rgba(255,138,0,0.15);color:#FF8A00">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0110 0v4"/></svg>
            </div>
            <div class="tech-info">
                <div class="tech-name">Sanctum</div>
                <div class="tech-desc">Auth & Security</div>
            </div>
        </div>
        <div class="tech-pill reveal reveal-delay-5">
            <div class="tech-icon tech-badge" style="background:rgba(100,200,100,0.15);color:#44BB44">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>
            </div>
            <div class="tech-info">
                <div class="tech-name">Midtrans</div>
                <div class="tech-desc">Payment Gateway</div>
            </div>
        </div>
        <div class="tech-pill reveal reveal-delay-1">
            <div class="tech-icon tech-badge" style="background:rgba(180,100,255,0.15);color:#B464FF">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"/><path stroke-linecap="round" d="M12 1v4M12 19v4M4.22 4.22l2.83 2.83M16.95 16.95l2.83 2.83M1 12h4M19 12h4M4.22 19.78l2.83-2.83M16.95 7.05l2.83-2.83"/></svg>
            </div>
            <div class="tech-info">
                <div class="tech-name">OpenRouter AI</div>
                <div class="tech-desc">AI Assistant</div>
            </div>
        </div>
        <div class="tech-pill reveal reveal-delay-2">
            <div class="tech-icon tech-badge" style="background:rgba(30,150,255,0.15);color:#1E96FF">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="2" y="2" width="20" height="20" rx="5"/><path stroke-linecap="round" d="M7 10l5 5 5-5"/></svg>
            </div>
            <div class="tech-info">
                <div class="tech-name">Docker</div>
                <div class="tech-desc">Deployment</div>
            </div>
        </div>
        <div class="tech-pill reveal reveal-delay-3">
            <div class="tech-icon tech-badge" style="background:rgba(0,180,100,0.15);color:#00B464">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 014 10 15.3 15.3 0 01-4 10 15.3 15.3 0 01-4-10 15.3 15.3 0 014-10z"/></svg>
            </div>
            <div class="tech-info">
                <div class="tech-name">Nginx</div>
                <div class="tech-desc">Reverse Proxy</div>
            </div>
        </div>
    </div>
</section>

<!-- ── Download CTA ───────────────────────────────────────────────────────── -->
<section id="download">
    <div class="download-box reveal">
        <div class="section-label" style="margin-bottom:20px">Download</div>
        <h2>Coba Aplikasinya Sekarang</h2>
        <p>Download APK Tomodachi Pet Shop untuk Android dan mulai kelola toko hewan peliharaanmu dengan lebih cerdas.</p>
        <a href="https://drive.google.com/drive/folders/17kIPbwfhSULLZN9Ar4K1S5SmzqmR8c6e"
           target="_blank"
           rel="noopener noreferrer"
           class="btn-primary"
           style="display:inline-flex;">
            <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" d="M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2M7 10l5 5 5-5M12 15V3"/>
            </svg>
            Download APK Gratis
        </a>
    </div>
</section>

<!-- ── Contact ────────────────────────────────────────────────────────────── -->
<section id="contact" style="background: var(--bg3); text-align: center;">
    <div class="download-box reveal" style="border-color: rgba(37,211,102,0.15);">
        <div class="section-label" style="margin-bottom:20px; background: rgba(37,211,102,0.1); border-color: rgba(37,211,102,0.2); color: #25D366;">Contact Us</div>
        <h2>Butuh Customisasi Aplikasi?</h2>
        <p>Jika ingin menambahkan fitur, mengubah tema, atau customize aplikasi sesuai kebutuhan spesifik pet shop-mu, jangan ragu untuk menghubungi kami via WhatsApp.</p>
        <a href="https://wa.me/6285158173446"
           target="_blank"
           rel="noopener noreferrer"
           class="btn-whatsapp"
           style="display:inline-flex;">
            <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
                <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51a12.8 12.8 0 0 0-.57-.01c-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413Z"/>
            </svg>
            Hubungi via WhatsApp
        </a>
    </div>
</section>

<!-- ── Footer ─────────────────────────────────────────────────────────────── -->
<footer>
    <a href="#top" class="footer-logo">
        <img src="{{ asset('images/logo.png') }}" alt="Logo">
        <span>Tomodachi Pet Shop</span>
    </a>
    <p>© {{ date('Y') }} Tomodachi Pet Shop · Laravel · Flutter · AI</p>
    <div class="footer-links">
        <a href="#about">About</a>
        <a href="#features">Features</a>
        <a href="#download">Download</a>
        <a href="#contact">Contact</a>
    </div>
</footer>

<script>
/* ── Hamburger Menu ───────────────────────────────────────────────────────── */
const hamburgerBtn = document.getElementById('hamburgerBtn');
const mobileNav    = document.getElementById('mobileNav');

hamburgerBtn.addEventListener('click', () => {
    hamburgerBtn.classList.toggle('open');
    mobileNav.classList.toggle('open');
});

function closeMobileNav() {
    hamburgerBtn.classList.remove('open');
    mobileNav.classList.remove('open');
}

/* ── Scroll Reveal ───────────────────────────────────────────────────────── */
const revealEls = document.querySelectorAll('.reveal');

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('visible');
            observer.unobserve(entry.target);
        }
    });
}, { threshold: 0.12 });

revealEls.forEach(el => observer.observe(el));

/* ── Header Scroll Shadow ────────────────────────────────────────────────── */
const header = document.getElementById('top');
window.addEventListener('scroll', () => {
    if (window.scrollY > 20) {
        header.style.background = 'rgba(11,12,16,0.92)';
    } else {
        header.style.background = 'rgba(11,12,16,0.7)';
    }
});
</script>

</body>
</html>
