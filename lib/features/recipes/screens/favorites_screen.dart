import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/favorites_controller.dart';
import '../widgets/favorites_filter_bar.dart';
import '../widgets/favorite_recipe_card.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Recipe> allRecipes;

  const FavoritesScreen({super.key, required this.allRecipes});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final controller = FavoritesController();

  @override
  void initState() {
    super.initState();
    controller.loadFavorites(widget.allRecipes, () => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : const Color(0xFF122620);
    final subtitleColor = isDark ? Colors.white70 : const Color(0xFF122620);
    final timestampColor = isDark ? Colors.white54 : Colors.black54;
    final cardColor = isDark ? theme.cardColor : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Favoriten',
            style: TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                FavoritesFilterBar(
                  searchController: controller.searchController,
                  filter: controller.filter,
                  onFilterChanged: (newFilter) =>
                      controller.updateFilter(newFilter, () => setState(() {})),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: controller.filteredFavorites().isEmpty
                      ? const Center(
                          child: Text(
                            'Keine Favoriten vorhanden.',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: controller.filteredFavorites().length,
                          itemBuilder: (ctx, i) {
                            final item = controller.filteredFavorites()[i];
                            return FavoriteRecipeCard(
                              item: item,
                              cardColor: cardColor,
                              textColor: textColor,
                              subtitleColor: subtitleColor,
                              timestampColor: timestampColor,
                              controller: controller,
                              onUpdate: () => setState(() {}),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
