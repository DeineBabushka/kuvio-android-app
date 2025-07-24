import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';

class RecipeFilter {
  final String selectedDiet;
  final String selectedCategory;
  final String searchQuery;

  RecipeFilter({
    required this.selectedDiet,
    required this.selectedCategory,
    this.searchQuery = '',
  });

  List<Recipe> apply(List<Recipe> allRecipes, BuildContext context) {
    const filterLang = 'de';
    final uiLang = Localizations.localeOf(context).languageCode;

    return allRecipes.where((recipe) {
      final title = recipe.title[uiLang]?.toLowerCase() ?? '';
      final diets = recipe.dietTypes[filterLang] ?? <String>[];
      final categories = recipe.categories[filterLang] ?? <String>[];

      final matchesDiet = selectedDiet.isEmpty || diets.contains(selectedDiet);
      final matchesCategory =
          selectedCategory.isEmpty || categories.contains(selectedCategory);
      final matchesSearch =
          searchQuery.isEmpty || title.contains(searchQuery.toLowerCase());

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
