import 'package:equatable/equatable.dart';
import '../../../../../core/params/login_params.dart';
import '../../../../../core/params/signup_params.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final LoginParams params;
  const LoginEvent({required this.params});
}

class SignUpEvent extends AuthEvent {
  final SignUpParams params;
  const SignUpEvent({required this.params});
}

class LoginWithGoogleEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class DeleteAccountEvent extends AuthEvent {}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  const ForgotPasswordEvent({required this.email});
}
