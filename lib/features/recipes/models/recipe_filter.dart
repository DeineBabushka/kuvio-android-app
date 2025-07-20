import 'recipe.dart';

class RecipeFilter {
  final String selectedDiet;
  final String selectedCategory;
  final String searchQuery;

  RecipeFilter({
    required this.selectedDiet,
    required this.selectedCategory,
    this.searchQuery = '',
  });

  List<Recipe> apply(List<Recipe> allRecipes) {
    return allRecipes.where((recipe) {
      final matchesDiet = recipe.dietTypes.contains(selectedDiet);
      final matchesCategory = recipe.categories.contains(selectedCategory);
      final matchesSearch =
          recipe.title.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesDiet && matchesCategory && matchesSearch;
    }).toList();
  }

  RecipeFilter copyWith({
    String? selectedDiet,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return RecipeFilter(
      selectedDiet: selectedDiet ?? this.selectedDiet,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
