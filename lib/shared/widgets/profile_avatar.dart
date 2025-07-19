import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? assetPath;
  final VoidCallback onEdit;

  const ProfileAvatar({
    super.key,
    required this.assetPath,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(assetPath ?? 'assets/character_1.png'),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
