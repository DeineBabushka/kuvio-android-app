import 'package:flutter/material.dart';

class LoginFormCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onLogin;
  final VoidCallback onGoogleLogin;
  final VoidCallback onNavigateToRegister;
  final Color cardColor;
  final Color textColor;
  final Color labelColor;
  final Color headingColor;
  final Color iconColor;
  final Color buttonBackground;
  final Color buttonTextColor;

  const LoginFormCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePasswordVisibility,
    required this.onLogin,
    required this.onGoogleLogin,
    required this.onNavigateToRegister,
    required this.cardColor,
    required this.textColor,
    required this.labelColor,
    required this.headingColor,
    required this.iconColor,
    required this.buttonBackground,
    required this.buttonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Anmelden',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: headingColor,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: emailController,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: 'Email-Adresse',
              labelStyle: TextStyle(color: labelColor),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            style: TextStyle(color: textColor),
            obscureText: obscurePassword,
            decoration: InputDecoration(
              labelText: 'Passwort',
              labelStyle: TextStyle(color: labelColor),
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: iconColor,
                ),
                onPressed: onTogglePasswordVisibility,
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: onLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBackground,
              foregroundColor: buttonTextColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Einloggen',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: buttonTextColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: onGoogleLogin,
            icon: const Icon(Icons.login),
            label: const Text('Mit Google anmelden'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onNavigateToRegister,
            child: RichText(
              text: TextSpan(
                text: 'Noch kein Konto? ',
                style: TextStyle(color: textColor),
                children: [
                  TextSpan(
                    text: 'Registrieren',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
