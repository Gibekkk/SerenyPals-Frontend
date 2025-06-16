// File: lib/models/user.dart

class User {
  final String id;
  final String name;
  final String email;
  final String token;
  final String? fcmToken; // fcmToken mungkin null atau tidak selalu ada
  final DateTime? createdAt; // createdAt juga mungkin null atau opsional

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.token,
    this.fcmToken,
    this.createdAt,
  });

  // Factory constructor untuk membuat objek User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
      fcmToken: json['fcmToken'] as String?, // Cast sebagai String?
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  // Metode untuk mengonversi objek User menjadi JSON (untuk dikirim ke API jika diperlukan)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
      'fcmToken': fcmToken,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}