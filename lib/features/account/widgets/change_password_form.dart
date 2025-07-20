import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuvio/features/account/services/user_service.dart';
import 'package:kuvio/features/account/widgets/change_password_button.dart';
import 'package:kuvio/features/auth/screens/login_screen.dart';
import 'package:kuvio/features/account/widgets/password_input_fields.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await UserService().changePassword(
      currentPassword: _currentPasswordController.text.trim(),
      newPassword: _newPasswordController.text.trim(),
    );

    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);

    if (result == null) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Passwort erfolgreich geändert.'),
          backgroundColor: Colors.green,
        ),
      );
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(result),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final inputColor = isDark ? Colors.white : Colors.black;
    final labelColor = isDark ? Colors.white70 : const Color(0xFF122620);
    final fillColor = isDark ? Colors.grey[850]! : Colors.white;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          PasswordInputFields.buildCurrentPasswordField(
            controller: _currentPasswordController,
            inputColor: inputColor,
            labelColor: labelColor,
            fillColor: fillColor,
            focusColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          PasswordInputFields.buildNewPasswordField(
            controller: _newPasswordController,
            inputColor: inputColor,
            labelColor: labelColor,
            fillColor: fillColor,
            focusColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          PasswordInputFields.buildRepeatPasswordField(
            controller: _repeatPasswordController,
            newPasswordController: _newPasswordController,
            inputColor: inputColor,
            labelColor: labelColor,
            fillColor: fillColor,
            focusColor: theme.colorScheme.primary,
          ),
          const SizedBox(height: 32),
          ChangePasswordButton(
            isLoading: _isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
