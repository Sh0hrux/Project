import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_app/core/router/app_router.dart';
import 'package:startup_app/core/theme/app_theme.dart';
import 'package:startup_app/core/theme/theme_cubit.dart';
import 'package:startup_app/features/auth/presentation/bloc/auth_bloc.dart';

class App extends StatefulWidget {
  final AuthBloc? authBloc;
  final ThemeCubit? themeCubit;

  const App({super.key, this.authBloc, this.themeCubit});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final bloc = widget.authBloc ?? context.read<AuthBloc>();
    _router = AppRouter.createRouter(bloc);
  }

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.system;
    if (widget.themeCubit != null) {
      themeMode = widget.themeCubit!.state;
    } else {
      try {
        themeMode = context.watch<ThemeCubit>().state;
      } catch (_) {
        themeMode = ThemeMode.system;
      }
    }

    return MaterialApp.router(
      title: 'Startup App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: _router,
    );
  }
}
