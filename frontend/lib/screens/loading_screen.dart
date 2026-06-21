import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';
import '../widgets/app_logo.dart';

const _brown900 = Color(0xFF3D2314);

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

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final Timer _timer;
  late final AnimationController _animationCtrl;
  late final Animation<double> _logoScale;
  late final Animation<double> _contentOpacity;

  @override
  void initState() {
    super.initState();
    _animationCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _logoScale = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationCtrl,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationCtrl,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
      ),
    );

    _timer = Timer(const Duration(milliseconds: 1800), _goToLogin);
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationCtrl.dispose();
    super.dispose();
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const LoginScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: FadeTransition(opacity: curvedAnimation, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _goToLogin,
        behavior: HitTestBehavior.opaque,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFA32C), Color(0xFFFFB969)],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _animationCtrl,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScale.value,
                      child: child,
                    );
                  },
                  child: Container(
                    width: 116,
                    height: 116,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(child: AppLogo(size: 104)),
                  ),
                ),
                const SizedBox(height: 28),
                AnimatedBuilder(
                  animation: _contentOpacity,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _contentOpacity.value,
                      child: child,
                    );
                  },
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _animationCtrl,
                        builder: (context, child) {
                          final offset =
                              Tween<Offset>(
                                begin: const Offset(0, 0.2),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _animationCtrl,
                                  curve: Curves.easeOut,
                                ),
                              );
                          return SlideTransition(
                            position: offset,
                            child: child,
                          );
                        },
                        child: Text(
                          'TOMODACHI PETSHOP',
                          textAlign: TextAlign.center,
                          style: _iosStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 4,
                            height: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
