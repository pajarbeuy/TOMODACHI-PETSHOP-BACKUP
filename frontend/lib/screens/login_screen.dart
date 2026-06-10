import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_management_screen.dart';
import 'reports_screen.dart';
import '../auth_service.dart';
import 'home_screen.dart';

const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: '/',
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

// ── Colors ───────────────────────────────────────────────────────────────────

const _brown900 = Color(0xFF3D2314);
const _brown700 = Color(0xFF5A3D2B);
const _brown500 = Color(0xFF6B4F3E);
const _brown400 = Color(0xFF9B7B6B);
const _brown200 = Color(0xFFC5A882);
const _orange = Color(0xFFFFB570);
const _orangeDark = Color(0xFFFF9A4D);
const _bgPage = Color(0xFFFFF6E9);
const _bgInput = Color(0xFFFFF8F2);
const _borderLight = Color(0x4DFFB570);

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
  Color color = _brown900,
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
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController(text: 'admin@tomodachi.com');
  final _passCtrl = TextEditingController(text: 'password123');
  bool _showPassword = false;
  bool _rememberMe = false;
  bool _loading = false;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  String? _errorMessage;

  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    // Override with: flutter run -d chrome --dart-define=API_BASE_URL=https://your-api.example.com
    _authService = AuthService();
    _authService.initialize(_apiBaseUrl);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _loading = false);
      _onLoginSuccess(
        CurrentUser(
          id: '1',
          name: 'Admin Utama',
          email: _emailCtrl.text,
          role: Role.admin,
        ),
      );
    });
  }

  void _handleQuickLogin(_DemoRole demo) {
    setState(() => _loading = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() => _loading = false);
      _onLoginSuccess(demo.user);
    });
  }

 void _onLoginSuccess(CurrentUser user) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Welcome, ${user.name}! (${user.role.name})',
        style: _iosStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: _orange,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  );

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const ReportsScreen(),
    ),
  );
}
  void _handleLogin() async {
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Email and password are required');
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final success = await _authService.login(email, password);

    if (!mounted) return;

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
            'Login failed. Please check your credentials.';
        _loading = false;
      });
      _showErrorDialog(_errorMessage ?? 'Login failed');
    }
  }

  void _handleQuickLogin(_DemoRole demo) async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final success = await _authService.login(demo.user.email, 'password123');

    if (!mounted) return;

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
        _errorMessage = _authService.errorMessage ?? 'Login failed';
        _loading = false;
      });
      _showErrorDialog(_errorMessage ?? 'Login failed');
    }
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
      body: FadeTransition(
        opacity: _fadeAnim,
        child: isWide ? _buildWideLayout() : _buildNarrowLayout(),
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFB570),
            Color(0xFFFF9A4D),
            Color(0xFFFFB88C),
            Color(0xFFFFC7D1),
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -96, left: -96, child: _blob(320)),
          Positioned(bottom: -64, right: -64, child: _blob(288)),
          Positioned(
            top: 0,
            bottom: 0,
            right: -32,
            child: Center(child: _blob(160)),
          ),
          Positioned(
            bottom: 0,
            left: 32,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: _blob(96),
              ),
            ),
          ),

          // Animated paw prints
          Positioned(
            top: 64,
            right: 96,
            child: _AnimatedPawIcon(size: 40, angle: 0.21),
          ),
          Positioned(
            bottom: 96,
            left: 64,
            child: _AnimatedPawIcon(size: 32, angle: -0.21),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo box with hover animation
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
                      color: Colors.white.withOpacity(0.85),
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🐕', style: TextStyle(fontSize: 44)),
                      SizedBox(width: 16),
                      Text('🐈', style: TextStyle(fontSize: 44)),
                      SizedBox(width: 16),
                      Text('🐠', style: TextStyle(fontSize: 44)),
                      SizedBox(width: 16),
                      Text('🐹', style: TextStyle(fontSize: 44)),
                      SizedBox(width: 16),
                      Text('🦜', style: TextStyle(fontSize: 44)),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
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
        ],
      ),
    );
  }

  Widget _blob(double size) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white10,
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
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_orange, _orangeDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _orange.withOpacity(0.4),
                color: _orange.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.pets, size: 32, color: Colors.white),
        ),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _orange.withOpacity(0.15),
            color: _orange.withValues(alpha: 0.15),
            blurRadius: 48,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back! 👋',
            style: _iosStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: _brown900,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Sign in to manage your petshop',
            style: _iosStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _brown400,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 28),

          // Error message display
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _errorMessage!,
                style: _iosStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.red.shade700,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],

          _buildLabel('Email Address'),
          const SizedBox(height: 6),
          _buildTextField(
            controller: _emailCtrl,
            hintText: 'you@example.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 18),

          _buildLabel('Password'),
          const SizedBox(height: 6),
          _buildPasswordField(),
          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                    'Remember me',
                    style: _iosStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: _brown500,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Forgot password?',
                  style: _iosStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _orange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSignInButton(),
          const SizedBox(height: 24),
          _buildDivider(),
          const SizedBox(height: 16),
          _buildDemoGrid(),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: _iosStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: _brown700,
        letterSpacing: -0.1,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
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
        filled: true,
        fillColor: _bgInput,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
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
        hintText: 'Enter your password',
        hintStyle: _iosStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _brown200,
        ),
        filled: true,
        fillColor: _bgInput,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
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
        suffixIcon: _AnimatedVisibilityIcon(
          visible: _showPassword,
          onToggle: () => setState(() => _showPassword = !_showPassword),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_orange, _orangeDark],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _orange.withOpacity(0.4),
              color: _orange.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _loading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _loading
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
                    const _AnimatedLoginIcon(),
                    const SizedBox(width: 8),
                    Text(
                      'Sign In',
                      style: _iosStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: _borderLight)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            color: Colors.white,
            child: Text(
              'Quick Demo Login',
              style: _iosStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _brown400,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: _borderLight)),
      ],
    );
  }

  Widget _buildDemoGrid() {
    return Row(
      children: _demoRoles.map((demo) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: demo == _demoRoles.first ? 0 : 6,
              right: demo == _demoRoles.last ? 0 : 6,
            ),
            child: _DemoRoleButton(
              demo: demo,
              loading: _loading,
              onTap: () => _handleQuickLogin(demo),
            ),
          ),
        );
      }).toList(),
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
                  color: Colors.white.withOpacity(_hovered ? 0.5 : 0.3),
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
              child: const Icon(Icons.pets, size: 48, color: Colors.white),
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
            color: _hovered ? demo.hoverBg : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? demo.hoverBorder : const Color(0x33FFB570),
              width: 2,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: demo.hoverBorder.withOpacity(0.18),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: _brown700,
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
