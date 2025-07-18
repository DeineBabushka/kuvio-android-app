import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuvio/models/recipe.dart';
import 'package:kuvio/screens/filtered_recipes_screen.dart';
import 'package:kuvio/widgets/hamburger_menu.dart';

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

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('recipes').get();

    setState(() {
      allRecipesList =
          querySnapshot.docs.map((doc) => Recipe.fromFirestore(doc)).toList();
      isLoading = false;
    });
  }

  void _handleShowRecipes() {
    if (selectedDiet != null && selectedCategory != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FilteredRecipesScreen(
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
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: Image.asset('assets/logo-horizontale.png', height: 200),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (!isWide) {
              // Hochformat (originale Version)
              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Was möchtest du heute kochen?",
                      style: TextStyle(
                        fontSize: 24,
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFilterCircle('assets/rohkost_icon.png', 'Rohkost',
                            filterTextColor),
                        _buildFilterCircle('assets/gluten_free_icon.png',
                            'Glutenfrei', filterTextColor),
                        _buildFilterCircle(
                            'assets/fish_icon.png', 'Fisch', filterTextColor),
                        _buildFilterCircle(
                            'assets/keto_icon.png', 'Keto', filterTextColor),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildFilterCircle('assets/proteins_icon.png',
                            'Fleisch', filterTextColor),
                        _buildFilterCircle('assets/vegetarian_icon.png',
                            'Vegetarisch', filterTextColor),
                        _buildFilterCircle('assets/alles_icon.png', 'Omnivor',
                            filterTextColor),
                        _buildFilterCircle(
                            'assets/vegan_icon.png', 'Vegan', filterTextColor),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Wähle die Gerichtskategorie:",
                      style: TextStyle(
                          fontSize: 20,
                          color: theme.textTheme.bodyLarge?.color),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildCategoryFilter("Vorspeise", buttonTextColor),
                        _buildCategoryFilter("Hauptgericht", buttonTextColor),
                        _buildCategoryFilter("Dessert", buttonTextColor),
                        _buildCategoryFilter("Beilage", buttonTextColor),
                        _buildCategoryFilter("Snack", buttonTextColor),
                        _buildCategoryFilter("Frühstück", buttonTextColor),
                        _buildCategoryFilter("Kalorienarm", buttonTextColor),
                      ],
                    ),
                    const Spacer(),
                    Center(
                      child: ElevatedButton(
                        onPressed: _handleShowRecipes,
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
            } else {
              // Querformat (neues Layout mit Wraps)
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Was möchtest du heute kochen?",
                      style: TextStyle(
                        fontSize: 28,
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildFilterCircle('assets/rohkost_icon.png', 'Rohkost',
                            filterTextColor),
                        _buildFilterCircle('assets/gluten_free_icon.png',
                            'Glutenfrei', filterTextColor),
                        _buildFilterCircle(
                            'assets/fish_icon.png', 'Fisch', filterTextColor),
                        _buildFilterCircle(
                            'assets/keto_icon.png', 'Keto', filterTextColor),
                        _buildFilterCircle('assets/proteins_icon.png',
                            'Fleisch', filterTextColor),
                        _buildFilterCircle('assets/vegetarian_icon.png',
                            'Vegetarisch', filterTextColor),
                        _buildFilterCircle('assets/alles_icon.png', 'Omnivor',
                            filterTextColor),
                        _buildFilterCircle(
                            'assets/vegan_icon.png', 'Vegan', filterTextColor),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Wähle die Gerichtskategorie:",
                      style: TextStyle(
                          fontSize: 20,
                          color: theme.textTheme.bodyLarge?.color),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        _buildCategoryFilter("Vorspeise", buttonTextColor),
                        _buildCategoryFilter("Hauptgericht", buttonTextColor),
                        _buildCategoryFilter("Dessert", buttonTextColor),
                        _buildCategoryFilter("Beilage", buttonTextColor),
                        _buildCategoryFilter("Snack", buttonTextColor),
                        _buildCategoryFilter("Frühstück", buttonTextColor),
                        _buildCategoryFilter("Kalorienarm", buttonTextColor),
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
            }
          },
        ),
      ),
    );
  }

  Widget _buildFilterCircle(String assetPath, String label, Color textColor) {
    final isSelected = selectedDiet == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDiet = label;
        });
      },
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(String category, Color textColor) {
    final theme = Theme.of(context);
    final isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
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
}
