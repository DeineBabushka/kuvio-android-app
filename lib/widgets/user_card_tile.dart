import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuvio/services/admin_service.dart';

class UserCardTile extends StatelessWidget {
  final DocumentSnapshot userDoc;
  final Color cardTextColor;

  const UserCardTile({
    super.key,
    required this.userDoc,
    required this.cardTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final userData = userDoc.data() as Map<String, dynamic>;
    final username = userData['username'] ?? 'Unbekannt';
    final isAdmin = userData['isAdmin'] == true;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: ListTile(
        title: Text(
          username,
          style: TextStyle(
            color: cardTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          isAdmin ? 'Admin' : 'Benutzer',
          style: TextStyle(
            color: cardTextColor.withAlpha(204),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: isAdmin,
              onChanged: (value) async {
                await AdminService.setAdminStatus(userDoc.id, value);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Adminstatus von "$username" geändert.',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: const Color(0xFF2E6B4D),
                    ),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Benutzer löschen'),
                    content: Text(
                      'Willst du "$username" wirklich löschen?',
                      style: const TextStyle(color: Colors.black),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Abbrechen'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Löschen'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await AdminService.deleteUser(userDoc.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Benutzer "$username" wurde gelöscht.',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
