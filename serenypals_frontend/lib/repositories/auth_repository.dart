import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
import '../models/user.dart'; // Ganti your_app_name
import '../services/auth_services.dart'; // Ganti your_app_name

class AuthRepository {
  final AuthService apiService;

  AuthRepository({required this.apiService});

  // Metode untuk mendapatkan FCM Token
  Future<String?> getFcmToken() async {
    try {
      // Minta izin notifikasi jika belum diberikan
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        return await FirebaseMessaging.instance.getToken();
      } else {
        print('User denied permission for notifications');
        return null; // Atau tangani sesuai kebutuhan
      }
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  // Metode register, menerima Map<String, dynamic> untuk body request
  Future<User> register(Map<String, dynamic> registerData) async {
    final response = await apiService.post('/auth/register/user', registerData);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Asumsi API mengembalikan data user yang diregistrasi
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register: ${response.statusCode} - ${response.body}');
    }
  }

  // Metode login, menerima Map<String, dynamic> untuk body request
  Future<User> login(Map<String, dynamic> loginData) async {
    final response = await apiService.post('/auth/login', loginData); // Asumsi endpoint login adalah /auth/login

    if (response.statusCode == 200) {
      // Asumsi API mengembalikan data user yang login
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login: ${response.statusCode} - ${response.body}');
    }
  }
}