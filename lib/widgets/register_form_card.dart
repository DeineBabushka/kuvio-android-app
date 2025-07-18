import 'package:flutter/material.dart';

class RegisterFormCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback toggleObscurePassword;
  final VoidCallback onSubmit;
  final Color cardColor;
  final Color textColor;
  final Color labelColor;
  final Color fieldTextColor;
  final Color buttonBackground;
  final Color buttonTextColor;

  const RegisterFormCard({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.toggleObscurePassword,
    required this.onSubmit,
    required this.cardColor,
    required this.textColor,
    required this.labelColor,
    required this.fieldTextColor,
    required this.buttonBackground,
    required this.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Konto erstellen',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: usernameController,
              style: TextStyle(color: fieldTextColor),
              decoration: InputDecoration(
                labelText: 'Benutzername',
                labelStyle: TextStyle(color: labelColor),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Benutzername eingeben'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              style: TextStyle(color: fieldTextColor),
              decoration: InputDecoration(
                labelText: 'E-Mail',
                labelStyle: TextStyle(color: labelColor),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'E-Mail eingeben';
                final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value))
                  return 'Ungültige E-Mail-Adresse';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              style: TextStyle(color: fieldTextColor),
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: 'Passwort',
                labelStyle: TextStyle(color: labelColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: labelColor,
                  ),
                  onPressed: toggleObscurePassword,
                ),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Passwort eingeben' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBackground,
                foregroundColor: buttonTextColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Registrieren',
                style: TextStyle(color: buttonTextColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
