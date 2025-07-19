import 'package:flutter/material.dart';

class ChangePasswordButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const ChangePasswordButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Passwort ändern'),
          );
  }
}
