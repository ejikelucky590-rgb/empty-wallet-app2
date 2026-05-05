import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(const DoveMusic());
}

class DoveMusic extends StatelessWidget {
  const DoveMusic({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dove Music',
      debugShowCheckedModeBanner: false,
      theme: DoveTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
