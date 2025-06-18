import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_services.dart';

class AuthRepository {
  final AuthService apiService;

  AuthRepository({required this.apiService});

  // 🔐 Simpan token autentikasi (dari backend)
  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
  }

  // 🔐 Ambil token autentikasi
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // ❌ Hapus token autentikasi
  Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }

  // 🔔 Ambil FCM Token dari Firebase
  Future<String?> getFcmToken() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        return await FirebaseMessaging.instance.getToken();
      } else {
        print('User denied permission for notifications');
        return null;
      }
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  // 🔔 Simpan FCM token ke SharedPreferences
  Future<void> saveFcmToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcmToken', token);
  }

  // 🔔 Ambil FCM token dari penyimpanan lokal
  Future<String?> getFcmTokenFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcmToken');
  }

  // 🔑 Login user
  Future<User> login(Map<String, dynamic> loginData) async {
    final response = await apiService.post('/auth/login', loginData);
    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));

      // Simpan auth token (jika tersedia dari backend)
      if (user.token != null) {
        await saveAuthToken(user.token!);
      }

      // Simpan FCM token (jika tersedia di user)
      // if (user.fcmToken != null) {
      //   await saveFcmToken(user.fcmToken!);
      // }

      return user;
    } else {
      throw Exception('Login gagal: ${response.statusCode}');
    }
  }

  // 📝 Register user
  Future<User> register(Map<String, dynamic> registerData) async {
    final response = await apiService.register(registerData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to register: ${response.statusCode} - ${response.body}');
    }
  }

  // 🔐 Kirim OTP untuk lupa password
  Future<void> sendForgotOtp(String email) async {
    await apiService.sendForgotOtp(email);
  }

  // 🔐 Verifikasi OTP lupa password
  Future<bool> verifyForgotOtp(String email, String otp) async {
    return await apiService.verifyForgotOtp(email, otp);
  }

  // 🔁 Reset password baru
  Future<void> resetPassword(String email, String newPassword) async {
    await apiService.resetPassword(email, newPassword);
  }

  // 👤 Ambil data profil (gunakan token dari storage)
  Future<User> getProfile() async {
    final token = await getAuthToken();
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await apiService.getProfile(token);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal mengambil profil: ${response.statusCode}');
    }
  }

  // ✏️ Update profil user
  Future<User> updateProfile(
      String token, Map<String, dynamic> updatedData) async {
    final response = await apiService.updateProfile(token, updatedData);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to update profile: ${response.statusCode} - ${response.body}');
    }
  }
}
