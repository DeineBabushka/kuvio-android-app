import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kuvio/localization/app_localizations.dart';
import 'package:kuvio/shared/utils/connectivity_provider.dart';

bool blockIfOffline(BuildContext context) {
  final loc = AppLocalizations.of(context)!;

  final isOnline =
      Provider.of<ConnectivityProvider>(context, listen: false).isOnline;

  if (!isOnline) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromRGBO(0, 0, 0, 0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, color: Colors.white, size: 60),
            const SizedBox(height: 20),
            Text(
              loc.offlineTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              loc.offlineMessage,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              loc.ok,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return true;
  }

  return false;
}
