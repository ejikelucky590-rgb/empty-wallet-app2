import 'package:flutter/material.dart';

class DoveColors {
  static const Color primaryCyan = Color(0xFF25F4EE);
  static const Color midnightBg = Color(0xFF000000);
  static const Color cardGrey = Color(0xFF121212);
  static const Color textGrey = Color(0xFFB3B3B3);
}

class DoveTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DoveColors.midnightBg,
      primaryColor: DoveColors.primaryCyan,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DoveColors.midnightBg,
        selectedItemColor: DoveColors.primaryCyan,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
