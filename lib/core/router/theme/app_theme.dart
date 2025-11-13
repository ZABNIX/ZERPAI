// PATH: lib/core/theme/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData.light();

    return base.copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF6F7F9),
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0C9E7A)),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
