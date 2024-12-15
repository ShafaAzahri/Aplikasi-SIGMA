class UserModel {
  final String idLogin;
  final String username;
  final String role;
  final String? idUkm;

  UserModel({
    required this.idLogin,
    required this.username,
    required this.role,
    this.idUkm,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      idLogin: json['id_login'].toString(),
      username: json['username'],
      role: json['role'],
      idUkm: json['id_ukm']?.toString(),
    );
  }
}
