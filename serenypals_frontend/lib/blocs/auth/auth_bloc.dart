import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:serenypals_frontend/models/login_request.dart';

import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepo;

  AuthBloc(this.authRepo) : super(AuthInitial()) {
    on<RegisterUser>(_onRegister);
    on<VerifyOtp>(_onVerifyOtp);
    on<LoginUser>(_onLogin);
    on<RequestForgotPassword>(_onRequestForgotPassword);
    on<VerifyForgotOtp>(_onVerifyForgotOtp);
    on<ResetPassword>(_onResetPassword);
  }

  Future<void> _onRegister(RegisterUser event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final registerData = RegisterRequestModel(
        name: event.name,
        birthDate: event.birthDate,
        phone: event.phone,
        email: event.email,
        password: event.password,
      );

      // Panggil repository dan dapatkan User object
      final user = await authRepo.register(registerData.toJson());

      // Simpan userId jika perlu
      final userId = user.id;

      emit(AuthRegisterSuccess(userId: userId));
    } catch (e) {
      emit(RegisterFailure("Gagal melakukan pendaftaran")); // ✅
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
      final loginData = LoginRequestModel(
          email: event.email,
          password: event.password,
          fcmToken: event.fcmToken);
      await authRepo.login(loginData.toJson());
      // final token = AuthToken.fromJson(response);
      emit(LoginSuccess());
    } catch (e) {
      emit(AuthFailure("Email atau password salah"));
    }
  }

  Future<void> _onRequestForgotPassword(
    RequestForgotPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepo.sendForgotOtp(event.email);
      emit(ForgotOtpSent());
    } catch (e) {
      emit(ForgotPasswordFailure('Gagal mengirim OTP'));
    }
  }

  Future<void> _onVerifyForgotOtp(
    VerifyForgotOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final verified = await authRepo.verifyForgotOtp(event.email, event.otp);
      if (verified) {
        emit(ForgotOtpVerified());
      } else {
        emit(ForgotPasswordFailure('OTP salah'));
      }
    } catch (e) {
      emit(ForgotPasswordFailure('Verifikasi OTP gagal'));
    }
  }

  Future<void> _onResetPassword(
    ResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authRepo.resetPassword(event.email, event.newPassword);
      emit(PasswordResetSuccess(event.email));
    } catch (e) {
      emit(ForgotPasswordFailure('Reset password gagal'));
    }
  }
}
