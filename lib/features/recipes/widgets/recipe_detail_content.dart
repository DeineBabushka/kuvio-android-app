import 'package:flutter/material.dart';
import 'package:kuvio/shared/models/ingredient.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/recipes/widgets/ingredient_list.dart';
import 'package:kuvio/features/recipes/widgets/instruction_list.dart';
import 'package:kuvio/features/recipes/widgets/nutrition_card.dart';
import 'package:kuvio/features/recipes/widgets/portion_selector.dart';
import 'package:kuvio/features/recipes/widgets/ingredient_add_all_button.dart';
import 'package:kuvio/features/comments/widgets/comment_section.dart';
import 'package:kuvio/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:kuvio/shared/utils/connectivity_provider.dart';

class RecipeDetailContent extends StatelessWidget {
  final Recipe recipe;
  final Color textColor;
  final Color cardColor;
  final bool isLoggedIn;
  final List<Ingredient> scaledIngredients;
  final int portionCount;
  final ValueChanged<int> onPortionChange;
  final VoidCallback onAddAll;
  final void Function(BuildContext, Ingredient) onAddSingle;
  final String lang;

  const RecipeDetailContent({
    super.key,
    required this.recipe,
    required this.textColor,
    required this.cardColor,
    required this.isLoggedIn,
    required this.scaledIngredients,
    required this.portionCount,
    required this.onPortionChange,
    required this.onAddAll,
    required this.onAddSingle,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final instructions = recipe.instructions[lang] ?? [];
    final prepTime = recipe.preparationTime[lang] ?? '';

    // ↓ online-status aus Provider holen
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PortionSelector(
              portionCount: portionCount,
              onDecrement: () =>
                  onPortionChange(portionCount > 1 ? portionCount - 1 : 1),
              onIncrement: () => onPortionChange(portionCount + 1),
              textColor: textColor,
            ),
            Text(
              '${loc?.durationLabel ?? 'Dauer'}: $prepTime',
              style: TextStyle(color: textColor, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          loc?.ingredientsLabel ?? 'Zutaten',
          style: TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        IngredientList(
          ingredients: scaledIngredients,
          textColor: textColor,
          cardColor: cardColor,
          isLoggedIn: isLoggedIn,
          onAddToShoppingList: onAddSingle,
        ),
        const SizedBox(height: 10),
        if (isLoggedIn) AddAllIngredientsButton(onPressed: onAddAll),
        const SizedBox(height: 20),
        Text(
          loc?.instructionsLabel ?? 'Zubereitung',
          style: TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        InstructionList(
          instructions: instructions,
          textColor: textColor,
          cardColor: cardColor,
        ),
        const SizedBox(height: 20),
        Text(
          loc?.nutritionPerPortionLabel ?? 'Nährwerte (pro Portion)',
          style: TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        NutritionCard(
          calories: recipe.calories,
          protein: recipe.proteinG,
          carbs: recipe.carbohydratesG,
          fat: recipe.fatG,
          textColor: textColor,
          cardColor: cardColor,
        ),
        const SizedBox(height: 20),

        // ↓ nur wenn online + eingeloggt
        if (isLoggedIn && isOnline) CommentSection(recipeId: recipe.id),
      ],
    );
  }
}
