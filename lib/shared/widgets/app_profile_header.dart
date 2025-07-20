import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileHeader extends StatelessWidget {
  final String username;
  final String? profileImage;

  const ProfileHeader({
    super.key,
    required this.username,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(profileImage ?? 'assets/character_1.png'),
          backgroundColor: Colors.transparent,
        ),
        const SizedBox(height: 16),
        Text(
          username,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          FirebaseAuth.instance.currentUser?.email ?? '',
          style: const TextStyle(fontSize: 18, color: Colors.white60),
        ),
      ],
    );
  }
}
