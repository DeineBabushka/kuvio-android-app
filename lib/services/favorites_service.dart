import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> addFavorite(String recipeID) async {
    final userID = _auth.currentUser!.uid;

    await _db.collection('favorites').add({
      'userID': userID,
      'recipeID': recipeID,
      'addedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeFavorite(String recipeID) async {
    final userID = _auth.currentUser!.uid;

    final snapshot = await _db
        .collection('favorites')
        .where('userID', isEqualTo: userID)
        .where('recipeID', isEqualTo: recipeID)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<List<String>> getFavoriteRecipeIDs() async {
    final userID = _auth.currentUser!.uid;

    final snapshot = await _db
        .collection('favorites')
        .where('userID', isEqualTo: userID)
        .get();

    return snapshot.docs.map((doc) => doc['recipeID'] as String).toList();
  }
}
