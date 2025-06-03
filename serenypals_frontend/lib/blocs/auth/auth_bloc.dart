import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;

  AuthBloc(this.authRepo) : super(AuthInitial()) {
    on<RegisterUser>(_onRegister);
    on<VerifyOtp>(_onVerifyOtp);
    on<LoginUser>(_onLogin);
  }

  Future<void> _onRegister(RegisterUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepo.register(
        name: event.name,
        birthDate: event.birthDate,
        phone: event.phone,
        email: event.email,
        password: event.password,
      );
      emit(AuthRegisterSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onVerifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepo.verifyOtp(event.email, event.otp);
      emit(OtpVerified());
    } catch (e) {
      emit(AuthFailure("OTP tidak valid atau expired"));
    }
  }

  Future<void> _onLogin(LoginUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepo.login(email: event.email, password: event.password);
      // final token = AuthToken.fromJson(response);
      emit(LoginSuccess());
    } catch (e) {
      emit(AuthFailure("Email atau password salah"));
    }
  }
}
