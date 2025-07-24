import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/widgets.dart';
import 'package:kuvio/features/auth/models/google_user_data.dart';
import 'package:kuvio/localization/app_localizations.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<({bool isAdmin, String? error})> signInWithGoogle(
    BuildContext context,
  ) async {
    final loc = AppLocalizations.of(context)!;

    try {
      await _googleSignIn.initialize(
        serverClientId:
            '544137355783-cst5n43i19qt0cj3me3pq98e0pnjq9lg.apps.googleusercontent.com',
      );

      final googleUser = await _googleSignIn.authenticate(
        scopeHint: ['email'],
      );

      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        return (
          isAdmin: false,
          error: 'Kein Benutzer vorhanden.',
        );
      }

      final userRef = _firestore.collection('users').doc(user.uid);
      final snapshot = await userRef.get();

      if (!snapshot.exists) {
        final newUserData = GoogleUserData.fromFirebaseUser(user);
        await userRef.set(newUserData.toMap());
      }

      final userData = (await userRef.get()).data();
      final isAdminFlag = userData != null && userData['isAdmin'] == true;

      return (
        isAdmin: isAdminFlag,
        error: null,
      );
    } catch (e) {
      return (
        isAdmin: false,
        error: loc.googleLoginError,
      );
    }
  }
}
