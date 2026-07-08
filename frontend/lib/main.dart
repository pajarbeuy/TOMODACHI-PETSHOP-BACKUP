import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'widgets/app_motion.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Prefetch Plus Jakarta Sans to avoid layout jumping
  GoogleFonts.pendingFonts([
    GoogleFonts.plusJakartaSans(),
    GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
    GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900),
  ]);
  runApp(const TomodachiApp());
}

class TomodachiApp extends StatelessWidget {
  const TomodachiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme =
        GoogleFonts.plusJakartaSansTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: const Color(0xFF3D2314),
          displayColor: const Color(0xFF3D2314),
        );

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Tomodachi Pet Shop',

      scrollBehavior: const AppScrollBehavior(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB570),
          brightness: Brightness.light,
        ),

        useMaterial3: true,
        textTheme: textTheme,
        primaryTextTheme: textTheme,
        splashFactory: InkSparkle.splashFactory,
        highlightColor: const Color(0xFFFFB570).withValues(alpha: 0.14),
        hoverColor: const Color(0xFFFFB570).withValues(alpha: 0.08),
        focusColor: const Color(0xFFFFB570).withValues(alpha: 0.12),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: const Color(0xFF3D2314),
            highlightColor: const Color(0xFFFFB570).withValues(alpha: 0.18),
            hoverColor: const Color(0xFFFFB570).withValues(alpha: 0.08),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            textStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
            animationDuration: const Duration(milliseconds: 180),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
            animationDuration: const Duration(milliseconds: 180),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            textStyle: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
            animationDuration: const Duration(milliseconds: 180),
          ),
        ),
      ),

      builder: (context, child) {
        return AppInteractionFeedback(child: child ?? const SizedBox.shrink());
      },

      home: const SplashScreen(),
    );
  }
}
