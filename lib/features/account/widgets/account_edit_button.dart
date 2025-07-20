import 'package:flutter/material.dart';

class EditProfileButton extends StatelessWidget {
  final VoidCallback onTap;

  const EditProfileButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.edit, color: Colors.white70),
        label: const Text(
          "Profil bearbeiten",
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
      ),
    );
  }
}
