import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../screens/main_navigation.dart';
import '../screens/auth_screen.dart';
import '../screens/onboarding_screen.dart';

final GoRouter router = GoRouter(
  // Optimization: Instantly look up session to decide initial path
  initialLocation: Supabase.instance.client.auth.currentSession == null ? '/auth' : '/',
  
  redirect: (context, state) {
    final client = Supabase.instance.client;
    final session = client.auth.currentSession;
    final currentPath = state.uri.path;

    // 1. If not logged in and not on auth, push directly to auth
    if (session == null && currentPath != '/auth') {
      return '/auth';
    }

    // 2. If logged in but lingering on auth, push to home hub
    if (session != null && currentPath == '/auth') {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainNavigation(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Text(
        "Router Error: ${state.error}",
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    ),
  ),
);
