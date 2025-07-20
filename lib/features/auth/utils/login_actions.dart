import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuvio/features/auth/services/google_auth_service.dart';
import 'package:kuvio/shared/services/user_service.dart';

class LoginActions {
  final UserService _userService;
  final GoogleAuthService _googleAuthService;

  LoginActions(this._userService, this._googleAuthService);

  Future<void> handleLogin({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      _showError(context, 'Bitte gib deine E-Mail-Adresse ein.');
      return;
    }

    if (!email.contains('@')) {
      _showError(context, 'Bitte gib eine gültige E-Mail-Adresse ein.');
      return;
    }

    if (password.isEmpty) {
      _showError(context, 'Bitte gib dein Passwort ein.');
      return;
    }

    try {
      final credential = await _userService.loginWithEmail(email, password);

      final user = credential.user;
      if (user == null) return;

      final isAdmin = await _userService.isAdmin(user.uid);
      debugPrint('Angemeldeter Benutzer ist Admin: $isAdmin');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFF2E6B4D),
            content: Text(
              'Erfolgreich eingeloggt',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (!context.mounted) return;

      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Diese E-Mail-Adresse ist nicht registriert.';
          break;
        case 'wrong-password':
          message = 'Falsches Passwort.';
          break;
        case 'invalid-email':
          message = 'Ungültige E-Mail-Adresse.';
          break;
        default:
          message = 'Anmeldung fehlgeschlagen. (${e.message})';
      }

      _showError(context, message);
    } catch (_) {
      if (context.mounted) {
        _showError(context, 'Unbekannter Fehler ist aufgetreten.');
      }
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final result = await _googleAuthService.signInWithGoogle();
    if (!context.mounted) return;

    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google-Login fehlgeschlagen: ${result.error}')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF2E6B4D),
        content: Text(
          'Erfolgreich mit Google eingeloggt',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    Navigator.pop(context);
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1C3C32),
      ),
    );
  }
}
