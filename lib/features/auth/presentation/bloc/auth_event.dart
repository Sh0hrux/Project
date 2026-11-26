import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

class LoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginRequestedEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];

  @override
  String toString() => 'LoginRequestedEvent(email: $email, password: ***MASKED***)';
}

class LogoutRequestedEvent extends AuthEvent {
  const LogoutRequestedEvent();
}
