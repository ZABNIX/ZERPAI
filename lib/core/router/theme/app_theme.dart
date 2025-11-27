// FILE: lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Zoho-like palette
  static const Color sidebarColor = Color(0xff1f2633);
  static const Color backgroundColor = Color(0xfff5f7fb);
  static const Color primaryBlue = Color(0xff3b7cff);
  static const Color accentGreen = Color(0xff27c59a);
  static const Color textPrimary = Color(0xff1f2933);
  static const Color textSecondary = Color(0xff6b7280);
  static const Color borderColor = Color(0xffd3d9e3);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'Roboto',

    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      secondary: accentGreen,
      surface: backgroundColor,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0.5,
      foregroundColor: textPrimary,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),

    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      shadowColor: Color(0x14000000), // soft shadow
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: borderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: primaryBlue, width: 1.2),
      ),
      labelStyle: const TextStyle(fontSize: 13, color: textSecondary),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 13.5, color: textPrimary),
    ),

    dividerColor: borderColor,
  );
}
