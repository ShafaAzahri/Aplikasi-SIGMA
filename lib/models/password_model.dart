class PasswordModel {
  final String oldPassword;
  final String newPassword;

  PasswordModel({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, String> toJson() {
    return {
      'old_password': oldPassword,
      'new_password': newPassword,
    };
  }
}