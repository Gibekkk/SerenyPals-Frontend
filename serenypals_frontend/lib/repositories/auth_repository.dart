import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthRepository {
  final String _baseUrl = 'https://api.kamu.com'; // Ganti sesuai API kamu

  Future<UserModel> register({
    required String name,
    required String birthDate,
    required String phone,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'birth_date': birthDate,
        'phone': phone,
        'email': email,
        'password': password,
      }),
    );

    return _handleResponse(response, (data) => UserModel.fromJson(data));
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    return _handleResponse(response, (data) => UserModel.fromJson(data));
  }

  Future<void> verifyOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'otp': otp}),
    );

    if (response.statusCode != 200) {
      final error = _extractErrorMessage(response);
      throw Exception('OTP tidak valid: $error');
    }
  }

  // Helper untuk handle response & parsing error
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

  String _extractErrorMessage(http.Response response) {
    try {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      return jsonBody['message'] ?? 'Terjadi kesalahan';
    } catch (_) {
      return response.body;
    }
  }
}
