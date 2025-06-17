import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class RegisterUser extends AuthEvent {
  final String name;
  final String birthDate;
  final String phone;
  final String email;
  final String password;

  const RegisterUser({
    required this.name,
    required this.birthDate,
    required this.phone,
    required this.email,
    required this.password,
    required bool subscribeNewsletter,
  });

  @override
  List<Object?> get props => [name, birthDate, phone, email, password];
}

class VerifyOtp extends AuthEvent {
  final String email;
  final String otp;

  const VerifyOtp({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class LoginUser extends AuthEvent {
  final String email;
  final String password;
  final String? fcmToken;

  const LoginUser(
      {required this.email, required this.password, required this.fcmToken});

  @override
  List<Object?> get props => [email, password, fcmToken];
}

class RequestForgotPassword extends AuthEvent {
  final String email;

  const RequestForgotPassword({required this.email});

  @override
  List<Object?> get props => [email];
}

class VerifyForgotOtp extends AuthEvent {
  final String email;
  final String otp;

  const VerifyForgotOtp({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

class ResetPassword extends AuthEvent {
  final String email;
  final String newPassword;

  const ResetPassword({required this.email, required this.newPassword});

  @override
  List<Object?> get props => [email, newPassword];
}

class Logout extends AuthEvent {
  const Logout();

  @override
  List<Object?> get props => [];
}
