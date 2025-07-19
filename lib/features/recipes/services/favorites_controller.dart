import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe.dart';
import '../models/favorites_filter.dart';
import 'favorite_service.dart';

class FavoritesController {
  final searchController = TextEditingController();
  FavoritesFilter filter = FavoritesFilter();
  List<FavoriteItem> allFavorites = [];
  bool isLoading = true;

  Future<void> loadFavorites(
    List<Recipe> allRecipes,
    VoidCallback onUpdate,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final loaded =
          await FavoriteService.loadFavoritesWithRecipes(user.uid, allRecipes);
      allFavorites = loaded;
    } catch (e) {
      debugPrint('Fehler beim Laden: $e');
    } finally {
      isLoading = false;
      onUpdate();
    }
  }

  List<FavoriteItem> filteredFavorites() {
    return allFavorites.where((f) => filter.matchesRecipe(f.recipe)).toList();
  }

  void updateFilter(FavoritesFilter newFilter, VoidCallback onUpdate) {
    filter = newFilter;
    onUpdate();
  }

  void dispose() {
    searchController.dispose();
  }
}
