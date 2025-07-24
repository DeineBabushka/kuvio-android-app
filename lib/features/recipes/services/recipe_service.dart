import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';

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
    required String lang,
  }) {
    return allRecipes.where((recipe) {
      final diets = recipe.dietTypes[lang] ?? [];
      final categories = recipe.categories[lang] ?? [];

      return diets.contains(diet) && categories.contains(category);
    }).toList();
  }
}
