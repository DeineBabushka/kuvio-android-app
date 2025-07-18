import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.email == null) return;

    setState(() => _isLoading = true);

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPasswordController.text.trim(),
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(_newPasswordController.text.trim());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Passwort erfolgreich geändert.'),
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Das aktuelle Passwort ist falsch.';
          break;
        case 'requires-recent-login':
          errorMessage =
              'Bitte melde dich erneut an, um dein Passwort zu ändern.';
          break;
        case 'user-mismatch':
          errorMessage =
              'Anmeldedaten stimmen nicht mit dem aktuellen Nutzer überein.';
          break;
        case 'invalid-credential':
          errorMessage = 'Das aktuelle Passwort ist falsch.';
          break;
        default:
          errorMessage = 'Fehler beim Ändern des Passworts.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(errorMessage),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final inputColor = isDark ? Colors.white : Colors.black;
    final labelColor = isDark ? Colors.white70 : const Color(0xFF122620);
    final fillColor = isDark ? Colors.grey[850] : Colors.white;

    InputDecoration inputDecoration(String label, String hint) {
      return InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: labelColor),
        hintStyle: TextStyle(color: labelColor.withAlpha(153)), // 0.6 * 255
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: labelColor.withAlpha(128)), // 0.5 * 255
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.primary),
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passwort ändern'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                style: TextStyle(color: inputColor),
                decoration: inputDecoration(
                  'Aktuelles Passwort',
                  'Gib dein aktuelles Passwort ein',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte aktuelles Passwort eingeben';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                style: TextStyle(color: inputColor),
                decoration: inputDecoration(
                  'Neues Passwort',
                  'Mindestens 6 Zeichen',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte neues Passwort eingeben';
                  }
                  if (value.length < 6) {
                    return 'Mindestens 6 Zeichen';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _repeatPasswordController,
                obscureText: true,
                style: TextStyle(color: inputColor),
                decoration: inputDecoration(
                  'Passwort wiederholen',
                  'Wiederhole das neue Passwort',
                ),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Passwörter stimmen nicht überein';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Passwort ändern'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
