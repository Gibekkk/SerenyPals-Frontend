import 'dart:convert';
import 'package:http/http.dart' as http;
import 'consts.dart'; // Pastikan path ini benar, misal: 'package:your_app_name/utils/consts.dart'

class AuthService {
  // Gunakan 'baseUrl' yang sudah didefinisikan dari AppConstants
  final String baseUrl = AppConstants.BASE_URL;

  // Metode POST umum yang bisa digunakan oleh semua fungsi lainnya
  Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl$endpoint'); // <-- Perhatikan: pakai '$baseUrl'
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(data);

    try {
      final response = await http.post(url, headers: headers, body: body);
      return response;
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  // Menggunakan kembali metode 'post' untuk setiap fungsi spesifik

  Future<http.Response> register(Map<String, dynamic> data) {
    return post('/register', data); // Memanggil metode 'post' di atas
  }

  Future<http.Response> login(Map<String, dynamic> data) {
    return post('/login', data); // Memanggil metode 'post' di atas
  }

  Future<http.Response> verifyOtp(Map<String, dynamic> data) {
    return post('/verify-otp', data); // Memanggil metode 'post' di atas
  }

  Future<void> sendForgotOtp(String email) async {
    final response = await post('/send-otp', {'email': email}); // Memanggil metode 'post' di atas

    if (response.statusCode != 200) {
      throw Exception('OTP gagal dikirim');
    }
  }

  Future<bool> verifyForgotOtp(String email, String otp) async {
    // Note: Anda bilang ini simulasi, jadi saya biarkan seperti ini.
    // Jika Anda ingin ini memanggil API, Anda bisa gunakan 'post' juga:
    // final response = await post('/verify-forgot-otp', {'email': email, 'otp': otp});
    // if (response.statusCode == 200) { /* handle success */ } else { /* handle failure */ }
    return otp == "123456";
  }

  Future<void> resetPassword(String email, String newPassword) async {
    final response = await post('/reset-password', {'email': email, 'password': newPassword}); // Memanggil metode 'post' di atas

    if (response.statusCode != 200) {
      throw Exception('Reset password gagal');
    }
  }
}