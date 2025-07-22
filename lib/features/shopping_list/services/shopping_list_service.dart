import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuvio/shared/models/ingredient.dart';

class ShoppingListService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> addIngredients(
    String uid,
    List<Ingredient> ingredients,
    String recipeId,
    Map<String, String> recipeTitle,
  ) async {
    final itemsRef =
        _db.collection('shopping_list').doc(uid).collection('items');

    for (final ingredient in ingredients) {
      final name = {
        'de': ingredient.name['de'] ?? '',
        'en': ingredient.name['en'] ?? '',
      };
      final unit = {
        'de': ingredient.unit['de'] ?? '',
        'en': ingredient.unit['en'] ?? '',
      };

      await itemsRef.add({
        'name': name,
        'unit': unit,
        'quantity': ingredient.quantity,
        'addedAt': FieldValue.serverTimestamp(),
        'fromRecipeId': recipeId,
        'recipeTitle': recipeTitle,
      });
    }
  }

  static Future<void> addSingleIngredient(
    String uid,
    Ingredient ingredient,
    String recipeId,
    Map<String, String> recipeTitle,
  ) async {
    await addIngredients(uid, [ingredient], recipeId, recipeTitle);
  }
}
