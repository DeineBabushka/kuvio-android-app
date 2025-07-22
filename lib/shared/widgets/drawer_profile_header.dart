import 'package:flutter/material.dart';
import 'package:kuvio/l10n/context_extension.dart';

class DrawerProfileHeader extends StatelessWidget {
  final String username;
  final String? bio;
  final String? profileImage;

  const DrawerProfileHeader({
    super.key,
    required this.username,
    required this.bio,
    required this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(profileImage ?? 'assets/character_1.png'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                (bio != null && bio!.isNotEmpty) ? bio! : loc.noDescription,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
