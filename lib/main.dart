import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_app/app.dart';
import 'package:startup_app/core/bloc/app_bloc_observer.dart';
import 'package:startup_app/core/theme/theme_cubit.dart';
import 'package:startup_app/features/auth/data/repositories/mock_auth_repository_impl.dart';
import 'package:startup_app/features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  final authRepository = MockAuthRepositoryImpl();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: const App(),
    ),
  );
}
