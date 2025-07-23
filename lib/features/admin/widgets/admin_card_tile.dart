import 'package:flutter/material.dart';
import 'package:kuvio/shared/models/app_user.dart';
import 'package:kuvio/features/admin/services/admin_service.dart';
import 'package:kuvio/features/admin/widgets/admin_delete_dialog.dart';
import 'package:kuvio/shared/utils/snackbar_helper.dart';

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
    final tileColor = const Color(0xFF2E6B4D); // identisch wie im Drawer

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: tileColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.person, color: Colors.white),
        title: Text(
          user.username,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          user.isAdmin ? 'Admin' : 'Benutzer',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: user.isAdmin,
              onChanged: (value) async {
                await AdminService.setAdminStatus(user.id, value);
                if (context.mounted) {
                  SnackbarHelper.showMessage(
                    context,
                    'Adminstatus von "${user.username}" geändert.',
                  );
                }
              },
              activeColor: Colors.white,
              inactiveThumbColor: Colors.white54,
              inactiveTrackColor: Colors.white24,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final confirm =
                    await showUserDeleteDialog(context, user.username);
                if (confirm == true) {
                  await AdminService.deleteUser(user.id);
                  if (context.mounted) {
                    SnackbarHelper.showMessage(
                      context,
                      'Benutzer "${user.username}" wurde gelöscht.',
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
