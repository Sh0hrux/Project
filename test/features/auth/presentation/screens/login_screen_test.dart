import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:startup_app/features/auth/domain/entities/user_entity.dart';
import 'package:startup_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:startup_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:startup_app/features/auth/presentation/screens/login_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthBloc authBloc;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(authRepository: mockAuthRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: const LoginScreen(),
      ),
    );
  }

  group('LoginScreen Widget Tests', () {
    testWidgets('Login ekrani maydonlari va tugmasi to\'g\'ri ko\'rinadi', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Xush kelibsiz'), findsOneWidget);
      expect(find.byKey(const Key('login_email_input')), findsOneWidget);
      expect(find.byKey(const Key('login_password_input')), findsOneWidget);
      expect(find.byKey(const Key('login_submit_button')), findsOneWidget);
    });

    testWidgets('Bo\'sh maydonlar bilan Kirish bosilganda validatsiya xatosi chiqadi', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pumpAndSettle();

      expect(find.text('Email kiriting'), findsOneWidget);
      expect(find.text('Parol kiriting'), findsOneWidget);
    });

    testWidgets('To\'g\'ri maydonlar kiritilganda LoginRequestedEvent yuboriladi', (tester) async {
      when(
        () => mockAuthRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer(
        (_) async => const UserEntity(
          id: '1',
          email: 'user@startup.uz',
          name: 'user',
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());

      await tester.enterText(
        find.byKey(const Key('login_email_input')),
        'user@startup.uz',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_input')),
        'password123',
      );

      await tester.tap(find.byKey(const Key('login_submit_button')));
      await tester.pump();

      expect(authBloc.state.status, anyOf(AuthStatus.loading, AuthStatus.authenticated));
    });
  });
}
