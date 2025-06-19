import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kuvio/models/recipe.dart';
import 'package:kuvio/widgets/hamburger_menu.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  Recipe? recipe;
  List<Recipe> allRecipesList = [];

  @override
  void initState() {
    super.initState();
    loadRecipe();
  }

  Future<void> loadRecipe() async {
    final jsonString = await rootBundle.loadString('assets/recipe.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);

    // Mappe jsonList zu Recipe-Objekten
    final List<Recipe> recipes =
        jsonList.map<Recipe>((item) => Recipe.fromJson(item)).toList();

    setState(() {
      recipe = recipes.isNotEmpty ? recipes[0] : null;
      allRecipesList = recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (recipe == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe!.title),
        backgroundColor: const Color(0xFF122620),
        actions: [
          HamburgerMenu(allRecipes: allRecipesList),
        ],
      ),
      backgroundColor: const Color(0xFF122620),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe!.image.isNotEmpty)
              Image.asset(
                'assets/${recipe!.image}',
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stack) => const Text(
                  "Bild nicht gefunden",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'Portionen: ${recipe!.portions} | Zeit: ${recipe!.preparationTime}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text('Zutaten:', style: _titleStyle()),
            const SizedBox(height: 8),
            for (final ingredient in recipe!.ingredients)
              Text('• $ingredient', style: _textStyle()),
            const SizedBox(height: 16),
            Text('Anleitung:', style: _titleStyle()),
            const SizedBox(height: 8),
            for (final step in recipe!.instructions)
              Text(step, style: _textStyle()),
            const SizedBox(height: 16),
            Text('Ernährungsform:', style: _titleStyle()),
            const SizedBox(height: 8),
            Text(
              recipe!.dietTypes.join(', '),
              style: _textStyle(),
            ),
            const SizedBox(height: 16),
            Text('Kategorien:', style: _titleStyle()),
            const SizedBox(height: 8),
            Text(
              recipe!.categories.join(', '),
              style: _textStyle(),
            ),
            const SizedBox(height: 16),
            Text('Nährwerte (pro Portion):', style: _titleStyle()),
            const SizedBox(height: 8),
            Text(
              'Kalorien: ${recipe!.calories} kcal\n'
              'Protein: ${recipe!.proteinG} g\n'
              'Kohlenhydrate: ${recipe!.carbohydratesG} g\n'
              'Fett: ${recipe!.fatG} g',
              style: _textStyle(),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _titleStyle() => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  TextStyle _textStyle() => const TextStyle(fontSize: 16, color: Colors.white);
}
