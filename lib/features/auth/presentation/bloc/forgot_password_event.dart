import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

class SendResetCodeEvent extends ForgotPasswordEvent {
  final String email;

  const SendResetCodeEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class VerifyResetCodeEvent extends ForgotPasswordEvent {
  final String code;

  const VerifyResetCodeEvent({required this.code});

  @override
  List<Object?> get props => [code];
}

class ResetPasswordSubmittedEvent extends ForgotPasswordEvent {
  final String newPassword;

  const ResetPasswordSubmittedEvent({required this.newPassword});

  @override
  List<Object?> get props => [newPassword];
}

class ResetForgotPasswordFlowEvent extends ForgotPasswordEvent {
  const ResetForgotPasswordFlowEvent();
}
