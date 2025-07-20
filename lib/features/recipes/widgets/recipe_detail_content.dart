import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/models/ingredient.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/recipes/widgets/ingredient_list.dart';
import 'package:kuvio/features/recipes/widgets/instruction_list.dart';
import 'package:kuvio/features/recipes/widgets/nutrition_card.dart';
import 'package:kuvio/features/recipes/widgets/portion_selector.dart';
import 'package:kuvio/features/recipes/widgets/add_all_ingredients_button.dart';
import 'package:kuvio/features/comments/widgets/comment_section.dart';

class RecipeDetailContent extends StatelessWidget {
  final Recipe recipe;
  final Color textColor;
  final Color cardColor;
  final bool isLoggedIn;
  final List<Ingredient> scaledIngredients;
  final int portionCount;
  final ValueChanged<int> onPortionChange;
  final VoidCallback onAddAll;
  final void Function(Ingredient) onAddSingle;

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
  });

  @override
  Widget build(BuildContext context) {
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
            Text('Dauer: ${recipe.preparationTime}',
                style: TextStyle(color: textColor, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 20),
        Text('Zutaten',
            style: TextStyle(
                color: textColor, fontSize: 22, fontWeight: FontWeight.w700)),
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
        Text('Zubereitung',
            style: TextStyle(
                color: textColor, fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        InstructionList(
          instructions: recipe.instructions,
          textColor: textColor,
          cardColor: cardColor,
        ),
        const SizedBox(height: 20),
        Text('Nährwerte (pro Portion)',
            style: TextStyle(
                color: textColor, fontSize: 22, fontWeight: FontWeight.w700)),
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
        if (isLoggedIn) CommentSection(recipeId: recipe.id),
      ],
    );
  }
}
