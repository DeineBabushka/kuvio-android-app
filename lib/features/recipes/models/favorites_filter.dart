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

  bool matchesRecipe(dynamic recipe) {
    final titleMatch = recipe.title.toLowerCase().contains(searchQuery);
    final categoryMatch =
        category == null || recipe.categories.contains(category);
    final dietMatch = dietType == null || recipe.dietTypes.contains(dietType);
    return titleMatch && categoryMatch && dietMatch;
  }
}
