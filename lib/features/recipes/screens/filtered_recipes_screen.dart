import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../models/recipe_filter.dart';
import '../../../shared/widgets/bottom_nav.dart';
import '../widgets/recipe_card.dart';

class FilteredRecipesScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
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

    final filteredRecipes = RecipeFilter(
      selectedDiet: selectedDiet,
      selectedCategory: selectedCategory,
    ).apply(allRecipes);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Gefundene Rezepte',
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
      body: filteredRecipes.isEmpty
          ? Center(
              child: Text(
                'Keine Rezepte gefunden!',
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
      bottomNavigationBar: BottomNavWidget(
        allRecipes: allRecipes,
      ),
    );
  }
}
