import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Tomodachi Pet Shop',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB570),
          brightness: Brightness.light,
        ),

        useMaterial3: true,
        fontFamily: 'Poppins',
      ),

      home: const SplashScreen(),
    );
  }
}
