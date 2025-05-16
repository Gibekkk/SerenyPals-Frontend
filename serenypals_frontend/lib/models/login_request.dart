class LoginRequest {
  final String id;
  final String email;
  final String password;

  LoginRequest({required this.id, required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(
      id: json['id'] ?? '', // Fallback to empty string if id is null
      email: json['email'] ?? '', // Fallback to empty string if email is null
      password:
          json['password'] ??
          '', // Fallback to empty string if password is null
    );
  }

  // Method to convert LoginRequest to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'password': password};
  }

  // Optionally, you can add a validation method
  bool isValid() {
    return id.isNotEmpty && email.isNotEmpty && password.isNotEmpty;
  }
}
