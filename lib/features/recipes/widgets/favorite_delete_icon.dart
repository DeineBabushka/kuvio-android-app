import 'package:flutter/material.dart';

class DeleteFavoriteIcon extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteFavoriteIcon({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.redAccent),
      onPressed: () async {
        final confirmed = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text(
                  'Favorit löschen?',
                  style: TextStyle(color: Colors.black),
                ),
                content: const Text(
                  'Möchtest du diesen Favoriten wirklich entfernen?',
                  style: TextStyle(color: Colors.black87),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Abbrechen',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Löschen',
                      style: TextStyle(color: Colors.redAccent),
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
