import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kuvio/features/account/services/dialog_service.dart';
import 'package:kuvio/localization/context_extension.dart';
import 'package:kuvio/shared/utils/snackbar_helper.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> loginWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<DocumentSnapshot?> loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('users').doc(user.uid).get();
    return doc.exists ? doc : null;
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

  Future<bool> isAdmin(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data()?['isAdmin'] ?? false;
  }

  Future<String?> changePassword({
    required BuildContext context,
    required String currentPassword,
    required String newPassword,
  }) async {
    final loc = context.loc;
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      return loc.noUserLoggedIn;
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
          return loc.errorWrongPassword;
        case 'requires-recent-login':
          return loc.errorRecentLoginRequired;
        case 'user-mismatch':
          return loc.errorUserMismatch;
        default:
          return loc.errorChangePasswordFailed;
      }
    }
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

  Future<bool> deleteAccountWithConfirmation({
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    final password = await DialogService.askForPassword(context);
    if (password == null || !context.mounted) return false;

    try {
      await deleteUserAndData(password);
      onSuccess();
      return true;
    } catch (e) {
      if (context.mounted) {
        SnackbarHelper.showMessage(
          context,
          '${context.loc.errorDeleteAccount} $e',
        );
      }
      return false;
    }
  }
}
