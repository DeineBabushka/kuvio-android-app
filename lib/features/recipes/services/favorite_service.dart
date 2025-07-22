import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';

class FavoriteItem {
  final Recipe recipe;
  final DateTime addedAt;

  FavoriteItem({required this.recipe, required this.addedAt});
}

class FavoriteService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> addFavorite(String userId, String recipeId) async {
    await _db.collection('favorites').add({
      'userId': userId,
      'recipeId': recipeId,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> removeFavorite(String userId, String recipeId) async {
    final snapshot = await _db
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .where('recipeId', isEqualTo: recipeId)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  static Future<bool> isFavorite(String userId, String recipeId) async {
    final snapshot = await _db
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .where('recipeId', isEqualTo: recipeId)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  static Future<bool> toggleFavorite(String userId, String recipeId) async {
    final isFav = await isFavorite(userId, recipeId);
    if (isFav) {
      await removeFavorite(userId, recipeId);
      return false;
    } else {
      await addFavorite(userId, recipeId);
      return true;
    }
  }

  static Future<List<String>> getFavoriteRecipeIds(String userId) async {
    final snapshot = await _db
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => doc['recipeId'] as String).toList();
  }

  static Future<List<FavoriteItem>> loadFavoritesWithRecipes(
      String userId, List<Recipe> allRecipes) async {
    final snapshot = await _db
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) {
      final recipeId = doc['recipeId'] as String;
      final addedAt =
          (doc['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now();

      final recipe = allRecipes.firstWhere(
        (r) => r.id == recipeId,
        orElse: () => Recipe(
          id: recipeId,
          title: {
            'de': 'Unbekanntes Rezept',
            'en': 'Unknown Recipe',
          },
          image: '',
          portions: 0,
          ingredients: [],
          instructions: {
            'de': ['Keine Anweisungen verfügbar.'],
            'en': ['No instructions available.'],
          },
          dietTypes: {
            'de': [],
            'en': [],
          },
          categories: {
            'de': [],
            'en': [],
          },
          preparationTime: {
            'de': '',
            'en': '',
          },
          calories: 0,
          proteinG: 0,
          carbohydratesG: 0,
          fatG: 0,
        ),
      );

      return FavoriteItem(recipe: recipe, addedAt: addedAt);
    }).toList();
  }
}
