<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Membuka Aplikasi Tomodachi Pet Shop</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-dark: #0f172a;
            --primary: #ff8a00;
            --primary-glow: rgba(255, 138, 0, 0.4);
            --card-bg: rgba(30, 41, 59, 0.7);
            --card-border: rgba(255, 255, 255, 0.08);
            --text-main: #f8fafc;
            --text-sub: #94a3b8;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg-dark);
            background-image: 
                radial-gradient(circle at 10% 20%, rgba(255, 138, 0, 0.08) 0%, transparent 40%),
                radial-gradient(circle at 90% 80%, rgba(34, 197, 94, 0.05) 0%, transparent 40%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-main);
            overflow: hidden;
        }

        /* Ambient Background Animations */
        .ambient-blur {
            position: absolute;
            width: 300px;
            height: 300px;
            background: var(--primary);
            filter: blur(120px);
            opacity: 0.15;
            border-radius: 50%;
            z-index: 1;
            animation: float 8s ease-in-out infinite alternate;
        }

        @keyframes float {
            0% { transform: translate(-20px, -20px); }
            100% { transform: translate(20px, 20px); }
        }

        /* Glassmorphism Container */
        .card {
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid var(--card-border);
            border-radius: 24px;
            padding: 40px 30px;
            width: 90%;
            max-width: 440px;
            text-align: center;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            z-index: 10;
            animation: fadeIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .logo-container {
            width: 80px;
            height: 80px;
            background: rgba(255, 138, 0, 0.1);
            border: 2px solid var(--primary);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 24px;
            position: relative;
            box-shadow: 0 0 20px var(--primary-glow);
        }

        /* Pulsing ring around logo */
        .logo-container::after {
            content: '';
            position: absolute;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            border: 2px solid var(--primary);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); opacity: 1; }
            100% { transform: scale(1.4); opacity: 0; }
        }

        .logo-icon {
            font-size: 32px;
            animation: bounce 2s infinite ease-in-out;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-4px); }
        }

        h1 {
            font-size: 22px;
            font-weight: 800;
            margin-bottom: 12px;
            letter-spacing: -0.5px;
        }

        p {
            font-size: 14px;
            color: var(--text-sub);
            line-height: 1.6;
            margin-bottom: 30px;
        }

        /* Premium Pulsing Button */
        .btn-open {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            width: 100%;
            background: linear-gradient(135deg, #ff8a00 0%, #ff5e00 100%);
            border: none;
            border-radius: 14px;
            padding: 16px 24px;
            color: white;
            font-family: inherit;
            font-size: 16px;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            box-shadow: 0 8px 16px var(--primary-glow);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .btn-open:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 24px rgba(255, 138, 0, 0.6);
        }

        .btn-open:active {
            transform: translateY(1px);
        }

        .footer-note {
            margin-top: 24px;
            font-size: 12px;
            color: var(--text-sub);
            opacity: 0.8;
        }

        /* Dot animation for loading */
        .dots::after {
            content: '...';
            display: inline-block;
            width: 20px;
            text-align: left;
            animation: dotLoader 1.5s infinite;
        }

        @keyframes dotLoader {
            0% { content: ''; }
            33% { content: '.'; }
            66% { content: '..'; }
            100% { content: '...'; }
        }
    </style>
</head>
<body>
    <div class="ambient-blur"></div>
    
    <div class="card">
        <div class="logo-container">
            <span class="logo-icon">🐾</span>
        </div>
        <h1>Membuka Aplikasi<span class="dots"></span></h1>
        <p>Sedang mengalihkan Anda ke aplikasi Tomodachi Pet Shop untuk melihat analisis restock.</p>
        
        <a href="tomodachi://restock" class="btn-open" id="appLink">
            Buka di Aplikasi
        </a>
        
        <div class="footer-note">
            Jika aplikasi tidak terbuka secara otomatis, silakan klik tombol di atas.
        </div>
    </div>

    <script>
        // Deteksi OS dan gunakan intent:// untuk Android Chrome demi melewati blokir browser
        window.addEventListener('DOMContentLoaded', () => {
            const isAndroid = /Android/i.test(navigator.userAgent);
            
            // Intent Android dengan fallback ke download APK jika aplikasi belum terinstal
            const androidIntent = "intent://restock/#Intent;scheme=tomodachi;package=com.example.frontendd;S.browser_fallback_url=https://tomodachi-petshop.xyz/download/tomodachi-apk-v2.0.apk;end";
            const iosScheme = "tomodachi://restock";
            
            const targetUrl = isAndroid ? androidIntent : iosScheme;
            
            // Update link tombol di HTML agar menggunakan URL yang tepat
            const btnLink = document.getElementById('appLink');
            if (btnLink) {
                btnLink.setAttribute('href', targetUrl);
            }
            
            // Jalankan pengalihan otomatis
            window.location.href = targetUrl;
            
            // Fallback pengalihan kedua
            setTimeout(() => {
                window.location.href = targetUrl;
            }, 600);
        });
    </script>
</body>
</html>
