class UserModel {
  final String name;
  final String birthDate;
  final String phone;
  final String email;

  UserModel({
    required this.name,
    required this.birthDate,
    required this.phone,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      birthDate: json['birth_date'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}
