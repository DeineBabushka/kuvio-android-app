import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'recipes_singleview_screen.dart';
import '../widgets/bottom_nav.dart'; // ← wichtig!

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

    final List<Recipe> filteredRecipes = allRecipes.where((recipe) {
      return recipe.dietTypes.contains(selectedDiet) &&
          recipe.categories.contains(selectedCategory);
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Gefundene Rezepte',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: filteredRecipes.isEmpty
          ? Center(
              child: Text(
                'Keine Rezepte gefunden!',
                style: TextStyle(color: textColor, fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredRecipes.length,
              itemBuilder: (context, index) {
                final recipe = filteredRecipes[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(
                          recipe: recipe,
                          recipeId: recipe.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: cardBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: SizedBox(
                            width: 100,
                            height: 150,
                            child: AspectRatio(
                              aspectRatio: 2 / 3,
                              child: Image.asset(
                                'assets/${recipe.image}',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  recipe.title,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: titleColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${recipe.portions} Portionen • ${recipe.preparationTime}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: subtitleColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavWidget(
        allRecipes: allRecipes,
        currentIndex: 1, // "Suche"-Tab ist aktiv
      ),
    );
  }
}
