import 'package:flutter/material.dart';
import '../models/comment_with_recipe.dart';
import '../models/recipe.dart';
import '../services/comment_service.dart';
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
      final loaded =
          await CommentService.getAllCommentsWithRecipes(widget.allRecipes);
      setState(() {
        commentData = loaded;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Fehler beim Laden der Kommentare: $e');
      setState(() => isLoading = false);
    }
  }

  String _formatDate(DateTime date) {
    final localDate = date.add(const Duration(hours: 2));
    return '${localDate.day.toString().padLeft(2, '0')}.'
        '${localDate.month.toString().padLeft(2, '0')}.'
        '${localDate.year} '
        '${localDate.hour.toString().padLeft(2, '0')}:'
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
                                heroTag: 'comment-${cwr.recipe.id}',
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
                              color: textColor,
                              fontWeight: FontWeight.bold,
                            ),
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
                                  color: textColor.withAlpha(153),
                                ),
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
