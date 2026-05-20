import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/main_navigation.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  // This completely fixes the GitHub Pages subdirectory routing blackout
  redirect: (context, state) {
    if (state.uri.path.contains('empty-wallet-app2')) {
      return '/';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainNavigation(),
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          "Router Redirect Error: ${state.error}",
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
    );
  },
);
