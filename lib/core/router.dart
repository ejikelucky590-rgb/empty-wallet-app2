import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/main_navigation.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
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
          state.error.toString(),
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
    );
  },
);
