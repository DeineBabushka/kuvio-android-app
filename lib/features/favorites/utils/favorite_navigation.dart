import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/recipes/screens/recipes_detail_screen.dart';

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
