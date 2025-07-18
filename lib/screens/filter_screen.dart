import 'package:flutter/material.dart';
import 'package:kuvio/models/recipe.dart';
import 'package:kuvio/models/favorites_filter.dart';
import 'package:kuvio/screens/filtered_recipes_screen.dart';
import 'package:kuvio/widgets/hamburger_menu.dart';
import 'package:kuvio/services/recipe_service.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  String? selectedDiet;
  String? selectedCategory;
  List<Recipe> allRecipesList = [];
  bool isLoading = true;

  final FavoritesFilter filterOptions = FavoritesFilter();

  final Map<String, String> dietTypeToAssetName = {
    'Rohkost': 'rohkost_icon.png',
    'Glutenfrei': 'gluten_free_icon.png',
    'Fisch': 'fish_icon.png',
    'Keto': 'keto_icon.png',
    'Fleisch': 'proteins_icon.png',
    'Vegetarisch': 'vegetarian_icon.png',
    'Omnivor': 'alles_icon.png',
    'Vegan': 'vegan_icon.png',
  };

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    allRecipesList = await RecipeService.fetchAllRecipes();
    setState(() {
      isLoading = false;
    });
  }

  void _handleShowRecipes() {
    if (selectedDiet != null && selectedCategory != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FilteredRecipesScreen(
            selectedDiet: selectedDiet!,
            selectedCategory: selectedCategory!,
            allRecipes: allRecipesList,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Bitte wähle Ernährungstyp und Kategorie')),
      );
    }
  }

  Widget _buildFilterCircle(String assetPath, String label, Color textColor) {
    final isSelected = selectedDiet == label;

    return GestureDetector(
      onTap: () => setState(() => selectedDiet = label),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(assetPath),
            backgroundColor:
                isSelected ? const Color(0xFF2E6B4D) : Colors.transparent,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF2E6B4D) : textColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(String category, Color textColor) {
    final theme = Theme.of(context);
    final isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () => setState(() => selectedCategory = category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E6B4D) : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final buttonTextColor = isDark ? Colors.white : const Color(0xFF122620);
    final filterTextColor = Colors.white;

    if (isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(
          child: CircularProgressIndicator(color: Colors.greenAccent),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: HamburgerDrawer(allRecipes: allRecipesList),
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Image.asset('assets/logo-horizontale.png', height: 200),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 64 : 32, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Was möchtest du heute kochen?",
                    style: TextStyle(
                      fontSize: isWide ? 28 : 24,
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: [
                      for (var diet in filterOptions.availableDietTypes)
                        _buildFilterCircle(
                          'assets/${isDark ? dietTypeToAssetName[diet]!.replaceAll('.png', '_dark.png') : dietTypeToAssetName[diet]!}',
                          diet,
                          filterTextColor,
                        ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "Wähle die Gerichtskategorie:",
                    style: TextStyle(
                      fontSize: 20,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      for (var category in filterOptions.availableCategories)
                        _buildCategoryFilter(category, buttonTextColor),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: _handleShowRecipes,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                      child: Text(
                        'Zeige mir Rezepte',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: buttonTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
