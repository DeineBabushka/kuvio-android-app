import 'package:cloud_firestore/cloud_firestore.dart';

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
}
