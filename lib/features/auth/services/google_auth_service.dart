import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/google_user_data.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<({bool isAdmin, String? error})> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return (isAdmin: false, error: null);

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        return (isAdmin: false, error: 'Kein Benutzer vorhanden.');
      }

      final userRef = _firestore.collection('users').doc(user.uid);
      final doc = await userRef.get();

      if (!doc.exists) {
        final googleUserData = GoogleUserData.fromFirebaseUser(user);
        await userRef.set(googleUserData.toMap());
      }

      final userData = (await userRef.get()).data();
      final isAdminRaw = userData?['isAdmin'];
      final bool isAdmin = isAdminRaw is bool ? isAdminRaw : false;

      return (isAdmin: isAdmin, error: null);
    } catch (e) {
      return (isAdmin: false, error: e.toString());
    }
  }
}
