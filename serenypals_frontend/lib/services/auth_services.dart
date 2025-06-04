import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String _baseUrl = 'https://api.kamu.com';

  Future<http.Response> register(Map<String, dynamic> data) {
    return http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  Future<http.Response> login(Map<String, dynamic> data) {
    return http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  Future<http.Response> verifyOtp(Map<String, dynamic> data) {
    return http.post(
      Uri.parse('$_baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
  }

  Future<void> sendForgotOtp(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception('OTP gagal dikirim');
    }
  }

  Future<bool> verifyForgotOtp(String email, String otp) async {
    // Simulasi valid OTP
    return otp == "123456";
  }

  Future<void> resetPassword(String email, String newPassword) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': newPassword}),
    );

    if (response.statusCode != 200) {
      throw Exception('Reset password gagal');
    }
  }
}
