import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lädt alle Benutzerdaten aus der `users`-Collection.
  Future<Map<String, dynamic>?> loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }

  /// Lädt Profildaten für die Bearbeitungsansicht (EditProfileScreen).
  Future<Map<String, dynamic>?> loadEditableUserData() async {
    return await loadUserData(); // gleiche Logik, evtl. später erweiterbar
  }

  /// Aktualisiert das Profil des Benutzers in Firestore.
  Future<void> updateProfile({
    required String bio,
    required String kitchen,
    required String favdish,
    required String? profileImage,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'bio': bio.trim(),
      'kitchen': kitchen,
      'favdish': favdish.trim(),
      'profileImage': profileImage,
    });
  }

  /// Löscht das Auth-Konto + alle zugehörigen Firestore-Daten des Benutzers.
  Future<void> deleteUserAndData(String password) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Re-Authentifizierung
    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(cred);
    final uid = user.uid;

    // Kommentare löschen
    final comments = await _firestore
        .collection('comments')
        .where('userId', isEqualTo: uid)
        .get();
    for (final doc in comments.docs) {
      await doc.reference.delete();
    }

    final favorites = await _firestore
        .collection('favorites')
        .where('userId', isEqualTo: uid)
        .get();
    for (final doc in favorites.docs) {
      await doc.reference.delete();
    }

    final shoppingListRef = _firestore.collection('shopping_list').doc(uid);
    final items = await shoppingListRef.collection('items').get();
    for (final item in items.docs) {
      await item.reference.delete();
    }
    await shoppingListRef.delete();

    await _firestore.collection('users').doc(uid).delete();

    await user.delete();
  }
}
