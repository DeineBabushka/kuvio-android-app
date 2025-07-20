import 'package:flutter/material.dart';
import 'package:kuvio/shared/models/app_user.dart';
import 'package:kuvio/features/admin/services/admin_service.dart';
import 'package:kuvio/shared/utils/constants.dart';
import 'package:kuvio/features/admin/widgets/user_delete_dialog.dart';

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
                      backgroundColor: AppColors.snackSuccess,
                    ),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm =
                    await showUserDeleteDialog(context, user.username);
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
