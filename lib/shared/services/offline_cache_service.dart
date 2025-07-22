import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class OfflineCacheService {
  static Future<void> preloadAll() async {
    final fs = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    try {
      await fs
          .collection('recipes')
          .get(const GetOptions(source: Source.server));

      if (user == null) {
        debugPrint("ℹ️ Nicht eingeloggt – nur Rezepte geladen.");
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

      debugPrint("📦 Firestore-Daten für Nutzer '$uid' vorgeladen.");
    } catch (e) {
      debugPrint("⚠️ Fehler beim Offline-Vorladen: $e");
    }
  }
}
