import 'package:flutter/material.dart';
import 'package:kuvio/localization/app_localizations.dart';
import 'package:kuvio/main.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key});

  static const Color dialogColor = Color(0xFF122620);
  static const TextStyle optionStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle titleStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: dialogColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(loc.language, style: titleStyle),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                KuvioApp.setLocale(context, const Locale('de'));
                Navigator.pop(context);
              },
              child: const Text('Deutsch', style: optionStyle),
            ),
            const Divider(color: Colors.white54),
            TextButton(
              onPressed: () {
                KuvioApp.setLocale(context, const Locale('en'));
                Navigator.pop(context);
              },
              child: const Text('English', style: optionStyle),
            ),
          ],
        ),
      ),
    );
  }
}
