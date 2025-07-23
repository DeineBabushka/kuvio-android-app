import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuvio/shared/models/ingredient.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/favorites/services/favorite_service.dart';
import 'package:kuvio/features/shopping_list/services/shopping_list_service.dart';
import 'package:kuvio/features/recipes/services/recipe_detail_service.dart';
import 'package:kuvio/shared/utils/snackbar_helper.dart';
import 'package:kuvio/l10n/app_localizations.dart';
import 'package:kuvio/shared/utils/block_if_offline.dart';
import 'package:kuvio/shared/utils/connectivity_provider.dart';
import 'package:provider/provider.dart';

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
    if (user == null || (recipeId?.isEmpty ?? true)) return false;

    try {
      final connectivity =
          Provider.of<ConnectivityProvider>(context, listen: false);
      if (!connectivity.isOnline) return false;

      return await FavoriteService.isFavorite(user.uid, recipeId!);
    } catch (e) {
      return false;
    }
  }

  Future<bool> toggleFavorite() async {
    if (blockIfOffline(context)) return false;

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
    List<Ingredient> ingredients,
    String lang,
  ) async {
    if (blockIfOffline(context)) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || recipeId == null) return;

    final localizedIngredients = ingredients.map((i) {
      return Ingredient(
        name: {
          'de': i.name['de'] ?? '',
          'en': i.name['en'] ?? '',
        },
        unit: {
          'de': i.unit['de'] ?? '',
          'en': i.unit['en'] ?? '',
        },
        quantity: i.quantity,
      );
    }).toList();

    await ShoppingListService.addIngredients(
      user.uid,
      localizedIngredients,
      recipeId!,
      {
        'de': recipe.title['de'] ?? '',
        'en': recipe.title['en'] ?? '',
      },
    );

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
    if (blockIfOffline(context)) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || recipeId == null) return;

    final localizedIngredient = Ingredient(
      name: {
        'de': ingredient.name['de'] ?? '',
        'en': ingredient.name['en'] ?? '',
      },
      unit: {
        'de': ingredient.unit['de'] ?? '',
        'en': ingredient.unit['en'] ?? '',
      },
      quantity: ingredient.quantity,
    );

    await ShoppingListService.addSingleIngredient(
      user.uid,
      localizedIngredient,
      recipeId!,
      {
        'de': recipe.title['de'] ?? '',
        'en': recipe.title['en'] ?? '',
      },
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
