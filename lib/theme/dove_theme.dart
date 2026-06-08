import 'package:flutter/material.dart';

class DoveColors {
  DoveColors._();

  static const Color primaryCyan = Color(0xFF25F4EE);
  static const Color midnightBg = Color(0xFF000000);
  static const Color cardGrey = Color(0xFF121212);
  static const Color textGrey = Color(0xFFB3B3B3);
}

class DoveTheme {
  DoveTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      scaffoldBackgroundColor: DoveColors.midnightBg,

      colorScheme: const ColorScheme.dark(
        primary: DoveColors.primaryCyan,
        surface: DoveColors.cardGrey,
      ),

      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: DoveColors.cardGrey,
        indicatorColor: DoveColors.primaryCyan.withValues(alpha: 0.15),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      cardTheme: const CardThemeData(
        elevation: 0,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    );
  }
}
