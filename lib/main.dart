import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_app/app.dart';
import 'package:startup_app/core/bloc/app_bloc_observer.dart';
import 'package:startup_app/core/network/dio_client.dart';
import 'package:startup_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:startup_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:startup_app/features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  final authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSourceImpl(client: DioClient()),
  );

  runApp(
    BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(authRepository: authRepository),
      child: const App(),
    ),
  );
}
