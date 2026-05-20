import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/main_navigation.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const MainNavigation();
      },
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(
        child: Text(
          state.error.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  },
);
