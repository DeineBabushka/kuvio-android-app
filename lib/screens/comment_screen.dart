import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment.dart';
import '../models/recipe.dart';
import 'recipes_singleview_screen.dart';

class CommentScreen extends StatefulWidget {
  final List<Recipe> allRecipes;

  const CommentScreen({super.key, required this.allRecipes});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<CommentWithRecipe> commentData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCommentsAndRecipes();
  }

  Future<void> loadCommentsAndRecipes() async {
    try {
      final commentSnapshot = await FirebaseFirestore.instance
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .get();

      final List<CommentWithRecipe> loaded = [];

      for (var doc in commentSnapshot.docs) {
        final comment = Comment.fromFirestore(doc); // 🔧 <-- angepasst

        final localMatch = widget.allRecipes.firstWhere(
          (r) => r.id == comment.recipeId,
          orElse: () => Recipe(
            id: '',
            title: '',
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

        if (localMatch.id.isNotEmpty) {
          loaded.add(CommentWithRecipe(comment: comment, recipe: localMatch));
          continue;
        }

        final recipeSnapshot = await FirebaseFirestore.instance
            .collection('recipes')
            .doc(comment.recipeId)
            .get();

        if (recipeSnapshot.exists) {
          final recipe = Recipe.fromFirestore(recipeSnapshot);
          loaded.add(CommentWithRecipe(comment: comment, recipe: recipe));
        }
      }

      setState(() {
        commentData = loaded;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Fehler beim Laden der Kommentare: $e');
      setState(() => isLoading = false);
    }
  }

  String _formatDate(DateTime date) {
    final localDate = date.add(const Duration(hours: 2));
    return '${localDate.day.toString().padLeft(2, '0')}.' 
        '${localDate.month.toString().padLeft(2, '0')}.' 
        '${localDate.year} ${localDate.hour.toString().padLeft(2, '0')}:' 
        '${localDate.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final cardColor = const Color(0xFF2C2C2E);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Kommentare'),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : commentData.isEmpty
              ? const Center(child: Text("Keine Kommentare gefunden."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: commentData.length,
                  itemBuilder: (context, index) {
                    final cwr = commentData[index];
                    return GestureDetector(
                      onTap: () {
                        if (cwr.recipe.id.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailScreen(
                                recipe: cwr.recipe,
                                recipeId: cwr.recipe.id,
                              ),
                            ),
                          );
                        }
                      },
                      child: Card(
                        color: cardColor,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: cwr.recipe.image.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/${cwr.recipe.image}',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Icon(Icons.image_not_supported, size: 40),
                          title: Text(
                            cwr.recipe.title.isNotEmpty
                                ? cwr.recipe.title
                                : 'Unbekanntes Rezept',
                            style: TextStyle(
                                color: textColor, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                cwr.comment.text,
                                style: TextStyle(color: textColor),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDate(cwr.comment.timestamp),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: textColor.withOpacity(0.6)),
                              ),
                            ],
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class CommentWithRecipe {
  final Comment comment;
  final Recipe recipe;

  CommentWithRecipe({required this.comment, required this.recipe});
}
