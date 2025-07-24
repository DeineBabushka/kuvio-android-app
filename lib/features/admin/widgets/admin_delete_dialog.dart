import 'package:flutter/material.dart';
import 'package:kuvio/localization/app_localizations.dart';

Future<bool?> showUserDeleteDialog(
  BuildContext context,
  String username,
) {
  final loc = AppLocalizations.of(context)!;

  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        loc.deleteUserTitle,
      ),
      content: Text(
        loc.deleteUserText.replaceFirst('{username}', username),
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(loc.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(loc.delete),
        ),
      ],
    ),
  );
}
