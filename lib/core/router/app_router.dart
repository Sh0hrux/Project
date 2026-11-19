import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_app/core/widgets/error_view.dart';
import 'package:startup_app/features/auth/presentation/screens/home_screen.dart';
import 'package:startup_app/features/auth/presentation/screens/login_screen.dart';
import 'package:startup_app/features/auth/presentation/screens/splash_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: ErrorView(
        message: 'Sahifa topilmadi: ${state.uri}',
        onRetry: () => context.go('/'),
      ),
    ),
  );
}
