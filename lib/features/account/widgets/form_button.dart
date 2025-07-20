import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;

  const FormButton({
    super.key,
    required this.icon,
    required this.text,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
