import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuvio/shared/models/ingredient.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/recipes/services/favorite_service.dart';
import 'package:kuvio/features/shopping_list/services/shopping_list_service.dart';
import 'package:kuvio/features/recipes/services/recipe_detail_service.dart';
import 'package:kuvio/features/recipes/utils/snackbar_helper.dart';
import 'package:kuvio/l10n/app_localizations.dart';

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
    if (!context.mounted) return updated;

    final loc = AppLocalizations.of(context);
    SnackbarHelper.showMessage(
      context,
      updated
          ? (loc?.addedToFavorites ?? "Zu Favoriten hinzugefügt")
          : (loc?.removedFromFavorites ?? "Aus Favoriten entfernt"),
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

  Future<void> addAllToShoppingList(
      List<Ingredient> ingredients, String lang) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || recipeId == null) return;

    final localizedIngredients = ingredients.map((i) {
      return Ingredient(
        name: {lang: i.name[lang] ?? i.name['en'] ?? ''},
        unit: {lang: i.unit[lang] ?? i.unit['en'] ?? ''},
        quantity: i.quantity,
      );
    }).toList();

    await ShoppingListService.addIngredients(
        user.uid, localizedIngredients, recipeId!);
    if (!context.mounted) return;

    final loc = AppLocalizations.of(context);
    SnackbarHelper.showMessage(
      context,
      loc?.addedAllToShoppingList ?? "Zutaten zur Einkaufsliste hinzugefügt",
    );
  }

  Future<void> addSingleToShoppingList(
    BuildContext context,
    Ingredient ingredient,
    String lang,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || recipeId == null) return;

    final localizedIngredient = Ingredient(
      name: {lang: ingredient.name[lang] ?? ingredient.name['en'] ?? ''},
      unit: {lang: ingredient.unit[lang] ?? ingredient.unit['en'] ?? ''},
      quantity: ingredient.quantity,
    );

    await ShoppingListService.addSingleIngredient(
      user.uid,
      localizedIngredient,
      recipeId!,
    );
    if (!context.mounted) return;

    final loc = AppLocalizations.of(context);
    final ingredientName = localizedIngredient.name[lang] ?? '';

    SnackbarHelper.showMessage(
      context,
      loc?.addedSingleToShoppingList(ingredientName) ??
          "$ingredientName hinzugefügt",
    );
  }
}
