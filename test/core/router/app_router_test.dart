import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:startup_app/core/router/app_router.dart';
import 'package:startup_app/core/router/app_routes.dart';
import 'package:startup_app/features/auth/domain/entities/user_entity.dart';
import 'package:startup_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:startup_app/features/auth/presentation/bloc/auth_bloc.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;

  const testUser = UserEntity(
    id: '1',
    email: 'user@example.com',
    name: 'Test User',
  );

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  testWidgets(
    '1. Tizimga kirmagan bo\'lsa (unauthenticated), /home ga so\'rov berganda /login ga redirect qiladi',
    (tester) async {
      when(() => mockAuthRepository.getCurrentUser()).thenAnswer((_) async => null);

      final authBloc = AuthBloc(authRepository: mockAuthRepository);
      authBloc.emit(const AuthState(status: AuthStatus.unauthenticated));

      final router = AppRouter.createRouter(authBloc);
      await tester.pumpWidget(
        BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      router.go(AppRoutes.home);
      await tester.pumpAndSettle();

      expect(find.text('Xush kelibsiz'), findsOneWidget);
      expect(find.text('Bosh sahifa'), findsNothing);
    },
  );

  testWidgets(
    '2. Tizimga kirgan bo\'lsa (authenticated), /login ga so\'rov berganda /home ga redirect qiladi',
    (tester) async {
      when(() => mockAuthRepository.getCurrentUser()).thenAnswer((_) async => testUser);

      final authBloc = AuthBloc(authRepository: mockAuthRepository);
      authBloc.emit(
        const AuthState(status: AuthStatus.authenticated, user: testUser),
      );

      final router = AppRouter.createRouter(authBloc);
      await tester.pumpWidget(
        BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      router.go(AppRoutes.login);
      await tester.pumpAndSettle();

      expect(find.text('Bosh sahifa'), findsOneWidget);
      expect(find.text('Xush kelibsiz'), findsNothing);
    },
  );

  testWidgets(
    '3. Noto\'g\'ri URL kiritilganda 404 ekrani (NotFoundScreen) ko\'rinadi',
    (tester) async {
      when(() => mockAuthRepository.getCurrentUser()).thenAnswer((_) async => testUser);

      final authBloc = AuthBloc(authRepository: mockAuthRepository);
      authBloc.emit(
        const AuthState(status: AuthStatus.authenticated, user: testUser),
      );

      final router = AppRouter.createRouter(authBloc);

      await tester.pumpWidget(
        BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      router.go('/unknown-route');
      await tester.pumpAndSettle();

      expect(find.text('404 - Sahifa topilmadi'), findsOneWidget);
    },
  );
}
