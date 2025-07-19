import 'package:cloud_firestore/cloud_firestore.dart';

class GroupedShoppingListService {
  static final _db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot> getUserShoppingItemsStream(String uid) {
    return _db
        .collection('shopping_list')
        .doc(uid)
        .collection('items')
        .orderBy('addedAt')
        .snapshots();
  }

  static Map<String, Map<String, Map<String, dynamic>>> groupItemsByRecipe(
    List<QueryDocumentSnapshot> docs,
  ) {
    final Map<String, Map<String, Map<String, dynamic>>> grouped = {};

    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final recipeId = data['fromRecipeId'] ?? 'Unbekannt';
      final name = data['name'];
      final unit = data['unit'];
      final quantity = (data['quantity'] as num?)?.toDouble() ?? 0.0;

      if (name == null || unit == null) continue;

      final key = '$name|$unit';

      grouped.putIfAbsent(recipeId, () => {});
      if (grouped[recipeId]!.containsKey(key)) {
        grouped[recipeId]![key]!['quantity'] += quantity;
      } else {
        grouped[recipeId]![key] = {
          'name': name,
          'unit': unit,
          'quantity': quantity,
        };
      }
    }

    return grouped;
  }

  static Future<Map<String, String>> loadRecipeTitles(
    Iterable<String> ids,
  ) async {
    final Map<String, String> titles = {};

    for (final id in ids) {
      if (id == 'Unbekannt') {
        titles[id] = 'Unbekanntes Rezept';
        continue;
      }

      try {
        final doc = await _db.collection('recipes').doc(id).get();
        final data = doc.data();
        titles[id] = data != null && data['title'] != null
            ? data['title'] as String
            : 'Rezept ohne Titel';
      } catch (_) {
        titles[id] = 'Fehler beim Laden';
      }
    }

    return titles;
  }

  static Future<void> deleteItemsForRecipe(
    List<QueryDocumentSnapshot> docs,
    String recipeId,
  ) async {
    final batch = _db.batch();

    final toDelete = docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['fromRecipeId'] == recipeId;
    });

    for (final doc in toDelete) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  static Future<void> deleteSingleItem(
    List<QueryDocumentSnapshot> docs,
    String recipeId,
    String name,
    String unit,
  ) async {
    final toDelete = docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['fromRecipeId'] == recipeId &&
          data['name'] == name &&
          data['unit'] == unit;
    });

    for (final doc in toDelete) {
      await doc.reference.delete();
    }
  }
}
