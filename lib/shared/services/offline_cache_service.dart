import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OfflineCacheService {
  static Future<void> preloadAll() async {
    final fs = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    await fs.collection('recipes').get(const GetOptions(source: Source.server));

    if (user == null) {
      return;
    }

    final uid = user.uid;

    await Future.wait([
      fs
          .collection('shopping_list')
          .doc(uid)
          .collection('items')
          .get(const GetOptions(source: Source.server)),
    ]);
  }
}
