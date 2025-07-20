import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/recipes/services/recipe_service.dart';
import 'package:kuvio/features/recipes/screens/filtered_recipes_screen.dart';
import 'package:kuvio/features/recipes/widgets/hamburger_menu.dart';
import 'package:kuvio/features/recipes/widgets/filter_title_text.dart';
import 'package:kuvio/features/recipes/widgets/filter_diet_wrap.dart';
import 'package:kuvio/features/recipes/widgets/category_filter_wrap.dart';
import 'package:kuvio/features/recipes/widgets/recipe_show_button.dart';
import 'package:kuvio/features/recipes/widgets/loading_indicator.dart';

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
    RecipeService.fetchAllRecipes().then((recipes) {
      setState(() {
        allRecipesList = recipes;
        isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final btnColor = isDark ? Colors.white : const Color(0xFF122620);
    final isWide = MediaQuery.of(context).size.width > 600;

    if (isLoading) return const Scaffold(body: LoadingIndicator());

    return Scaffold(
      drawer: HamburgerDrawer(allRecipes: allRecipesList),
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Image.asset('assets/logo-horizontale.png', height: 200),
      ),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: isWide ? 64 : 32, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterTitleText(
              text: "Was möchtest du heute kochen?",
              fontSize: isWide ? 28 : 24,
              color: theme.colorScheme.onPrimary,
            ),
            const SizedBox(height: 20),
            DietFilterWrap(
              selectedDiet: selectedDiet,
              onSelect: (diet) => setState(() => selectedDiet = diet),
              isDark: isDark,
            ),
            const SizedBox(height: 30),
            FilterTitleText(
              text: "Wähle die Gerichtskategorie:",
              fontSize: 20,
              color: theme.textTheme.bodyLarge?.color ?? Colors.white,
            ),
            const SizedBox(height: 10),
            CategoryFilterWrap(
              selectedCategory: selectedCategory,
              onSelect: (category) =>
                  setState(() => selectedCategory = category),
              textColor: btnColor,
              theme: theme,
            ),
            const SizedBox(height: 40),
            Center(
              child: ShowRecipesButton(
                onPressed: _handleShowRecipes,
                textColor: btnColor,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
