import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_app/core/network/dio_client.dart';
import 'package:startup_app/core/router/app_router.dart';
import 'package:startup_app/core/theme/app_theme.dart';
import 'package:startup_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:startup_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:startup_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:startup_app/features/auth/presentation/bloc/auth_bloc.dart';

class App extends StatelessWidget {
  final AuthRepository? authRepository;

  const App({super.key, this.authRepository});

  @override
  Widget build(BuildContext context) {
    final repository = authRepository ??
        AuthRepositoryImpl(
          remoteDataSource: AuthRemoteDataSourceImpl(client: DioClient()),
        );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: repository),
        ),
      ],
      child: MaterialApp.router(
        title: 'Startup App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
