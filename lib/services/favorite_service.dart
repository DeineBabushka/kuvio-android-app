import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteService {
  static Future<bool> isFavorite(String uid, String recipeId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final List<dynamic> favorites = userDoc.data()?['favorites'] ?? [];
    return favorites.contains(recipeId);
  }

  static Future<void> addFavorite(String uid, String recipeId) async {
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final favoritesCollection =
        FirebaseFirestore.instance.collection('favorites');

    await userDocRef.update({
      'favorites': FieldValue.arrayUnion([recipeId]),
    });

    await favoritesCollection.add({
      'userId': uid,
      'recipeId': recipeId,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> removeFavorite(String uid, String recipeId) async {
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final favoritesCollection =
        FirebaseFirestore.instance.collection('favorites');

    await userDocRef.update({
      'favorites': FieldValue.arrayRemove([recipeId]),
    });

    final favSnapshot = await favoritesCollection
        .where('userId', isEqualTo: uid)
        .where('recipeId', isEqualTo: recipeId)
        .get();

    for (var doc in favSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  static Future<bool> toggleFavorite(String uid, String recipeId) async {
    final isFav = await isFavorite(uid, recipeId);
    if (isFav) {
      await removeFavorite(uid, recipeId);
    } else {
      await addFavorite(uid, recipeId);
    }
    return !isFav;
  }
}
