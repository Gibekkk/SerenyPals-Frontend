// File: lib/models/register_request_model.dart

class RegisterRequestModel {
  final String name;
  final String birthDate;
  final String phone;
  final String email;
  final String password;
  final String? fcmToken; // Optional, tergantung API Anda
  // Anda juga bisa menambahkan fcmToken di sini jika dikirim saat register

  RegisterRequestModel({
    required this.name,
    required this.birthDate,
    required this.phone,
    required this.email,
    required this.password,
    this.fcmToken,
  });

  // Metode untuk mengonversi objek ini ke Map untuk dikirim sebagai JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDate': birthDate,
      'phone': phone,
      'email': email,
      'password': password,
      if (fcmToken != null) 'fcmToken': fcmToken, // Hanya tambahkan jika ada
    };
  }
}

// File: lib/models/login_request_model.dart

class LoginRequestModel {
  final String email;
  final String password;
  final String? token; // Optional, tergantung API Anda

  LoginRequestModel({
    required this.email,
    required this.password,
    required this.token,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,

      if (token != null) 'fcmToken': token, // Hanya tambahkan jika ada
    };
  }
}
