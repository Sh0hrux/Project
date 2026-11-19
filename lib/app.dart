import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_app/core/router/app_router.dart';
import 'package:startup_app/core/theme/app_theme.dart';
import 'package:startup_app/features/auth/presentation/bloc/auth_bloc.dart';

class App extends StatefulWidget {
  final AuthBloc? authBloc;

  const App({super.key, this.authBloc});

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
    return MaterialApp.router(
      title: 'Startup App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
