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
<script type="module" src="https://unpkg.com/@splinetool/viewer@1.12.98/build/spline-viewer.js"></script>

<style>
/* ── Reset & Base ─────────────────────────────────────────────────────────── */
*, *::before, *::after {
    margin: 0; padding: 0;
    box-sizing: border-box;
}

html {
    font-family: 'Plus Jakarta Sans', sans-serif;
    scroll-behavior: smooth;
}

:root {
    /* Primary palette — Indigo/Violet (populer: Linear, Notion, Figma) */
    --indigo:        #6366F1;
    --indigo-dark:   #4F46E5;
    --indigo-light:  #818CF8;
    --violet:        #8B5CF6;
    --violet-light:  #A78BFA;
    --pink:          #EC4899;

    /* Accent warm */
    --amber:         #F59E0B;
    --emerald:       #10B981;

    /* Dark backgrounds */
    --bg:            #0A0B14;
    --bg2:           #0F1020;
    --bg3:           #13152A;
    --surface:       #1A1D36;
    --surface2:      #222548;

    /* Glass */
    --glass:         rgba(255,255,255,0.04);
    --glass-border:  rgba(255,255,255,0.08);
    --glass-hover:   rgba(99,102,241,0.08);

    /* Text */
    --text:          #F1F5F9;
    --text-muted:    #94A3B8;
    --text-dim:      #64748B;

    /* Utility */
    --radius-xl:     20px;
    --radius-2xl:    28px;
    --radius-full:   9999px;
    --transition:    0.3s cubic-bezier(.4,0,.2,1);
    --shadow-glow:   0 0 40px rgba(99,102,241,0.25);
}

body {
    background: var(--bg);
    color: var(--text);
    overflow-x: hidden;
    line-height: 1.6;
}

/* ── Scrollbar ────────────────────────────────────────────────────────────── */
::-webkit-scrollbar { width: 5px; }
::-webkit-scrollbar-track { background: var(--bg); }
::-webkit-scrollbar-thumb {
    background: linear-gradient(var(--indigo), var(--violet));
    border-radius: 99px;
}

/* ── Background Orbs ──────────────────────────────────────────────────────── */
.bg-orbs {
    position: fixed; inset: 0;
    pointer-events: none; overflow: hidden; z-index: 0;
}
.orb {
    position: absolute; border-radius: 50%;
    filter: blur(80px); opacity: 0.4;
    animation: orbFloat 20s ease-in-out infinite;
}
.orb-1 {
    width: 500px; height: 500px;
    background: radial-gradient(circle, rgba(99,102,241,0.35), transparent 70%);
    top: -15%; left: -10%;
    animation-duration: 25s;
}
.orb-2 {
    width: 400px; height: 400px;
    background: radial-gradient(circle, rgba(139,92,246,0.3), transparent 70%);
    top: 40%; right: -10%;
    animation-duration: 18s; animation-delay: -8s;
}
.orb-3 {
    width: 300px; height: 300px;
    background: radial-gradient(circle, rgba(236,72,153,0.2), transparent 70%);
    bottom: 10%; left: 20%;
    animation-duration: 22s; animation-delay: -5s;
}
@keyframes orbFloat {
    0%, 100% { transform: translate(0,0) scale(1); }
    33%  { transform: translate(30px,-20px) scale(1.05); }
    66%  { transform: translate(-20px,30px) scale(0.97); }
}

/* Paw prints decorative */
.paw-bg {
    position: fixed; inset: 0; pointer-events: none;
    overflow: hidden; z-index: 0;
}
.paw {
    position: absolute;
    color: var(--indigo);
    opacity: 0.025;
    animation: floatPaw 14s ease-in-out infinite;
    user-select: none;
}
.paw svg { width: clamp(40px,5vw,72px); height: auto; }
.paw:nth-child(1) { top: 8%;  left: 5%;  animation-delay: 0s;   animation-duration: 16s; }
.paw:nth-child(2) { top: 30%; right:4%;  animation-delay: 2s;   animation-duration: 12s; }
.paw:nth-child(3) { top: 65%; left: 2%;  animation-delay: 5s;   animation-duration: 18s; }
.paw:nth-child(4) { top: 80%; right:10%; animation-delay: 1s;   animation-duration: 14s; }
.paw:nth-child(5) { top: 50%; left: 50%; animation-delay: 3.5s; animation-duration: 20s; }
@keyframes floatPaw {
    0%, 100% { transform: translateY(0) rotate(0deg); }
    50%       { transform: translateY(-22px) rotate(10deg); }
}

/* ── Header ──────────────────────────────────────────────────────────────── */
header {
    position: fixed; top: 0; left: 0; right: 0;
    z-index: 1000;
    display: flex; justify-content: space-between; align-items: center;
    padding: 14px 6%;
    background: rgba(10,11,20,0.6);
    backdrop-filter: blur(24px);
    -webkit-backdrop-filter: blur(24px);
    border-bottom: 1px solid var(--glass-border);
    transition: var(--transition);
}
header.scrolled {
    background: rgba(10,11,20,0.9);
    box-shadow: 0 4px 30px rgba(0,0,0,0.3);
}

.logo {
    display: flex; align-items: center; gap: 12px;
    text-decoration: none;
}
.logo img {
    width: 40px; height: 40px;
    border-radius: 12px; object-fit: cover;
    box-shadow: 0 0 0 2px rgba(99,102,241,0.5), 0 4px 12px rgba(99,102,241,0.3);
}
.logo-text {
    font-size: 18px; font-weight: 800;
    background: linear-gradient(90deg, var(--indigo-light), var(--violet-light));
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    background-clip: text;
}

nav { display: flex; align-items: center; gap: 4px; }
nav a {
    text-decoration: none; color: var(--text-muted);
    padding: 8px 14px; border-radius: 10px;
    font-size: 14px; font-weight: 500;
    transition: var(--transition);
}
nav a:hover { color: var(--text); background: var(--glass); }

.nav-cta {
    background: linear-gradient(135deg, var(--indigo), var(--indigo-dark)) !important;
    color: white !important;
    font-weight: 700 !important;
    padding: 9px 20px !important;
    border-radius: 10px !important;
    box-shadow: 0 4px 15px rgba(99,102,241,0.4) !important;
}
.nav-cta:hover {
    transform: translateY(-1px);
    box-shadow: 0 6px 20px rgba(99,102,241,0.5) !important;
    opacity: 1 !important;
}

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
.hamburger.open span:nth-child(1) { transform: rotate(45deg) translate(5px,5px); }
.hamburger.open span:nth-child(2) { opacity: 0; }
.hamburger.open span:nth-child(3) { transform: rotate(-45deg) translate(5px,-5px); }

.mobile-nav {
    display: none;
    position: fixed; top: 69px; left: 0; right: 0;
    background: rgba(10,11,20,0.98);
    backdrop-filter: blur(24px);
    padding: 16px 6%;
    border-bottom: 1px solid var(--glass-border);
    z-index: 999;
    flex-direction: column; gap: 4px;
}
.mobile-nav.open { display: flex; }
.mobile-nav a {
    text-decoration: none; color: var(--text-muted);
    padding: 12px 14px; border-radius: 10px;
    font-size: 15px; font-weight: 500;
    transition: var(--transition);
}
.mobile-nav a:hover { color: var(--text); background: var(--glass); }

/* ── HERO — Full Screen Split Layout ─────────────────────────────────────── */
.hero {
    min-height: 100vh;
    display: flex; align-items: center; justify-content: center;
    padding: 100px 6% 60px;
    position: relative; overflow: hidden;
}

/* Animated mesh grid */
.hero::before {
    content: '';
    position: absolute; inset: 0;
    background-image:
        linear-gradient(rgba(99,102,241,0.04) 1px, transparent 1px),
        linear-gradient(90deg, rgba(99,102,241,0.04) 1px, transparent 1px);
    background-size: 60px 60px;
    mask-image: radial-gradient(ellipse at 30% 50%, black 30%, transparent 75%);
    pointer-events: none;
}

/* Split wrapper */
.hero-inner {
    width: 100%; max-width: 1280px;
    position: relative; z-index: 1;
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 48px;
    align-items: center;
}

/* Left: text side */
.hero-left {
    display: flex; flex-direction: column; align-items: flex-start;
}

/* Right: Spline side */
.hero-right {
    position: relative;
    display: flex; align-items: center; justify-content: center;
    height: 640px;
}

/* Spline glow backdrop */
.hero-right::before {
    content: '';
    position: absolute; inset: 0;
    background: radial-gradient(ellipse at center, rgba(99,102,241,0.18) 0%, transparent 70%);
    border-radius: 50%; pointer-events: none;
    animation: glowPulse 4s ease-in-out infinite;
}
@keyframes glowPulse {
    0%, 100% { opacity: 0.7; transform: scale(1); }
    50%       { opacity: 1;   transform: scale(1.08); }
}

/* Spline iframe container */
.spline-wrap {
    width: 100%; height: 100%;
    position: relative; z-index: 1;
    /* pointer-events pass-through so Spline stays interactive */
}
.spline-wrap iframe {
    width: 100%; height: 100%;
    border: none;
    border-radius: 24px;
}

/* Live badge */
.hero-badge {
    display: inline-flex; align-items: center; gap: 8px;
    background: rgba(99,102,241,0.1);
    border: 1px solid rgba(99,102,241,0.3);
    color: var(--indigo-light);
    padding: 7px 18px; border-radius: var(--radius-full);
    font-size: 13px; font-weight: 600; letter-spacing: 0.2px;
    margin-bottom: 24px;
    align-self: flex-start;
}
.badge-dot {
    width: 8px; height: 8px;
    background: #4ADE80; border-radius: 50%;
    animation: pulse 2s infinite;
}
@keyframes pulse {
    0%, 100% { box-shadow: 0 0 0 0 rgba(74,222,128,0.6); }
    50%       { box-shadow: 0 0 0 6px rgba(74,222,128,0); }
}

/* Heading — rata kiri */
.hero h1 {
    font-size: clamp(32px, 4.5vw, 64px);
    font-weight: 900;
    line-height: 1.08;
    letter-spacing: -2.5px;
    margin-bottom: 20px;
    text-align: left;
}
.hero h1 .grad {
    background: linear-gradient(135deg, var(--indigo-light), var(--violet-light), #C084FC);
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    background-clip: text;
}

.hero-sub {
    font-size: clamp(14px, 1.5vw, 17px);
    color: var(--text-muted); line-height: 1.8;
    max-width: 480px; margin-bottom: 36px;
    text-align: left;
}

/* CTA Group — rata kiri */
.hero-cta {
    display: flex; flex-wrap: wrap; gap: 14px;
    justify-content: flex-start; align-items: center;
    margin-bottom: 44px;
}

.btn-primary {
    display: inline-flex; align-items: center; gap: 10px;
    padding: 16px 36px;
    background: linear-gradient(135deg, var(--indigo), var(--indigo-dark), var(--violet));
    color: white; text-decoration: none;
    border-radius: var(--radius-full); font-weight: 700; font-size: 16px;
    box-shadow: 0 8px 30px rgba(99,102,241,0.5), 0 0 0 1px rgba(255,255,255,0.1) inset;
    transition: var(--transition);
    position: relative; overflow: hidden;
    letter-spacing: -0.2px;
}
.btn-primary::after {
    content: '';
    position: absolute; inset: 0;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.18), transparent);
    transform: translateX(-100%);
    animation: shimmer 2.5s infinite;
}
@keyframes shimmer { 100% { transform: translateX(100%); } }
.btn-primary:hover {
    transform: translateY(-3px) scale(1.02);
    box-shadow: 0 14px 40px rgba(99,102,241,0.65), 0 0 0 1px rgba(255,255,255,0.12) inset;
}

.btn-secondary {
    display: inline-flex; align-items: center; gap: 10px;
    padding: 15px 32px;
    background: var(--glass);
    color: var(--text); text-decoration: none;
    border-radius: var(--radius-full); font-weight: 600; font-size: 15px;
    border: 1px solid rgba(255,255,255,0.1);
    backdrop-filter: blur(10px);
    transition: var(--transition);
}
.btn-secondary:hover {
    border-color: rgba(99,102,241,0.4);
    background: rgba(99,102,241,0.08);
    transform: translateY(-2px);
}

/* Hero stats bar — rata kiri */
.hero-stats {
    display: flex; gap: 28px; justify-content: flex-start;
    padding: 18px 28px;
    background: rgba(255,255,255,0.03);
    border: 1px solid var(--glass-border);
    border-radius: var(--radius-xl);
    backdrop-filter: blur(12px);
    align-self: flex-start;
}
.hero-stat { text-align: left; }
.hero-stat .num {
    font-size: 28px; font-weight: 900; line-height: 1;
    background: linear-gradient(135deg, var(--indigo-light), var(--violet-light));
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    background-clip: text;
}
.hero-stat .lbl { font-size: 12px; color: var(--text-muted); font-weight: 500; margin-top: 3px; }
.hero-stats-divider {
    width: 1px; background: var(--glass-border); align-self: stretch;
}

/* ── Section Base ────────────────────────────────────────────────────────── */
section { padding: 96px 6%; position: relative; z-index: 1; }

.section-label {
    display: inline-flex; align-items: center; gap: 6px;
    background: rgba(99,102,241,0.1);
    border: 1px solid rgba(99,102,241,0.25);
    color: var(--indigo-light);
    padding: 4px 14px; border-radius: var(--radius-full);
    font-size: 12px; font-weight: 700; letter-spacing: 1.2px;
    text-transform: uppercase; margin-bottom: 16px;
}
.section-title {
    font-size: clamp(26px, 4vw, 44px);
    font-weight: 800; letter-spacing: -1.2px;
    margin-bottom: 14px; line-height: 1.15;
}
.section-sub { color: var(--text-muted); font-size: 16px; max-width: 520px; line-height: 1.7; }
.section-head { margin-bottom: 56px; }

/* ── About ───────────────────────────────────────────────────────────────── */
#about { background: var(--bg2); }

.about-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
    gap: 20px;
}

.about-card {
    background: var(--glass);
    border: 1px solid var(--glass-border);
    border-radius: var(--radius-xl);
    padding: 32px;
    backdrop-filter: blur(12px);
    transition: var(--transition);
    position: relative; overflow: hidden;
}
.about-card::before {
    content: '';
    position: absolute; top: 0; left: 0; right: 0; height: 1px;
    background: linear-gradient(90deg, transparent, rgba(99,102,241,0.5), transparent);
    opacity: 0; transition: var(--transition);
}
.about-card:hover {
    border-color: rgba(99,102,241,0.3);
    transform: translateY(-6px);
    box-shadow: 0 20px 40px rgba(0,0,0,0.25), var(--shadow-glow);
    background: var(--glass-hover);
}
.about-card:hover::before { opacity: 1; }
.about-icon {
    width: 52px; height: 52px; border-radius: 14px;
    display: flex; align-items: center; justify-content: center;
    margin-bottom: 18px; flex-shrink: 0;
    /* background & border set via inline style per-card for unique color */
    background: rgba(99,102,241,0.12);
    border: 1px solid rgba(99,102,241,0.2);
    transition: var(--transition);
}
.about-card:hover .about-icon { transform: scale(1.1) rotate(-4deg); }
.about-card h3 { font-size: 17px; font-weight: 700; margin-bottom: 8px; text-align: left; }
.about-card p { font-size: 14px; color: var(--text-muted); line-height: 1.7; text-align: left; }

/* ── Features ────────────────────────────────────────────────────────────── */
#features { background: var(--bg3); }

.features-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 20px;
}

.feature-card {
    background: var(--glass);
    border: 1px solid var(--glass-border);
    border-radius: var(--radius-xl);
    padding: 30px;
    transition: var(--transition);
    backdrop-filter: blur(14px);
    position: relative; overflow: hidden;
    cursor: default;
}
.feature-card::after {
    content: '';
    position: absolute; bottom: 0; left: 0; right: 0; height: 2px;
    background: linear-gradient(90deg, var(--indigo), var(--violet));
    opacity: 0; transition: var(--transition);
}
.feature-card:hover {
    border-color: rgba(99,102,241,0.3);
    transform: translateY(-6px);
    box-shadow: 0 20px 50px rgba(0,0,0,0.3), 0 0 0 1px rgba(99,102,241,0.15);
    background: rgba(99,102,241,0.06);
}
.feature-card:hover::after { opacity: 1; }

.feature-icon-wrap {
    width: 56px; height: 56px; border-radius: 16px;
    display: flex; align-items: center; justify-content: center;
    margin-bottom: 20px;
    position: relative;
}
.feature-icon-wrap svg { position: relative; z-index: 1; }
.feature-card h3 {
    font-size: 17px; font-weight: 700; margin-bottom: 10px; color: var(--text); text-align: left;
}
.feature-card p { font-size: 14px; color: var(--text-muted); line-height: 1.75; text-align: left; }

/* ── Roles ───────────────────────────────────────────────────────────────── */
#roles { background: var(--bg2); }

.roles-grid {
    display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px;
}

.role-card {
    background: var(--glass);
    border: 1px solid var(--glass-border);
    border-radius: var(--radius-2xl);
    padding: 40px 30px; text-align: center;
    transition: var(--transition);
    backdrop-filter: blur(14px);
    position: relative; overflow: hidden;
}
.role-glow {
    position: absolute; inset: 0;
    opacity: 0; transition: var(--transition);
    pointer-events: none;
}
.role-card:hover .role-glow { opacity: 1; }
.role-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 24px 60px rgba(0,0,0,0.3);
}
/* Individual role accent colors */
.role-card.owner { --role-c: var(--amber); }
.role-card.admin  { --role-c: var(--indigo); }
.role-card.kasir  { --role-c: var(--emerald); }
.role-card:hover  { border-color: rgba(var(--role-rgb),0.3); }
.role-card.owner:hover  { border-color: rgba(245,158,11,0.35); box-shadow: 0 24px 60px rgba(0,0,0,0.3), 0 0 40px rgba(245,158,11,0.12); }
.role-card.admin:hover  { border-color: rgba(99,102,241,0.35); box-shadow: 0 24px 60px rgba(0,0,0,0.3), 0 0 40px rgba(99,102,241,0.12); }
.role-card.kasir:hover  { border-color: rgba(16,185,129,0.35); box-shadow: 0 24px 60px rgba(0,0,0,0.3), 0 0 40px rgba(16,185,129,0.12); }

.role-icon-wrap {
    width: 72px; height: 72px; border-radius: 20px;
    display: flex; align-items: center; justify-content: center;
    margin: 0 auto 20px; font-size: 32px;
    transition: var(--transition);
}
.role-card.owner .role-icon-wrap { background: rgba(245,158,11,0.12); border: 1px solid rgba(245,158,11,0.25); }
.role-card.admin  .role-icon-wrap { background: rgba(99,102,241,0.12); border: 1px solid rgba(99,102,241,0.25); }
.role-card.kasir  .role-icon-wrap { background: rgba(16,185,129,0.12); border: 1px solid rgba(16,185,129,0.25); }
.role-card:hover .role-icon-wrap { transform: scale(1.08) rotate(-4deg); }

.role-card h3 { font-size: 22px; font-weight: 800; margin-bottom: 12px; }
.role-card p { color: var(--text-muted); font-size: 14px; line-height: 1.75; margin-bottom: 20px; }
.role-tag {
    display: inline-block;
    padding: 5px 14px; border-radius: var(--radius-full);
    font-size: 12px; font-weight: 700; letter-spacing: 0.3px;
}
.role-card.owner .role-tag { background: rgba(245,158,11,0.12); color: #FCD34D; border: 1px solid rgba(245,158,11,0.25); }
.role-card.admin  .role-tag { background: rgba(99,102,241,0.12); color: var(--indigo-light); border: 1px solid rgba(99,102,241,0.25); }
.role-card.kasir  .role-tag { background: rgba(16,185,129,0.12); color: #6EE7B7; border: 1px solid rgba(16,185,129,0.25); }

/* ── Guide ───────────────────────────────────────────────────────────────── */
#guide { background: var(--bg3); }

.guide-grid {
    display: flex; flex-direction: column;
    max-width: 740px; margin: 0 auto; gap: 0;
}

.guide-item {
    display: flex; gap: 24px; align-items: stretch;
}
.guide-marker {
    display: flex; flex-direction: column; align-items: center; flex-shrink: 0;
}
.guide-step-num {
    display: inline-flex; align-items: center; justify-content: center;
    width: 40px; height: 40px; border-radius: 50%;
    background: linear-gradient(135deg, var(--indigo), var(--violet));
    color: white; font-size: 15px; font-weight: 800; flex-shrink: 0;
    box-shadow: 0 4px 16px rgba(99,102,241,0.4);
}
.guide-marker-line {
    flex: 1; width: 2px; min-height: 24px; margin: 8px 0;
    background: linear-gradient(var(--indigo), transparent);
    opacity: 0.4;
}
.guide-item:last-child .guide-marker-line { display: none; }

.guide-card {
    flex: 1;
    background: var(--glass);
    border: 1px solid var(--glass-border);
    border-radius: var(--radius-xl);
    padding: 28px 30px;
    margin-bottom: 24px;
    transition: var(--transition);
    backdrop-filter: blur(12px);
}
.guide-card:hover {
    border-color: rgba(99,102,241,0.3);
    transform: translateX(6px);
    box-shadow: 0 12px 40px rgba(0,0,0,0.2);
    background: rgba(99,102,241,0.05);
}
.guide-card h3 { font-size: 17px; font-weight: 700; margin-bottom: 8px; color: var(--text); }
.guide-card p  { font-size: 14px; color: var(--text-muted); line-height: 1.7; margin-bottom: 16px; }
.guide-steps {
    list-style: none;
    display: flex; flex-direction: column; gap: 10px;
    padding-top: 14px;
    border-top: 1px solid var(--glass-border);
}
.guide-steps li {
    position: relative; padding-left: 20px;
    font-size: 13px; color: var(--text-muted); line-height: 1.6;
}
.guide-steps li::before {
    content: '';
    position: absolute; left: 0; top: 6px;
    width: 7px; height: 7px; border-radius: 50%;
    background: linear-gradient(var(--indigo), var(--violet));
}
.guide-steps li strong { color: var(--text); font-weight: 600; }
.guide-steps li code {
    background: rgba(99,102,241,0.12);
    color: var(--indigo-light);
    padding: 1px 7px; border-radius: 5px; font-size: 12px;
}

/* ── Stats ───────────────────────────────────────────────────────────────── */
#stats { background: var(--bg2); }

.stats-grid {
    display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px;
}
.stat-card {
    background: var(--glass);
    border: 1px solid var(--glass-border);
    border-radius: var(--radius-xl);
    padding: 36px 24px; text-align: center;
    transition: var(--transition);
    backdrop-filter: blur(12px);
    position: relative; overflow: hidden;
}
.stat-card::before {
    content: '';
    position: absolute; top: 0; left: 50%; transform: translateX(-50%);
    width: 60%; height: 1px;
    background: linear-gradient(90deg, transparent, rgba(99,102,241,0.6), transparent);
}
.stat-card:hover {
    border-color: rgba(99,102,241,0.3);
    transform: translateY(-5px);
    box-shadow: 0 16px 40px rgba(0,0,0,0.2), var(--shadow-glow);
}
.stat-card .num {
    font-size: 52px; font-weight: 900; line-height: 1;
    background: linear-gradient(135deg, var(--indigo-light), var(--violet-light));
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-bottom: 10px;
}
.stat-card p { color: var(--text-muted); font-size: 14px; font-weight: 600; }

/* ── Technology ──────────────────────────────────────────────────────────── */
#technology { background: var(--bg3); }

.tech-grid {
    display: grid; grid-template-columns: repeat(auto-fit, minmax(185px, 1fr)); gap: 16px;
}
.tech-pill {
    background: var(--glass);
    border: 1px solid var(--glass-border);
    border-radius: var(--radius-xl); padding: 20px 18px;
    display: flex; align-items: center; gap: 14px;
    transition: var(--transition); backdrop-filter: blur(12px);
}
.tech-pill:hover {
    border-color: rgba(99,102,241,0.3);
    transform: translateY(-4px);
    background: rgba(99,102,241,0.05);
    box-shadow: 0 10px 30px rgba(0,0,0,0.2);
}
.tech-icon {
    width: 44px; height: 44px; border-radius: 12px; flex-shrink: 0;
    display: flex; align-items: center; justify-content: center;
}
.tech-name { font-size: 14px; font-weight: 700; margin-bottom: 2px; }
.tech-desc { font-size: 12px; color: var(--text-muted); }

/* ── Download CTA ────────────────────────────────────────────────────────── */
#download { background: var(--bg2); text-align: center; }

.download-box {
    position: relative; overflow: hidden;
    max-width: 720px; margin: auto;
    background: var(--glass);
    border: 1px solid rgba(99,102,241,0.2);
    border-radius: var(--radius-2xl);
    padding: 72px 56px;
    backdrop-filter: blur(20px);
}
/* Glow halo behind box */
.download-box::before {
    content: '';
    position: absolute; inset: -1px;
    border-radius: var(--radius-2xl);
    background: linear-gradient(135deg, rgba(99,102,241,0.3), rgba(139,92,246,0.2), transparent 60%);
    z-index: -1;
    filter: blur(20px);
}
.download-box::after {
    content: '';
    position: absolute; top: -60%; left: -60%;
    width: 220%; height: 220%;
    background: radial-gradient(circle at center, rgba(99,102,241,0.07) 0%, transparent 55%);
    pointer-events: none;
}
.download-box h2 {
    font-size: clamp(28px, 4.5vw, 46px); font-weight: 900;
    margin-bottom: 16px; letter-spacing: -1.5px;
}
.download-box h2 .grad {
    background: linear-gradient(135deg, var(--indigo-light), var(--violet-light));
    -webkit-background-clip: text; -webkit-text-fill-color: transparent;
    background-clip: text;
}
.download-box p {
    color: var(--text-muted); font-size: 16px; max-width: 480px;
    margin: 0 auto 40px; line-height: 1.75;
}
.download-cta-group {
    display: flex; flex-wrap: wrap; gap: 14px; justify-content: center; align-items: center;
    position: relative; z-index: 1;
}
/* Big CTA pulse animation */
.btn-cta-big {
    display: inline-flex; align-items: center; gap: 12px;
    padding: 18px 44px;
    background: linear-gradient(135deg, var(--indigo), var(--indigo-dark), var(--violet));
    color: white; text-decoration: none;
    border-radius: var(--radius-full); font-weight: 800; font-size: 17px;
    box-shadow: 0 10px 40px rgba(99,102,241,0.55), 0 0 0 1px rgba(255,255,255,0.1) inset;
    transition: var(--transition);
    position: relative; overflow: hidden;
    letter-spacing: -0.2px;
    animation: ctaPulse 3s ease-in-out infinite;
}
.btn-cta-big::after {
    content: '';
    position: absolute; inset: 0;
    background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
    transform: translateX(-100%);
    animation: shimmer 2s infinite;
}
@keyframes ctaPulse {
    0%, 100% { box-shadow: 0 10px 40px rgba(99,102,241,0.55), 0 0 0 1px rgba(255,255,255,0.1) inset; }
    50%       { box-shadow: 0 10px 60px rgba(99,102,241,0.75), 0 0 0 6px rgba(99,102,241,0.15), 0 0 0 1px rgba(255,255,255,0.1) inset; }
}
.btn-cta-big:hover {
    transform: translateY(-3px) scale(1.03);
    animation: none;
    box-shadow: 0 16px 50px rgba(99,102,241,0.7);
}

.btn-whatsapp {
    display: inline-flex; align-items: center; gap: 10px;
    padding: 16px 32px;
    background: #25D366; color: white; text-decoration: none;
    border-radius: var(--radius-full); font-weight: 700; font-size: 15px;
    box-shadow: 0 8px 28px rgba(37,211,102,0.35);
    transition: var(--transition);
}
.btn-whatsapp:hover {
    background: #128C7E;
    transform: translateY(-3px);
    box-shadow: 0 12px 36px rgba(37,211,102,0.45);
}

/* ── Contact ─────────────────────────────────────────────────────────────── */
#contact { background: var(--bg3); text-align: center; }

.contact-box {
    max-width: 640px; margin: auto;
    background: var(--glass);
    border: 1px solid rgba(37,211,102,0.2);
    border-radius: var(--radius-2xl);
    padding: 64px 48px;
    backdrop-filter: blur(20px);
    position: relative; overflow: hidden;
}
.contact-box::before {
    content: '';
    position: absolute; top: -60%; left: -60%;
    width: 220%; height: 220%;
    background: radial-gradient(circle at center, rgba(37,211,102,0.05) 0%, transparent 55%);
    pointer-events: none;
}
.contact-box h2 {
    font-size: clamp(24px, 4vw, 38px); font-weight: 900;
    margin-bottom: 14px; letter-spacing: -1px;
}
.contact-box p {
    color: var(--text-muted); font-size: 15px;
    max-width: 420px; margin: 0 auto 36px; line-height: 1.75;
}

/* ── Footer ──────────────────────────────────────────────────────────────── */
footer {
    background: var(--bg);
    border-top: 1px solid var(--glass-border);
    padding: 40px 6%;
    display: flex; justify-content: space-between; align-items: center;
    flex-wrap: wrap; gap: 20px;
}
.footer-logo {
    display: flex; align-items: center; gap: 10px; text-decoration: none;
}
.footer-logo img { width: 34px; height: 34px; border-radius: 9px; object-fit: cover; }
.footer-logo span { font-size: 15px; font-weight: 700; color: var(--text); }
footer p { color: var(--text-dim); font-size: 13px; }
.footer-links { display: flex; gap: 20px; }
.footer-links a {
    color: var(--text-dim); text-decoration: none;
    font-size: 13px; transition: var(--transition);
}
.footer-links a:hover { color: var(--indigo-light); }

/* ── Scroll Reveal ───────────────────────────────────────────────────────── */
.reveal {
    opacity: 0; transform: translateY(28px);
    transition: opacity 0.65s ease, transform 0.65s ease;
}
.reveal.visible { opacity: 1; transform: none; }
.reveal-delay-1 { transition-delay: 0.1s; }
.reveal-delay-2 { transition-delay: 0.2s; }
.reveal-delay-3 { transition-delay: 0.3s; }
.reveal-delay-4 { transition-delay: 0.4s; }
.reveal-delay-5 { transition-delay: 0.5s; }

/* ═══════════════════════════════════════════════════════════════════════════
   RESPONSIVE — Mobile · Tablet · Laptop · Desktop
   ═══════════════════════════════════════════════════════════════════════════
   Breakpoints:
     xs  : ≤ 480px   (small phone)
     sm  : ≤ 640px   (phone)
     md  : ≤ 768px   (large phone / small tablet)
     lg  : ≤ 1024px  (tablet / laptop)
     xl  : > 1024px  (desktop) — default styles above
   ═══════════════════════════════════════════════════════════════════════════ */

/* ── Laptop / Tablet Landscape (≤ 1024px) ────────────────────────────────── */
@media (max-width: 1024px) {
    section { padding: 80px 5%; }

    .hero { padding: 110px 5% 70px; }
    .hero-inner { grid-template-columns: 1fr 1fr; gap: 32px; }
    .hero-right { height: 520px; }
    .hero h1 { font-size: clamp(28px, 4.5vw, 48px); }

    .about-grid { grid-template-columns: repeat(2, 1fr); }
    .features-grid { grid-template-columns: repeat(2, 1fr); }
    .roles-grid { grid-template-columns: repeat(3, 1fr); }
    .stats-grid { grid-template-columns: repeat(2, 1fr); }
    .tech-grid  { grid-template-columns: repeat(3, 1fr); }

    .download-box { padding: 60px 44px; }
    .contact-box  { padding: 56px 40px; }
}

/* ── Tablet Portrait (≤ 768px) ───────────────────────────────────────────── */
@media (max-width: 768px) {
    nav { display: none; }
    .hamburger { display: flex; }

    section { padding: 72px 5%; }

    /* Hero: stack Spline atas, teks bawah */
    .hero { padding: 90px 5% 56px; }
    .hero-inner {
        grid-template-columns: 1fr;
        grid-template-rows: auto auto;
        gap: 16px;
    }
    .hero-left { align-items: center; order: 2; }
    .hero-right { order: 1; height: 380px; }
    .hero h1 { font-size: clamp(28px, 7vw, 42px); letter-spacing: -1.5px; text-align: center; }
    .hero-sub { font-size: 15px; text-align: center; max-width: 100%; }
    .hero-badge { align-self: center; }
    .hero-cta { justify-content: center; }
    .hero-stats { align-self: center; justify-content: center; gap: 20px; padding: 16px 20px; }
    .hero-stat { text-align: center; }

    /* Grids */
    .about-grid    { grid-template-columns: repeat(2, 1fr); gap: 14px; }
    .features-grid { grid-template-columns: repeat(2, 1fr); gap: 14px; }
    .roles-grid    { grid-template-columns: 1fr; gap: 16px; }
    .stats-grid    { grid-template-columns: repeat(2, 1fr); gap: 14px; }
    .tech-grid     { grid-template-columns: repeat(2, 1fr); gap: 12px; }

    .role-card { padding: 28px 20px; }
    .role-icon-wrap { width: 56px; height: 56px; border-radius: 16px; }
    .about-card   { padding: 22px; }
    .feature-card { padding: 22px; }
    .stat-card    { padding: 28px 16px; }
    .stat-card .num { font-size: 40px; }
    .guide-grid { max-width: 100%; }
    .guide-card { padding: 22px 20px; }
    .download-box { padding: 44px 24px; }
    .contact-box  { padding: 40px 20px; }
    .btn-cta-big  { padding: 16px 32px; font-size: 15px; }
    .tech-pill { padding: 16px 14px; }

    footer { flex-direction: column; text-align: center; align-items: center; }
    .footer-links { flex-wrap: wrap; justify-content: center; }
}

/* ── Small Phone (≤ 640px) ───────────────────────────────────────────────── */
@media (max-width: 640px) {
    section { padding: 60px 4%; }

    /* Hero */
    .hero { padding: 90px 4% 48px; }
    .hero-mascot { width: 100px; height: 100px; }
    .hero h1 { font-size: clamp(26px, 8vw, 38px); letter-spacing: -1px; }
    .hero-sub { font-size: 14px; }

    /* Grids collapse to 1 col */
    .about-grid    { grid-template-columns: 1fr; gap: 12px; }
    .features-grid { grid-template-columns: 1fr; gap: 12px; }
    .tech-grid     { grid-template-columns: repeat(2, 1fr); gap: 10px; }

    /* Section headings */
    .section-title { font-size: clamp(22px, 6vw, 30px); }

    /* Stats */
    .stats-grid { grid-template-columns: repeat(2, 1fr); gap: 10px; }
    .stat-card  { padding: 24px 12px; }
    .stat-card .num { font-size: 36px; }
}

/* ── Tiny Phone (≤ 480px) ────────────────────────────────────────────────── */
@media (max-width: 480px) {
    header { padding: 12px 4%; }

    section { padding: 52px 4%; }

    /* Hero full adjustments */
    .hero { padding: 80px 4% 44px; }
    .hero-mascot { width: 90px; height: 90px; }
    .hero h1 { font-size: clamp(24px, 9vw, 34px); letter-spacing: -0.8px; }
    .hero-stats { flex-direction: column; gap: 12px; padding: 16px; }
    .hero-stats-divider { display: none; }
    .hero-stat .num { font-size: 24px; }
    .hero-cta { flex-direction: column; align-items: stretch; }
    .btn-primary, .btn-secondary { justify-content: center; padding: 14px 20px; font-size: 14px; }
    .btn-cta-big { padding: 14px 24px; font-size: 14px; }

    /* Cards full width */
    .about-grid    { grid-template-columns: 1fr; }
    .features-grid { grid-template-columns: 1fr; }
    .stats-grid    { grid-template-columns: 1fr; }
    .tech-grid     { grid-template-columns: 1fr 1fr; }

    /* Compress cards */
    .about-card   { padding: 18px; }
    .feature-card { padding: 18px; }
    .about-icon, .feature-icon-wrap { width: 44px; height: 44px; border-radius: 12px; }

    /* Download box */
    .download-box { padding: 36px 16px; }
    .download-box h2 { font-size: clamp(20px, 7vw, 28px); }
    .contact-box  { padding: 32px 16px; }
    .contact-box h2 { font-size: clamp(18px, 7vw, 26px); }

    /* Guide */
    .guide-card { padding: 18px 16px; }
    .guide-item { gap: 16px; }
    .guide-step-num { width: 34px; height: 34px; font-size: 13px; }

    /* Tech pills */
    .tech-pill { padding: 12px; gap: 10px; }
    .tech-icon { width: 36px; height: 36px; border-radius: 10px; }
    .tech-name { font-size: 12px; }
    .tech-desc { font-size: 11px; }

    /* Role cards */
    .role-card { padding: 28px 18px; }
    .role-icon-wrap { width: 60px; height: 60px; }

    /* Logo compact */
    .logo-text { display: none; }
}
</style>
</head>
<body>

<!-- Background orbs -->
<div class="bg-orbs" aria-hidden="true">
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>
    <div class="orb orb-3"></div>
</div>

<!-- Floating paw prints -->
<div class="paw-bg" aria-hidden="true">
    @for($i = 0; $i < 5; $i++)
    <div class="paw">
        <svg viewBox="0 0 64 64" fill="currentColor">
            <ellipse cx="12" cy="18" rx="7" ry="9"/>
            <ellipse cx="32" cy="10" rx="7" ry="9"/>
            <ellipse cx="52" cy="18" rx="7" ry="9"/>
            <ellipse cx="22" cy="26" rx="7" ry="9"/>
            <path d="M32 30c-10 0-18 6-18 16 0 7 4 12 10 13 3 1 5 3 8 3s5-2 8-3c6-1 10-6 10-13 0-10-8-16-18-16z"/>
        </svg>
    </div>
    @endfor
</div>

<!-- ── Header ──────────────────────────────────────────────────────────────── -->
<header id="top">
    <a href="#hero" class="logo">
        <img src="{{ asset('images/logo.png') }}" alt="Tomodachi Logo">
        <span class="logo-text">Tomodachi</span>
    </a>

    <nav>
        <a href="#about">About</a>
        <a href="#features">Features</a>
        <a href="#roles">Roles</a>
        <a href="#guide">Panduan</a>
        <a href="#technology">Tech</a>
        <a href="#contact">Kontak</a>
        <a href="#download" class="nav-cta">⬇ Download APK</a>
    </nav>

    <button class="hamburger" id="hamburgerBtn" aria-label="Toggle menu">
        <span></span><span></span><span></span>
    </button>
</header>

<div class="mobile-nav" id="mobileNav">
    <a href="#about"      onclick="closeMobileNav()">About</a>
    <a href="#features"   onclick="closeMobileNav()">Features</a>
    <a href="#roles"      onclick="closeMobileNav()">Roles</a>
    <a href="#guide"      onclick="closeMobileNav()">Panduan</a>
    <a href="#technology" onclick="closeMobileNav()">Technology</a>
    <a href="#contact"    onclick="closeMobileNav()">Kontak</a>
    <a href="#download"   onclick="closeMobileNav()">Download APK</a>
</div>

<!-- ── HERO — Full Screen Split Layout ───────────────────────────────────── -->
<section class="hero" id="hero">
    <div class="hero-inner">

        <!-- LEFT: Text Content -->
        <div class="hero-left">

            <!-- Live badge -->
            <div class="hero-badge reveal">
                <span class="badge-dot"></span>
                Sistem Aktif &amp; Online
            </div>

            <!-- Heading -->
            <h1 class="reveal reveal-delay-1">
                Smart <span class="grad">Pet Shop</span><br>
                Management System
            </h1>

            <p class="hero-sub reveal reveal-delay-2">
                Kelola produk, stok, transaksi, laporan bisnis, dan AI assistant
                dalam satu platform modern. Dibangun dengan Laravel &amp; Flutter.
            </p>

            <!-- CTA Buttons -->
            <div class="hero-cta reveal reveal-delay-3">
                <a href="#download" class="btn-primary" id="hero-download-btn">
                    <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2M7 10l5 5 5-5M12 15V3"/>
                    </svg>
                    Download APK Gratis
                </a>
                <a href="#features" class="btn-secondary" id="hero-explore-btn">
                    <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M13 7l5 5-5 5M6 12h12"/>
                    </svg>
                    Lihat Fitur
                </a>
            </div>

            <!-- Stats bar -->
            <div class="hero-stats reveal reveal-delay-4">
                <div class="hero-stat">
                    <div class="num">3</div>
                    <div class="lbl">User Roles</div>
                </div>
                <div class="hero-stats-divider"></div>
                <div class="hero-stat">
                    <div class="num">6+</div>
                    <div class="lbl">Fitur Utama</div>
                </div>
                <div class="hero-stats-divider"></div>
                <div class="hero-stat">
                    <div class="num">24/7</div>
                    <div class="lbl">Akses Penuh</div>
                </div>
            </div>

        </div><!-- /hero-left -->

        <!-- RIGHT: Spline 3D Phone -->
        <div class="hero-right reveal reveal-delay-2">
            <div class="spline-wrap">
                <spline-viewer url="https://prod.spline.design/zyTPcjocDDxl7BTj/scene.splinecode"></spline-viewer>
            </div>
        </div><!-- /hero-right -->

    </div>
</section>

<!-- ── About ───────────────────────────────────────────────────────────────── -->
<section id="about">
    <div class="section-head reveal">
        <div class="section-label">About</div>
        <h2 class="section-title">Kenapa Tomodachi?</h2>
        <p class="section-sub">
            Solusi manajemen pet shop yang modern, cepat, dan mudah digunakan —
            dari kasir hingga owner, semua terkontrol dalam satu sistem.
        </p>
    </div>
    <div class="about-grid">
        <div class="about-card reveal reveal-delay-1">
            <div class="about-icon" style="background:rgba(99,102,241,0.12);border-color:rgba(99,102,241,0.25);color:#818CF8;">
                <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                </svg>
            </div>
            <h3>Super Cepat</h3>
            <p>Transaksi kasir selesai dalam hitungan detik. Performa tinggi dioptimasi untuk kebutuhan toko sehari-hari.</p>
        </div>
        <div class="about-card reveal reveal-delay-2">
            <div class="about-icon" style="background:rgba(16,185,129,0.12);border-color:rgba(16,185,129,0.25);color:#6EE7B7;">
                <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                    <path stroke-linecap="round" d="M7 11V7a5 5 0 0110 0v4"/>
                </svg>
            </div>
            <h3>Aman &amp; Terpercaya</h3>
            <p>Auth berbasis Laravel Sanctum, enkripsi data, CAPTCHA, dan role-based access control yang ketat.</p>
        </div>
        <div class="about-card reveal reveal-delay-3">
            <div class="about-icon" style="background:rgba(139,92,246,0.12);border-color:rgba(139,92,246,0.25);color:#C084FC;">
                <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="3"/>
                    <path stroke-linecap="round" d="M19.4 15a1.65 1.65 0 00.33 1.82l.06.06a2 2 0 010 2.83 2 2 0 01-2.83 0l-.06-.06a1.65 1.65 0 00-1.82-.33 1.65 1.65 0 00-1 1.51V21a2 2 0 01-4 0v-.09A1.65 1.65 0 009 19.4a1.65 1.65 0 00-1.82.33l-.06.06a2 2 0 01-2.83-2.83l.06-.06A1.65 1.65 0 004.68 15a1.65 1.65 0 00-1.51-1H3a2 2 0 010-4h.09A1.65 1.65 0 004.6 9a1.65 1.65 0 00-.33-1.82l-.06-.06a2 2 0 012.83-2.83l.06.06A1.65 1.65 0 009 4.68a1.65 1.65 0 001-1.51V3a2 2 0 014 0v.09a1.65 1.65 0 001 1.51 1.65 1.65 0 001.82-.33l.06-.06a2 2 0 012.83 2.83l-.06.06A1.65 1.65 0 0019.4 9a1.65 1.65 0 001.51 1H21a2 2 0 010 4h-.09a1.65 1.65 0 00-1.51 1z"/>
                </svg>
            </div>
            <h3>AI-Powered</h3>
            <p>Tommi AI Assistant siap memberikan insight bisnis, rekomendasi stok, dan analisis data secara otomatis.</p>
        </div>
        <div class="about-card reveal reveal-delay-4">
            <div class="about-icon" style="background:rgba(56,189,248,0.12);border-color:rgba(56,189,248,0.25);color:#7DD3FC;">
                <svg width="24" height="24" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                    <rect x="5" y="2" width="14" height="20" rx="2" ry="2"/>
                    <line x1="12" y1="18" x2="12.01" y2="18" stroke-linecap="round" stroke-width="2.5"/>
                </svg>
            </div>
            <h3>Multi Platform</h3>
            <p>Tersedia sebagai web dashboard dan aplikasi Android Flutter, semua terhubung ke satu backend terpusat.</p>
        </div>
    </div>
</section>

<!-- ── Features ───────────────────────────────────────────────────────────── -->
<section id="features">
    <div class="section-head reveal">
        <div class="section-label">Features</div>
        <h2 class="section-title">Fitur Lengkap untuk Pet Shop Modern</h2>
        <p class="section-sub">Semua yang kamu butuhkan untuk mengelola bisnis pet shop secara efisien.</p>
    </div>
    <div class="features-grid">

        <div class="feature-card reveal reveal-delay-1">
            <div class="feature-icon-wrap" style="background:rgba(99,102,241,0.12);border:1px solid rgba(99,102,241,0.25);">
                <svg width="26" height="26" fill="none" stroke="#818CF8" stroke-width="1.8" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 10V11"/>
                </svg>
            </div>
            <h3>Product Management</h3>
            <p>Kelola produk, harga, SKU, dan gambar dengan mudah. Sinkron antara stok offline dan online.</p>
        </div>

        <div class="feature-card reveal reveal-delay-2">
            <div class="feature-icon-wrap" style="background:rgba(245,158,11,0.12);border:1px solid rgba(245,158,11,0.25);">
                <svg width="26" height="26" fill="none" stroke="#FCD34D" stroke-width="1.8" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A2 2 0 013 12V7a4 4 0 014-4z"/>
                </svg>
            </div>
            <h3>Category Management</h3>
            <p>Kategorisasi produk berdasarkan jenis hewan dan sub-kategori untuk pencarian yang lebih cepat.</p>
        </div>

        <div class="feature-card reveal reveal-delay-3">
            <div class="feature-icon-wrap" style="background:rgba(16,185,129,0.12);border:1px solid rgba(16,185,129,0.25);">
                <svg width="26" height="26" fill="none" stroke="#6EE7B7" stroke-width="1.8" viewBox="0 0 24 24">
                    <rect x="1" y="4" width="22" height="16" rx="2" ry="2"/>
                    <line x1="1" y1="10" x2="23" y2="10"/>
                </svg>
            </div>
            <h3>POS Transactions</h3>
            <p>Transaksi kasir cepat dengan dukungan pembayaran tunai, QRIS, dan transfer via Midtrans.</p>
        </div>

        <div class="feature-card reveal reveal-delay-4">
            <div class="feature-icon-wrap" style="background:rgba(139,92,246,0.12);border:1px solid rgba(139,92,246,0.25);">
                <svg width="26" height="26" fill="none" stroke="#C084FC" stroke-width="1.8" viewBox="0 0 24 24">
                    <line x1="18" y1="20" x2="18" y2="10"/>
                    <line x1="12" y1="20" x2="12" y2="4"/>
                    <line x1="6"  y1="20" x2="6"  y2="14"/>
                </svg>
            </div>
            <h3>Analytics Dashboard</h3>
            <p>Pantau performa bisnis real-time: pendapatan, transaksi, produk terlaris, dan alert stok.</p>
        </div>

        <div class="feature-card reveal reveal-delay-5">
            <div class="feature-icon-wrap" style="background:rgba(236,72,153,0.12);border:1px solid rgba(236,72,153,0.25);">
                <svg width="26" height="26" fill="none" stroke="#F9A8D4" stroke-width="1.8" viewBox="0 0 24 24">
                    <polyline points="22 7 13.5 15.5 8.5 10.5 2 17"/>
                    <polyline points="16 7 22 7 22 13"/>
                </svg>
            </div>
            <h3>Sales Reports</h3>
            <p>Laporan penjualan harian, mingguan, dan bulanan yang dapat difilter dan diekspor.</p>
        </div>

        <div class="feature-card reveal reveal-delay-1">
            <div class="feature-icon-wrap" style="background:rgba(56,189,248,0.12);border:1px solid rgba(56,189,248,0.25);">
                <svg width="26" height="26" fill="none" stroke="#7DD3FC" stroke-width="1.8" viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="3"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 1v4M12 19v4M4.22 4.22l2.83 2.83M16.95 16.95l2.83 2.83M1 12h4M19 12h4M4.22 19.78l2.83-2.83M16.95 7.05l2.83-2.83"/>
                </svg>
            </div>
            <h3>AI Assistant</h3>
            <p>Tommi AI siap bantu analisis stok, rekomendasi restock, dan insight bisnis berbasis data nyata.</p>
        </div>

    </div>
</section>

<!-- ── Roles ───────────────────────────────────────────────────────────────── -->
<section id="roles">
    <div class="section-head reveal">
        <div class="section-label">User Roles</div>
        <h2 class="section-title">Tiga Level Akses</h2>
        <p class="section-sub">Setiap peran punya akses yang tepat sesuai tanggung jawabnya.</p>
    </div>
    <div class="roles-grid">

        <div class="role-card owner reveal reveal-delay-1">
            <div class="role-icon-wrap">
                <!-- Crown / trophy icon for Owner -->
                <svg width="30" height="30" fill="none" stroke="#FCD34D" stroke-width="1.7" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M2 20h20M4 20l2-8 4 4 2-7 2 7 4-4 2 8"/>
                    <circle cx="12" cy="5" r="2" fill="#FCD34D" stroke="none"/>
                    <circle cx="4" cy="10" r="1.5" fill="#FCD34D" stroke="none"/>
                    <circle cx="20" cy="10" r="1.5" fill="#FCD34D" stroke="none"/>
                </svg>
            </div>
            <h3 style="text-align: left;">Owner</h3>
            <p style="text-align: left;">Akses penuh ke laporan bisnis, analytics dashboard, manajemen akun, dan seluruh data penjualan.</p>
            <div style="text-align: left;"><span class="role-tag">Full Analytics Access</span></div>
        </div>

        <div class="role-card admin reveal reveal-delay-2">
            <div class="role-icon-wrap">
                <!-- Shield / admin icon -->
                <svg width="30" height="30" fill="none" stroke="#818CF8" stroke-width="1.7" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 2l7 4v5c0 5-3.5 9.74-7 11C8.5 20.74 5 16 5 11V6l7-4z"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4"/>
                </svg>
            </div>
            <h3 style="text-align: left;">Admin</h3>
            <p style="text-align: left;">Mengelola produk, kategori, dan stok barang. Dapat memperbarui data produk dan harga secara lengkap.</p>
            <div style="text-align: left;"><span class="role-tag">Product &amp; Stock</span></div>
        </div>

        <div class="role-card kasir reveal reveal-delay-3">
            <div class="role-icon-wrap">
                <!-- POS / cashier icon -->
                <svg width="30" height="30" fill="none" stroke="#6EE7B7" stroke-width="1.7" viewBox="0 0 24 24">
                    <rect x="2" y="3" width="20" height="14" rx="2"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="M8 21h8M12 17v4"/>
                    <path stroke-linecap="round" stroke-linejoin="round" d="M7 8h2m2 0h2m2 0h2M7 11h2m2 0h2"/>
                </svg>
            </div>
            <h3 style="text-align: left;">Kasir</h3>
            <p style="text-align: left;">Melakukan transaksi penjualan, mencetak struk, dan mengelola pembayaran pelanggan dengan mudah.</p>
            <div style="text-align: left;"><span class="role-tag">POS &amp; Transactions</span></div>
        </div>

    </div>
</section>

<!-- ── Panduan Pengguna ────────────────────────────────────────────────────── -->
<section id="guide">
    <div class="section-head reveal">
        <div class="section-label">Panduan</div>
        <h2 class="section-title">Cara Menggunakan Tomodachi</h2>
        <p class="section-sub">Mulai kelola toko hewan peliharaanmu hanya dengan beberapa langkah mudah.</p>
    </div>

    <div class="guide-grid">

        <div class="guide-item reveal reveal-delay-1">
            <div class="guide-marker">
                <span class="guide-step-num">1</span>
                <div class="guide-marker-line"></div>
            </div>
            <div class="guide-card">
                <h3>Download &amp; Install APK</h3>
                <p>Siapkan aplikasi Tomodachi di perangkat Android kamu sebelum mulai digunakan.</p>
                <ol class="guide-steps">
                    <li>Klik tombol <strong>Download APK</strong> di navbar atau bagian Download halaman ini.</li>
                    <li>Buka file <code>.apk</code> yang terunduh dan izinkan instalasi jika diminta sistem.</li>
                    <li>Tunggu instalasi selesai, lalu buka aplikasi Tomodachi.</li>
                </ol>
            </div>
        </div>

        <div class="guide-item reveal reveal-delay-2">
            <div class="guide-marker">
                <span class="guide-step-num">2</span>
                <div class="guide-marker-line"></div>
            </div>
            <div class="guide-card">
                <h3>Login &amp; Akses Dashboard</h3>
                <p>Masuk dengan akun terdaftar, tampilan menu menyesuaikan otomatis sesuai peran.</p>
                <ol class="guide-steps">
                    <li>Buka menu <strong>Login</strong>, masukkan email dan password akun.</li>
                    <li><strong>Owner</strong> masuk ke dashboard analytics, <strong>Admin</strong> ke menu produk, <strong>Kasir</strong> ke halaman POS.</li>
                    <li>Lupa password? Hubungi Owner toko untuk reset akun.</li>
                </ol>
            </div>
        </div>

        <div class="guide-item reveal reveal-delay-3">
            <div class="guide-marker">
                <span class="guide-step-num">3</span>
                <div class="guide-marker-line"></div>
            </div>
            <div class="guide-card">
                <h3>Kelola Produk &amp; Stok</h3>
                <p>Langkah untuk Owner dan Admin dalam mengatur data produk dan stok barang.</p>
                <ol class="guide-steps">
                    <li>Buka menu <strong>Produk</strong>, klik <strong>Tambah Produk</strong>, isi nama, kategori, dan harga.</li>
                    <li>Stok berkurang otomatis setiap ada transaksi dari Kasir.</li>
                    <li>Sistem mengirim notifikasi jika stok mulai menipis.</li>
                </ol>
            </div>
        </div>

        <div class="guide-item reveal reveal-delay-4">
            <div class="guide-marker">
                <span class="guide-step-num">4</span>
                <div class="guide-marker-line"></div>
            </div>
            <div class="guide-card">
                <h3>Lakukan Transaksi POS</h3>
                <p>Alur transaksi cepat untuk peran Kasir saat melayani pelanggan.</p>
                <ol class="guide-steps">
                    <li>Pilih produk dari katalog, total dihitung otomatis.</li>
                    <li>Pilih metode pembayaran: tunai, QRIS, atau transfer via Midtrans.</li>
                    <li>Cetak atau kirim struk digital ke pelanggan.</li>
                </ol>
            </div>
        </div>

        <div class="guide-item reveal reveal-delay-5">
            <div class="guide-marker">
                <span class="guide-step-num">5</span>
                <div class="guide-marker-line"></div>
            </div>
            <div class="guide-card">
                <h3>Pantau Laporan &amp; AI Assistant</h3>
                <p>Fitur khusus Owner untuk memantau performa bisnis dan mendapat insight otomatis.</p>
                <ol class="guide-steps">
                    <li>Buka menu <strong>Laporan</strong>, filter data berdasarkan tanggal atau kategori.</li>
                    <li>Tanya <strong>Tommi AI Assistant</strong> untuk rekomendasi restock dan insight bisnis.</li>
                    <li>Export laporan jika dibutuhkan untuk arsip atau presentasi.</li>
                </ol>
            </div>
        </div>

    </div>
</section>

<!-- ── Stats ───────────────────────────────────────────────────────────────── -->
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

<!-- ── Technology ──────────────────────────────────────────────────────────── -->
<section id="technology">
    <div class="section-head reveal">
        <div class="section-label">Tech Stack</div>
        <h2 class="section-title">Dibangun dengan Teknologi Modern</h2>
        <p class="section-sub">Stack yang battle-tested untuk performa dan skalabilitas terbaik.</p>
    </div>
    <div class="tech-grid">

        <div class="tech-pill reveal reveal-delay-1">
            <div class="tech-icon" style="background:rgba(255,69,0,0.12);color:#FF4500;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M22.046 7.422c-.053-.298-.246-.548-.521-.676l-8.877-4.148c-.413-.193-.892-.193-1.305 0l-8.875 4.148c-.276.129-.469.379-.522.677-.053.298.04.606.252.831l4.757 5.048c.189.2.457.315.733.315h4.636c.552 0 1-.448 1-1s-.448-1-1-1h-3.951l-3.32-3.523 7.394-3.456 7.394 3.456-3.87 4.106h-2.18c-.552 0-1 .448-1 1s.448 1 1 1h2.862c.277 0 .545-.116.734-.316l4.409-4.679c.211-.225.304-.533.25-.831z"/>
                </svg>
            </div>
            <div>
                <div class="tech-name">Laravel 10</div>
                <div class="tech-desc">REST API Backend</div>
            </div>
        </div>

        <div class="tech-pill reveal reveal-delay-2">
            <div class="tech-icon" style="background:rgba(70,150,255,0.12);color:#4696FF;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M14.314 0L2.3 12 6 15.7 21.684.01h-7.37z"/>
                    <path d="M10.791 15.518l-3.2 3.2.001.001 3.2 3.271H18.17l-6.443-6.471z"/>
                    <path d="M10.791 15.518l3.19 3.19 6.443-6.472h-7.37z"/>
                </svg>
            </div>
            <div>
                <div class="tech-name">Flutter</div>
                <div class="tech-desc">Mobile &amp; Web App</div>
            </div>
        </div>

        <div class="tech-pill reveal reveal-delay-3">
            <div class="tech-icon" style="background:rgba(0,130,200,0.12);color:#0082C8;">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <ellipse cx="12" cy="5" rx="9" ry="3"/>
                    <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/>
                    <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>
                </svg>
            </div>
            <div>
                <div class="tech-name">MySQL 8</div>
                <div class="tech-desc">Database System</div>
            </div>
        </div>

        <div class="tech-pill reveal reveal-delay-4">
            <div class="tech-icon" style="background:rgba(99,102,241,0.12);color:#818CF8;">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                    <path d="M7 11V7a5 5 0 0110 0v4"/>
                </svg>
            </div>
            <div>
                <div class="tech-name">Sanctum</div>
                <div class="tech-desc">Auth &amp; Security</div>
            </div>
        </div>

        <div class="tech-pill reveal reveal-delay-5">
            <div class="tech-icon" style="background:rgba(16,185,129,0.12);color:#6EE7B7;">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <rect x="1" y="4" width="22" height="16" rx="2" ry="2"/>
                    <line x1="1" y1="10" x2="23" y2="10"/>
                </svg>
            </div>
            <div>
                <div class="tech-name">Midtrans</div>
                <div class="tech-desc">Payment Gateway</div>
            </div>
        </div>

        <div class="tech-pill reveal reveal-delay-1">
            <div class="tech-icon" style="background:rgba(180,100,255,0.12);color:#C084FC;">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="3"/>
                    <path stroke-linecap="round" d="M12 1v4M12 19v4M4.22 4.22l2.83 2.83M16.95 16.95l2.83 2.83M1 12h4M19 12h4M4.22 19.78l2.83-2.83M16.95 7.05l2.83-2.83"/>
                </svg>
            </div>
            <div>
                <div class="tech-name">OpenRouter AI</div>
                <div class="tech-desc">AI Assistant</div>
            </div>
        </div>

        <div class="tech-pill reveal reveal-delay-2">
            <div class="tech-icon" style="background:rgba(30,150,255,0.12);color:#60A5FA;">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <rect x="2" y="2" width="20" height="20" rx="5"/>
                    <path stroke-linecap="round" d="M7 10l5 5 5-5"/>
                </svg>
            </div>
            <div>
                <div class="tech-name">Docker</div>
                <div class="tech-desc">Deployment</div>
            </div>
        </div>

        <div class="tech-pill reveal reveal-delay-3">
            <div class="tech-icon" style="background:rgba(0,180,100,0.12);color:#34D399;">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="10"/>
                    <line x1="2" y1="12" x2="22" y2="12"/>
                    <path d="M12 2a15.3 15.3 0 014 10 15.3 15.3 0 01-4 10 15.3 15.3 0 01-4-10 15.3 15.3 0 014-10z"/>
                </svg>
            </div>
            <div>
                <div class="tech-name">Nginx</div>
                <div class="tech-desc">Reverse Proxy</div>
            </div>
        </div>

    </div>
</section>

<!-- ── Download CTA ────────────────────────────────────────────────────────── -->
<section id="download">
    <div class="download-box reveal">
        <div class="section-label" style="margin-bottom:20px;">Download</div>
        <h2>Coba Aplikasinya <span class="grad">Sekarang</span></h2>
        <p>Download APK Tomodachi Pet Shop untuk Android dan mulai kelola toko hewan peliharaanmu dengan lebih cerdas dan efisien.</p>
        <div class="download-cta-group">
            <a href="https://drive.google.com/drive/folders/17kIPbwfhSULLZN9Ar4K1S5SmzqmR8c6e"
               target="_blank" rel="noopener noreferrer"
               class="btn-cta-big" id="main-download-btn">
                <svg width="22" height="22" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M4 16v2a2 2 0 002 2h12a2 2 0 002-2v-2M7 10l5 5 5-5M12 15V3"/>
                </svg>
                Download APK Gratis
            </a>
        </div>
    </div>
</section>

<!-- ── Contact ─────────────────────────────────────────────────────────────── -->
<section id="contact">
    <div class="contact-box reveal">
        <div class="section-label" style="background:rgba(37,211,102,0.1);border-color:rgba(37,211,102,0.25);color:#4ADE80;margin-bottom:20px;">
            Contact Us
        </div>
        <h2>Butuh Customisasi Aplikasi?</h2>
        <p>Ingin menambahkan fitur, mengubah tema, atau customize aplikasi sesuai kebutuhan spesifik pet shop-mu? Hubungi kami langsung via WhatsApp.</p>
        <a href="https://wa.me/6285158173446"
           target="_blank" rel="noopener noreferrer"
           class="btn-whatsapp" id="whatsapp-contact-btn"
           style="display:inline-flex;">
            <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
                <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51a12.8 12.8 0 0 0-.57-.01c-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 0 1-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 0 1-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 0 1 2.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0 0 12.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 0 0 5.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 0 0-3.48-8.413Z"/>
            </svg>
            Hubungi via WhatsApp
        </a>
    </div>
</section>

<!-- ── Footer ──────────────────────────────────────────────────────────────── -->
<footer>
    <a href="#hero" class="footer-logo">
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
/* ── Hamburger Menu ─────────────────────────────────────────────────────────── */
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

/* ── Header scroll ──────────────────────────────────────────────────────────── */
const header = document.querySelector('header');
window.addEventListener('scroll', () => {
    header.classList.toggle('scrolled', window.scrollY > 20);
}, { passive: true });

/* ── Scroll Reveal ──────────────────────────────────────────────────────────── */
const revealEls = document.querySelectorAll('.reveal');

const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('visible');
            revealObserver.unobserve(entry.target);
        }
    });
}, { threshold: 0.1 });

revealEls.forEach(el => revealObserver.observe(el));

/* ── Active nav highlight on scroll ─────────────────────────────────────────── */
const sections = document.querySelectorAll('section[id], .hero[id]');
const navLinks  = document.querySelectorAll('nav a:not(.nav-cta)');

const navObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            navLinks.forEach(link => {
                link.style.color = '';
                if (link.getAttribute('href') === '#' + entry.target.id) {
                    link.style.color = '#818CF8';
                }
            });
        }
    });
}, { threshold: 0.4 });

sections.forEach(s => navObserver.observe(s));
</script>

</body>
</html>