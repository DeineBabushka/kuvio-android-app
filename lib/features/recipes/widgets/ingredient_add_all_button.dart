import 'package:flutter/material.dart';
import 'package:kuvio/localization/app_localizations.dart';

class AddAllIngredientsButton extends StatelessWidget {
  final void Function() onPressed;

  const AddAllIngredientsButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Center(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add_shopping_cart),
        label: Text(loc.addAllIngredients),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
