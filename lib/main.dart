import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_app/app.dart';
import 'package:startup_app/core/bloc/app_bloc_observer.dart';
import 'package:startup_app/core/storage/token_storage.dart';
import 'package:startup_app/core/theme/theme_cubit.dart';
import 'package:startup_app/features/auth/data/repositories/mock_auth_repository_impl.dart';
import 'package:startup_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:startup_app/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:startup_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:startup_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:startup_app/features/profile/presentation/bloc/profile_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  final tokenStorage = SecureTokenStorage();
  final authRepository = MockAuthRepositoryImpl(tokenStorage: tokenStorage);
  final profileRepository = ProfileRepositoryImpl(
    remoteDataSource: MockProfileRemoteDataSourceImpl(),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
        BlocProvider<ForgotPasswordBloc>(
          create: (context) => ForgotPasswordBloc(authRepository: authRepository),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(profileRepository: profileRepository),
        ),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: const App(),
    ),
  );
}
