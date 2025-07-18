import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe.dart';
import '../models/favorites_filter.dart';
import '../services/favorite_service.dart';
import 'recipes_singleview_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Recipe> allRecipes;

  const FavoritesScreen({super.key, required this.allRecipes});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<FavoriteItem> favoriteRecipes = [];
  bool isLoading = true;

  final searchController = TextEditingController();
  FavoritesFilter filter = FavoritesFilter();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final loaded = await FavoriteService.loadFavoritesWithRecipes(
        user.uid,
        widget.allRecipes,
      );

      setState(() {
        favoriteRecipes = loaded;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Fehler beim Laden: $e');
      setState(() => isLoading = false);
    }
  }

  List<FavoriteItem> _filteredFavorites() {
    return favoriteRecipes
        .where((f) => filter.matchesRecipe(f.recipe))
        .toList();
  }

  String _formatDate(DateTime date) {
    final d = date.add(const Duration(hours: 2));
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: searchController,
                    onChanged: (val) => setState(() => filter =
                        filter.copyWith(searchQuery: val.toLowerCase())),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Suche nach Rezepten...',
                      hintStyle: const TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white10,
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          filter.availableCategories,
                          filter.category,
                          'Kategorie',
                          (val) => setState(
                              () => filter = filter.copyWith(category: val)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDropdown(
                          filter.availableDietTypes,
                          filter.dietType,
                          'Ernährungsform',
                          (val) => setState(
                              () => filter = filter.copyWith(dietType: val)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: _filteredFavorites().isEmpty
                      ? const Center(
                          child: Text('Keine passenden Favoriten gefunden.',
                              style: TextStyle(color: Colors.white)))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredFavorites().length,
                          itemBuilder: (ctx, i) {
                            final item = _filteredFavorites()[i];
                            final r = item.recipe;

                            return GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RecipeDetailScreen(
                                    recipe: r,
                                    recipeId: r.id,
                                    heroTag: 'fav-${r.id}',
                                  ),
                                ),
                              ),
                              child: Card(
                                color: cardColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                                elevation: 4,
                                margin: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        bottomLeft: Radius.circular(16),
                                      ),
                                      child: SizedBox(
                                        width: 100,
                                        height: 150,
                                        child: r.image.isNotEmpty
                                            ? Hero(
                                                tag: 'fav-${r.id}',
                                                child: Image.asset(
                                                    'assets/${r.image}',
                                                    fit: BoxFit.cover),
                                              )
                                            : const SizedBox(),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(r.title,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: textColor)),
                                            const SizedBox(height: 8),
                                            Text(
                                                '${r.portions} Portionen • ${r.preparationTime}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: subtitleColor)),
                                            const SizedBox(height: 8),
                                            Text(
                                                'Hinzugefügt am: ${_formatDate(item.addedAt)}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: timestampColor)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildDropdown(List<String> items, String? selected, String label,
      void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selected,
      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      items: [
        DropdownMenuItem(
            value: null,
            child: Text(label, style: const TextStyle(color: Colors.white))),
        ...items.map((val) => DropdownMenuItem(
            value: val,
            child: Text(val, style: const TextStyle(color: Colors.white)))),
      ],
      onChanged: onChanged,
    );
  }
}
