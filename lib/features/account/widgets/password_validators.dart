import 'package:kuvio/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

String? validateCurrentPassword(String? value, BuildContext context) {
  final loc = AppLocalizations.of(context)!;
  if (value == null || value.isEmpty) {
    return loc.enterCurrentPassword;
  }
  return null;
}

String? validateNewPassword(String? value, BuildContext context) {
  final loc = AppLocalizations.of(context)!;
  if (value == null || value.isEmpty) {
    return loc.enterNewPassword;
  }
  if (value.length < 6) {
    return loc.passwordHint;
  }
  return null;
}

String? validateRepeatPassword(
    String? value, String originalPassword, BuildContext context) {
  final loc = AppLocalizations.of(context)!;
  if (value != originalPassword) {
    return loc.passwordsDontMatch;
  }
  return null;
}
