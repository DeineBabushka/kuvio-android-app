import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kuvio/l10n/app_localizations.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> registerUser({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> saveInitialUserData({
    required String uid,
    required String username,
    required String email,
    required String kitchenPlaceholder,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'username': username.trim(),
      'email': email.trim(),
      'createdAt': Timestamp.now(),
      'bio': '',
      'kitchen': kitchenPlaceholder,
      'favdish': '',
      'isAdmin': false,
      'favorites': [],
      'profileImage': 'assets/character_9.png',
    });
  }

  Future<void> signOutUser(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;

    Navigator.pop(context);
    await _auth.signOut();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.logoutSuccess)),
      );
    }
  }
}
