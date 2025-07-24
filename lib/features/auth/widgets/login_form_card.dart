import 'package:flutter/material.dart';
import 'package:kuvio/localization/app_localizations.dart';
import 'package:kuvio/shared/utils/block_if_offline.dart';

class LoginFormCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onLogin;
  final VoidCallback onGoogleLogin;
  final VoidCallback onNavigateToRegister;
  final VoidCallback onForgotPassword;
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
    required this.onForgotPassword,
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
    final loc = AppLocalizations.of(context)!;

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
            loc.loginTitle,
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
              labelText: loc.loginEmailLabel,
              labelStyle: TextStyle(color: labelColor),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: passwordController,
            style: TextStyle(color: textColor),
            obscureText: obscurePassword,
            decoration: InputDecoration(
              labelText: loc.loginPasswordLabel,
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
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                if (blockIfOffline(context)) return;
                onForgotPassword();
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              child: Text(
                loc.loginForgotPassword,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF122620),
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                  decorationColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : const Color(0xFF122620),
                  decorationThickness: 2.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              if (blockIfOffline(context)) return;
              onLogin();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBackground,
              foregroundColor: buttonTextColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              loc.loginButton,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: buttonTextColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              if (blockIfOffline(context)) return;
              onGoogleLogin();
            },
            icon: const Icon(Icons.login),
            label: Text(loc.loginGoogle),
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
            onTap: () {
              if (blockIfOffline(context)) return;
              onNavigateToRegister();
            },
            child: RichText(
              text: TextSpan(
                text: loc.loginNoAccount,
                style: TextStyle(color: textColor),
                children: [
                  TextSpan(
                    text: loc.loginRegisterNow,
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
