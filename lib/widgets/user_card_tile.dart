import 'package:flutter/material.dart';
import 'package:kuvio/models/app_user.dart';
import 'package:kuvio/services/admin_service.dart';

class UserCardTile extends StatelessWidget {
  final AppUser user;
  final Color cardTextColor;

  const UserCardTile({
    super.key,
    required this.user,
    required this.cardTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: ListTile(
        title: Text(
          user.username,
          style: TextStyle(
            color: cardTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          user.isAdmin ? 'Admin' : 'Benutzer',
          style: TextStyle(
            color: cardTextColor.withAlpha(204),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: user.isAdmin,
              onChanged: (value) async {
                await AdminService.setAdminStatus(user.id, value);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Adminstatus von "${user.username}" geändert.',
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
                      'Willst du "${user.username}" wirklich löschen?',
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
                  await AdminService.deleteUser(user.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Benutzer "${user.username}" wurde gelöscht.',
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
