import '../models/recipe.dart';

class RecipeFilter {
  final String selectedDiet;
  final String selectedCategory;

  RecipeFilter({
    required this.selectedDiet,
    required this.selectedCategory,
  });

  List<Recipe> apply(List<Recipe> allRecipes) {
    return allRecipes.where((recipe) {
      return recipe.dietTypes.contains(selectedDiet) &&
          recipe.categories.contains(selectedCategory);
    }).toList();
  }
}
