abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthRegisterSuccess extends AuthState {} // Navigasi ke OTP Page

class OtpVerified extends AuthState {} // Navigasi ke login/home

class OtpSent extends AuthState {}

class OtpFailure extends AuthState {
  final String message;
  OtpFailure(this.message);
}

class LoginSuccess extends AuthState {
  // final AuthToken token;
  // LoginSuccess(this.token);
} // Home page

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
