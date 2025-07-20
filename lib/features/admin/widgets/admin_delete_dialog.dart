import 'package:flutter/material.dart';

Future<bool?> showUserDeleteDialog(BuildContext context, String username) {
  return showDialog<bool>(
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
}
