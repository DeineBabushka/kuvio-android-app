import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../widgets/password_input_field.dart';
import '../../widgets/password_input_decoration_helper.dart';

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

  Future<void> _handlePasswordChange() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final result = await UserService().changePassword(
      currentPassword: _currentPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: result == null ? Colors.green : Colors.red,
        content: Text(result ?? 'Passwort erfolgreich geändert.'),
      ),
    );

    if (result == null) Navigator.pop(context);
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final inputColor = isDark ? Colors.white : Colors.black;
    final labelColor = isDark ? Colors.white70 : const Color(0xFF122620);
    final fillColor = isDark ? Colors.grey[850]! : Colors.white;

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
              PasswordInputField(
                controller: _currentPasswordController,
                label: 'Aktuelles Passwort',
                hint: 'Gib dein aktuelles Passwort ein',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte aktuelles Passwort eingeben';
                  }
                  return null;
                },
                textColor: inputColor,
                decoration: buildPasswordInputDecoration(
                  label: 'Aktuelles Passwort',
                  hint: 'Gib dein aktuelles Passwort ein',
                  labelColor: labelColor,
                  fillColor: fillColor,
                  focusColor: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              PasswordInputField(
                controller: _newPasswordController,
                label: 'Neues Passwort',
                hint: 'Mindestens 6 Zeichen',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte neues Passwort eingeben';
                  }
                  if (value.length < 6) {
                    return 'Mindestens 6 Zeichen';
                  }
                  return null;
                },
                textColor: inputColor,
                decoration: buildPasswordInputDecoration(
                  label: 'Neues Passwort',
                  hint: 'Mindestens 6 Zeichen',
                  labelColor: labelColor,
                  fillColor: fillColor,
                  focusColor: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              PasswordInputField(
                controller: _repeatPasswordController,
                label: 'Passwort wiederholen',
                hint: 'Wiederhole das neue Passwort',
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'Passwörter stimmen nicht überein';
                  }
                  return null;
                },
                textColor: inputColor,
                decoration: buildPasswordInputDecoration(
                  label: 'Passwort wiederholen',
                  hint: 'Wiederhole das neue Passwort',
                  labelColor: labelColor,
                  fillColor: fillColor,
                  focusColor: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _handlePasswordChange,
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
