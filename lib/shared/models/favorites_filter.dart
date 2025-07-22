import 'package:flutter/material.dart';

class FavoritesFilter {
  final String? category;
  final String? dietType;
  final String searchQuery;

  FavoritesFilter({
    this.category,
    this.dietType,
    this.searchQuery = '',
  });

  List<String> get availableCategories => const [
        "Vorspeise",
        "Hauptgericht",
        "Dessert",
        "Beilage",
        "Snack",
        "Frühstück",
        "Kalorienarm",
      ];

  List<String> get availableDietTypes => const [
        'Rohkost',
        'Glutenfrei',
        'Fisch',
        'Keto',
        'Fleisch',
        'Vegetarisch',
        'Omnivor',
        'Vegan',
      ];

  FavoritesFilter copyWith({
    String? category,
    String? dietType,
    String? searchQuery,
  }) {
    return FavoritesFilter(
      category: category ?? this.category,
      dietType: dietType ?? this.dietType,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool matchesRecipe(dynamic recipe, BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;

    final title = recipe.title[lang]?.toLowerCase() ?? '';
    final categories = recipe.categories[lang] ?? <String>[];
    final dietTypes = recipe.dietTypes[lang] ?? <String>[];

    final titleMatch = title.contains(searchQuery.toLowerCase());
    final categoryMatch = category == null || categories.contains(category);
    final dietMatch = dietType == null || dietTypes.contains(dietType);

    return titleMatch && categoryMatch && dietMatch;
  }
}
