import 'package:flutter/material.dart';
import 'package:kuvio/shared/models/ingredient.dart';

class IngredientList extends StatelessWidget {
  final List<Ingredient> ingredients;
  final Color textColor;
  final Color cardColor;
  final void Function(BuildContext, Ingredient)? onAddToShoppingList;
  final bool isLoggedIn;

  const IngredientList({
    super.key,
    required this.ingredients,
    required this.textColor,
    required this.cardColor,
    required this.isLoggedIn,
    this.onAddToShoppingList,
  });

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    return Column(
      children: ingredients.map((ingredient) {
        final name = ingredient.name[lang] ?? ingredient.name['en'] ?? '???';
        final unit = ingredient.unit[lang] ?? ingredient.unit['en'] ?? '';

        final text = ingredient.quantity != null
            ? '${ingredient.quantity!.toStringAsFixed(2)} $unit $name'
            : '$unit $name';

        return Card(
          color: cardColor,
          margin: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            title: Text(
              text.trim(),
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            trailing: (isLoggedIn && onAddToShoppingList != null)
                ? IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    color: textColor,
                    onPressed: () =>
                        onAddToShoppingList?.call(context, ingredient),
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}
