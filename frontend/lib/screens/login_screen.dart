import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth_service.dart';
import '../utils/error_message.dart';
import '../widgets/app_logo.dart';
import '../widgets/glass_container.dart';
import 'home_screen.dart';

const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://127.0.0.1:8000',
);
const _mobileApiBaseUrl = String.fromEnvironment(
  'MOBILE_API_BASE_URL',
  defaultValue: 'https://tomodachi-petshop.xyz',
);


// ── Models ──────────────────────────────────────────────────────────────────

enum Role { admin, kasir, owner }

class CurrentUser {
  final String id;
  final String name;
  final String email;
  final Role role;

  const CurrentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
}

// ── Demo roles data ──────────────────────────────────────────────────────────

class _DemoRole {
  final Role role;
  final String label;
  final String emoji;
  final String desc;
  final CurrentUser user;
  final Color hoverBg;
  final Color hoverBorder;

  const _DemoRole({
    required this.role,
    required this.label,
    required this.emoji,
    required this.desc,
    required this.user,
    required this.hoverBg,
    required this.hoverBorder,
  });
}

// ignore: unused_element
final _demoRoles = [
  _DemoRole(
    role: Role.admin,
    label: 'Admin',
    emoji: '👑',
    desc: 'Full access',
    user: CurrentUser(
      id: '1',
      name: 'Admin Utama',
      email: 'admin@tomodachi.com',
      role: Role.admin,
    ),
    hoverBg: const Color(0xFFFFF0E0),
    hoverBorder: const Color(0xFFFFB570),
  ),
  _DemoRole(
    role: Role.kasir,
    label: 'Kasir',
    emoji: '🏪',
    desc: 'POS & Products',
    user: CurrentUser(
      id: '2',
      name: 'Budi Santoso',
      email: 'kasir@tomodachi.com',
      role: Role.kasir,
    ),
    hoverBg: const Color(0xFFFFF0F3),
    hoverBorder: const Color(0xFFFFC7D1),
  ),
  _DemoRole(
    role: Role.owner,
    label: 'Owner',
    emoji: '🏆',
    desc: 'Reports & Analytics',
    user: CurrentUser(
      id: '3',
      name: 'Pak Heri',
      email: 'owner@tomodachi.com',
      role: Role.owner,
    ),
    hoverBg: const Color(0xFFF0FDF8),
    hoverBorder: const Color(0xFFB8F2E6),
  ),
];

// ── Dark Neon Colors ───────────────────────────────────────────────────────────

const _brown900 = Colors.white;
const _brown700 = Color(0xE6FFFFFF); // 90% white
const _brown500 = Color(0xB3FFFFFF); // 70% white
const _brown400 = Color(0x99FFFFFF); // 60% white
const _brown200 = Color(0x66FFFFFF); // 40% white
const _orange = Color(0xFFB570FF); // Primary Neon Purple
const _orangeDark = Color(0xFFFF5EEA); // Secondary Neon Pink
const _bgPage = Color(0xFF0F0C29); // Dark background
const _bgInput = Color(0x0CFFFFFF); // 5% white
const _borderLight = Color(0x26FFFFFF); // 15% white

// ── iOS-style TextStyle helpers ───────────────────────────────────────────────
//
// Uses Plus Jakarta Sans (closest Google Font to SF Pro: geometric, rounded,
// tight tracking, excellent weight range). Add to pubspec.yaml:
//   google_fonts: ^6.2.1
//
// And optionally pre-cache in main():
//   GoogleFonts.config.allowRuntimeFetching = true;

TextStyle _iosStyle({
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.w500,
  Color color = Colors.white,
  double letterSpacing = -0.3,
  double height = 1.4,
}) => GoogleFonts.plusJakartaSans(
  fontSize: fontSize,
  fontWeight: fontWeight,
  color: color,
  letterSpacing: letterSpacing,
  height: height,
);

// ── Login Screen ─────────────────────────────────────────────────────────────

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _captchaCtrl = TextEditingController();
  bool _showPassword = false;
  bool _rememberMe = false;
  bool _loading = false;
  bool _captchaLoading = false;

  late final AnimationController _fadeCtrl;
  late final AnimationController _bgAnimCtrl;
  late final Animation<double> _fadeAnim;
  String? _errorMessage;
  CaptchaChallenge? _captchaChallenge;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    // Continuous background animation for left panel
    _bgAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    // Chrome/web uses local backend, while phone/native builds use ngrok.
    // Override with:
    // flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
    // flutter run --dart-define=MOBILE_API_BASE_URL=https://your-ngrok-url
    _authService = AuthService();
    _authService.initialize(kIsWeb ? _apiBaseUrl : _mobileApiBaseUrl);
    _loadCaptcha();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _bgAnimCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _captchaCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCaptcha() async {
    if (mounted) {
      setState(() => _captchaLoading = true);
    }

    try {
      final challenge = await _authService.fetchCaptcha();
      if (!mounted) return;
      setState(() {
        _captchaChallenge = challenge;
        _captchaCtrl.clear();
        _captchaLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _captchaLoading = false;
        _errorMessage = userFriendlyError(e, fallback: 'Gagal memuat captcha');
      });
    }
  }

  void _handleLogin() async {
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();
    final captchaAnswer = _captchaCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Email and password are required');
      return;
    }

    if (_captchaChallenge == null || captchaAnswer.isEmpty) {
      setState(() => _errorMessage = 'Captcha answer is required');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    _showLoadingDialog();

    final success = await _authService.login(
      email,
      password,
      captchaKey: _captchaChallenge!.key,
      captchaAnswer: captchaAnswer,
      rememberMe: _rememberMe,
    );

    if (!mounted) return;

    Navigator.of(context).pop(); // Close loading dialog

    if (success && _authService.currentUser != null) {
      final user = _authService.currentUser!;
      _onLoginSuccess(
        CurrentUser(
          id: user.id,
          name: user.name,
          email: user.email,
          role: _roleFromString(user.role),
        ),
      );
    } else {
      setState(() {
        _errorMessage =
            _authService.errorMessage ??
            'Login gagal. Periksa email, password, dan captcha.';
        _loading = false;
      });
      await _loadCaptcha();
      _showErrorDialog(_errorMessage ?? 'Login gagal');
    }
  }

  void _handleQuickLogin(_DemoRole demo) async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    _showLoadingDialog();

    bool success = false;
    try {
      final challenge = await _authService.fetchCaptcha();
      success = await _authService.login(
        demo.user.email,
        'password123',
        captchaKey: challenge.key,
        captchaAnswer: _solveCaptcha(challenge.question),
        rememberMe: true,
      );
    } catch (e) {
      if (!mounted) return;
      Navigator.of(context).pop();
      setState(() {
        _errorMessage = userFriendlyError(e, fallback: 'Login gagal');
        _loading = false;
      });
      await _loadCaptcha();
      _showErrorDialog(_errorMessage ?? 'Login gagal');
      return;
    }

    if (!mounted) return;

    Navigator.of(context).pop(); // Close loading dialog

    if (success && _authService.currentUser != null) {
      final user = _authService.currentUser!;
      _onLoginSuccess(
        CurrentUser(
          id: user.id,
          name: user.name,
          email: user.email,
          role: _roleFromString(user.role),
        ),
      );
    } else {
      setState(() {
        _errorMessage = _authService.errorMessage ?? 'Login gagal';
        _loading = false;
      });
      await _loadCaptcha();
      _showErrorDialog(_errorMessage ?? 'Login gagal');
    }
  }

  String _solveCaptcha(String question) {
    final parts = question.split('+');
    if (parts.length != 2) {
      return '';
    }

    final left = int.tryParse(parts[0].trim()) ?? 0;
    final right = int.tryParse(parts[1].trim()) ?? 0;
    return (left + right).toString();
  }

  Role _roleFromString(String roleString) {
    switch (roleString.toLowerCase()) {
      case 'admin':
        return Role.admin;
      case 'kasir':
        return Role.kasir;
      case 'owner':
        return Role.owner;
      default:
        return Role.kasir;
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _orange.withValues(alpha: 0.2),
                    blurRadius: 48,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: _orange,
                      backgroundColor: _orange.withValues(alpha: 0.1),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Signing in...',
                    style: _iosStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _brown900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please wait while we verify your credentials',
                    textAlign: TextAlign.center,
                    style: _iosStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: _brown400,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onLoginSuccess(CurrentUser user) {
    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Welcome, ${user.name}! (${user.role.name})',
          style: _iosStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: _orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate to home/dashboard after a brief delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeScreen(authService: _authService),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      backgroundColor: _bgPage,
      body: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.03),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut)),
        child: FadeTransition(
          opacity: _fadeAnim,
          child: isWide ? _buildWideLayout() : _buildNarrowLayout(),
        ),
      ),
    );
  }

  // ── Wide layout ───────────────────────────────────────────────────────────

  Widget _buildWideLayout() {
    return Row(
      children: [
        Flexible(flex: 52, child: _buildLeftPanel()),
        Flexible(flex: 48, child: _buildRightPanel()),
      ],
    );
  }

  // ── Narrow layout ─────────────────────────────────────────────────────────

  Widget _buildNarrowLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 48),
          _buildMobileLogo(),
          const SizedBox(height: 24),
          _buildCard(),
          const SizedBox(height: 16),
          _buildFooter(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Left decorative panel ─────────────────────────────────────────────────

  Widget _buildLeftPanel() {
    return AnimatedBuilder(
      animation: _bgAnimCtrl,
      builder: (context, centerChild) {
        final t = _bgAnimCtrl.value;
        return LayoutBuilder(
          builder: (context, box) {
            final h = box.maxHeight.isFinite ? box.maxHeight : 800.0;
            final w = box.maxWidth.isFinite ? box.maxWidth : 400.0;
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0F0C29),
                    Color(0xFF191238),
                    Color(0xFF0F0C29),
                    Color(0xFF1E112A),
                  ],
                  stops: [0.0, 0.4, 0.7, 1.0],
                ),
              ),
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  // ── Large floating blobs ──────────────────────────────
                  Positioned(
                    top: -96 + sin(t * 2 * pi) * 28,
                    left: -96 + cos(t * 2 * pi + 0.5) * 16,
                    child: _blob(320, opacity: 0.15 + sin(t * pi) * 0.04, color: _orange),
                  ),
                  Positioned(
                    bottom: -64 + cos(t * 2 * pi + 1.0) * 24,
                    right: -64 + sin(t * 2 * pi + 1.0) * 14,
                    child: _blob(288, opacity: 0.12 + cos(t * pi + 1.0) * 0.03, color: _orangeDark),
                  ),
                  Positioned(
                    top: h / 2 - 80 + sin(t * 2 * pi + 1.5) * 36,
                    right: -32,
                    child: _blob(160, opacity: 0.15 + sin(t * pi + 1.5) * 0.04, color: const Color(0xFF00F0FF)), // Neon Cyan
                  ),
                  Positioned(
                    bottom: 80 + sin(t * 2 * pi + 2.5) * 18,
                    left: 32 + cos(t * 2 * pi + 2.5) * 10,
                    child: _blob(96, opacity: 0.18 + sin(t * pi + 2.5) * 0.05, color: _orange),
                  ),

                  // ── Medium accent blobs ───────────────────────────────
                  Positioned(
                    top: h * 0.22 + sin(t * 2 * pi + 0.8) * 22,
                    left: w * 0.10 + cos(t * 2 * pi + 0.8) * 12,
                    child: _blob(60,
                        opacity: 0.15 + sin(t * pi + 0.8) * 0.04,
                        color: _orangeDark),
                  ),
                  Positioned(
                    top: h * 0.60 + cos(t * 2 * pi + 2.3) * 20,
                    right: w * 0.12 + sin(t * 2 * pi + 2.3) * 10,
                    child: _blob(48, opacity: 0.15 + cos(t * pi + 2.3) * 0.04, color: _orange),
                  ),
                  Positioned(
                    top: h * 0.78 + sin(t * 2 * pi + 4.0) * 16,
                    left: w * 0.50 + cos(t * 2 * pi + 4.0) * 8,
                    child: _blob(36, opacity: 0.12 + sin(t * pi + 4.0) * 0.03, color: const Color(0xFF00F0FF)),
                  ),
                  Positioned(
                    top: h * 0.12 + cos(t * 2 * pi + 5.0) * 14,
                    right: w * 0.08 + sin(t * 2 * pi + 5.0) * 10,
                    child: _blob(28, opacity: 0.18 + cos(t * pi + 5.0) * 0.05, color: _orangeDark),
                  ),

                  // ── Floating paw prints ───────────────────────────────
                  Positioned(
                    top: 64 + sin(t * 2 * pi + 0.5) * 14,
                    right: 96 + cos(t * 2 * pi + 0.5) * 6,
                    child: Opacity(
                      opacity:
                          (0.18 + sin(t * pi + 0.5) * 0.10).clamp(0.0, 1.0),
                      child: Transform.rotate(
                        angle: 0.21 + sin(t * pi) * 0.08,
                        child: const Icon(Icons.pets,
                            size: 40, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 96 + cos(t * 2 * pi + 2.0) * 12,
                    left: 64 + sin(t * 2 * pi + 2.0) * 8,
                    child: Opacity(
                      opacity:
                          (0.18 + cos(t * pi + 2.0) * 0.10).clamp(0.0, 1.0),
                      child: Transform.rotate(
                        angle: -0.21 + cos(t * pi + 2.0) * 0.08,
                        child: const Icon(Icons.pets,
                            size: 32, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    top: h * 0.48 + sin(t * 2 * pi + 3.7) * 18,
                    left: 44 + cos(t * 2 * pi + 3.7) * 8,
                    child: Opacity(
                      opacity:
                          (0.12 + sin(t * pi + 3.7) * 0.06).clamp(0.0, 1.0),
                      child: Transform.rotate(
                        angle: 0.9 + sin(t * pi + 3.7) * 0.12,
                        child: const Icon(Icons.pets,
                            size: 22, color: Colors.white),
                      ),
                    ),
                  ),

                  // ── Center content (rebuilt once, passed as child) ─────
                  centerChild!,
                ],
              ),
            );
          },
        );
      },
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _AnimatedLogoBox(),
              const SizedBox(height: 24),
              Text(
                'TOMODACHI',
                style: _iosStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              Text(
                'PETSHOP',
                style: _iosStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 10,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Your trusted pet care management system',
                textAlign: TextAlign.center,
                style: _iosStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  '💕 Because every pet deserves the best',
                  style: _iosStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _blob(double size,
      {double opacity = 0.10, Color color = Colors.white}) =>
      Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity.clamp(0.0, 1.0)),
        ),
      );

  // ── Right panel ───────────────────────────────────────────────────────────

  Widget _buildRightPanel() {
    return Container(
      color: _bgPage,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                _buildCard(),
                const SizedBox(height: 20),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Mobile logo ───────────────────────────────────────────────────────────

  Widget _buildMobileLogo() {
    return Column(
      children: [
        const AppLogo(size: 92),
        const SizedBox(height: 12),
        Text(
          'TOMODACHI PETSHOP',
          style: _iosStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: _brown900,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  // ── Card ──────────────────────────────────────────────────────────────────

  Widget _buildCard() {
    return GlassContainer(
      glowColor: _orange,
      glowIntensity: 0.15,
      blur: 24.0,
      borderRadius: BorderRadius.circular(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Premium Header ───────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_orange, _orangeDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _orange.withValues(alpha: 0.45),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.pets_rounded,
                      color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang! 👋',
                        style: _iosStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: _brown900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Masuk ke panel manajemen petshop',
                        style: _iosStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _brown400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Thin separator
          Container(height: 1, color: const Color(0x19FFB570)),

          // ── Form Section ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error banner
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: Colors.redAccent, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: _iosStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                ],

                _buildLabel('Email'),
                const SizedBox(height: 6),
                _buildTextField(
                  controller: _emailCtrl,
                  hintText: 'contoh@email.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),

                _buildLabel('Password'),
                const SizedBox(height: 6),
                _buildPasswordField(),
                const SizedBox(height: 16),

                _buildLabel('Verifikasi Captcha'),
                const SizedBox(height: 6),
                _buildCaptchaField(),
                const SizedBox(height: 16),

                // Remember me
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (v) =>
                            setState(() => _rememberMe = v ?? false),
                        activeColor: _orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ingat saya di perangkat ini',
                      style: _iosStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _brown500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildSignInButton(),

                const SizedBox(height: 22),

                // Quick login divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                          color: _brown200.withValues(alpha: 0.4)),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'atau masuk cepat sebagai',
                        style: _iosStyle(
                          fontSize: 11,
                          color: _brown400,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                          color: _brown200.withValues(alpha: 0.4)),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Quick role login cards
                Row(
                  children: [
                    for (int i = 0; i < _demoRoles.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      Expanded(
                        child: _DemoRoleButton(
                          demo: _demoRoles[i],
                          loading: _loading,
                          onTap: () => _handleQuickLogin(_demoRoles[i]),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: _iosStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: _brown700,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    IconData? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: _iosStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: _iosStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _brown200,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: _brown400, size: 18)
            : null,
        filled: true,
        fillColor: _bgInput,
        contentPadding: EdgeInsets.symmetric(
          horizontal: prefixIcon != null ? 8 : 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderLight, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderLight, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _orange, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passCtrl,
      obscureText: !_showPassword,
      style: _iosStyle(fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: 'Masukkan password kamu',
        hintStyle: _iosStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _brown200,
        ),
        prefixIcon:
            const Icon(Icons.lock_outline_rounded, color: _brown400, size: 18),
        filled: true,
        fillColor: _bgInput,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderLight, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _borderLight, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _orange, width: 2),
        ),
        suffixIcon: _AnimatedVisibilityIcon(
          visible: _showPassword,
          onToggle: () => setState(() => _showPassword = !_showPassword),
        ),
      ),
    );
  }

  Widget _buildCaptchaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Visual math question chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: _orange.withValues(alpha: 0.09),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _orange.withValues(alpha: 0.22)),
          ),
          child: Row(
            children: [
              Icon(Icons.calculate_outlined, size: 15, color: _orangeDark),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _captchaLoading
                      ? 'Memuat soal...'
                      : 'Berapa ${_captchaChallenge?.question ?? '? + ?'} = ?',
                  style: _iosStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _orangeDark,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _captchaLoading ? null : _loadCaptcha,
                child: _captchaLoading
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _orangeDark,
                        ),
                      )
                    : const Icon(Icons.refresh_rounded,
                        size: 16, color: _orangeDark),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Answer input
        TextField(
          controller: _captchaCtrl,
          keyboardType: TextInputType.number,
          style: _iosStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: 'Ketik jawabanmu di sini...',
            hintStyle: _iosStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: _brown200,
            ),
            prefixIcon:
                const Icon(Icons.tag_rounded, color: _brown400, size: 18),
            filled: true,
            fillColor: _bgInput,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _borderLight, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _borderLight, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _orange, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return _HoverSignInButton(
      loading: _loading,
      onPressed: _loading ? null : _handleLogin,
    );
  }

  Widget _buildFooter() {
    return Text(
      '© 2024 Tomodachi Petshop · All rights reserved',
      textAlign: TextAlign.center,
      style: _iosStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: _brown400,
        letterSpacing: 0,
      ),
    );
  }
}

// ── Hover Sign-In Button ──────────────────────────────────────────────────────

class _HoverSignInButton extends StatefulWidget {
  final bool loading;
  final VoidCallback? onPressed;

  const _HoverSignInButton({required this.loading, required this.onPressed});

  @override
  State<_HoverSignInButton> createState() => _HoverSignInButtonState();
}

class _HoverSignInButtonState extends State<_HoverSignInButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: AnimatedScale(
        scale: _hovered && !widget.loading ? 1.015 : 1.0,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.loading
                  ? [Colors.white.withValues(alpha: 0.1), Colors.white.withValues(alpha: 0.05)]
                  : [
                      _hovered ? const Color(0xFFD09BFF) : _orange,
                      _hovered ? const Color(0xFFFF85F0) : _orangeDark,
                    ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: widget.loading
                ? []
                : [
                    BoxShadow(
                      color: _orange
                          .withValues(alpha: _hovered ? 0.6 : 0.4),
                      blurRadius: _hovered ? 32 : 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(14),
              splashColor: Colors.white.withValues(alpha: 0.15),
              highlightColor: Colors.transparent,
              child: Center(
                child: widget.loading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Masuk ke Panel',
                            style: _iosStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          AnimatedSlide(
                            offset: _hovered
                                ? const Offset(0.2, 0)
                                : Offset.zero,
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            child: const Icon(Icons.arrow_forward_rounded,
                                color: Colors.white, size: 18),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Animated Logo Box (left panel) ───────────────────────────────────────────

class _AnimatedLogoBox extends StatefulWidget {
  @override
  State<_AnimatedLogoBox> createState() => _AnimatedLogoBoxState();
}

class _AnimatedLogoBoxState extends State<_AnimatedLogoBox> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.10 : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutBack,
        child: AnimatedRotation(
          turns: _hovered ? 0.03 : 0.0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: _hovered ? 0.5 : 0.3),
                  blurRadius: _hovered ? 48 : 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: AnimatedRotation(
              turns: _hovered ? -0.03 : 0.0,
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOut,
              child: const AppLogo(size: 86),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Animated Paw Icon (decorative) ───────────────────────────────────────────

class _AnimatedPawIcon extends StatefulWidget {
  final double size;
  final double angle;

  const _AnimatedPawIcon({required this.size, required this.angle});

  @override
  State<_AnimatedPawIcon> createState() => _AnimatedPawIconState();
}

class _AnimatedPawIconState extends State<_AnimatedPawIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.25 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        child: AnimatedOpacity(
          opacity: _hovered ? 0.45 : 0.2,
          duration: const Duration(milliseconds: 200),
          child: Transform.rotate(
            angle: widget.angle,
            child: Icon(Icons.pets, size: widget.size, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ── Animated Visibility Toggle Icon ──────────────────────────────────────────

class _AnimatedVisibilityIcon extends StatefulWidget {
  final bool visible;
  final VoidCallback onToggle;

  const _AnimatedVisibilityIcon({
    required this.visible,
    required this.onToggle,
  });

  @override
  State<_AnimatedVisibilityIcon> createState() =>
      _AnimatedVisibilityIconState();
}

class _AnimatedVisibilityIconState extends State<_AnimatedVisibilityIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onToggle,
        child: AnimatedScale(
          scale: _hovered ? 1.18 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutBack,
          child: AnimatedRotation(
            turns: _hovered ? 0.04 : 0.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: Icon(
              widget.visible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 20,
              color: _hovered ? _orange : _brown400,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Animated Sign In Icon ─────────────────────────────────────────────────────

class _AnimatedLoginIcon extends StatefulWidget {
  const _AnimatedLoginIcon();

  @override
  State<_AnimatedLoginIcon> createState() => _AnimatedLoginIconState();
}

class _AnimatedLoginIconState extends State<_AnimatedLoginIcon> {
  @override
  Widget build(BuildContext context) {
    // This icon animates when the parent button is hovered;
    // we keep it simple: slight scale on the whole button handles it.
    return const Icon(Icons.login_rounded, size: 20, color: Colors.white);
  }
}

// ── Demo Role Button ──────────────────────────────────────────────────────────

class _DemoRoleButton extends StatefulWidget {
  final _DemoRole demo;
  final bool loading;
  final VoidCallback onTap;

  const _DemoRoleButton({
    required this.demo,
    required this.loading,
    required this.onTap,
  });

  @override
  State<_DemoRoleButton> createState() => _DemoRoleButtonState();
}

class _DemoRoleButtonState extends State<_DemoRoleButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final demo = widget.demo;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.loading ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: _hovered ? Colors.white.withValues(alpha: 0.12) : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? _orange : Colors.white.withValues(alpha: 0.15),
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: demo.hoverBorder.withValues(alpha: 0.18),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Opacity(
            opacity: widget.loading ? 0.6 : 1.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated emoji / icon area
                AnimatedScale(
                  scale: _hovered ? 1.18 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: AnimatedRotation(
                    turns: _hovered ? 0.04 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: Text(
                      demo.emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  demo.label,
                  style: _iosStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  demo.desc,
                  textAlign: TextAlign.center,
                  style: _iosStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: _brown400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
