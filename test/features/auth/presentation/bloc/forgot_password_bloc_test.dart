import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:startup_app/features/auth/data/repositories/mock_auth_repository_impl.dart';
import 'package:startup_app/features/auth/presentation/bloc/forgot_password_bloc.dart';

void main() {
  group('ForgotPasswordBloc Unit Tests', () {
    late MockAuthRepositoryImpl mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepositoryImpl();
    });

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      '1. Kod muvaffaqiyatli yuborilganda step verifyCode ga o\'tadi',
      build: () => ForgotPasswordBloc(authRepository: mockAuthRepository),
      act: (bloc) =>
          bloc.add(const SendResetCodeEvent(email: 'user@startup.uz')),
      expect: () => [
        const ForgotPasswordState(
          status: ForgotPasswordStatus.loading,
          step: ForgotPasswordStep.enterEmail,
        ),
        const ForgotPasswordState(
          status: ForgotPasswordStatus.success,
          step: ForgotPasswordStep.verifyCode,
          email: 'user@startup.uz',
        ),
      ],
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      '2. Noto\'g\'ri tasdiqlash kodi kiritilganda failure holati chiqadi',
      build: () => ForgotPasswordBloc(authRepository: mockAuthRepository),
      seed: () => const ForgotPasswordState(
        step: ForgotPasswordStep.verifyCode,
        email: 'user@startup.uz',
      ),
      act: (bloc) => bloc.add(const VerifyResetCodeEvent(code: '000000')),
      expect: () => [
        const ForgotPasswordState(
          status: ForgotPasswordStatus.loading,
          step: ForgotPasswordStep.verifyCode,
          email: 'user@startup.uz',
        ),
        const ForgotPasswordState(
          status: ForgotPasswordStatus.failure,
          step: ForgotPasswordStep.verifyCode,
          email: 'user@startup.uz',
          errorMessage: 'Tasdiqlash kodi noto\'g\'ri. (Mock: 123456)',
        ),
      ],
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      '3. To\'g\'ri kod (123456) va yangi parol o\'rnatilganda completed bo\'ladi',
      build: () => ForgotPasswordBloc(authRepository: mockAuthRepository),
      seed: () => const ForgotPasswordState(
        step: ForgotPasswordStep.verifyCode,
        email: 'user@startup.uz',
      ),
      act: (bloc) async {
        bloc.add(const VerifyResetCodeEvent(code: '123456'));
        await Future.delayed(Duration.zero);
        bloc.add(const ResetPasswordSubmittedEvent(newPassword: 'newpass123'));
      },
      expect: () => [
        const ForgotPasswordState(
          status: ForgotPasswordStatus.loading,
          step: ForgotPasswordStep.verifyCode,
          email: 'user@startup.uz',
        ),
        const ForgotPasswordState(
          status: ForgotPasswordStatus.success,
          step: ForgotPasswordStep.resetPassword,
          email: 'user@startup.uz',
          code: '123456',
        ),
        const ForgotPasswordState(
          status: ForgotPasswordStatus.loading,
          step: ForgotPasswordStep.resetPassword,
          email: 'user@startup.uz',
          code: '123456',
        ),
        const ForgotPasswordState(
          status: ForgotPasswordStatus.success,
          step: ForgotPasswordStep.completed,
          email: 'user@startup.uz',
          code: '123456',
        ),
      ],
    );
  });
}
