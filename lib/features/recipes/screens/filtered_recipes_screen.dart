import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/recipes/models/recipe_filter.dart';
import 'package:kuvio/features/recipes/widgets/bottom_nav.dart';
import 'package:kuvio/features/recipes/widgets/recipe_card.dart';
import 'package:kuvio/l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
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

    final filteredRecipes = filter.apply(widget.allRecipes);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          loc?.filteredRecipesTitle ?? 'Gefundene Rezepte',
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
                hintText:
                    loc?.searchRecipeByNameHint ?? 'Nach Rezeptnamen suchen...',
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
          const SizedBox(height: 8),
          Expanded(
            child: filteredRecipes.isEmpty
                ? Center(
                    child: Text(
                      loc?.noRecipesFound ?? 'Keine Rezepte gefunden!',
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
