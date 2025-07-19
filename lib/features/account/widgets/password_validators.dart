String? validateCurrentPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Bitte aktuelles Passwort eingeben';
  }
  return null;
}

String? validateNewPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Bitte neues Passwort eingeben';
  }
  if (value.length < 6) {
    return 'Mindestens 6 Zeichen';
  }
  return null;
}

String? validateRepeatPassword(String? value, String originalPassword) {
  if (value != originalPassword) {
    return 'Passwörter stimmen nicht überein';
  }
  return null;
}
