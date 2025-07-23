import 'package:flutter/material.dart';
import 'package:kuvio/localization/context_extension.dart';

class EditProfileButton extends StatelessWidget {
  final VoidCallback onTap;

  const EditProfileButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.edit, color: Colors.white70),
        label: Text(
          context.loc.editProfile,
          style: const TextStyle(color: Colors.white70, fontSize: 18),
        ),
      ),
    );
  }
}
