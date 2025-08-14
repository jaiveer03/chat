class UserModel {
  final String id;
  final String role;
  final String email;
  final String name;

  UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      id: json['_id'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
