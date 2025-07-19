import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/google_auth_service.dart';
import '../../account/services/user_service.dart';

class LoginActions {
  final UserService _userService;
  final GoogleAuthService _googleAuthService;

  LoginActions(this._userService, this._googleAuthService);

  Future<void> handleLogin({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    try {
      final credential = await _userService.loginWithEmail(
        emailController.text,
        passwordController.text,
      );

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
      if (context.mounted) {
        final message = _userService.getErrorMessage(e.code);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unbekannter Fehler')),
        );
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
}
