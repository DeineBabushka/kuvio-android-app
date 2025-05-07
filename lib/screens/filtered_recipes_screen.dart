import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'recipes_overview_screen.dart'; // Damit wir auf die Detailseite navigieren können!

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
    // Filtere die Rezepte basierend auf den gewählten Kriterien
    final List<Recipe> filteredRecipes = allRecipes.where((recipe) {
      return recipe.dietTypes.contains(selectedDiet) &&
          recipe.categories.contains(selectedCategory);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF122620),
      appBar: AppBar(
        title: Text(
          'Gefundene Rezepte',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF122620),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: filteredRecipes.isEmpty
          ? const Center(
              child: Text(
                'Keine Rezepte gefunden!',
                style: TextStyle(color: Colors.white, fontSize: 18),
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
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          child: Image.asset(
                            'assets/${recipe.image}',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            recipe.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF122620),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
