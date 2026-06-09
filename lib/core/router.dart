import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../screens/auth_screen.dart';
import '../screens/main_navigation.dart';

final GoRouter appRouter = GoRouter(
  initialLocation:
      Supabase.instance.client.auth.currentSession == null
          ? '/auth'
          : '/',

  redirect: (context, state) {
    final session = Supabase.instance.client.auth.currentSession;
    final currentPath = state.uri.path;

    if (session == null && currentPath != '/auth') {
      return '/auth';
    }

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
  ],

  errorBuilder: (context, state) => Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Text(
        'Router Error: ${state.error}',
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
      ),
    ),
  ),
);
