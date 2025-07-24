import 'package:flutter/material.dart';

class PasswordInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final Color textColor;
  final InputDecoration decoration;

  const PasswordInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.validator,
    required this.textColor,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      style: TextStyle(
        color: textColor,
      ),
      decoration: decoration,
      validator: validator,
    );
  }
}
