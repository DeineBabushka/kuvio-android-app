class RegisterUserData {
  final String username;
  final String email;
  final String password;

  RegisterUserData({
    required this.username,
    required this.email,
    required this.password,
  });

  RegisterUserData copyWith({
    String? username,
    String? email,
    String? password,
  }) {
    return RegisterUserData(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  bool get isComplete =>
      username.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      password.trim().isNotEmpty;
}
