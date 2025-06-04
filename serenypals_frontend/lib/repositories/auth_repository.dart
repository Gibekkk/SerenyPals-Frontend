import '../models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../services/auth_services.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<UserModel> register({
    required String name,
    required String birthDate,
    required String phone,
    required String email,
    required String password,
  }) async {
    final response = await _authService.register({
      'name': name,
      'birth_date': birthDate,
      'phone': phone,
      'email': email,
      'password': password,
    });

    return _handleResponse(response, (data) => UserModel.fromJson(data));
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _authService.login({
      'email': email,
      'password': password,
    });

    return _handleResponse(response, (data) => UserModel.fromJson(data));
  }

  Future<void> verifyOtp(String email, String otp) async {
    final response = await _authService.verifyOtp({'email': email, 'otp': otp});

    if (response.statusCode != 200) {
      final error = _extractErrorMessage(response);
      throw Exception('OTP tidak valid: $error');
    }
  }

  // Helper untuk handle response & parsing error

  String _extractErrorMessage(http.Response response) {
    try {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      return jsonBody['message'] ?? 'Terjadi kesalahan';
    } catch (_) {
      return response.body;
    }
  }

  Future<void> sendForgotOtp(String email) async {
    await _authService.sendForgotOtp(email);
  }

  Future<bool> verifyForgotOtp(String email, String otp) async {
    return await _authService.verifyForgotOtp(email, otp);
  }

  Future<void> resetPassword(String email, String newPassword) async {
    await _authService.resetPassword(email, newPassword);
  }

  Future<UserModel> getUserProfile() async {
    // Implementasi untuk mendapatkan profil user
    // Misalnya panggil API dan kembalikan UserModel
    final response = await http.get(
      Uri.parse('https://api.kamu.com/user/profile'),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mendapatkan profil user');
    }
  }

  T _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) onSuccess,
  ) {
    final Map<String, dynamic> body = json.decode(response.body);

    switch (response.statusCode) {
      case 200:
        return onSuccess(body);
      case 400:
        throw Exception(
          'Permintaan tidak valid: ${body['message'] ?? 'Cek kembali data kamu'}',
        );
      case 401:
        throw Exception(
          'Tidak terotorisasi: ${body['message'] ?? 'Login gagal'}',
        );
      case 404:
        throw Exception(
          'Tidak ditemukan: ${body['message'] ?? 'Endpoint salah'}',
        );
      case 500:
        throw Exception(
          'Server error: ${body['message'] ?? 'Coba beberapa saat lagi'}',
        );
      default:
        throw Exception(
          'Error ${response.statusCode}: ${body['message'] ?? 'Terjadi kesalahan'}',
        );
    }
  }
}
