import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';
import 'recipes_singleview_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Recipe> allRecipes;

  const FavoritesScreen({super.key, required this.allRecipes});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<_FavoriteItem> favoriteRecipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final favSnapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .get();

      if (favSnapshot.docs.isEmpty) {
        setState(() {
          favoriteRecipes = [];
          isLoading = false;
        });
        return;
      }

      List<_FavoriteItem> loadedFavorites = favSnapshot.docs.map((doc) {
        final recipeId = doc['recipeId'] as String;
        final addedAtTimestamp = doc['addedAt'] as Timestamp?;
        final addedAt = addedAtTimestamp?.toDate() ?? DateTime.now();

        final recipe = widget.allRecipes.firstWhere(
          (r) => r.id == recipeId,
          orElse: () => Recipe(
            id: '',
            title: 'Unbekanntes Rezept',
            image: '',
            portions: 0,
            ingredients: [],
            instructions: [],
            dietTypes: [],
            categories: [],
            preparationTime: '',
            calories: 0,
            proteinG: 0,
            carbohydratesG: 0,
            fatG: 0,
          ),
        );

        return _FavoriteItem(recipe: recipe, addedAt: addedAt);
      }).toList();

      setState(() {
        favoriteRecipes = loadedFavorites;
        isLoading = false;
      });
    } catch (e) {
      print('Fehler beim Laden der Favoriten: $e');
      setState(() => isLoading = false);
    }
  }

  String _formatDate(DateTime date) {
    final localDate = date.toLocal();
    return '${localDate.day.toString().padLeft(2, '0')}.'
        '${localDate.month.toString().padLeft(2, '0')}.'
        '${localDate.year} '
        '${localDate.hour.toString().padLeft(2, '0')}:'
        '${localDate.minute.toString().padLeft(2, '0')}';
  }

 @override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  final backgroundColor = theme.scaffoldBackgroundColor;
  final textColor = isDarkMode ? Colors.white : const Color(0xFF122620);
  final subtitleColor = isDarkMode ? Colors.white70 : const Color(0xFF122620);
  final timestampColor = isDarkMode ? Colors.white54 : Colors.black54;
  final cardColor = isDarkMode ? theme.cardColor : Colors.white;

  return Scaffold(
    appBar: AppBar(
      title: Text('Meine Favoriten', style: TextStyle(color: Colors.white)),
      backgroundColor: backgroundColor,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    backgroundColor: backgroundColor,
    body: isLoading
        ? Center(child: CircularProgressIndicator(color: Colors.white))
        : favoriteRecipes.isEmpty
            ? Center(
                child: Text(
                  'Keine Favoriten gefunden.',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favoriteRecipes.length,
                itemBuilder: (context, index) {
                  final favItem = favoriteRecipes[index];
                  final recipe = favItem.recipe;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(
                            recipe: recipe,
                            recipeId: recipe.id,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
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
                              child: AspectRatio(
                                aspectRatio: 2 / 3,
                                child: recipe.image.isNotEmpty
                                    ? Image.asset(
                                        'assets/${recipe.image}',
                                        fit: BoxFit.cover,
                                      )
                                    : const SizedBox(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${recipe.portions} Portionen • ${recipe.preparationTime}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: subtitleColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Hinzugefügt am: ${_formatDate(favItem.addedAt)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: timestampColor,
                                    ),
                                  ),
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
  );
}
}

class _FavoriteItem {
  final Recipe recipe;
  final DateTime addedAt;

  _FavoriteItem({
    required this.recipe,
    required this.addedAt,
  });
}
