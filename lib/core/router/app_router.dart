import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_app/core/router/app_routes.dart';
import 'package:startup_app/core/router/not_found_screen.dart';
import 'package:startup_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:startup_app/features/auth/presentation/screens/home_screen.dart';
import 'package:startup_app/features/auth/presentation/screens/login_screen.dart';
import 'package:startup_app/features/auth/presentation/screens/splash_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  AppRouter._();

  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        if (state.error != null) {
          return null;
        }

        final authState = authBloc.state;
        final status = authState.status;

        final isSplash = state.matchedLocation == AppRoutes.splash;
        final isLogin = state.matchedLocation == AppRoutes.login;

        if (status == AuthStatus.initial || status == AuthStatus.loading) {
          return isSplash ? null : AppRoutes.splash;
        }

        final isAuthenticated = status == AuthStatus.authenticated;

        if (!isAuthenticated) {
          return isLogin ? null : AppRoutes.login;
        }

        if (isSplash || isLogin) {
          return AppRoutes.home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.splash,
          name: AppRoutes.splashName,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.loginName,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.homeName,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
      errorBuilder: (context, state) => NotFoundScreen(
        uri: state.uri.toString(),
      ),
    );
  }
}
