import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuvio/shared/models/ingredient.dart';

class ShoppingListService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> addIngredients(
      String uid, List<Ingredient> ingredients, String recipeId) async {
    final itemsRef =
        _db.collection('shopping_list').doc(uid).collection('items');

    for (final ingredient in ingredients) {
      await itemsRef.add({
        'name': ingredient.name,
        'quantity': ingredient.quantity,
        'unit': ingredient.unit,
        'addedAt': FieldValue.serverTimestamp(),
        'fromRecipeId': recipeId,
      });
    }
  }

  static Future<void> addSingleIngredient(
      String uid, Ingredient ingredient, String recipeId) async {
    await addIngredients(uid, [ingredient], recipeId);
  }
}
