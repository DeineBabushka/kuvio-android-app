import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuvio/features/auth/services/google_auth_service.dart';
import 'package:kuvio/shared/services/user_service.dart';
import 'package:kuvio/localization/app_localizations.dart';
import 'package:kuvio/shared/utils/snackbar_helper.dart';

class LoginActions {
  final UserService _userService;
  final GoogleAuthService _googleAuthService;

  LoginActions(this._userService, this._googleAuthService);

  Future<void> handleLogin({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    final loc = AppLocalizations.of(context)!;

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      _showError(context, loc.loginErrorMissingEmail);
      return;
    }
    if (!email.contains('@')) {
      _showError(context, loc.loginErrorInvalidEmail);
      return;
    }
    if (password.isEmpty) {
      _showError(context, loc.loginErrorMissingPassword);
      return;
    }

    try {
      final credential = await _userService.loginWithEmail(email, password);
      final user = credential.user;
      if (user == null) return;

      await _userService.isAdmin(user.uid);
      if (!context.mounted) return;

      SnackbarHelper.showMessage(context, loc.loginSuccess);
      Navigator.pop(context);
    } on FirebaseAuthException {
      if (context.mounted) {
        _showError(context, loc.loginErrorWrongCredentials);
      }
    } catch (_) {
      if (context.mounted) {
        _showError(context, loc.loginErrorUnknown);
      }
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    final result = await _googleAuthService.signInWithGoogle();
    if (!context.mounted) return;

    if (result.error != null) {
      _showError(context, '${loc.loginErrorGoogleFailed}: ${result.error}');
      return;
    }

    SnackbarHelper.showMessage(context, loc.loginGoogleSuccess);
    Navigator.pop(context);
  }

  void _showError(BuildContext context, String message) {
    SnackbarHelper.showMessage(context, message);
  }
}
