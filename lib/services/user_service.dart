import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }

  Future<Map<String, dynamic>?> loadEditableUserData() async {
    return await loadUserData();
  }

  Future<Map<String, dynamic>?> fetchCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.data();
  }

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

  Future<void> deleteUserAndData(String password) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) return;

    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(cred);

    final uid = user.uid;

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

  Future<String?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      return 'Kein Benutzer angemeldet.';
    }

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          return 'Das aktuelle Passwort ist falsch.';
        case 'requires-recent-login':
          return 'Bitte melde dich erneut an, um dein Passwort zu ändern.';
        case 'user-mismatch':
          return 'Anmeldedaten stimmen nicht mit dem aktuellen Nutzer überein.';
        default:
          return 'Fehler beim Ändern des Passworts.';
      }
    }
  }

  Future<UserCredential> loginWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<bool> isAdmin(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['isAdmin'] ?? false;
  }

  String getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail Adresse oder Passwort falsch.';
      default:
        return 'Unbekannter Fehler beim Login.';
    }
  }
}
