import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  Map<String, dynamic>? recipe;

  @override
  void initState() {
    super.initState();
    loadRecipe();
  }

  Future<void> loadRecipe() async {
    final jsonString = await rootBundle.loadString('assets/recipe.json');
    final List<dynamic> jsonList = jsonDecode(jsonString);

    // Beispiel: zeige das 1. Rezept
    final Map<String, dynamic> firstRecipe = jsonList[0];

    setState(() {
      recipe = firstRecipe;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (recipe == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe!['title']),
        backgroundColor: const Color(0xFF122620),
      ),
      backgroundColor: const Color(0xFF122620),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bild
            if (recipe!['image'] != null)
              Image.asset(
                'assets/${recipe!['image']}',
                fit: BoxFit.cover,
                errorBuilder:
                    (ctx, error, stack) => const Text(
                      "Bild nicht gefunden",
                      style: TextStyle(color: Colors.white),
                    ),
              ),
            const SizedBox(height: 20),

            // Portionen & Zeit
            Text(
              'Portionen: ${recipe!['portions']} | Zeit: ${recipe!['preparation_time']}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Zutaten
            Text('Zutaten:', style: _titleStyle()),
            const SizedBox(height: 8),
            for (final ingredient
                in recipe!['ingredients'] ?? recipe!['ingredient'])
              Text('• $ingredient', style: _textStyle()),

            const SizedBox(height: 16),
            Text('Anleitung:', style: _titleStyle()),
            const SizedBox(height: 8),
            for (final step in recipe!['instructions'])
              Text(step, style: _textStyle()),

            const SizedBox(height: 16),
            Text('Ernährungsform:', style: _titleStyle()),
            const SizedBox(height: 8),
            Text(
              (recipe!['diet_types'] as List).join(', '),
              style: _textStyle(),
            ),

            const SizedBox(height: 16),
            Text('Kategorien:', style: _titleStyle()),
            const SizedBox(height: 8),
            Text(
              (recipe!['categories'] as List).join(', '),
              style: _textStyle(),
            ),

            const SizedBox(height: 16),
            Text('Nährwerte (pro Portion):', style: _titleStyle()),
            const SizedBox(height: 8),
            Text(
              'Kalorien: ${recipe!['nutrition']['calories']} kcal\n'
              'Protein: ${recipe!['nutrition']['protein_g']} g\n'
              'Kohlenhydrate: ${recipe!['nutrition']['carbohydrates_g']} g\n'
              'Fett: ${recipe!['nutrition']['fat_g']} g',
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
