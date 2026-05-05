import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DoveColors {
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color cyan = Color(0xFF25F4EE);
  static const Color grey = Color(0xFF808080);
}

class DoveTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: DoveColors.black,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      colorScheme: const ColorScheme.dark(
        primary: DoveColors.white,
        secondary: DoveColors.cyan,
      ),
    );
  }
}
