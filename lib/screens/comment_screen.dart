import 'package:flutter/material.dart';
import '../models/formatted_comment.dart';
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
  List<FormattedComment> commentData = [];
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
      final formatted =
          loaded.map((cwr) => FormattedComment.fromCWR(cwr)).toList();
      setState(() {
        commentData = formatted;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Fehler beim Laden der Kommentare: $e');
      setState(() => isLoading = false);
    }
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
                    final fc = commentData[index];
                    final cwr = fc.data;
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
                                fc.formattedDate,
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
