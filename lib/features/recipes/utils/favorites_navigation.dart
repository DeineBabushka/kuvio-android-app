import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../screens/recipes_singleview_screen.dart';

void navigateToFavoriteRecipeDetail(
  BuildContext context,
  Recipe recipe,
  String heroTag,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => RecipeDetailScreen(
        recipe: recipe,
        recipeId: recipe.id,
        heroTag: heroTag,
      ),
    ),
  );
}
