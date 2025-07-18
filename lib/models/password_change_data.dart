class PasswordChangeData {
  final String currentPassword;
  final String newPassword;
  final String repeatPassword;

  PasswordChangeData({
    required this.currentPassword,
    required this.newPassword,
    required this.repeatPassword,
  });

  bool get isNewPasswordValid => newPassword.length >= 6;

  bool get isRepeatCorrect => newPassword == repeatPassword;
}
