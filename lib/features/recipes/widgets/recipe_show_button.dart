import 'package:flutter/material.dart';
import 'package:kuvio/l10n/app_localizations.dart';

class ShowRecipesButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color textColor;

  const ShowRecipesButton({
    super.key,
    required this.onPressed,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
      child: Text(
        loc?.showRecipesButton ?? 'Zeige mir Rezepte',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
