import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'username': username.trim(),
      'email': email.trim(),
      'createdAt': Timestamp.now(),
      'bio': '',
      'kitchen': 'Nicht angegeben',
      'favdish': '',
      'isAdmin': false,
      'favorites': [],
      'profileImage': 'assets/character_9.png',
    });
  }

  Future<void> signOutUser(BuildContext context) async {
    Navigator.pop(context);
    await _auth.signOut();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Du wurdest abgemeldet.")),
      );
    }
  }
}
