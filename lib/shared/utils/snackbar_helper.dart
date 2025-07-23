import 'package:flutter/material.dart';

class SnackbarHelper {
  static const Color _commonColor = Color(0xFF2E6B4D);

  static void showMessage(BuildContext context, String message) {
    if (!context.mounted) return;

    final snackBar = SnackBar(
      backgroundColor: _commonColor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

/// Für alte Verwendung (falls noch verwendet)
void showSuccessMessage(BuildContext context, String message) {
  SnackbarHelper.showMessage(context, message);
}
