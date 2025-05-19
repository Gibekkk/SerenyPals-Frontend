class User {
  final String id;
  final String name;
  final String notelepon;
  final String birthdate;
  final String email;
  final String password;
  final String token;

  const User({
    required this.id,
    required this.name,
    required this.notelepon,
    required this.birthdate,
    required this.email,
    required this.password,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      notelepon: json['notelepon'] ?? '',
      birthdate: json['birthdate'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'notelepon': notelepon,
      'birthdate': birthdate,
      'email': email,
      'password': password,
      'token': token,
    };
  }
}
