abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final String userId;

  RegisterSuccess({required this.userId});
class AuthRegisterSuccess extends AuthState {
  final String userId;
  AuthRegisterSuccess({required this.userId});

  List<Object?> get props => [userId];
} // Navigasi ke OTP Page

class RegisterFailure extends AuthState {
  final String message;
  RegisterFailure(this.message);
  List<Object?> get props => [message];
}

class OtpVerified extends AuthState {} // Navigasi ke login/home

class OtpSent extends AuthState {}

class OtpFailure extends AuthState {
  final String message;
  OtpFailure(this.message);

  List<Object?> get props => [message];
}

class LoginSuccess extends AuthState {
  final String token;
  LoginSuccess(this.token);
} // Home page

class LoginFailure extends AuthState {
  final String message;
  LoginFailure(this.message);

  AuthFailure(String error, this.message);
  List<Object?> get props => [message];
}

class ForgotOtpSent extends AuthState {}

class ForgotOtpVerified extends AuthState {}

class PasswordResetSuccess extends AuthState {
  final String message;
  PasswordResetSuccess(this.message);

  List<Object?> get props => [message];
}

class OtpResent extends AuthState {}

class ForgotPasswordFailure extends AuthState {
  final String message;
  ForgotPasswordFailure(this.message);

  List<Object?> get props => [message];
}
