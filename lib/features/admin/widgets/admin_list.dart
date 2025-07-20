import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuvio/shared/models/app_user.dart';
import 'package:kuvio/features/admin/widgets/admin_card_tile.dart';

class UserList extends StatelessWidget {
  final Stream<QuerySnapshot> userStream;
  final Color cardTextColor;

  const UserList({
    super.key,
    required this.userStream,
    required this.cardTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        final users = snapshot.data?.docs ?? [];

        if (users.isEmpty) {
          return const Center(
            child: Text(
              'Keine Benutzer gefunden.',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userDoc = users[index];
            final user = AppUser.fromSnapshot(userDoc);
            return UserCardTile(
              user: user,
              cardTextColor: cardTextColor,
            );
          },
        );
      },
    );
  }
}
