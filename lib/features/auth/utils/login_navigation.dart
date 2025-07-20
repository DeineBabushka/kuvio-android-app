import 'package:flutter/material.dart';
import 'package:kuvio/features/auth/screens/register_screen.dart';

void navigateToRegister(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const RegisterScreen()),
  );
}
