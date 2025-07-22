import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:kuvio/shared/models/ingredient.dart';

class ShoppingListService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> addIngredients(
    String uid,
    List<Ingredient> ingredients,
    String recipeId,
  ) async {
    final itemsRef =
        _db.collection('shopping_list').doc(uid).collection('items');

    final lang = WidgetsBinding.instance.platformDispatcher.locale.languageCode;

    for (final ingredient in ingredients) {
      final name = ingredient.name[lang] ?? ingredient.name['en'] ?? '???';
      final unit = ingredient.unit[lang] ?? ingredient.unit['en'] ?? '';

      await itemsRef.add({
        'name': {
          'de': ingredient.name['de'] ?? name,
          'en': ingredient.name['en'] ?? name,
        },
        'unit': {
          'de': ingredient.unit['de'] ?? unit,
          'en': ingredient.unit['en'] ?? unit,
        },
        'quantity': ingredient.quantity,
        'addedAt': FieldValue.serverTimestamp(),
        'fromRecipeId': recipeId,
      });
    }
  }

  static Future<void> addSingleIngredient(
    String uid,
    Ingredient ingredient,
    String recipeId,
  ) async {
    await addIngredients(uid, [ingredient], recipeId);
  }
}
