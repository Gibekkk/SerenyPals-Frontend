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

  const LoginUser({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
