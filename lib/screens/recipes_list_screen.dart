import 'package:flutter/material.dart';
import 'package:kuvio/models/recipe.dart';
import 'package:kuvio/widgets/hamburger_menu.dart';

class RecipesListScreen extends StatelessWidget {
  final List<Recipe> allRecipes;

  const RecipesListScreen({
    super.key,
    required this.allRecipes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rezepte für dich"),
        backgroundColor: const Color(0xFF122620),
        actions: [
          HamburgerMenu(allRecipes: allRecipes),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF122620),
              height: 10,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView.builder(
                  itemCount: allRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = allRecipes[index];
                    return Column(
                      children: [
                        _buildRecipeRow(
                          recipe.title,
                          'assets/${recipe.image}',
                          'assets/sample_icon.png',
                          recipe.categories.isNotEmpty
                              ? recipe.categories[0]
                              : '',
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              color: const Color(0xFF122620),
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeRow(
    String title,
    String imageUrl,
    String iconUrl,
    String category,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: Image.asset(
          imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (ctx, error, stack) =>
              const Icon(Icons.broken_image, size: 60),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Image.asset(
              iconUrl,
              width: 20,
              height: 20,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, stack) =>
                  const Icon(Icons.category, size: 20),
            ),
            const SizedBox(width: 8),
            Text(
              category,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
