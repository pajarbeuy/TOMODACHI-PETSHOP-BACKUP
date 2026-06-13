import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
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
