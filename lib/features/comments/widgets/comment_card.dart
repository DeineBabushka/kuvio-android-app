import 'package:flutter/material.dart';
import '../models/formatted_comment.dart';
import '../../recipes/screens/recipes_singleview_screen.dart';

class CommentCard extends StatelessWidget {
  final FormattedComment comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final cardColor = const Color(0xFF2C2C2E);
    final cwr = comment.data;

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
              Text(cwr.comment.text, style: TextStyle(color: textColor)),
              const SizedBox(height: 4),
              Text(
                comment.formattedDate,
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
  }
}
