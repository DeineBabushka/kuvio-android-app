import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ingredient.dart';

class ShoppingListService {
  static Future<void> addIngredients(
      String uid, List<Ingredient> ingredients, String recipeId) async {
    final shoppingListRef = FirebaseFirestore.instance
        .collection('shopping_list')
        .doc(uid)
        .collection('items');

    for (var ingredient in ingredients) {
      await shoppingListRef.add({
        'name': ingredient.name,
        'quantity': ingredient.quantity,
        'unit': ingredient.unit,
        'addedAt': FieldValue.serverTimestamp(),
        'fromRecipeId': recipeId,
      });
    }
  }
}
