import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_app/core/error/failures.dart';
import 'package:startup_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:startup_app/features/auth/presentation/bloc/forgot_password_event.dart';
import 'package:startup_app/features/auth/presentation/bloc/forgot_password_state.dart';

export 'forgot_password_event.dart';
export 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthRepository authRepository;

  ForgotPasswordBloc({required this.authRepository})
      : super(const ForgotPasswordState()) {
    on<SendResetCodeEvent>(_onSendResetCode);
    on<VerifyResetCodeEvent>(_onVerifyCode);
    on<ResetPasswordSubmittedEvent>(_onResetPassword);
    on<ResetForgotPasswordFlowEvent>(_onResetFlow);
  }

  Future<void> _onSendResetCode(
    SendResetCodeEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading, clearError: true));
    try {
      await authRepository.sendResetCode(email: event.email);
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.success,
          step: ForgotPasswordStep.verifyCode,
          email: event.email,
        ),
      );
    } on Failure catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: 'Kutilmagan xatolik yuz berdi',
        ),
      );
    }
  }

  Future<void> _onVerifyCode(
    VerifyResetCodeEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading, clearError: true));
    try {
      await authRepository.verifyCode(email: state.email, code: event.code);
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.success,
          step: ForgotPasswordStep.resetPassword,
          code: event.code,
        ),
      );
    } on Failure catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: 'Kutilmagan xatolik yuz berdi',
        ),
      );
    }
  }

  Future<void> _onResetPassword(
    ResetPasswordSubmittedEvent event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading, clearError: true));
    try {
      await authRepository.resetPassword(
        email: state.email,
        code: state.code,
        newPassword: event.newPassword,
      );
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.success,
          step: ForgotPasswordStep.completed,
        ),
      );
    } on Failure catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.failure,
          errorMessage: 'Kutilmagan xatolik yuz berdi',
        ),
      );
    }
  }

  void _onResetFlow(
    ResetForgotPasswordFlowEvent event,
    Emitter<ForgotPasswordState> emit,
  ) {
    emit(const ForgotPasswordState());
  }
}
