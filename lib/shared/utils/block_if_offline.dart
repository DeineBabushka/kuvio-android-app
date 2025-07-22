import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kuvio/shared/utils/connectivity_provider.dart';

bool blockIfOffline(BuildContext context) {
  try {
    final isOnline =
        Provider.of<ConnectivityProvider>(context, listen: false).isOnline;

    if (!isOnline) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            backgroundColor: const Color.fromRGBO(0, 0, 0, 0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.cloud_off, color: Colors.white, size: 60),
                SizedBox(height: 20),
                Text(
                  'Du bist offline.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Diese Funktion ist nur online verfügbar.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      });
      return true;
    }
  } catch (_) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: const Color.fromRGBO(0, 0, 0, 0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: const Text(
            '⚠️ Verbindungsstatus konnte nicht geprüft werden.',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    });
    return true;
  }

  return false;
}
