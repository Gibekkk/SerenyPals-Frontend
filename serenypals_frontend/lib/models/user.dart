// File: lib/models/user.dart

class User {
  final String id;
  final String name;
  final String email;
  final String birthDate;
  final String phone;
  final String? token; // fcmToken mungkin null atau tidak selalu ada
  final DateTime? createdAt; // createdAt juga mungkin null atau opsional

  User({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.phone,
    required this.email,
    required this.token,
    this.createdAt,
  });

  // Factory constructor untuk membuat objek User dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      birthDate: json['birthDate'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      token: json['fcmToken'] as String?, // fcmToken bisa null
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
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
