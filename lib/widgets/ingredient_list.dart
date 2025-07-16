import 'package:flutter/material.dart';
import '../models/ingredient.dart';

class IngredientList extends StatelessWidget {
  final List<Ingredient> ingredients;
  final Color textColor;
  final Color cardColor;
  final void Function(Ingredient)? onAddToShoppingList;

  const IngredientList({
    super.key,
    required this.ingredients,
    required this.textColor,
    required this.cardColor,
    this.onAddToShoppingList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: ingredients.map((ingredient) {
        final text =
            '${ingredient.quantity?.toStringAsFixed(2) ?? ''} ${ingredient.unit ?? ''} ${ingredient.name}';

        return Card(
          color: cardColor,
          margin: const EdgeInsets.symmetric(vertical: 4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            title: Text(text.trim(),
                style: TextStyle(color: textColor, fontSize: 16)),
            trailing: onAddToShoppingList != null
                ? IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    color: textColor,
                    onPressed: () => onAddToShoppingList?.call(ingredient),
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}
