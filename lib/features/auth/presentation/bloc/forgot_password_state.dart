import 'package:equatable/equatable.dart';

enum ForgotPasswordStep { enterEmail, verifyCode, resetPassword, completed }

enum ForgotPasswordStatus { initial, loading, success, failure }

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStep step;
  final ForgotPasswordStatus status;
  final String email;
  final String code;
  final String? errorMessage;

  const ForgotPasswordState({
    this.step = ForgotPasswordStep.enterEmail,
    this.status = ForgotPasswordStatus.initial,
    this.email = '',
    this.code = '',
    this.errorMessage,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStep? step,
    ForgotPasswordStatus? status,
    String? email,
    String? code,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ForgotPasswordState(
      step: step ?? this.step,
      status: status ?? this.status,
      email: email ?? this.email,
      code: code ?? this.code,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [step, status, email, code, errorMessage];
}
