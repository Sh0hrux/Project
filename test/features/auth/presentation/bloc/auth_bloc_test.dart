import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:startup_app/core/error/failures.dart';
import 'package:startup_app/features/auth/data/repositories/mock_auth_repository_impl.dart';
import 'package:startup_app/features/auth/domain/entities/user_entity.dart';
import 'package:startup_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:startup_app/features/auth/presentation/bloc/auth_bloc.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthBloc authBloc;

  const testUser = UserEntity(
    id: 'user_1',
    email: 'test@example.com',
    name: 'Test User',
  );

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(authRepository: mockAuthRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Unit Tests', () {
    test(
      '1. Boshlang\'ich holat AuthState(status: AuthStatus.initial) bo\'lishi kerak',
      () {
        expect(authBloc.state, const AuthState());
        expect(authBloc.state.status, AuthStatus.initial);
      },
    );

    blocTest<AuthBloc, AuthState>(
      '2. Login muvaffaqiyatli bo\'lganda [loading, authenticated] chiqaradi',
      build: () {
        when(
          () => mockAuthRepository.login(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => testUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const LoginRequestedEvent(
          email: 'test@example.com',
          password: 'password123',
        ),
      ),
      expect: () => [
        const AuthState(status: AuthStatus.loading, errorMessage: null),
        const AuthState(status: AuthStatus.authenticated, user: testUser),
      ],
      verify: (_) {
        verify(
          () => mockAuthRepository.login(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      '3. Login xatolik bilan tugaganda [loading, failure] chiqaradi',
      build: () {
        when(
          () => mockAuthRepository.login(
            email: 'wrong@example.com',
            password: 'wrongpassword',
          ),
        ).thenThrow(
          const ServerFailure(message: 'Noto\'g\'ri login yoki parol'),
        );
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const LoginRequestedEvent(
          email: 'wrong@example.com',
          password: 'wrongpassword',
        ),
      ),
      expect: () => [
        const AuthState(status: AuthStatus.loading, errorMessage: null),
        const AuthState(
          status: AuthStatus.failure,
          errorMessage: 'Noto\'g\'ri login yoki parol',
        ),
      ],
      verify: (_) {
        verify(
          () => mockAuthRepository.login(
            email: 'wrong@example.com',
            password: 'wrongpassword',
          ),
        ).called(1);
      },
    );
  });

  group('MockAuthRepositoryImpl bilan AuthBloc testlari', () {
    blocTest<AuthBloc, AuthState>(
      '4. Istalgan to\'g\'ri email va parol bilan muvaffaqiyatli kiradi',
      build: () => AuthBloc(authRepository: MockAuthRepositoryImpl()),
      act: (bloc) => bloc.add(
        const LoginRequestedEvent(
          email: 'user@startup.uz',
          password: 'secretpassword',
        ),
      ),
      expect: () => [
        const AuthState(status: AuthStatus.loading, errorMessage: null),
        const AuthState(
          status: AuthStatus.authenticated,
          user: UserEntity(
            id: 'mock_user_1',
            email: 'user@startup.uz',
            name: 'user',
          ),
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      '5. "error@test.com" emaili bilan kirilganda ServerFailure yuzaga keladi',
      build: () => AuthBloc(authRepository: MockAuthRepositoryImpl()),
      act: (bloc) => bloc.add(
        const LoginRequestedEvent(
          email: 'error@test.com',
          password: 'secretpassword',
        ),
      ),
      expect: () => [
        const AuthState(status: AuthStatus.loading, errorMessage: null),
        const AuthState(
          status: AuthStatus.failure,
          errorMessage:
              'Serverda xatolik yuz berdi. Iltimos keyinroq qayta urining.',
        ),
      ],
    );
  });
}
