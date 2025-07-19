import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class RecipeService {
  static final _db = FirebaseFirestore.instance;

  static Future<List<Recipe>> fetchAllRecipes() async {
    final querySnapshot = await _db.collection('recipes').get();
    return querySnapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
  }

  static List<Recipe> filterRecipes({
    required List<Recipe> allRecipes,
    required String diet,
    required String category,
  }) {
    return allRecipes.where((recipe) {
      return recipe.dietTypes.contains(diet) &&
          recipe.categories.contains(category);
    }).toList();
  }
}
