import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  static final _db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot> getUserStream() {
    return _db.collection('users').snapshots();
  }

  static Future<void> setAdminStatus(String userId, bool isAdmin) async {
    await _db.collection('users').doc(userId).update({'isAdmin': isAdmin});
  }

  static Future<void> deleteUser(String userId) async {
    final comments = await _db
        .collection('comments')
        .where('userId', isEqualTo: userId)
        .get();
    for (final doc in comments.docs) {
      await doc.reference.delete();
    }
    final favorites = await _db
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .get();
    for (final doc in favorites.docs) {
      await doc.reference.delete();
    }
    final shoppingListRef = _db.collection('shopping_list').doc(userId);
    final items = await shoppingListRef.collection('items').get();
    for (final item in items.docs) {
      await item.reference.delete();
    }
    await shoppingListRef.delete();
    await _db.collection('users').doc(userId).delete();
  }
}
