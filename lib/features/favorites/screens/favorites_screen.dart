import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/favorites/services/favorites_controller.dart';
import 'package:kuvio/features/favorites/widgets/favorite_filter_bar.dart';
import 'package:kuvio/features/recipes/widgets/favorite_recipe_card.dart';
import 'package:kuvio/localization/app_localizations.dart';

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

    final loc = AppLocalizations.of(context);

    final filteredFavorites = controller.filteredFavorites(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loc?.favoritesTitle ?? 'Meine Favoriten',
          style: const TextStyle(color: Colors.white),
        ),
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
                  child: filteredFavorites.isEmpty
                      ? Center(
                          child: Text(
                            loc?.noFavoritesFound ??
                                'Keine Favoriten vorhanden.',
                            style: const TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredFavorites.length,
                          itemBuilder: (ctx, i) {
                            final item = filteredFavorites[i];
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
