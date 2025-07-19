import 'package:flutter/material.dart';

class AccountDeleteHint extends StatelessWidget {
  const AccountDeleteHint({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Wenn du dein Konto löscht, werden all deine\nBenutzerdaten und dein Zugang unwiderruflich gelöscht.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white60, fontSize: 13),
    );
  }
}
