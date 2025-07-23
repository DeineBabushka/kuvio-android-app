import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/recipes/models/recipe_filter.dart';
import 'package:kuvio/features/recipes/widgets/bottom_nav.dart';
import 'package:kuvio/features/recipes/widgets/recipe_card.dart';
import 'package:kuvio/localization/app_localizations.dart';

class FilteredRecipesScreen extends StatefulWidget {
  final String selectedDiet;
  final String selectedCategory;
  final List<Recipe> allRecipes;

  const FilteredRecipesScreen({
    super.key,
    required this.selectedDiet,
    required this.selectedCategory,
    required this.allRecipes,
  });

  @override
  State<FilteredRecipesScreen> createState() => _FilteredRecipesScreenState();
}

class _FilteredRecipesScreenState extends State<FilteredRecipesScreen> {
  late RecipeFilter filter;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filter = RecipeFilter(
      selectedDiet: widget.selectedDiet,
      selectedCategory: widget.selectedCategory,
    );
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      filter = filter.copyWith(searchQuery: searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  String localizeDiet(String key, AppLocalizations loc) {
    switch (key) {
      case 'raw':
        return loc.dietRaw;
      case 'gluten_free':
        return loc.dietGlutenFree;
      case 'fish':
        return loc.dietFish;
      case 'keto':
        return loc.dietKeto;
      case 'meat':
        return loc.dietMeat;
      case 'vegetarian':
        return loc.dietVegetarian;
      case 'omnivore':
        return loc.dietOmnivore;
      case 'vegan':
        return loc.dietVegan;
      default:
        return key;
    }
  }

  String localizeCategory(String key, AppLocalizations loc) {
    switch (key) {
      case 'starter':
        return loc.categoryStarter;
      case 'main':
        return loc.categoryMain;
      case 'dessert':
        return loc.categoryDessert;
      case 'side':
        return loc.categorySide;
      case 'snack':
        return loc.categorySnack;
      case 'breakfast':
        return loc.categoryBreakfast;
      case 'lowcal':
        return loc.categoryLowCalorie;
      default:
        return key;
    }
  }

  String convertDietLabelToKey(String label) {
    switch (label.toLowerCase()) {
      case 'roh':
      case 'raw':
        return 'raw';
      case 'glutenfrei':
      case 'gluten free':
        return 'gluten_free';
      case 'fisch':
      case 'fish':
        return 'fish';
      case 'keto':
        return 'keto';
      case 'fleisch':
      case 'meat':
        return 'meat';
      case 'vegetarisch':
      case 'vegetarian':
        return 'vegetarian';
      case 'omnivor':
      case 'omnivore':
        return 'omnivore';
      case 'vegan':
        return 'vegan';
      default:
        return label;
    }
  }

  String convertCategoryLabelToKey(String label) {
    switch (label.toLowerCase()) {
      case 'vorspeise':
      case 'starter':
        return 'starter';
      case 'hauptgericht':
      case 'main':
        return 'main';
      case 'dessert':
        return 'dessert';
      case 'beilage':
      case 'side':
        return 'side';
      case 'snack':
        return 'snack';
      case 'frühstück':
      case 'breakfast':
        return 'breakfast';
      case 'kalorienarm':
      case 'low calorie':
      case 'lowcal':
        return 'lowcal';
      default:
        return label;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final cardBackground = isDarkMode ? theme.cardColor : Colors.white;
    final titleColor =
        isDarkMode ? theme.colorScheme.primary : const Color(0xFF122620);
    final subtitleColor = isDarkMode
        ? theme.textTheme.bodyMedium?.color ?? Colors.white70
        : Colors.black87;

    final filteredRecipes = filter.apply(widget.allRecipes, context);

    final localizedDiet = localizeDiet(
      convertDietLabelToKey(widget.selectedDiet),
      loc,
    );
    final localizedCategory = localizeCategory(
      convertCategoryLabelToKey(widget.selectedCategory),
      loc,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          loc.filteredRecipesTitle,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: searchController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: loc.searchRecipeByNameHint,
                hintStyle: TextStyle(color: textColor.withAlpha(150)),
                prefixIcon: Icon(Icons.search, color: textColor),
                filled: true,
                fillColor: isDarkMode ? Colors.white10 : Colors.black12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '$localizedDiet • $localizedCategory',
              style: TextStyle(color: textColor.withAlpha(160)),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredRecipes.isEmpty
                ? Center(
                    child: Text(
                      loc.noRecipesFound,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = filteredRecipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        cardBackground: cardBackground,
                        titleColor: titleColor,
                        subtitleColor: subtitleColor,
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavWidget(
        allRecipes: widget.allRecipes,
      ),
    );
  }
}
