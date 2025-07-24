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

  List<String> availableCategories(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final categories = localizedCategories[lang];
    if (categories != null) return categories;
    return localizedCategories['de']!;
  }

  List<String> availableDietTypes(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final dietTypes = localizedDietTypes[lang];
    if (dietTypes != null) return dietTypes;
    return localizedDietTypes['de']!;
  }

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

    final title = recipe.title[lang];
    final categories = recipe.categories['de'];
    final dietTypes = recipe.dietTypes['de'];

    if (title == null || categories == null || dietTypes == null) {
      return false;
    }

    final titleMatch = title.toLowerCase().contains(searchQuery.toLowerCase());
    final categoryMatch = category == null || categories.contains(category);
    final dietMatch = dietType == null || dietTypes.contains(dietType);

    return titleMatch && categoryMatch && dietMatch;
  }

  static const Map<String, List<String>> localizedDietTypes = {
    'de': [
      'Rohkost',
      'Glutenfrei',
      'Fisch',
      'Keto',
      'Fleisch',
      'Vegetarisch',
      'Omnivor',
      'Vegan',
    ],
    'en': [
      'Rohkost',
      'Glutenfrei',
      'Fisch',
      'Keto',
      'Fleisch',
      'Vegetarisch',
      'Omnivor',
      'Vegan',
    ],
  };

  static const Map<String, List<String>> localizedCategories = {
    'de': [
      'Vorspeise',
      'Hauptgericht',
      'Dessert',
      'Beilage',
      'Snack',
      'Frühstück',
      'Kalorienarm',
    ],
    'en': [
      'Starter',
      'Main course',
      'Dessert',
      'Side dish',
      'Snack',
      'Breakfast',
      'Low calorie',
    ],
  };
}
