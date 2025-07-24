import 'package:flutter/material.dart';
import 'package:kuvio/localization/app_localizations.dart';
import 'package:kuvio/shared/utils/block_if_offline.dart';

class DeleteFavoriteIcon extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteFavoriteIcon({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.redAccent),
      onPressed: () async {
        if (blockIfOffline(context)) return;

        final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  loc.deleteFavoriteTitle,
                  style: const TextStyle(color: Colors.black),
                ),
                content: Text(
                  loc.deleteFavoriteText,
                  style: const TextStyle(color: Colors.black87),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      loc.cancel,
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                      loc.delete,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ) ??
            false;

        if (confirmed) onDelete();
      },
    );
  }
}
