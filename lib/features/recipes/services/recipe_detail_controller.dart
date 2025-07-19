import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ingredient.dart';
import '../models/recipe.dart';
import 'favorite_service.dart';
import '../../shopping_list/services/shopping_list_service.dart';
import 'recipe_detail_service.dart';
import '../utils/snackbar_helper.dart';

class RecipeDetailController {
  final BuildContext context;
  final Recipe recipe;
  final String? recipeId;

  RecipeDetailController({
    required this.context,
    required this.recipe,
    required this.recipeId,
  });

  int get initialPortions => recipe.portions;

  Future<bool> loadFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || recipeId == null) return false;
    return await FavoriteService.isFavorite(user.uid, recipeId!);
  }

  Future<bool> toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || recipeId == null) return false;

    final updated = await FavoriteService.toggleFavorite(user.uid, recipeId!);
    SnackbarHelper.showMessage(
      context,
      updated ? "Zu Favoriten hinzugefügt" : "Aus Favoriten entfernt",
    );
    return updated;
  }

  List<Ingredient> getScaledIngredients(int portionCount) {
    return RecipeDetailService.getScaledIngredients(
      recipe.ingredients,
      recipe.portions,
      portionCount,
    );
  }

  Future<void> addAllToShoppingList(List<Ingredient> ingredients) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || recipeId == null) return;

    await ShoppingListService.addIngredients(user.uid, ingredients, recipeId!);
    SnackbarHelper.showMessage(
        context, "Zutaten zur Einkaufsliste hinzugefügt");
  }

  Future<void> addSingleToShoppingList(Ingredient ingredient) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || recipeId == null) return;

    await ShoppingListService.addSingleIngredient(
        user.uid, ingredient, recipeId!);
    SnackbarHelper.showMessage(context, "${ingredient.name} hinzugefügt");
  }
}
