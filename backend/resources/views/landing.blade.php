<!DOCTYPE html>
<html lang="id">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="Tomodachi Pet Shop POS - Sistem manajemen toko hewan peliharaan modern berbasis Laravel & Flutter dengan tema alam yang segar.">
<title>Tomodachi Pet Shop POS - Smart Pet Shop Management</title>

<link rel="canonical" href="{{ url('/') }}">
<link rel="preload" href="{{ asset('images/cat.png') }}" as="image" fetchpriority="high">
<meta property="og:type" content="website">
<meta property="og:url" content="{{ url('/') }}">
<meta property="og:title" content="Tomodachi Pet Shop POS">
<meta property="og:description" content="Kelola produk, stok, transaksi, laporan bisnis, dan AI assistant dalam satu platform modern.">
<meta property="og:image" content="{{ asset('images/cat.png') }}">
<meta property="twitter:card" content="summary_large_image">
<meta property="twitter:url" content="{{ url('/') }}">
<meta property="twitter:title" content="Tomodachi Pet Shop POS">
<meta property="twitter:description" content="Sistem manajemen toko hewan peliharaan modern berbasis Laravel & Flutter.">
<meta property="twitter:image" content="{{ asset('images/cat.png') }}">

<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "{{ url('/') }}#organization",
      "name": "Tomodachi Pet Shop",
      "url": "{{ url('/') }}",
      "logo": { "@type": "ImageObject", "url": "{{ asset('images/logo.png') }}" },
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
      "publisher": { "@id": "{{ url('/') }}#organization" }
    }
  ]
}
</script>

<link rel="icon" type="image/png" href="{{ asset('images/logo.png') }}">
<link href="https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@500;600;700;800&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
<script type="module" src="https://unpkg.com/@google/model-viewer@3.5.0/dist/model-viewer.min.js"></script>

<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
:root {
    --bg: #1d1b18;
    --panel: rgba(40, 37, 32, 0.84);
    --panel-strong: rgba(50, 45, 38, 0.94);
    --line: rgba(255, 231, 205, 0.28);
    --line-hot: rgba(255, 143, 22, 0.68);
    --orange: #ff8a00;
    --orange-soft: #ffe4bd;
    --cyan: #fff6eb;
    --green: #ffad32;
    --leaf: #ffc266;
    --moss: #d75f00;
    --text: #fffaf3;
    --muted: #ead6c2;
    --dark: #171512;
    --radius: 8px;
    --ease: cubic-bezier(.2,.8,.2,1);
}

html { scroll-behavior: smooth; scroll-padding-top: 80px; }
body {
    min-height: 100vh;
    overflow-x: hidden;
    background:
        radial-gradient(circle at 78% 12%, rgba(255, 255, 255, 0.09), transparent 26%),
        radial-gradient(circle at 14% 6%, rgba(255, 138, 0, 0.16), transparent 28%),
        linear-gradient(135deg, rgba(255, 138, 0, .12), transparent 35%),
        linear-gradient(180deg, #2a2722 0%, #1d1b18 48%, #171512 100%);
    color: var(--text);
    font-family: Inter, system-ui, sans-serif;
}

body::before {
    content: "";
    position: fixed;
    inset: 0;
    pointer-events: none;
    z-index: -2;
    background-image:
        radial-gradient(ellipse at 12% 0%, rgba(255, 138, 0, .18), transparent 30%),
        radial-gradient(ellipse at 86% 0%, rgba(255, 255, 255, .09), transparent 34%),
        linear-gradient(120deg, transparent 0 34%, rgba(255, 255, 255, .06) 35%, transparent 36% 100%);
    mask-image: linear-gradient(to bottom, #000 0 72%, transparent 100%);
    animation: forestLight 9s ease-in-out infinite;
}

body::after {
    content: "";
    position: fixed;
    inset: 0;
    pointer-events: none;
    z-index: -1;
    background:
        radial-gradient(circle at 20% calc(14% + var(--scroll-shift, 0%)), rgba(255, 255, 255, .12), transparent 24%),
        linear-gradient(115deg, transparent 0 38%, rgba(255,255,255,0.075) 39%, transparent 40% 100%);
    animation: sunbeamDrift 11s ease-in-out infinite;
}

::-webkit-scrollbar { width: 8px; }
::-webkit-scrollbar-track { background: var(--dark); }
::-webkit-scrollbar-thumb { background: linear-gradient(var(--orange), #fff7ed); border-radius: 99px; }

.shell-lines {
    position: fixed;
    inset: 0;
    pointer-events: none;
    overflow: hidden;
    z-index: 0;
}
.shell-lines::before,
.shell-lines::after {
    content: "";
    position: absolute;
    pointer-events: none;
    opacity: .62;
}
.shell-lines::before {
    width: 34vw;
    height: 34vw;
    right: -9vw;
    top: 16vh;
    border: 1px solid rgba(255, 226, 189, .22);
    border-radius: 50%;
    box-shadow: inset 0 0 56px rgba(255, 180, 92, .1), 0 0 70px rgba(255, 255, 255, .08);
    animation: canopySway 18s ease-in-out infinite;
}
.shell-lines::after {
    left: -12vw;
    bottom: 8vh;
    width: 42vw;
    height: 2px;
    background: linear-gradient(90deg, transparent, rgba(255, 123, 32, .72), rgba(255, 255, 255, .62), transparent);
    filter: drop-shadow(0 0 14px rgba(255, 164, 72, .42));
    transform: rotate(-24deg);
    animation: grassGlimmer 5.4s ease-in-out infinite;
}
.spark {
    position: absolute;
    top: 0;
    width: 18px;
    height: 10px;
    border-radius: 90% 0 90% 0;
    background: linear-gradient(135deg, rgba(255, 246, 235, .95), rgba(255, 132, 36, .82));
    box-shadow: 0 0 18px rgba(255, 164, 72, .24);
    transform-origin: 50% 50%;
    animation: leafFall 12s linear infinite;
}
.spark:nth-child(1) { left: 9%; animation-delay: -1s; }
.spark:nth-child(2) { left: 24%; animation-delay: -5s; }
.spark:nth-child(3) { left: 52%; animation-delay: -3s; }
.spark:nth-child(4) { left: 70%; animation-delay: -7s; }
.spark:nth-child(5) { left: 88%; animation-delay: -2s; }
.spark:nth-child(6) { left: 16%; animation-delay: -8s; animation-duration: 9.4s; background: linear-gradient(135deg, #fff7ed, #ff9a3c); }
.spark:nth-child(7) { left: 37%; animation-delay: -4.2s; animation-duration: 13.2s; }
.spark:nth-child(8) { left: 61%; animation-delay: -6.8s; animation-duration: 10.4s; background: linear-gradient(135deg, #ffe2bd, #f47c20); }
.spark:nth-child(9) { left: 79%; animation-delay: -9.1s; animation-duration: 14s; }
.energy-streak {
    position: absolute;
    width: min(360px, 34vw);
    height: 70px;
    border-radius: 999px;
    background:
        radial-gradient(ellipse at 50% 50%, rgba(255,255,255,.2), transparent 52%),
        linear-gradient(90deg, transparent, rgba(255, 164, 72, .3), rgba(255, 255, 255, .22), transparent);
    filter: blur(.2px);
    opacity: 0;
    transform: rotate(-22deg);
    animation: sunRaySweep 7.8s ease-in-out infinite;
}
.energy-streak.one { left: 4%; top: 24%; animation-delay: -1.2s; }
.energy-streak.two { right: 8%; top: 64%; animation-delay: -3.7s; --streak-rotate: -33deg; }
.energy-streak.three { left: 32%; bottom: 18%; animation-delay: -5.1s; --streak-rotate: 18deg; }
.circuit-node {
    position: absolute;
    width: 16px;
    height: 16px;
    background: rgba(255, 209, 138, .85);
    box-shadow: 0 0 22px rgba(255, 209, 138, .35);
    clip-path: polygon(50% 0, 62% 34%, 98% 36%, 68% 57%, 79% 92%, 50% 70%, 21% 92%, 32% 57%, 2% 36%, 38% 34%);
    animation: fireflyPulse 2.8s ease-in-out infinite;
}
.circuit-node.one { left: 11%; top: 34%; }
.circuit-node.two { right: 18%; top: 22%; animation-delay: -.9s; background: rgba(255, 246, 235, .86); box-shadow: 0 0 20px rgba(255, 255, 255, .34); }
.circuit-node.three { right: 9%; bottom: 18%; animation-delay: -1.7s; }

.nature-vines {
    position: fixed;
    inset: 0;
    pointer-events: none;
    overflow: hidden;
    z-index: 1;
}
.nature-vines span {
    position: absolute;
    top: -80px;
    width: 26px;
    height: 14px;
    border-radius: 90% 0 90% 0;
    background: linear-gradient(135deg, rgba(255, 247, 237, .96), rgba(244, 124, 32, .84));
    box-shadow: 0 0 20px rgba(255, 164, 72, .18);
    opacity: .7;
    animation: leafFallSoft 15s linear infinite;
}
.nature-vines span:nth-child(1) { left: 6%; animation-delay: -2s; }
.nature-vines span:nth-child(2) { left: 18%; animation-delay: -9s; animation-duration: 18s; transform: scale(.74); }
.nature-vines span:nth-child(3) { left: 31%; animation-delay: -5s; background: linear-gradient(135deg, #fff7ed, #ff9a3c); }
.nature-vines span:nth-child(4) { left: 47%; animation-delay: -13s; animation-duration: 20s; transform: scale(1.18); }
.nature-vines span:nth-child(5) { left: 63%; animation-delay: -7s; animation-duration: 16s; }
.nature-vines span:nth-child(6) { left: 78%; animation-delay: -11s; background: linear-gradient(135deg, #ffe2bd, #f47c20); }
.nature-vines span:nth-child(7) { left: 91%; animation-delay: -4s; animation-duration: 19s; transform: scale(.82); }

.sky-birds {
    position: fixed;
    inset: 0;
    z-index: 1;
    pointer-events: none;
    overflow: hidden;
}
.sky-birds .guide-bird {
    top: var(--bird-top, 18vh);
    width: var(--bird-size, 54px);
    color: rgba(255, 248, 238, .78);
    animation-duration: var(--bird-speed, 18s);
    animation-delay: var(--bird-delay, 0s);
}
.sky-birds .guide-bird:nth-child(1) { --bird-top: 14vh; --bird-size: 58px; --bird-speed: 17s; --bird-delay: -2s; }
.sky-birds .guide-bird:nth-child(2) { --bird-top: 29vh; --bird-size: 42px; --bird-speed: 21s; --bird-delay: -9s; opacity: .64; }
.sky-birds .guide-bird:nth-child(3) { --bird-top: 47vh; --bird-size: 50px; --bird-speed: 24s; --bird-delay: -15s; opacity: .58; }
.sky-birds .guide-bird:nth-child(4) { --bird-top: 66vh; --bird-size: 46px; --bird-speed: 19s; --bird-delay: -6s; opacity: .54; }
.sky-birds .guide-bird:nth-child(5) { --bird-top: 82vh; --bird-size: 38px; --bird-speed: 26s; --bird-delay: -18s; opacity: .46; }
.sky-birds .guide-bird:nth-child(6) { --bird-top: 20vh; --bird-size: 36px; --bird-speed: 14s; --bird-delay: -11s; opacity: .6; }
.sky-birds .guide-bird:nth-child(7) { --bird-top: 38vh; --bird-size: 64px; --bird-speed: 23s; --bird-delay: -4s; opacity: .7; }
.sky-birds .guide-bird:nth-child(8) { --bird-top: 56vh; --bird-size: 34px; --bird-speed: 18s; --bird-delay: -13s; opacity: .5; }
.sky-birds .guide-bird:nth-child(9) { --bird-top: 73vh; --bird-size: 58px; --bird-speed: 28s; --bird-delay: -21s; opacity: .42; }

header {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 100;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 20px;
    padding: 14px clamp(18px, 5vw, 78px);
    background: rgba(29, 27, 24, 0.68);
    border-bottom: 1px solid rgba(255, 226, 189, 0.18);
    backdrop-filter: blur(18px);
    -webkit-backdrop-filter: blur(18px);
    transition: background .25s var(--ease), box-shadow .25s var(--ease), border-color .25s var(--ease);
}
header.scrolled {
    background: rgba(23, 21, 18, 0.95);
    border-color: var(--line);
    box-shadow: 0 12px 36px rgba(0, 0, 0, 0.32);
}
.brand {
    display: inline-flex;
    align-items: center;
    gap: 12px;
    color: var(--text);
    text-decoration: none;
    min-width: max-content;
}
.brand-mark {
    width: 46px;
    height: 46px;
    display: grid;
    place-items: center;
    border-radius: 50%;
    overflow: hidden;
    background: transparent;
    flex-shrink: 0;
}
.brand-mark img {
    width: 100%;
    height: 100%;
    object-fit: contain;
    display: block;
    animation: insigniaCharge 3.2s ease-in-out infinite;
}
.brand-text {
    font-family: "Barlow Condensed", Inter, sans-serif;
    font-size: 30px;
    line-height: 1;
    font-weight: 800;
    letter-spacing: .02em;
    color: var(--orange-soft);
    text-shadow: 0 0 20px rgba(255, 138, 31, 0.38);
}

nav {
    display: flex;
    align-items: center;
    gap: 8px;
}
nav a, .mobile-nav a {
    position: relative;
    overflow: hidden;
    color: var(--muted);
    text-decoration: none;
    font-weight: 700;
    font-size: 14px;
    padding: 10px 12px;
    border: 1px solid transparent;
    transition: color .2s var(--ease), border-color .2s var(--ease), background .2s var(--ease);
}
nav a::before, .mobile-nav a::before,
.btn-primary::before, .btn-ghost::before, .btn-whatsapp::before {
    content: "";
    position: absolute;
    inset: 0;
    pointer-events: none;
    background: linear-gradient(110deg, transparent, rgba(255,255,255,.24), transparent);
    transform: translateX(-125%);
    transition: transform .55s var(--ease);
}
nav a:hover, .mobile-nav a:hover {
    color: var(--orange-soft);
    border-color: rgba(255, 138, 31, 0.28);
    background: rgba(255, 138, 31, 0.08);
}
nav a:hover::before, .mobile-nav a:hover::before,
.btn-primary:hover::before, .btn-ghost:hover::before, .btn-whatsapp:hover::before {
    transform: translateX(125%);
}
.nav-cta, .btn-primary {
    position: relative;
    overflow: hidden;
    color: #fff !important;
    background: linear-gradient(180deg, #fff4e4, #ff9a3c 46%, #d95f12);
    border: 1px solid rgba(255, 247, 237, 0.86) !important;
    border-radius: 999px;
    box-shadow: 0 0 0 4px rgba(255, 164, 72, 0.14), 0 0 28px rgba(255, 164, 72, 0.3);
}
.hamburger {
    display: none;
    width: 42px;
    height: 42px;
    border: 1px solid var(--line);
    background: rgba(255,255,255,.03);
    color: var(--text);
    cursor: pointer;
}
.hamburger span {
    display: block;
    width: 20px;
    height: 2px;
    margin: 5px auto;
    background: currentColor;
    transition: transform .2s var(--ease), opacity .2s var(--ease);
}
.hamburger.open span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
.hamburger.open span:nth-child(2) { opacity: 0; }
.hamburger.open span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }
.mobile-nav {
    display: none;
    position: fixed;
    top: 75px;
    left: 0;
    right: 0;
    z-index: 90;
    padding: 16px 22px 22px;
    background: rgba(2, 7, 13, .96);
    border-bottom: 1px solid var(--line);
}
.mobile-nav.open { display: grid; }

.hero {
    min-height: 100vh;
    position: relative;
    display: grid;
    place-items: center;
    padding: 16px;
    background:
        radial-gradient(circle at 18% 12%, rgba(255, 138, 0, .28), transparent 28%),
        radial-gradient(circle at 82% 36%, rgba(255, 194, 102, .16), transparent 32%),
        linear-gradient(180deg, #302d28 0%, #1d1b18 58%, #171512 100%);
    overflow: hidden;
}
.hero::before {
    content: none;
}
.hero::after {
    content: none;
}
.hero-showcase {
    position: relative;
    width: 100%;
    height: calc(100vh - 32px);
    min-height: 520px;
    overflow: hidden;
    border: 1px solid rgba(255, 247, 237, .34);
    background:
        radial-gradient(circle at 16% 18%, rgba(255, 138, 0, .24), transparent 20%),
        radial-gradient(circle at 76% 28%, rgba(255, 255, 255, .08), transparent 26%),
        linear-gradient(180deg, #34302a 0%, #211f1b 54%, #171512 100%);
    border-radius: 18px;
    box-shadow: 0 22px 70px rgba(0, 0, 0, .28);
}
.hero-showcase::before {
    content: "";
    position: absolute;
    inset: 0;
    z-index: 1;
    pointer-events: none;
    background:
        linear-gradient(90deg, rgba(35, 16, 4, .58) 0%, rgba(35, 16, 4, .18) 48%, transparent 72%),
        radial-gradient(circle at 12% 22%, rgba(255, 255, 255, .34), transparent 12%),
        radial-gradient(circle at 73% 32%, rgba(255, 164, 72, .18), transparent 22%);
}
.hero-showcase::after {
    content: "";
    position: absolute;
    inset: 0;
    z-index: 1;
    pointer-events: none;
    background: linear-gradient(110deg, transparent 0 45%, rgba(255, 241, 191, .18) 46%, transparent 47% 100%);
    mix-blend-mode: screen;
    animation: heroSunSweep 8s linear infinite;
}
.hero-showcase img {
    display: none;
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: center center;
    opacity: .32;
    filter: saturate(.9) contrast(.82) sepia(.18);
    animation: heroBreath 8s ease-in-out infinite;
}
.hero-nature {
    position: absolute;
    inset: 0;
    z-index: 2;
    pointer-events: none;
    overflow: hidden;
    background:
        radial-gradient(circle at 16% 16%, rgba(255, 255, 255, .62), transparent 11%),
        linear-gradient(180deg, rgba(255, 247, 237, .2), transparent 42%);
}
.hero-nature::before {
    content: "";
    position: absolute;
    left: -8%;
    right: -8%;
    bottom: -12%;
    height: 54%;
    background:
        radial-gradient(ellipse at 15% 88%, #f47c20 0 34%, transparent 35%),
        radial-gradient(ellipse at 42% 86%, #bd6423 0 38%, transparent 39%),
        radial-gradient(ellipse at 75% 88%, #9c4b16 0 42%, transparent 43%),
        linear-gradient(180deg, transparent 0 38%, rgba(94, 36, 7, .96) 39% 100%);
    filter: drop-shadow(0 -16px 28px rgba(94, 36, 7, .26));
}
.hero-nature::after {
    content: "";
    position: absolute;
    inset: -8% -6% auto -6%;
    height: 42%;
    background:
        radial-gradient(ellipse at 12% 0%, rgba(255, 170, 83, .76) 0 26%, transparent 27%),
        radial-gradient(ellipse at 38% -8%, rgba(255, 246, 235, .64) 0 30%, transparent 31%),
        radial-gradient(ellipse at 72% 0%, rgba(218, 95, 18, .7) 0 28%, transparent 29%),
        radial-gradient(ellipse at 94% -4%, rgba(255, 190, 118, .66) 0 22%, transparent 23%);
    animation: canopySway 15s ease-in-out infinite;
}
.hero-energy {
    position: absolute;
    inset: 0;
    z-index: 3;
    pointer-events: none;
    overflow: hidden;
}
.hero-energy .ember {
    position: absolute;
    width: 4px;
    height: 4px;
    border-radius: 50%;
    background: #fff7ed;
    box-shadow: 0 0 18px #ff9a3c, 0 0 34px rgba(255, 164, 72, .35);
    opacity: 0;
    animation: emberRise 4.8s linear infinite;
}
.hero-energy .ember:nth-child(1) { left: 42%; bottom: 8%; animation-delay: -.4s; }
.hero-energy .ember:nth-child(2) { left: 50%; bottom: 3%; animation-delay: -1.6s; animation-duration: 5.8s; }
.hero-energy .ember:nth-child(3) { left: 62%; bottom: 9%; animation-delay: -2.7s; animation-duration: 4.2s; }
.hero-energy .ember:nth-child(4) { left: 78%; bottom: 12%; animation-delay: -1s; animation-duration: 6.2s; }
.hero-energy .ember:nth-child(5) { left: 86%; bottom: 22%; animation-delay: -3.5s; }
.hero-energy .bolt {
    position: absolute;
    width: 110px;
    height: 44px;
    border-radius: 100% 0 100% 0;
    background: linear-gradient(135deg, rgba(255, 247, 237, .9), rgba(255, 132, 36, .7));
    filter: drop-shadow(0 0 10px rgba(255, 164, 72, .34));
    transform: rotate(-28deg);
    opacity: 0;
    animation: boltFlash 3.6s ease-in-out infinite;
}
.hero-energy .bolt.one { right: 18%; top: 30%; }
.hero-energy .bolt.two { right: 8%; top: 58%; animation-delay: -1.8s; transform: rotate(-38deg); }
.hero-cat-stage {
    position: absolute;
    inset: 9% 6% 8% 48%;
    z-index: 3;
    display: grid;
    place-items: center;
    pointer-events: none;
}
.hero-cat-stage::before,
.hero-cat-stage::after {
    content: "";
    position: absolute;
    border-radius: 50%;
    pointer-events: none;
}
.hero-cat-stage::before {
    width: min(38vw, 520px);
    aspect-ratio: 1;
    background:
        radial-gradient(circle at 48% 42%, rgba(255, 247, 237, .46), transparent 26%),
        radial-gradient(circle at 50% 50%, rgba(255, 138, 0, .22), transparent 54%),
        conic-gradient(from 45deg, rgba(255, 138, 0, .08), rgba(255, 246, 235, .62), rgba(255, 173, 50, .18), rgba(255, 246, 235, .48), rgba(255, 138, 0, .08));
    border: 1px solid rgba(255, 247, 237, .32);
    filter: drop-shadow(0 0 46px rgba(255, 164, 72, .3));
    opacity: .9;
    animation: catAuraSpin 16s linear infinite;
}
.hero-cat-stage::after {
    width: min(30vw, 405px);
    aspect-ratio: 1;
    border: 1px solid rgba(255, 247, 237, .5);
    box-shadow:
        inset 0 0 44px rgba(255, 164, 72, .18),
        0 0 40px rgba(255, 164, 72, .22);
    animation: catRingPulse 3.8s ease-in-out infinite;
}
.hero-cat-card {
    position: relative;
    width: min(30vw, 410px);
    aspect-ratio: 1;
    display: grid;
    place-items: center;
    isolation: isolate;
    transform-style: preserve-3d;
    animation: catFloat 5.6s ease-in-out infinite;
}
.hero-cat-card::before {
    content: "";
    position: absolute;
    inset: -8%;
    z-index: -2;
    border-radius: 50%;
    background:
        radial-gradient(circle at 36% 25%, rgba(255, 255, 255, .58), transparent 20%),
        radial-gradient(circle at 50% 56%, rgba(255, 138, 0, .34), rgba(255, 194, 102, .17) 50%, transparent 72%);
    box-shadow:
        inset 0 0 70px rgba(255, 247, 237, .16),
        0 32px 80px rgba(0, 0, 0, .28),
        0 0 42px rgba(255, 164, 72, .26);
    transform: translateY(12px) scale(1.02);
    animation: catShadowPulse 5.6s ease-in-out infinite;
}
.hero-cat-card::after {
    content: "";
    position: absolute;
    inset: -10%;
    z-index: 2;
    border-radius: 50%;
    background: linear-gradient(115deg, transparent 0 34%, rgba(255,255,255,.72) 40%, transparent 48% 100%);
    mix-blend-mode: screen;
    opacity: 0;
    transform: translateX(-42%) rotate(-14deg);
    animation: catShine 4.4s ease-in-out infinite;
}
.hero-cat-card img {
    display: block;
    width: 100%;
    height: 100%;
    object-fit: contain;
    object-position: center;
    opacity: 1;
    filter:
        drop-shadow(0 24px 24px rgba(0, 0, 0, .34))
        drop-shadow(0 0 34px rgba(255, 164, 72, .42));
    animation: catPop 3.6s ease-in-out infinite;
}
.cat-sparkle {
    position: absolute;
    width: 14px;
    height: 14px;
    background: #fff7ed;
    clip-path: polygon(50% 0, 62% 36%, 100% 50%, 62% 64%, 50% 100%, 38% 64%, 0 50%, 38% 36%);
    filter: drop-shadow(0 0 12px rgba(255, 247, 237, .72));
    opacity: 0;
    animation: catSparkle 2.8s ease-in-out infinite;
}
.cat-sparkle.one { left: 8%; top: 19%; animation-delay: -.4s; }
.cat-sparkle.two { right: 10%; top: 28%; animation-delay: -1.2s; transform: scale(.78); }
.cat-sparkle.three { left: 18%; bottom: 22%; animation-delay: -2s; transform: scale(.64); }
.cat-sparkle.four { right: 22%; bottom: 12%; animation-delay: -2.4s; transform: scale(.9); }
.hero-overlay {
    position: absolute;
    inset: 0;
    z-index: 4;
    display: flex;
    align-items: center;
    padding: 90px clamp(32px, 6.4vw, 90px) 48px;
    pointer-events: none;
}
.hero-copy {
    position: relative;
    z-index: 2;
    max-width: clamp(340px, 46vw, 620px);
    pointer-events: auto;
    display: flex;
    flex-direction: column;
    gap: 0;
}
.hero-copy .status {
    margin-bottom: 24px;
    width: fit-content;
}
.hero-copy h1 {
    font-family: "Barlow Condensed", Inter, sans-serif;
    font-size: clamp(52px, 5.8vw, 96px);
    line-height: .92;
    font-weight: 800;
    text-transform: none;
    letter-spacing: .01em;
    text-shadow: 0 6px 0 rgba(0,0,0,.35), 0 0 24px rgba(0,0,0,.2);
    margin: 0;
}
.hero-copy h1 .hot {
    color: var(--orange);
    text-shadow: 0 0 28px rgba(255,138,31,.75), 0 6px 0 rgba(0,0,0,.3);
}
.hero-copy > p {
    max-width: 520px;
    margin-top: 22px;
    color: rgba(237, 220, 205, .82);
    font-size: clamp(15px, 1.35vw, 19px);
    line-height: 1.72;
    text-shadow: 0 1px 10px rgba(0, 0, 0, .6);
}
.hero-actions {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 14px;
    margin-top: 34px;
}
.hero-actions .btn-primary,
.hero-actions .btn-ghost {
    min-width: 190px;
}
.sr-only {
    position: absolute;
    width: 1px;
    height: 1px;
    padding: 0;
    margin: -1px;
    overflow: hidden;
    clip: rect(0, 0, 0, 0);
    white-space: nowrap;
    border: 0;
}
.status {
    width: max-content;
    display: inline-flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 28px;
    padding: 11px 16px;
    color: #c9ff9c;
    border: 1px solid rgba(168, 224, 99, .38);
    background: rgba(32, 96, 53, .22);
    box-shadow: 0 0 30px rgba(168, 224, 99, .18);
    font-weight: 700;
    border-radius: var(--radius);
}
.status-gem {
    width: 20px;
    height: 26px;
    background: linear-gradient(135deg, #e9ffc8, #58b862 56%, #a8e063);
    border-radius: 90% 0 90% 0;
    box-shadow: 0 0 18px rgba(168, 224, 99, .62);
    animation: pulseGem 2s ease-in-out infinite;
}
h1, h2, h3 {
    font-family: "Barlow Condensed", Inter, sans-serif;
    letter-spacing: .01em;
}
.btn-primary, .btn-ghost, .btn-whatsapp {
    position: relative;
    overflow: hidden;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    min-height: 54px;
    padding: 15px 25px;
    font-weight: 800;
    text-decoration: none;
    transition: transform .2s var(--ease), box-shadow .2s var(--ease), border-color .2s var(--ease);
}
.btn-primary:hover, .btn-ghost:hover, .btn-whatsapp:hover { transform: translateY(-3px); }
.btn-ghost {
    color: var(--text);
    border: 1px solid rgba(214, 255, 153, .34);
    background: rgba(14, 58, 32, .38);
    border-radius: 999px;
}
.hero-unit {
    position: relative;
    z-index: 2;
    min-height: 520px;
}
.robot-pet {
    position: absolute;
    right: 1%;
    bottom: 2%;
    width: min(44vw, 590px);
    max-width: 100%;
    border-radius: 14px;
    opacity: .01;
}
.pet-orbit {
    position: absolute;
    right: 8%;
    bottom: 10%;
    width: min(31vw, 430px);
    aspect-ratio: 1;
    border: 1px solid rgba(102, 215, 255, .22);
    border-radius: 50%;
    box-shadow: inset 0 0 40px rgba(102, 215, 255, .08), 0 0 44px rgba(255, 138, 31, .14);
    animation: spin 18s linear infinite;
}
.pet-orbit::before, .pet-orbit::after {
    content: "";
    position: absolute;
    width: 16px;
    height: 16px;
    border-radius: 50%;
    background: var(--orange);
    box-shadow: 0 0 24px var(--orange);
}
.pet-orbit::before { top: 10%; left: 18%; }
.pet-orbit::after { right: 8%; bottom: 22%; background: var(--cyan); box-shadow: 0 0 24px var(--cyan); }
.mini-bot {
    position: absolute;
    display: grid;
    place-items: center;
    width: 86px;
    height: 86px;
    color: var(--orange-soft);
    background: linear-gradient(145deg, rgba(14, 28, 42, .94), rgba(45, 22, 16, .88));
    border: 1px solid var(--line-hot);
    clip-path: polygon(13% 0, 87% 0, 100% 16%, 100% 84%, 87% 100%, 13% 100%, 0 84%, 0 16%);
    box-shadow: 0 18px 40px rgba(0,0,0,.32), 0 0 26px rgba(255, 138, 31, .24);
    animation: botFloat 4.5s ease-in-out infinite;
}
.mini-bot svg { width: 48px; height: 48px; }
.mini-bot.one { right: 3%; top: 20%; }
.mini-bot.two { left: 8%; bottom: 18%; animation-delay: -1.7s; color: var(--cyan); border-color: rgba(102, 215, 255, .52); }

main {
    position: relative;
    z-index: 2;
}
section {
    position: relative;
    z-index: 2;
    padding: 100px clamp(24px, 7vw, 100px);
}
section::before {
    content: "";
    position: absolute;
    inset: 26px clamp(10px, 4vw, 54px);
    z-index: -1;
    pointer-events: none;
    opacity: .46;
    background:
        radial-gradient(ellipse at 8% 18%, rgba(168, 224, 99, .14), transparent 20%),
        radial-gradient(ellipse at 92% 82%, rgba(255, 209, 138, .11), transparent 18%),
        linear-gradient(115deg, transparent 0 70%, rgba(121, 223, 130, .08) 71%, transparent 74% 100%);
    border-radius: 26px;
}
.section-head {
    display: grid;
    gap: 13px;
    max-width: 740px;
    margin-bottom: 42px;
}
.eyebrow {
    position: relative;
    width: max-content;
    color: var(--orange-soft);
    font-size: 13px;
    font-weight: 800;
    letter-spacing: .18em;
    text-transform: uppercase;
    padding-bottom: 8px;
    border-bottom: 1px solid var(--line-hot);
}
.eyebrow::after {
    content: "";
    position: absolute;
    left: 0;
    bottom: -2px;
    width: 42px;
    height: 2px;
    background: var(--leaf);
    box-shadow: 0 0 16px rgba(168, 224, 99, .54);
    animation: eyebrowSpark 2.6s ease-in-out infinite;
}
.section-title {
    font-size: clamp(38px, 5vw, 70px);
    line-height: .95;
    text-transform: uppercase;
    text-shadow: 0 0 22px rgba(168, 224, 99, .12), 0 0 30px rgba(255, 209, 138, .08);
}
.section-sub {
    color: var(--muted);
    line-height: 1.7;
    font-size: 17px;
}

.about {
    display: grid;
    grid-template-columns: minmax(0, 1fr) minmax(320px, .9fr);
    gap: 30px;
    align-items: center;
}
.command-panel, .feature-card, .role-card, .guide-card, .tech-pill, .download-box, .stat-card {
    position: relative;
    background:
        linear-gradient(145deg, rgba(42, 39, 34, .9), rgba(24, 22, 19, .78)),
        radial-gradient(circle at 12% 0%, rgba(255, 138, 0, .12), transparent 26%);
    border: 1px solid var(--line);
    border-radius: var(--radius);
    box-shadow: 0 22px 70px rgba(0,0,0,.25);
    overflow: hidden;
    isolation: isolate;
}
.command-panel > *, .feature-card > *, .role-card > *, .guide-card > *, .tech-pill > *, .download-box > *, .stat-card > * {
    position: relative;
    z-index: 2;
}
.command-panel::before, .feature-card::before, .role-card::before, .guide-card::before, .download-box::before {
    content: "";
    position: absolute;
    inset: 0;
    pointer-events: none;
    background:
        linear-gradient(90deg, transparent, rgba(255, 247, 237, .28), transparent) top left / 100% 1px no-repeat,
        linear-gradient(180deg, rgba(255,255,255,.055), transparent 35%);
}
.command-panel::after, .feature-card::after, .role-card::after, .guide-card::after, .tech-pill::after, .download-box::after, .stat-card::after {
    content: "";
    position: absolute;
    inset: -45% -70%;
    z-index: 1;
    pointer-events: none;
    background:
        linear-gradient(115deg, transparent 30%, rgba(255, 255, 255, .13), transparent 48%),
        linear-gradient(72deg, transparent 44%, rgba(255, 164, 72, .18), transparent 57%);
    transform: translateX(-42%) rotate(8deg);
    opacity: .7;
    animation: cardEnergySweep 8s ease-in-out infinite;
}
.feature-card:nth-child(2n)::after,
.role-card:nth-child(2n)::after,
.guide-card:nth-child(2n)::after,
.tech-pill:nth-child(2n)::after {
    animation-delay: -2.7s;
}
.command-panel {
    min-height: 360px;
    padding: 18px;
    border-color: rgba(255, 226, 189, .32);
}
.mecha-pet-frame {
    position: relative;
    width: 100%;
    min-height: 360px;
    display: grid;
    place-items: center;
    overflow: hidden;
    isolation: isolate;
    border-radius: 8px;
    background:
        radial-gradient(circle at 50% 52%, rgba(255, 255, 255, .16), transparent 30%),
        radial-gradient(circle at 72% 32%, rgba(255, 164, 72, .2), transparent 28%),
        linear-gradient(145deg, rgba(47, 43, 37, .9), rgba(23, 21, 18, .94));
}
.mecha-pet-frame::before,
.mecha-pet-frame::after {
    content: "";
    position: absolute;
    inset: 12px;
    pointer-events: none;
    border-radius: 8px;
    z-index: 2;
}
.mecha-pet-frame::before {
    border: 1px solid rgba(255, 226, 189, .3);
    box-shadow:
        inset 0 0 26px rgba(255, 247, 237, .12),
        0 0 24px rgba(255, 164, 72, .12);
}
.mecha-pet-frame::after {
    background:
        linear-gradient(90deg, transparent, rgba(255, 247, 237, .42), transparent) 0 20% / 100% 2px no-repeat,
        linear-gradient(180deg, rgba(255,255,255,.1), transparent 36%, rgba(255, 164, 72, .1));
    mix-blend-mode: screen;
    animation: scannerSweep 4.6s ease-in-out infinite;
}
.mecha-pet-frame img {
    width: 100%;
    min-height: 320px;
    object-fit: cover;
    border-radius: 8px;
    filter: saturate(1.08) contrast(1.04) drop-shadow(0 0 18px rgba(168, 224, 99, .2));
    animation: mechaPetMove 5.2s ease-in-out infinite;
}
.mecha-pet-frame.about-mecha img {
    min-height: 360px;
    object-position: 72% center;
}
.mecha-pet-frame.guide-mecha img {
    min-height: 430px;
    object-position: 78% center;
    animation-duration: 5.8s;
}
.mecha-pet-frame.sent-mecha img {
    width: min(88%, 560px);
    height: auto;
    min-height: 0;
    object-fit: contain;
    object-position: center;
}
.mecha-pet-frame.sent-mecha .core-glow {
    left: 50%;
    top: 53%;
}
.mecha-pet-frame .core-glow {
    position: absolute;
    left: 70%;
    top: 52%;
    width: 62px;
    height: 62px;
    border-radius: 50%;
    pointer-events: none;
    z-index: 3;
    background: radial-gradient(circle, rgba(255, 255, 255, .84), rgba(255, 164, 72, .38) 34%, transparent 70%);
    filter: blur(.5px);
    animation: corePulse 1.55s ease-in-out infinite;
}
.mecha-pet-frame .spark-bit {
    position: absolute;
    width: 4px;
    height: 22px;
    border-radius: 999px;
    pointer-events: none;
    z-index: 4;
    background: linear-gradient(180deg, rgba(255,255,255,.98), rgba(255, 132, 36, .86), transparent);
    box-shadow: 0 0 14px rgba(255, 164, 72, .56);
    animation: mechaSpark 2.35s linear infinite;
}
.spark-bit:nth-child(3) { left: 18%; top: 82%; animation-delay: -.3s; }
.spark-bit:nth-child(4) { left: 42%; top: 76%; animation-delay: -1.1s; animation-duration: 2.8s; }
.spark-bit:nth-child(5) { left: 78%; top: 70%; animation-delay: -.7s; animation-duration: 2.15s; }
.spark-bit:nth-child(6) { left: 88%; top: 46%; animation-delay: -1.6s; animation-duration: 2.65s; }
.spark-bit:nth-child(7) { left: 64%; top: 26%; animation-delay: -2s; animation-duration: 3s; }
.guide-visual .mecha-pet-frame {
    min-height: 430px;
    border: 1px solid var(--line);
}

/* 3D Model Viewer frame */
.model3d-frame {
    position: relative;
    width: 100%;
    min-height: 430px;
    border-radius: 18px;
    overflow: hidden;
    border: 1px solid rgba(255, 226, 189, .28);
    background:
        radial-gradient(circle at 30% 30%, rgba(255, 138, 0, .12), transparent 44%),
        radial-gradient(circle at 72% 68%, rgba(255, 194, 102, .10), transparent 38%),
        linear-gradient(145deg, rgba(40, 36, 30, .96), rgba(22, 20, 17, .98));
    box-shadow:
        0 22px 70px rgba(0,0,0,.28),
        inset 0 1px 0 rgba(255,247,237,.06);
    isolation: isolate;
}
.model3d-frame::before {
    content: "";
    position: absolute;
    inset: 0;
    z-index: 1;
    pointer-events: none;
    border-radius: 18px;
    background:
        linear-gradient(90deg, transparent, rgba(255,247,237,.14), transparent) top / 100% 1px no-repeat,
        linear-gradient(180deg, rgba(255,255,255,.04), transparent 40%);
}
.model3d-frame model-viewer {
    width: 100%;
    height: 430px;
    background: transparent;
    --poster-color: transparent;
}
.model3d-badge {
    position: absolute;
    bottom: 14px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 10;
    display: inline-flex;
    align-items: center;
    gap: 7px;
    padding: 6px 14px;
    background: rgba(29, 27, 24, .76);
    border: 1px solid rgba(255, 226, 189, .22);
    border-radius: 999px;
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    font-size: 12px;
    font-weight: 700;
    color: var(--muted);
    white-space: nowrap;
    pointer-events: none;
}
.model3d-badge span {
    width: 7px;
    height: 7px;
    border-radius: 50%;
    background: var(--orange);
    box-shadow: 0 0 8px var(--orange);
    animation: pulseGem 1.8s ease-in-out infinite;
}
.about-copy {
    display: grid;
    gap: 20px;
}
.about-copy p {
    color: var(--muted);
    line-height: 1.8;
}
.spec-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 12px;
}
.spec {
    padding: 14px;
    border: 1px solid var(--line);
    background: rgba(255,255,255,.035);
    border-radius: var(--radius);
}
.spec strong {
    display: block;
    font-family: "Barlow Condensed", Inter, sans-serif;
    color: var(--orange-soft);
    font-size: 28px;
    line-height: 1;
}
.spec span { color: var(--muted); font-size: 12px; }

.features-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 22px;
}
.feature-card {
    min-height: 230px;
    padding: 32px 28px;
    transition: transform .3s var(--ease), border-color .3s var(--ease), box-shadow .3s var(--ease);
    cursor: default;
}
.feature-card.feature-burst {
    animation: featureClickBloom .54s cubic-bezier(.16, 1, .3, 1);
}
.feature-card:hover, .role-card:hover, .tech-pill:hover, .guide-card:hover, .stat-card:hover {
    transform: translateY(-10px);
    border-color: var(--line-hot);
    box-shadow: 0 28px 80px rgba(0,0,0,.38), 0 0 40px rgba(255, 164, 72, .2);
}
/* Feature icon — each card gets its own accent via CSS vars on the wrapper */
.feature-icon {
    width: 58px;
    height: 58px;
    display: grid;
    place-items: center;
    margin-bottom: 22px;
    color: var(--fi-color, var(--orange-soft));
    border: 1.5px solid var(--fi-border, rgba(255,138,0,.55));
    background: var(--fi-bg, rgba(255,138,0,.12));
    border-radius: 14px;
    box-shadow:
        inset 0 1px 0 rgba(255,255,255,.1),
        0 0 20px var(--fi-glow, rgba(255,138,0,.15));
    animation: iconCharge 3.8s ease-in-out infinite;
    flex-shrink: 0;
}
/* Per-card accent colours — set on .feature-card so vars cascade to both icon & label */
.feature-card:nth-child(1) {
    --fi-color: #ffb55a;
    --fi-border: rgba(255,160,60,.6);
    --fi-bg: rgba(255,138,0,.14);
    --fi-glow: rgba(255,138,0,.22);
}
.feature-card:nth-child(2) {
    --fi-color: #7ee8a2;
    --fi-border: rgba(100,220,140,.55);
    --fi-bg: rgba(80,200,120,.1);
    --fi-glow: rgba(80,200,120,.18);
}
.feature-card:nth-child(3) {
    --fi-color: #56cfe1;
    --fi-border: rgba(80,200,225,.55);
    --fi-bg: rgba(60,190,215,.1);
    --fi-glow: rgba(60,190,215,.18);
}
.feature-card:nth-child(4) {
    --fi-color: #c77dff;
    --fi-border: rgba(180,100,255,.5);
    --fi-bg: rgba(150,80,230,.12);
    --fi-glow: rgba(150,80,230,.18);
}
.feature-card:nth-child(5) {
    --fi-color: #ff8fab;
    --fi-border: rgba(255,100,140,.5);
    --fi-bg: rgba(230,80,120,.1);
    --fi-glow: rgba(230,80,120,.18);
}
.feature-card:nth-child(6) {
    --fi-color: #ffd166;
    --fi-border: rgba(255,200,80,.52);
    --fi-bg: rgba(240,170,40,.12);
    --fi-glow: rgba(240,170,40,.2);
}
.feature-card-label {
    display: inline-block;
    margin-bottom: 10px;
    padding: 3px 10px;
    font-size: 11px;
    font-weight: 800;
    letter-spacing: .12em;
    text-transform: uppercase;
    border-radius: 999px;
    color: var(--fi-color, var(--orange-soft));
    background: var(--fi-bg, rgba(255,138,0,.12));
    border: 1px solid var(--fi-border, rgba(255,138,0,.3));
}
.feature-card h3, .role-card h3, .guide-card h3 {
    font-size: 26px;
    line-height: 1.05;
    margin-bottom: 10px;
}
.feature-card p, .role-card p, .guide-card p, .guide-card li {
    color: var(--muted);
    line-height: 1.7;
    font-size: 15px;
}

.roles-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 20px;
}
.role-card {
    min-height: 340px;
    padding: 20px;
    transition: transform .25s var(--ease), border-color .25s var(--ease);
}
.role-avatar {
    position: relative;
    overflow: hidden;
    height: 170px;
    display: grid;
    place-items: center;
    margin-bottom: 18px;
    background:
        radial-gradient(circle at 50% 40%, rgba(255, 255, 255, .22), transparent 34%),
        radial-gradient(ellipse at 50% 100%, rgba(255, 132, 36, .34), transparent 52%),
        linear-gradient(145deg, rgba(255, 154, 60, .18), rgba(255, 255, 255, .08));
    border: 1px solid rgba(255, 247, 237, .16);
    border-radius: 18px;
}
.role-avatar::after {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(180deg, transparent, rgba(255, 232, 172, .14), transparent);
    transform: translateY(-110%);
    animation: scannerSweepVertical 4.2s ease-in-out infinite;
}
.role-avatar svg {
    width: 106px;
    height: 106px;
    filter: drop-shadow(0 0 16px rgba(255, 164, 72, .34));
    animation: characterMove 3.8s ease-in-out infinite;
}
.role-card:nth-child(2) .role-avatar svg { color: var(--orange-soft); animation-delay: -.8s; }
.role-card:nth-child(3) .role-avatar svg { color: #ffe8ac; animation-delay: -1.4s; }
.role-tag {
    display: inline-flex;
    margin-top: 16px;
    padding: 8px 12px;
    color: var(--orange-soft);
    border: 1px solid rgba(255, 138, 31, .28);
    border-radius: 999px;
    font-size: 12px;
    font-weight: 800;
}

.guide-layout {
    position: relative;
    display: grid;
    grid-template-columns: minmax(300px, .78fr) minmax(0, 1fr);
    gap: 38px;
    align-items: start;
}
.guide-layout::before {
    content: "";
    position: absolute;
    inset: -40px -4vw auto -4vw;
    height: 220px;
    pointer-events: none;
    background:
        radial-gradient(ellipse at 18% 20%, rgba(168, 224, 99, .14), transparent 34%),
        linear-gradient(180deg, rgba(168, 224, 99, .08), transparent);
    opacity: .8;
    transform: translateY(var(--scroll-lift, 0px));
}
.guide-visual {
    position: sticky;
    top: 100px;
}
.guide-birds {
    position: absolute;
    inset: -42px -6vw auto -6vw;
    height: 210px;
    pointer-events: none;
    overflow: hidden;
    z-index: 4;
}
.guide-bird {
    position: absolute;
    left: -90px;
    top: var(--bird-top, 40px);
    width: var(--bird-size, 68px);
    height: 38px;
    color: rgba(255, 241, 198, .9);
    filter: drop-shadow(0 10px 16px rgba(0,0,0,.22));
    animation: birdFly var(--bird-speed, 11s) linear infinite;
    animation-delay: var(--bird-delay, 0s);
}
.guide-bird::before,
.guide-bird::after {
    content: "";
    position: absolute;
    top: 12px;
    width: 34px;
    height: 18px;
    border-top: 3px solid currentColor;
    border-radius: 50% 50% 0 0;
    transform-origin: right center;
    animation: wingBeat .56s ease-in-out infinite;
}
.guide-bird::before {
    left: 4px;
    --wing-open: 18deg;
    --wing-closed: -12deg;
    transform: rotate(var(--wing-open));
}
.guide-bird::after {
    right: 4px;
    transform-origin: left center;
    --wing-open: -18deg;
    --wing-closed: 12deg;
    transform: rotate(var(--wing-open));
}
.guide-bird i {
    position: absolute;
    left: 30px;
    top: 14px;
    width: 9px;
    height: 7px;
    border-radius: 50%;
    background: currentColor;
}
.guide-bird:nth-child(2) {
    --bird-top: 82px;
    --bird-size: 48px;
    --bird-speed: 14s;
    --bird-delay: -5s;
    opacity: .78;
}
.guide-bird:nth-child(3) {
    --bird-top: 28px;
    --bird-size: 56px;
    --bird-speed: 16s;
    --bird-delay: -9s;
    opacity: .64;
}
.guide-bird:nth-child(4) {
    --bird-top: 122px;
    --bird-size: 44px;
    --bird-speed: 12s;
    --bird-delay: -3.2s;
    opacity: .74;
}
.guide-bird:nth-child(5) {
    --bird-top: 56px;
    --bird-size: 38px;
    --bird-speed: 13.5s;
    --bird-delay: -7.4s;
    opacity: .68;
}
.guide-bird:nth-child(6) {
    --bird-top: 156px;
    --bird-size: 60px;
    --bird-speed: 18s;
    --bird-delay: -12s;
    opacity: .52;
}
.bird-stage {
    position: relative;
    z-index: 4;
    width: min(94%, 560px);
    min-height: 330px;
    display: grid;
    place-items: center;
    overflow: hidden;
    border-radius: 22px;
    background:
        radial-gradient(circle at 20% 20%, rgba(255,255,255,.36), transparent 16%),
        radial-gradient(ellipse at 50% 100%, rgba(255, 132, 36, .26), transparent 46%);
}
.bird-stage::before {
    content: "";
    position: absolute;
    inset: auto -10% -12% -10%;
    height: 38%;
    background:
        radial-gradient(ellipse at 18% 100%, rgba(255, 247, 237, .72) 0 24%, transparent 25%),
        radial-gradient(ellipse at 48% 100%, rgba(255, 154, 60, .72) 0 34%, transparent 35%),
        radial-gradient(ellipse at 80% 100%, rgba(217, 95, 18, .6) 0 28%, transparent 29%);
}
.perch-bird {
    position: absolute;
    left: var(--bird-left, 50%);
    top: var(--bird-top, 44%);
    width: var(--bird-size, 96px);
    height: calc(var(--bird-size, 96px) * .56);
    color: rgba(255, 248, 238, .96);
    filter: drop-shadow(0 16px 18px rgba(60, 24, 5, .28));
    transform: translate(-50%, -50%) scale(var(--bird-scale, 1));
    animation: hoverBird var(--hover-speed, 3.4s) ease-in-out infinite;
    animation-delay: var(--bird-delay, 0s);
}
.perch-bird::before,
.perch-bird::after {
    content: "";
    position: absolute;
    top: 35%;
    width: 48%;
    height: 34%;
    border-top: 5px solid currentColor;
    border-radius: 50% 50% 0 0;
    animation: stationaryWing .64s ease-in-out infinite;
    animation-delay: var(--bird-delay, 0s);
}
.perch-bird::before {
    left: 4%;
    transform-origin: right center;
    --wing-open: 20deg;
    --wing-closed: -20deg;
}
.perch-bird::after {
    right: 4%;
    transform-origin: left center;
    --wing-open: -20deg;
    --wing-closed: 20deg;
}
.perch-bird i {
    position: absolute;
    left: 44%;
    top: 40%;
    width: 13%;
    height: 11%;
    border-radius: 50%;
    background: currentColor;
}
.perch-bird.one { --bird-left: 50%; --bird-top: 42%; --bird-size: 120px; }
.perch-bird.two { --bird-left: 29%; --bird-top: 34%; --bird-size: 78px; --bird-scale: .9; --bird-delay: -.8s; opacity: .84; }
.perch-bird.three { --bird-left: 72%; --bird-top: 58%; --bird-size: 88px; --bird-scale: .94; --bird-delay: -1.5s; opacity: .78; }
.hero-bird-stage .perch-bird:nth-child(4) { --bird-left: 40%; --bird-top: 66%; --bird-size: 62px; --bird-scale: .82; --bird-delay: -2.1s; opacity: .72; }
.hero-bird-stage .perch-bird:nth-child(5) { --bird-left: 84%; --bird-top: 36%; --bird-size: 68px; --bird-scale: .86; --bird-delay: -2.8s; opacity: .66; }
.hero-bird-stage {
    position: absolute;
    inset: 10% 7% 12% 44%;
    z-index: 3;
    min-height: 360px;
}
.hero-bird-stage .bird-stage {
    width: 100%;
    height: 100%;
    min-height: 360px;
    background: transparent;
}
.pet-scene {
    position: relative;
    width: min(96%, 570px);
    min-height: 350px;
    display: grid;
    place-items: end center;
    overflow: hidden;
    border-radius: 18px;
    background:
        radial-gradient(circle at 18% 16%, rgba(255,255,255,.48), transparent 14%),
        linear-gradient(180deg, rgba(255, 238, 210, .82) 0%, rgba(255, 154, 31, .42) 50%, rgba(108, 43, 0, .18) 100%);
}
.pet-scene::before {
    content: "";
    position: absolute;
    left: -10%;
    right: -10%;
    bottom: -6%;
    height: 34%;
    background:
        radial-gradient(ellipse at 18% 100%, rgba(255, 224, 156, .88) 0 28%, transparent 29%),
        radial-gradient(ellipse at 48% 100%, rgba(255, 138, 0, .82) 0 36%, transparent 37%),
        radial-gradient(ellipse at 82% 100%, rgba(205, 88, 0, .66) 0 32%, transparent 33%),
        linear-gradient(180deg, #ffc56d, #d76000);
}
.pet-scene::after {
    content: "";
    position: absolute;
    inset: auto 0 20% 0;
    height: 36px;
    background:
        linear-gradient(82deg, transparent 0 8%, #7cb840 9% 11%, transparent 12% 100%),
        linear-gradient(96deg, transparent 0 18%, #95ca45 19% 21%, transparent 22% 100%),
        linear-gradient(78deg, transparent 0 36%, #67a833 37% 39%, transparent 40% 100%),
        linear-gradient(92deg, transparent 0 58%, #8ec33d 59% 61%, transparent 62% 100%),
        linear-gradient(84deg, transparent 0 78%, #74b13b 79% 81%, transparent 82% 100%);
    opacity: .9;
    animation: grassNibble 1.4s ease-in-out infinite;
}
.animal {
    position: relative;
    z-index: 3;
    width: 230px;
    height: 160px;
    margin-bottom: 74px;
    transform-origin: 50% 100%;
    animation: animalBreathe 2.6s ease-in-out infinite;
}
.animal .body,
.animal .head,
.animal .ear,
.animal .tail,
.animal .leg,
.animal .muzzle,
.animal .food,
.animal .eye {
    position: absolute;
}
.animal .body {
    left: 42px;
    bottom: 18px;
    width: 150px;
    height: 88px;
    border-radius: 54% 46% 48% 52%;
    background: linear-gradient(145deg, #fff0d3, #ffb45a);
    box-shadow: inset -16px -16px 24px rgba(178, 79, 0, .16), 0 20px 28px rgba(76, 25, 0, .24);
}
.animal .head {
    right: 18px;
    bottom: 72px;
    width: 82px;
    height: 70px;
    border-radius: 48% 52% 44% 56%;
    background: linear-gradient(145deg, #fff3dc, #ffb861);
    transform-origin: 42% 78%;
    animation: munchHead 1.15s ease-in-out infinite;
}
.animal .eye {
    right: 33px;
    top: 26px;
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #3a1605;
}
.animal .muzzle {
    right: -6px;
    bottom: 16px;
    width: 30px;
    height: 22px;
    border-radius: 50%;
    background: #fff7ed;
    animation: mouthNibble .58s ease-in-out infinite;
}
.animal .leg {
    bottom: 0;
    width: 32px;
    height: 30px;
    border-radius: 42% 42% 50% 50%;
    background: #f59a37;
}
.animal .leg.front { right: 42px; }
.animal .leg.back { left: 70px; }
.animal .food {
    right: -22px;
    bottom: 48px;
    width: 58px;
    height: 32px;
    background:
        radial-gradient(circle at 50% 20%, #74b13b 0 10%, transparent 11%),
        linear-gradient(90deg, transparent 0 12%, #69a936 13% 16%, transparent 17% 38%, #8fc642 39% 42%, transparent 43% 68%, #7cb840 69% 72%, transparent 73% 100%);
    transform-origin: 50% 100%;
    animation: foodShake .58s ease-in-out infinite;
}
.animal.rabbit .ear {
    width: 22px;
    height: 74px;
    bottom: 124px;
    border-radius: 50% 50% 42% 42%;
    background: linear-gradient(180deg, #fff8ec, #ffb861);
    transform-origin: 50% 100%;
}
.animal.rabbit .ear.one { right: 62px; transform: rotate(-10deg); animation: rabbitEarOne 2.1s ease-in-out infinite; }
.animal.rabbit .ear.two { right: 35px; transform: rotate(12deg); animation: rabbitEarTwo 2.1s ease-in-out infinite; }
.animal.rabbit .tail {
    left: 20px;
    bottom: 66px;
    width: 42px;
    height: 42px;
    border-radius: 50%;
    background: #fff8ec;
    box-shadow: 0 0 18px rgba(255, 247, 237, .5);
}
.animal.cat {
    width: 245px;
}
.animal.cat .body {
    background: linear-gradient(145deg, #ffcf85, #ff8a00);
}
.animal.cat .head {
    border-radius: 48% 52% 48% 52%;
    background: linear-gradient(145deg, #ffd79a, #ff9317);
}
.animal.cat .ear {
    bottom: 128px;
    width: 0;
    height: 0;
    border-left: 18px solid transparent;
    border-right: 18px solid transparent;
    border-bottom: 44px solid #ffb04d;
    transform-origin: 50% 100%;
}
.animal.cat .ear.one { right: 66px; transform: rotate(-16deg); animation: catEarTwitch 2.4s ease-in-out infinite; }
.animal.cat .ear.two { right: 26px; transform: rotate(18deg); animation: catEarTwitch 2.4s ease-in-out infinite reverse; }
.animal.cat .tail {
    left: 18px;
    bottom: 72px;
    width: 78px;
    height: 54px;
    border: 16px solid #ff9a24;
    border-right: 0;
    border-bottom: 0;
    border-radius: 60px 0 0 0;
    transform-origin: 84% 88%;
    animation: tailSway 1.8s ease-in-out infinite;
}
.animal.cat .food {
    width: 64px;
    height: 30px;
    background:
        radial-gradient(circle at 22% 68%, #8a4a1f 0 8%, transparent 9%),
        radial-gradient(circle at 44% 58%, #b06024 0 8%, transparent 9%),
        radial-gradient(circle at 64% 70%, #704015 0 7%, transparent 8%),
        linear-gradient(180deg, transparent 0 44%, #fff5de 45% 100%);
}
@keyframes animalBreathe {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
}
@keyframes munchHead {
    0%, 100% { transform: rotate(0deg) translateY(0); }
    45%, 65% { transform: rotate(5deg) translateY(8px); }
}
@keyframes mouthNibble {
    0%, 100% { transform: scaleX(1); }
    50% { transform: scaleX(.82) translateX(2px); }
}
@keyframes foodShake {
    0%, 100% { transform: rotate(0); }
    50% { transform: rotate(-4deg); }
}
@keyframes rabbitEarOne {
    0%, 100% { transform: rotate(-10deg); }
    50% { transform: rotate(-18deg); }
}
@keyframes rabbitEarTwo {
    0%, 100% { transform: rotate(12deg); }
    50% { transform: rotate(20deg); }
}
@keyframes catEarTwitch {
    0%, 80%, 100% { filter: brightness(1); }
    88% { filter: brightness(1.18); transform: rotate(-8deg); }
}
@keyframes tailSway {
    0%, 100% { transform: rotate(-4deg); }
    50% { transform: rotate(9deg); }
}
@keyframes grassNibble {
    0%, 100% { transform: translateX(0); }
    50% { transform: translateX(8px); }
}
.guide-list {
    display: grid;
    gap: 16px;
}
.guide-card {
    padding: 24px 24px 24px 82px;
    transition: transform .25s var(--ease), border-color .25s var(--ease), box-shadow .25s var(--ease);
}
.guide-card.visible {
    animation: guideLift .9s var(--ease) both;
}
.guide-num {
    position: absolute;
    left: 24px;
    top: 24px;
    width: 38px;
    height: 38px;
    display: grid;
    place-items: center;
    color: var(--dark);
    background: linear-gradient(135deg, #fff7ed, var(--orange));
    border-radius: 50%;
    font-weight: 900;
    box-shadow: 0 0 20px rgba(255, 138, 31, .42);
    animation: guideBeacon 2.4s ease-in-out infinite;
}
.guide-card ol {
    display: grid;
    gap: 8px;
    margin-top: 14px;
    padding-left: 18px;
}
.guide-card strong { color: var(--text); }
.guide-card code {
    color: var(--cyan);
    background: rgba(102, 215, 255, .08);
    padding: 2px 6px;
    border-radius: 4px;
}

.stats-grid {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 16px;
}
.stat-card {
    padding: 24px;
    text-align: center;
    transition: transform .25s var(--ease), border-color .25s var(--ease), box-shadow .25s var(--ease);
}
.stat-card .num {
    font-family: "Barlow Condensed", Inter, sans-serif;
    font-size: 48px;
    font-weight: 800;
    color: var(--orange-soft);
    text-shadow: 0 0 20px rgba(255, 138, 31, .44);
    animation: numberGlow 2.8s ease-in-out infinite;
}
.stat-card p { color: var(--muted); font-weight: 700; }

.tech-grid {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 15px;
}
.tech-pill {
    min-height: 112px;
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 18px;
    transition: transform .25s var(--ease), border-color .25s var(--ease), box-shadow .25s var(--ease);
}
.tech-icon {
    width: 48px;
    height: 48px;
    display: grid;
    place-items: center;
    color: var(--orange-soft);
    background: rgba(255, 247, 237, .1);
    border: 1px solid rgba(255, 226, 189, .24);
    border-radius: 50%;
    flex: 0 0 auto;
    animation: techPulse 3.2s ease-in-out infinite;
}
.tech-name { font-weight: 900; color: var(--text); }
.tech-desc { margin-top: 4px; color: var(--muted); font-size: 13px; }

#download, #contact { text-align: center; }
#download::before,
#contact::before {
    opacity: .7;
    background:
        radial-gradient(ellipse at 18% 20%, rgba(255, 232, 172, .14), transparent 24%),
        radial-gradient(ellipse at 82% 78%, rgba(255, 164, 72, .16), transparent 28%);
}
.download-box {
    max-width: 980px;
    margin: 0 auto;
    padding: clamp(30px, 5vw, 62px);
    border-color: rgba(255, 226, 189, .38);
    border-radius: 28px;
    background:
        radial-gradient(circle at 12% 16%, rgba(255, 232, 172, .18), transparent 24%),
        radial-gradient(ellipse at 85% 98%, rgba(255, 132, 36, .26), transparent 32%),
        linear-gradient(145deg, rgba(43, 39, 34, .94), rgba(23, 21, 18, .86)),
        radial-gradient(circle at 50% 0, rgba(255, 247, 237, .2), transparent 35%);
}
.download-box::before {
    background:
        linear-gradient(90deg, transparent, rgba(255, 247, 237, .28), transparent) top left / 100% 1px no-repeat,
        radial-gradient(ellipse at 8% 100%, rgba(255, 164, 72, .18), transparent 22%),
        radial-gradient(ellipse at 94% 0%, rgba(255, 232, 172, .14), transparent 24%);
}
.download-box h2 {
    font-size: clamp(38px, 6vw, 76px);
    line-height: .95;
    text-transform: uppercase;
    margin-bottom: 16px;
}
.download-box p {
    max-width: 650px;
    margin: 0 auto 28px;
    color: var(--muted);
    line-height: 1.7;
}
.btn-whatsapp {
    position: relative;
    overflow: hidden;
    color: #231004;
    background: linear-gradient(180deg, #fff7ed, #ffad62 50%, #f47c20);
    border: 1px solid rgba(255, 247, 237, .9);
    border-radius: 999px;
    box-shadow: 0 0 28px rgba(255, 164, 72, .28);
}

footer {
    position: relative;
    z-index: 2;
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;
    align-items: center;
    gap: 18px;
    padding: 30px clamp(18px, 7vw, 100px);
    color: var(--muted);
    border-top: 1px solid var(--line);
    background:
        linear-gradient(90deg, rgba(255, 247, 237, .1), transparent 22%, transparent 78%, rgba(255, 164, 72, .1)),
        rgba(23, 21, 18, .94);
}
.footer-links {
    display: flex;
    flex-wrap: wrap;
    gap: 14px;
}
footer a { color: var(--muted); text-decoration: none; font-weight: 700; }
footer a:hover { color: var(--orange-soft); }
.footer-logo {
    display: inline-flex;
    align-items: center;
    gap: 12px;
    color: var(--text);
}
.footer-logo .brand-mark {
    width: 46px;
    height: 46px;
}
.footer-logo .brand-text {
    font-size: 30px;
}

[data-animate] {
    opacity: 0;
    filter: blur(8px) saturate(.92);
    transform: translate3d(0, 34px, 0) scale(.985);
    transform-origin: 50% 65%;
    transition:
        opacity .72s cubic-bezier(.16, 1, .3, 1),
        transform .72s cubic-bezier(.16, 1, .3, 1),
        filter .72s cubic-bezier(.16, 1, .3, 1);
    will-change: opacity, transform, filter;
}
[data-animate="left"] { transform: translate3d(-34px, 20px, 0) scale(.985); }
[data-animate="right"] { transform: translate3d(34px, 20px, 0) scale(.985); }
[data-animate].visible {
    opacity: 1;
    filter: blur(0);
    transform: none;
}
.delay-1 { transition-delay: .08s; }
.delay-2 { transition-delay: .16s; }
.delay-3 { transition-delay: .24s; }
.delay-4 { transition-delay: .32s; }
.delay-5 { transition-delay: .4s; }

.leaf-burst-particle {
    position: fixed;
    left: var(--burst-x);
    top: var(--burst-y);
    z-index: 9999;
    width: var(--leaf-w, 18px);
    height: var(--leaf-h, 10px);
    pointer-events: none;
    border-radius: 90% 0 90% 0;
    background:
        linear-gradient(135deg, rgba(255,255,255,.72), transparent 34%),
        linear-gradient(135deg, var(--leaf-color-a, #fff1c4), var(--leaf-color-b, #ff8a00));
    box-shadow: 0 0 16px rgba(255, 138, 0, .34);
    opacity: 0;
    transform: translate(-50%, -50%) rotate(var(--leaf-rot, 0deg)) scale(.45);
    animation: leafBurst var(--leaf-time, .92s) cubic-bezier(.15,.78,.24,1) forwards;
    animation-delay: var(--leaf-delay, 0ms);
}
.leaf-burst-particle::after {
    content: "";
    position: absolute;
    left: 18%;
    right: 18%;
    top: 50%;
    height: 1px;
    background: rgba(80, 36, 0, .28);
    transform: rotate(-18deg);
}

@keyframes scanBeam {
    from { transform: translateX(-80%); }
    to { transform: translateX(80%); }
}
@keyframes forestLight {
    0%, 100% { opacity: .68; transform: translate3d(0, 0, 0) scale(1); }
    50% { opacity: .94; transform: translate3d(10px, -8px, 0) scale(1.02); }
}
@keyframes sunbeamDrift {
    0%, 100% { opacity: .68; transform: translateX(-2%); }
    50% { opacity: .95; transform: translateX(3%); }
}
@keyframes gridPulse {
    0%, 100% { opacity: .64; transform: translate3d(0, 0, 0); }
    50% { opacity: .92; transform: translate3d(8px, -8px, 0); }
}
@keyframes scanlineTwitch {
    0%, 100% { opacity: .78; }
    50% { opacity: .48; }
}
@keyframes reactorSpin {
    to { transform: rotate(360deg); }
}
@keyframes canopySway {
    0%, 100% { transform: translate3d(0, 0, 0) rotate(-2deg); opacity: .5; }
    50% { transform: translate3d(-18px, 12px, 0) rotate(5deg); opacity: .78; }
}
@keyframes grassGlimmer {
    0%, 100% { opacity: .16; transform: translateX(-18px) rotate(-24deg) scaleX(.78); }
    45%, 62% { opacity: .7; transform: translateX(36px) rotate(-24deg) scaleX(1.04); }
}
@keyframes energyRail {
    0%, 100% { opacity: .18; transform: translateX(-18px) rotate(-24deg) scaleX(.78); }
    45%, 62% { opacity: .85; transform: translateX(36px) rotate(-24deg) scaleX(1.04); }
}
@keyframes sparkDrift {
    0% { transform: translate3d(0, 105vh, 0) scale(.8); opacity: 0; }
    10%, 82% { opacity: 1; }
    100% { transform: translate3d(42px, -10vh, 0) scale(1.4); opacity: 0; }
}
@keyframes leafFall {
    0% { transform: translate3d(0, -12vh, 0) rotate(0deg) scale(.82); opacity: 0; }
    8%, 82% { opacity: .88; }
    100% { transform: translate3d(76px, 112vh, 0) rotate(420deg) scale(1.08); opacity: 0; }
}
@keyframes leafFallSoft {
    0% { transform: translate3d(-20px, -20px, 0) rotate(0deg); opacity: 0; }
    10%, 76% { opacity: .72; }
    100% { transform: translate3d(90px, calc(100vh + 140px), 0) rotate(520deg); opacity: 0; }
}
@keyframes streakFly {
    0%, 50%, 100% { opacity: 0; transform: translate3d(-80px, 24px, 0) rotate(var(--streak-rotate, -22deg)) scaleX(.35); }
    12%, 24% { opacity: .9; transform: translate3d(80px, -24px, 0) rotate(var(--streak-rotate, -22deg)) scaleX(1); }
}
@keyframes sunRaySweep {
    0%, 52%, 100% { opacity: 0; transform: translate3d(-90px, 26px, 0) rotate(var(--streak-rotate, -22deg)) scaleX(.35); }
    14%, 28% { opacity: .72; transform: translate3d(90px, -24px, 0) rotate(var(--streak-rotate, -22deg)) scaleX(1); }
}
@keyframes nodePulse {
    0%, 100% { transform: scale(.8) rotate(0deg); opacity: .48; }
    50% { transform: scale(1.24) rotate(45deg); opacity: 1; }
}
@keyframes fireflyPulse {
    0%, 100% { transform: translateY(0) scale(.76) rotate(0deg); opacity: .42; }
    50% { transform: translateY(-12px) scale(1.18) rotate(18deg); opacity: 1; }
}
@keyframes heroBreath {
    0%, 100% { transform: translate3d(0,0,0) scale(1); }
    50% { transform: translate3d(10px,-8px,0) scale(1.018); }
}
@keyframes heroScan {
    from { transform: translateX(-95%); opacity: 0; }
    18%, 70% { opacity: 1; }
    to { transform: translateX(95%); opacity: 0; }
}
@keyframes heroSunSweep {
    from { transform: translateX(-95%); opacity: 0; }
    18%, 70% { opacity: .74; }
    to { transform: translateX(95%); opacity: 0; }
}
@keyframes emberRise {
    0% { transform: translate3d(0, 0, 0) scale(.55); opacity: 0; }
    14% { opacity: 1; }
    100% { transform: translate3d(34px, -390px, 0) scale(1.35); opacity: 0; }
}
@keyframes boltFlash {
    0%, 58%, 100% { opacity: 0; transform: translateX(-18px) rotate(-28deg) scaleX(.45); }
    62%, 68% { opacity: .95; transform: translateX(0) rotate(-28deg) scaleX(1); }
    72% { opacity: 0; transform: translateX(26px) rotate(-28deg) scaleX(.6); }
}
@keyframes catFloat {
    0%, 100% { transform: translate3d(0, 0, 0) rotate(-1deg); }
    42% { transform: translate3d(0, -18px, 0) rotate(1.4deg); }
    70% { transform: translate3d(8px, -6px, 0) rotate(-.55deg); }
}
@keyframes catPop {
    0%, 100% { transform: scale(1); filter: drop-shadow(0 24px 24px rgba(0, 0, 0, .34)) drop-shadow(0 0 34px rgba(255, 164, 72, .42)); }
    50% { transform: scale(1.025); filter: drop-shadow(0 30px 28px rgba(0, 0, 0, .38)) drop-shadow(0 0 48px rgba(255, 194, 102, .58)); }
}
@keyframes catAuraSpin {
    to { transform: rotate(360deg); }
}
@keyframes catRingPulse {
    0%, 100% { transform: scale(.94); opacity: .52; }
    50% { transform: scale(1.04); opacity: .95; }
}
@keyframes catShadowPulse {
    0%, 100% { opacity: .72; transform: translateY(12px) scale(.98); }
    50% { opacity: 1; transform: translateY(18px) scale(1.06); }
}
@keyframes catShine {
    0%, 46%, 100% { opacity: 0; transform: translateX(-42%) rotate(-14deg); }
    58%, 66% { opacity: .55; }
    78% { opacity: 0; transform: translateX(42%) rotate(-14deg); }
}
@keyframes catSparkle {
    0%, 100% { opacity: 0; transform: translateY(12px) scale(.5) rotate(0deg); }
    42% { opacity: .95; transform: translateY(-4px) scale(1) rotate(45deg); }
    70% { opacity: .36; transform: translateY(-18px) scale(.78) rotate(90deg); }
}
@keyframes insigniaCharge {
    0%, 100% { filter: brightness(1); transform: translateY(0); }
    50% { filter: brightness(1.25); transform: translateY(-2px); }
}
@keyframes eyebrowSpark {
    0%, 100% { transform: translateX(0); opacity: .45; }
    48% { transform: translateX(72px); opacity: 1; }
}
@keyframes cardEnergySweep {
    0%, 100% { transform: translateX(-48%) rotate(8deg); opacity: .18; }
    46%, 58% { transform: translateX(48%) rotate(8deg); opacity: .82; }
}
@keyframes iconCharge {
    0%, 100% { filter: brightness(1); transform: translateY(0); }
    50% { filter: brightness(1.28); transform: translateY(-3px); }
}
@keyframes featureClickBloom {
    0% { transform: translateY(-8px) scale(1); box-shadow: 0 24px 76px rgba(0,0,0,.34), 0 0 34px rgba(255, 164, 72, .18); }
    42% { transform: translateY(-11px) scale(1.018); box-shadow: 0 28px 82px rgba(0,0,0,.38), 0 0 48px rgba(255, 138, 0, .36); }
    100% { transform: translateY(-8px) scale(1); box-shadow: 0 24px 76px rgba(0,0,0,.34), 0 0 34px rgba(255, 164, 72, .18); }
}
@keyframes scannerSweepVertical {
    0%, 100% { transform: translateY(-120%); opacity: 0; }
    38%, 48% { opacity: .95; }
    68% { transform: translateY(120%); opacity: 0; }
}
@keyframes guideBeacon {
    0%, 100% { box-shadow: 0 0 20px rgba(168, 224, 99, .35); filter: brightness(1); }
    50% { box-shadow: 0 0 34px rgba(168, 224, 99, .62), 0 0 18px rgba(255, 209, 138, .32); filter: brightness(1.18); }
}
@keyframes guideLift {
    0% { box-shadow: 0 10px 34px rgba(0,0,0,.12); }
    55% { box-shadow: 0 26px 74px rgba(0,0,0,.32), 0 0 36px rgba(168, 224, 99, .2); }
    100% { box-shadow: 0 22px 70px rgba(0,0,0,.25); }
}
@keyframes birdFly {
    0% { transform: translate3d(-8vw, 0, 0) scale(.86); opacity: 0; }
    8%, 82% { opacity: 1; }
    46% { transform: translate3d(54vw, -28px, 0) scale(1); }
    100% { transform: translate3d(112vw, 10px, 0) scale(.92); opacity: 0; }
}
@keyframes wingBeat {
    0%, 100% { transform: rotate(var(--wing-open)) translateY(0); }
    50% { transform: rotate(var(--wing-closed)) translateY(3px); }
}
@keyframes hoverBird {
    0%, 100% { transform: translate(-50%, -50%) scale(var(--bird-scale, 1)) translateY(0); }
    50% { transform: translate(-50%, -50%) scale(var(--bird-scale, 1)) translateY(-16px); }
}
@keyframes stationaryWing {
    0%, 100% { transform: rotate(var(--wing-open)) translateY(0); }
    50% { transform: rotate(var(--wing-closed)) translateY(6px); }
}
@keyframes numberGlow {
    0%, 100% { color: var(--orange-soft); transform: translateY(0); }
    50% { color: #ffd089; transform: translateY(-2px); }
}
@keyframes techPulse {
    0%, 100% { box-shadow: 0 0 0 rgba(102, 215, 255, 0); }
    50% { box-shadow: 0 0 24px rgba(102, 215, 255, .24); }
}
@keyframes pulseGem {
    0%, 100% { transform: scale(1); filter: brightness(1); }
    50% { transform: scale(1.1); filter: brightness(1.35); }
}
@keyframes spin { to { transform: rotate(360deg); } }
@keyframes botFloat {
    0%, 100% { transform: translateY(0) rotate(-2deg); }
    50% { transform: translateY(-18px) rotate(3deg); }
}
@keyframes characterMove {
    0%, 100% { transform: translateY(0) rotate(-1deg); }
    40% { transform: translateY(-10px) rotate(2deg); }
    70% { transform: translateY(4px) rotate(-2deg); }
}
@keyframes panelHover {
    0%, 100% { transform: translateY(0) scale(1); }
    50% { transform: translateY(-10px) scale(1.015); }
}
@keyframes mechaPetMove {
    0%, 100% { transform: translate3d(0, 0, 0) scale(1.01) rotate(-.25deg); }
    30% { transform: translate3d(0, -10px, 0) scale(1.025) rotate(.45deg); }
    58% { transform: translate3d(5px, 2px, 0) scale(1.018) rotate(-.35deg); }
    78% { transform: translate3d(-4px, -6px, 0) scale(1.028) rotate(.25deg); }
}
@keyframes corePulse {
    0%, 100% { transform: translate(-50%, -50%) scale(.9); opacity: .7; }
    50% { transform: translate(-50%, -50%) scale(1.18); opacity: 1; }
}
@keyframes scannerSweep {
    0%, 100% { background-position: 0 18%, 0 0; opacity: .55; }
    48% { background-position: 0 78%, 0 0; opacity: .95; }
    64% { background-position: 0 42%, 0 0; opacity: .45; }
}
@keyframes mechaSpark {
    0% { transform: translate3d(0, 0, 0) rotate(24deg) scale(.45); opacity: 0; }
    12% { opacity: 1; }
    100% { transform: translate3d(42px, -180px, 0) rotate(24deg) scale(1.05); opacity: 0; }
}
@keyframes leafBurst {
    0% {
        opacity: 0;
        transform: translate(-50%, -50%) rotate(var(--leaf-rot, 0deg)) scale(.35);
    }
    10% { opacity: 1; }
    68% { opacity: .96; }
    100% {
        opacity: 0;
        transform:
            translate(calc(-50% + var(--leaf-tx)), calc(-50% + var(--leaf-ty)))
            rotate(calc(var(--leaf-rot, 0deg) + var(--leaf-spin, 320deg)))
            scale(var(--leaf-scale, 1));
    }
}

@media (max-width: 1060px) {
    nav { display: none; }
    .hamburger { display: block; }
    .hero {
        padding: 12px;
    }
    .hero-showcase {
        height: calc(100vh - 24px);
        min-height: 500px;
    }
    .hero-showcase img {
        object-position: 60% center;
    }
    .hero-cat-stage {
        inset: 15% 3% 6% 52%;
    }
    .hero-cat-card {
        width: min(39vw, 380px);
    }
    .hero-cat-stage::before {
        width: min(45vw, 430px);
    }
    .hero-cat-stage::after {
        width: min(36vw, 350px);
    }
    .hero-overlay {
        padding: 80px 5% 36px;
        align-items: center;
    }
    .hero-copy {
        max-width: 54vw;
    }
    .hero-copy h1 {
        font-size: clamp(42px, 7.5vw, 74px);
    }
    .hero-copy > p {
        font-size: 15px;
        max-width: 480px;
    }
    .about, .guide-layout { grid-template-columns: 1fr; }
    .guide-visual { position: relative; top: 0; }
    .features-grid, .roles-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
    .tech-grid, .stats-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); }
}

@media (max-width: 680px) {
    header { padding: 12px 16px; }
    .brand-text { font-size: 24px; }
    .brand-mark { width: 40px; height: 40px; }
    .hero { min-height: 92vh; padding: 8px; }
    .hero-showcase {
        height: calc(92vh - 16px);
        min-height: 440px;
    }
    .hero-showcase img {
        object-position: 67% center;
    }
    .hero-cat-stage {
        inset: auto -8% 6% 34%;
        place-items: end center;
    }
    .hero-cat-card {
        width: min(70vw, 310px);
    }
    .hero-cat-stage::before {
        width: min(76vw, 340px);
    }
    .hero-cat-stage::after {
        width: min(60vw, 280px);
    }
    .cat-sparkle {
        width: 10px;
        height: 10px;
    }
    .hero-overlay {
        padding: 72px 18px 24px;
        align-items: flex-start;
        background: linear-gradient(90deg, rgba(2, 7, 13, .88), rgba(2, 7, 13, .35) 70%, transparent);
    }
    .hero-copy {
        max-width: 76vw;
    }
    .hero-copy .status {
        margin-bottom: 18px;
        padding: 8px 12px;
        font-size: 13px;
    }
    .hero-copy h1 { font-size: clamp(36px, 11vw, 58px); }
    .hero-copy > p { font-size: 14px; line-height: 1.58; max-width: 300px; }
    .hero-actions { align-items: stretch; }
    .hero-actions .btn-primary,
    .hero-actions .btn-ghost {
        width: min(100%, 260px);
        min-width: 0;
        min-height: 48px;
        padding: 12px 18px;
    }
    .btn-whatsapp { width: 100%; }
    section { padding: 72px 18px; }
    .features-grid, .roles-grid, .tech-grid, .stats-grid, .spec-grid { grid-template-columns: 1fr; }
    .guide-card { padding: 74px 20px 22px; }
    .guide-num { left: 20px; }
    .command-panel .mecha-pet-frame,
    .guide-visual .mecha-pet-frame,
    .command-panel img,
    .guide-visual img { min-height: 260px; }
    .mecha-pet-frame .core-glow { left: 72%; top: 54%; width: 46px; height: 46px; }
}

@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        animation-duration: .001ms !important;
        animation-iteration-count: 1 !important;
        scroll-behavior: auto !important;
        transition-duration: .001ms !important;
    }
}
</style>
</head>
<body>
<div class="shell-lines" aria-hidden="true">
    <span class="spark"></span>
    <span class="spark"></span>
    <span class="spark"></span>
    <span class="spark"></span>
    <span class="spark"></span>
    <span class="spark"></span>
    <span class="spark"></span>
    <span class="spark"></span>
    <span class="spark"></span>
    <span class="energy-streak one"></span>
    <span class="energy-streak two"></span>
    <span class="energy-streak three"></span>
    <span class="circuit-node one"></span>
    <span class="circuit-node two"></span>
    <span class="circuit-node three"></span>
</div>
<div class="nature-vines" aria-hidden="true">
    <span></span>
    <span></span>
    <span></span>
    <span></span>
    <span></span>
    <span></span>
    <span></span>
</div>
<div class="sky-birds" aria-hidden="true">
    <span class="guide-bird"><i></i></span>
    <span class="guide-bird"><i></i></span>
    <span class="guide-bird"><i></i></span>
    <span class="guide-bird"><i></i></span>
    <span class="guide-bird"><i></i></span>
    <span class="guide-bird"><i></i></span>
    <span class="guide-bird"><i></i></span>
    <span class="guide-bird"><i></i></span>
    <span class="guide-bird"><i></i></span>
</div>

<header id="top">
    <a href="#top" class="brand" aria-label="Tomodachi Home">
        <span class="brand-mark" aria-hidden="true">
            <img src="{{ asset('images/logo.png') }}" alt="Tomodachi Logo" width="46" height="46">
        </span>
        <span class="brand-text">Tomodachi</span>
    </a>
    <nav aria-label="Navigasi utama">
        <a href="#about">About</a>
        <a href="#features">Features</a>
        <a href="#roles">Roles</a>
        <a href="#guide">Panduan</a>
        <a href="#technology">Tech</a>
        <a href="#contact">Contact</a>
        <a class="nav-cta" href="#download">Download APK</a>
    </nav>
    <button class="hamburger" id="hamburgerBtn" type="button" aria-label="Buka menu">
        <span></span><span></span><span></span>
    </button>
</header>

<div class="mobile-nav" id="mobileNav">
    <a href="#about">About</a>
    <a href="#features">Features</a>
    <a href="#roles">Roles</a>
    <a href="#guide">User Guide</a>
    <a href="#technology">Tech</a>
    <a href="#contact">Contact</a>
    <a class="nav-cta" href="#download">Download APK</a>
</div>

<main>
    <section class="hero" id="home">
        <div class="hero-showcase" data-animate>
            <div class="hero-nature" aria-hidden="true"></div>
            <div class="hero-cat-stage" aria-hidden="true">
                <div class="hero-cat-card">
                    <img src="{{ asset('images/cat.png') }}" fetchpriority="high" width="320" height="320" alt="Tomodachi Hero Cat">
                    <span class="cat-sparkle one"></span>
                    <span class="cat-sparkle two"></span>
                    <span class="cat-sparkle three"></span>
                    <span class="cat-sparkle four"></span>
                </div>
            </div>
            <div class="hero-energy" aria-hidden="true">
                <span class="ember"></span>
                <span class="ember"></span>
                <span class="ember"></span>
                <span class="ember"></span>
                <span class="ember"></span>
                <span class="bolt one"></span>
                <span class="bolt two"></span>
            </div>
            <div class="hero-overlay">
                <div class="hero-copy">
                    <div class="status"><span class="status-gem"></span>Sistem Aktif &amp; Online</div>
                    <h1>Natural <span class="hot">Pet Shop</span><br>Management<br>System</h1>
                    <p>Kelola produk, stok, transaksi, laporan bisnis, dan AI assistant dalam satu platform modern. Dibangun dengan Laravel &amp; Flutter untuk pengalaman terbaik.</p>
                    <div class="hero-actions">
                        <a class="btn-primary" href="#features">
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4"><path d="M12 21V9" stroke-linecap="round"/><path d="M12 13c-5 0-8-3-8-8 5 0 8 3 8 8ZM12 15c5 0 8-3 8-8-5 0-8 3-8 8Z" stroke-linecap="round" stroke-linejoin="round"/></svg>
                            Explore Features
                        </a>
                        <a class="btn-ghost" href="{{ asset('download/tomodachi-apk-v2.0.apk') }}" download>
                            <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.3"><path d="M12 4v12" stroke-linecap="round"/><path d="m7 11 5 5 5-5" stroke-linecap="round" stroke-linejoin="round"/><path d="M5 20c4-3 10-3 14 0" stroke-linecap="round"/></svg>
                            Download APK
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section id="about" class="about">
        <div class="command-panel" data-animate="left">
            <div class="model3d-frame" style="border-radius: 10px; min-height: 360px;">
                <model-viewer
                    src="https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/main/2.0/Fox/glTF-Binary/Fox.glb"
                    alt="Tomodachi Pet Cat 3D"
                    auto-rotate
                    auto-rotate-delay="500"
                    rotation-per-second="24deg"
                    camera-controls
                    disable-zoom
                    shadow-intensity="0"
                    environment-image="neutral"
                    exposure="1.3"
                    animation-name="Survey"
                    autoplay
                    camera-orbit="0deg 80deg 120%"
                    min-camera-orbit="auto 50deg auto"
                    max-camera-orbit="auto 88deg auto"
                    interaction-prompt="none"
                    loading="lazy"
                    style="height: 360px;"
                ></model-viewer>
                <div class="model3d-badge">
                    <span></span> Tomodachi Pet — 3D Preview
                </div>
            </div>
        </div>
        <div class="about-copy" data-animate="right">
            <div class="eyebrow">Kenapa Tomodachi?</div>
            <h2 class="section-title">Taman kerja untuk pet shop modern</h2>
            <p>Tomodachi menyatukan inventori, transaksi POS, laporan, dan role pengguna dalam dashboard yang cepat dipantau. Nuansa visual dibuat lebih natural agar terasa ramah, segar, dan dekat dengan dunia hewan peliharaan.</p>
            <div class="spec-grid">
                <div class="spec"><strong>3</strong><span>User roles</span></div>
                <div class="spec"><strong>6+</strong><span>Core features</span></div>
                <div class="spec"><strong>24/7</strong><span>System access</span></div>
            </div>
        </div>
    </section>

    <section id="features">
        <div class="section-head" data-animate>
            <div class="eyebrow">Features</div>
            <h2 class="section-title">Fitur segar untuk operasional harian</h2>
            <p class="section-sub">Setiap modul dibuat untuk mempercepat kerja kasir, admin, dan owner tanpa kehilangan kontrol bisnis.</p>
        </div>
        <div class="features-grid">
            @php
                $features = [
                    [
                        'Inventory',
                        'Stok',
                        'Kontrol stok real-time, kategori produk, dan notifikasi stok menipis.',
                        '<svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="7" width="20" height="14" rx="2"/><path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/><line x1="12" y1="12" x2="12" y2="16"/><line x1="10" y1="14" x2="14" y2="14"/></svg>'
                    ],
                    [
                        'Sales Analytics',
                        'Laporan',
                        'Pantau performa penjualan dan omzet melalui laporan yang mudah dibaca.',
                        '<svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"/><line x1="12" y1="20" x2="12" y2="4"/><line x1="6" y1="20" x2="6" y2="14"/><line x1="2" y1="20" x2="22" y2="20"/></svg>'
                    ],
                    [
                        'Stock Tracking',
                        'Tracking',
                        'Pergerakan stok tercatat otomatis setiap terjadi transaksi atau restock.',
                        '<svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l2-1.14"/><path d="m7.5 4.27 9 5.15"/><polyline points="3.29 7 12 12 20.71 7"/><line x1="12" y1="22" x2="12" y2="12"/><circle cx="18.5" cy="15.5" r="2.5"/><path d="M20.27 17.27 22 19"/></svg>'
                    ],
                    [
                        'POS Processing',
                        'Kasir',
                        'Checkout cepat, pembayaran tunai atau digital, dan struk transaksi.',
                        '<svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>'
                    ],
                    [
                        'Pet Care Modules',
                        'Pelanggan',
                        'Profil pelanggan dan kebutuhan hewan tersimpan dalam satu sistem.',
                        '<svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/></svg>'
                    ],
                    [
                        'AI Assistant',
                        'AI',
                        'Bantu owner membaca insight bisnis dan rekomendasi restock secara otomatis.',
                        '<svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="4"/><path d="M10 8h4M12 6v4"/><rect x="4" y="14" width="16" height="7" rx="2"/><path d="M8 14v-2a4 4 0 0 1 8 0v2"/><line x1="9" y1="18" x2="9" y2="18"/><line x1="12" y1="18" x2="12" y2="18"/><line x1="15" y1="18" x2="15" y2="18"/></svg>'
                    ],
                ];
            @endphp
            @foreach ($features as $index => $feature)
            <article class="feature-card delay-{{ ($index % 5) + 1 }}" data-animate>
                <div class="feature-icon">
                    {!! $feature[3] !!}
                </div>
                <span class="feature-card-label">{{ $feature[1] }}</span>
                <h3>{{ $feature[0] }}</h3>
                <p>{{ $feature[2] }}</p>
            </article>
            @endforeach
        </div>
    </section>

    <section id="roles">
        <div class="section-head" data-animate>
            <div class="eyebrow">User Roles</div>
            <h2 class="section-title">Tiga karakter, satu sistem</h2>
            <p class="section-sub">Owner, Admin, dan Kasir punya akses berbeda agar operasional tetap rapi dan aman.</p>
        </div>
        <div class="roles-grid">
            <article class="role-card delay-1" data-animate>
                <div class="role-avatar">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="m2 4 3 12h14l3-12-6 7-4-7-4 7-6-7zm3 16h14" />
                    </svg>
                </div>
                <h3>Owner</h3>
                <p>Melihat metrik bisnis, laporan penjualan, performa toko, dan insight strategis.</p>
                <span class="role-tag">Business Control</span>
            </article>
            <article class="role-card delay-2" data-animate>
                <div class="role-avatar">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="3" />
                        <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z" />
                    </svg>
                </div>
                <h3>Admin</h3>
                <p>Mengelola data produk, konfigurasi sistem, stok, kategori, dan monitoring operasional.</p>
                <span class="role-tag">Data & System</span>
            </article>
            <article class="role-card delay-3" data-animate>
                <div class="role-avatar">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 2v20l2-1 2 1 2-1 2 1 2-1 2 1 2-1 2 1V2l-2 1-2-1-2 1-2-1-2 1-2-1-2 1-2-1z" />
                        <path d="M16 8H8m8 4H8m4 4H8" />
                    </svg>
                </div>
                <h3>Kasir</h3>
                <p>Memproses penjualan, pembayaran pelanggan, cetak struk, dan riwayat transaksi.</p>
                <span class="role-tag">POS & Transactions</span>
            </article>
        </div>
    </section>

    <section id="guide">
        <div class="guide-layout">
            <div class="guide-birds" aria-hidden="true">
                <span class="guide-bird"><i></i></span>
                <span class="guide-bird"><i></i></span>
                <span class="guide-bird"><i></i></span>
                <span class="guide-bird"><i></i></span>
                <span class="guide-bird"><i></i></span>
                <span class="guide-bird"><i></i></span>
            </div>
            <div class="guide-visual" data-animate="left">
                <div class="model3d-frame">
                    <model-viewer
                        src="https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/main/2.0/Fox/glTF-Binary/Fox.glb"
                        alt="Tomodachi Pet 3D"
                        auto-rotate
                        auto-rotate-delay="0"
                        rotation-per-second="30deg"
                        camera-controls
                        disable-zoom
                        shadow-intensity="0"
                        environment-image="neutral"
                        exposure="1.4"
                        animation-name="Walk"
                        autoplay
                        camera-orbit="0deg 75deg 105%"
                        min-camera-orbit="auto 45deg auto"
                        max-camera-orbit="auto 90deg auto"
                        interaction-prompt="none"
                        loading="lazy"
                        ar
                        ar-modes="webxr scene-viewer quick-look"
                    ></model-viewer>
                    <div class="model3d-badge">
                        <span></span> Tomodachi Pet — Interactive 3D
                    </div>
                </div>
            </div>
            <div>
                <div class="section-head" data-animate>
                    <div class="eyebrow">Panduan User</div>
                    <h2 class="section-title">Aktif dalam lima langkah</h2>
                    <p class="section-sub">Mulai dari instalasi sampai laporan, alurnya dibuat sederhana untuk dipakai setiap hari.</p>
                </div>
                <div class="guide-list">
                    <article class="guide-card delay-1" data-animate>
                        <span class="guide-num">1</span>
                        <h3>Download & Install APK</h3>
                        <p>Siapkan aplikasi Tomodachi di perangkat Android kamu.</p>
                        <ol><li>Klik tombol <a href="{{ asset('download/tomodachi-apk-v2.0.apk') }}" download style="color: var(--orange); font-weight: bold; text-decoration: underline;">Download APK</a>.</li><li>Buka file <code>.apk</code> dan izinkan instalasi.</li><li>Tunggu proses selesai lalu buka aplikasi.</li></ol>
                    </article>
                    <article class="guide-card delay-2" data-animate>
                        <span class="guide-num">2</span>
                        <h3>Login & Akses Dashboard</h3>
                        <p>Masuk dengan akun yang sudah didaftarkan.</p>
                        <ol><li>Input email dan password.</li><li>Menu otomatis menyesuaikan role.</li><li>Hubungi owner jika perlu reset akun.</li></ol>
                    </article>
                    <article class="guide-card delay-3" data-animate>
                        <span class="guide-num">3</span>
                        <h3>Kelola Produk & Stok</h3>
                        <p>Admin dan Owner dapat mengatur data produk serta stok barang.</p>
                        <ol><li>Tambah produk, kategori, harga, dan stok.</li><li>Stok berkurang otomatis saat transaksi.</li><li>Pantau notifikasi stok menipis.</li></ol>
                    </article>
                    <article class="guide-card delay-4" data-animate>
                        <span class="guide-num">4</span>
                        <h3>Lakukan Transaksi POS</h3>
                        <p>Kasir melayani pelanggan dengan alur checkout cepat.</p>
                        <ol><li>Pilih produk dari katalog.</li><li>Pilih metode pembayaran.</li></ol>
                    </article>
                    <article class="guide-card delay-5" data-animate>
                        <span class="guide-num">5</span>
                        <h3>Pantau Laporan & AI</h3>
                        <p>Owner membaca performa toko dan rekomendasi otomatis.</p>
                        <ol><li>Buka menu laporan.</li><li>Filter berdasarkan tanggal atau kategori.</li><li>Gunakan AI Assistant untuk insight restock.</li></ol>
                    </article>
                </div>
            </div>
        </div>
    </section>

    <section id="stats">
        <div class="stats-grid">
            <div class="stat-card delay-1" data-animate><div class="num">3</div><p>User Roles</p></div>
            <div class="stat-card delay-2" data-animate><div class="num">6+</div><p>Fitur Utama</p></div>
            <div class="stat-card delay-3" data-animate><div class="num">24/7</div><p>System Access</p></div>
            <div class="stat-card delay-4" data-animate><div class="num">100%</div><p>Integrated</p></div>
        </div>
    </section>

    <section id="technology">
        <div class="section-head" data-animate>
            <div class="eyebrow">Tech Stack</div>
            <h2 class="section-title">Dibangun dengan teknologi modern</h2>
            <p class="section-sub">Stack yang stabil untuk backend, mobile app, database, pembayaran, dan AI assistant.</p>
        </div>
        <div class="tech-grid">
            @php
                $techs = [
                    [
                        'Laravel 10', 'REST API Backend',
                        '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 3H5a2 2 0 0 0-2 2v4m6-6h10a2 2 0 0 1 2 2v4M9 3v18m0 0h10a2 2 0 0 0 2-2V9M9 21H5a2 2 0 0 1-2-2V9m0 0h18"/></svg>'
                    ],
                    [
                        'Flutter', 'Mobile & Web App',
                        '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="5" y="2" width="14" height="20" rx="2" ry="2"/><line x1="12" y1="18" x2="12.01" y2="18"/></svg>'
                    ],
                    [
                        'MySQL 8', 'Database System',
                        '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><ellipse cx="12" cy="5" rx="9" ry="3"/><path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/><path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/></svg>'
                    ],
                    [
                        'Sanctum', 'Auth & Security',
                        '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>'
                    ],
                    [
                        'Midtrans', 'Payment Gateway',
                        '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"/><line x1="1" y1="10" x2="23" y2="10"/></svg>'
                    ],
                    [
                        'OpenRouter AI', 'AI Assistant',
                        '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="M12 8v4l3 3"/></svg>'
                    ],
                    [
                        'Docker', 'Deployment',
                        '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="2" width="20" height="8" rx="2" ry="2"/><rect x="2" y="14" width="20" height="8" rx="2" ry="2"/><line x1="6" y1="6" x2="6.01" y2="6"/><line x1="6" y1="18" x2="6.01" y2="18"/></svg>'
                    ],
                    [
                        'Nginx', 'Reverse Proxy',
                        '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 22 8.5 22 15.5 12 22 2 15.5 2 8.5 12 2"/><line x1="12" y1="22" x2="12" y2="15.5"/><polyline points="22 8.5 12 15.5 2 8.5"/></svg>'
                    ],
                ];
            @endphp
            @foreach ($techs as $index => $tech)
            <div class="tech-pill delay-{{ ($index % 5) + 1 }}" data-animate>
                <div class="tech-icon">
                    {!! $tech[2] !!}
                </div>
                <div><div class="tech-name">{{ $tech[0] }}</div><div class="tech-desc">{{ $tech[1] }}</div></div>
            </div>
            @endforeach
        </div>
    </section>

    <section id="download">
        <div class="download-box" data-animate>
            <div class="eyebrow" style="margin: 0 auto 18px;">Download</div>
            <h2>Coba aplikasinya sekarang</h2>
            <p>Download APK Tomodachi Pet Shop untuk Android dan mulai kelola toko hewan peliharaanmu dengan sistem yang lebih cepat.</p>
            <a href="{{ asset('download/tomodachi-apk-v2.0.1.apk') }}" class="btn-primary" download>
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path d="M12 4v12" stroke-linecap="round"/><path d="m7 11 5 5 5-5" stroke-linecap="round" stroke-linejoin="round"/><path d="M5 20c4-3 10-3 14 0" stroke-linecap="round"/></svg>
                Download APK Gratis
            </a>
        </div>
    </section>

    <section id="contact">
        <div class="download-box" data-animate>
            <div class="eyebrow" style="margin: 0 auto 18px; color: var(--green); border-color: rgba(94,255,141,.45);">Contact Us</div>
            <h2>Butuh customisasi aplikasi?</h2>
            <p>Jika ingin menambahkan fitur, mengubah tema, atau menyesuaikan aplikasi dengan kebutuhan pet shop kamu, hubungi kami via WhatsApp.</p>
            <a href="https://wa.me/6285158173446" target="_blank" rel="noopener noreferrer" class="btn-whatsapp">
                <svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2.3" viewBox="0 0 24 24"><path d="M5 19c3.5-5 8.5-8.5 14-10" stroke-linecap="round"/><path d="M9 15c-3 0-5-2-5-5 3 0 5 2 5 5ZM14 12c0-4 2.5-7 6-8 0 4-2.5 7-6 8Z" stroke-linecap="round" stroke-linejoin="round"/></svg>
                Hubungi via WhatsApp
            </a>
        </div>
    </section>
</main>

<footer>
    <a href="#home" class="footer-logo brand" aria-label="Tomodachi Home">
        <span class="brand-mark" aria-hidden="true">
            <img src="{{ asset('images/logo.png') }}" alt="Tomodachi Logo" width="46" height="46">
        </span>
        <span class="brand-text">Tomodachi</span>
    </a>
    <p>&copy; {{ date('Y') }} Tomodachi Pet Shop. Laravel, Flutter, AI.</p>
    <div class="footer-links">
        <a href="#about">About</a>
        <a href="#features">Features</a>
        <a href="#download">Download</a>
        <a href="#contact">Contact</a>
    </div>
</footer>

<script>
const hamburgerBtn = document.getElementById('hamburgerBtn');
const mobileNav = document.getElementById('mobileNav');
const header = document.getElementById('top');
const root = document.documentElement;
const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

hamburgerBtn.addEventListener('click', () => {
    hamburgerBtn.classList.toggle('open');
    mobileNav.classList.toggle('open');
});

document.querySelectorAll('.mobile-nav a').forEach(link => {
    link.addEventListener('click', () => {
        hamburgerBtn.classList.remove('open');
        mobileNav.classList.remove('open');
    });
});

const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        entry.target.classList.toggle('visible', entry.isIntersecting);
    });
}, { threshold: 0.1, rootMargin: '0px 0px -36px 0px' });

document.querySelectorAll('[data-animate]').forEach((el) => observer.observe(el));

const leafPalette = [
    ['#fff2bf', '#ff8a00'],
    ['#ffe4bd', '#ffb02e'],
    ['#ffd06b', '#e66d00'],
    ['#fff7ed', '#f47c20'],
];

const createLeafBurst = (x, y) => {
    if (prefersReducedMotion.matches) {
        return;
    }

    const particleCount = 16;
    for (let i = 0; i < particleCount; i += 1) {
        const leaf = document.createElement('span');
        const angle = (Math.PI * 2 * i) / particleCount + (Math.random() * .55);
        const distance = 42 + Math.random() * 98;
        const lift = 12 + Math.random() * 58;
        const tx = Math.cos(angle) * distance;
        const ty = Math.sin(angle) * distance - lift;
        const palette = leafPalette[Math.floor(Math.random() * leafPalette.length)];

        leaf.className = 'leaf-burst-particle';
        leaf.style.setProperty('--burst-x', `${x}px`);
        leaf.style.setProperty('--burst-y', `${y}px`);
        leaf.style.setProperty('--leaf-tx', `${tx.toFixed(1)}px`);
        leaf.style.setProperty('--leaf-ty', `${ty.toFixed(1)}px`);
        leaf.style.setProperty('--leaf-rot', `${Math.floor(Math.random() * 360)}deg`);
        leaf.style.setProperty('--leaf-spin', `${220 + Math.floor(Math.random() * 420)}deg`);
        leaf.style.setProperty('--leaf-scale', `${(.72 + Math.random() * .72).toFixed(2)}`);
        leaf.style.setProperty('--leaf-delay', `${Math.floor(Math.random() * 55)}ms`);
        leaf.style.setProperty('--leaf-time', `${(.72 + Math.random() * .34).toFixed(2)}s`);
        leaf.style.setProperty('--leaf-w', `${12 + Math.floor(Math.random() * 13)}px`);
        leaf.style.setProperty('--leaf-h', `${8 + Math.floor(Math.random() * 8)}px`);
        leaf.style.setProperty('--leaf-color-a', palette[0]);
        leaf.style.setProperty('--leaf-color-b', palette[1]);

        document.body.appendChild(leaf);
        leaf.addEventListener('animationend', () => leaf.remove(), { once: true });
    }
};

document.addEventListener('pointerdown', (event) => {
    createLeafBurst(event.clientX, event.clientY);
}, { passive: true });

document.querySelectorAll('.feature-card').forEach((card) => {
    card.addEventListener('pointerdown', () => {
        card.classList.remove('feature-burst');
        void card.offsetWidth;
        card.classList.add('feature-burst');
    }, { passive: true });

    card.addEventListener('animationend', (event) => {
        if (event.animationName === 'featureClickBloom') {
            card.classList.remove('feature-burst');
        }
    });
});

const updateScrollNature = () => {
    const maxScroll = Math.max(document.body.scrollHeight - window.innerHeight, 1);
    const scrollProgress = window.scrollY / maxScroll;
    root.style.setProperty('--scroll-progress', scrollProgress.toFixed(3));
    root.style.setProperty('--scroll-shift', `${(scrollProgress * 18).toFixed(2)}%`);
    root.style.setProperty('--scroll-lift', `${(scrollProgress * -26).toFixed(2)}px`);
    header.classList.toggle('scrolled', window.scrollY > 18);
};

updateScrollNature();
window.addEventListener('scroll', updateScrollNature, { passive: true });
</script>
</body>
</html>
