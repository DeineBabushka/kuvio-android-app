import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/screens/recipes_singleview_screen.dart';
import 'package:kuvio/features/comments/models/formatted_comment.dart';
import 'package:kuvio/features/comments/services/comment_service.dart';

class CommentCard extends StatefulWidget {
  final FormattedComment comment;

  const CommentCard({super.key, required this.comment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isDeleted = false;

  @override
  Widget build(BuildContext context) {
    if (isDeleted) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final cardColor = const Color(0xFF2C2C2E);
    final cwr = widget.comment.data;

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
          leading: _buildRecipeImage(cwr.recipe.image),
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
                widget.comment.formattedDate,
                style: TextStyle(
                  fontSize: 12,
                  color: textColor.withAlpha(153),
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => _confirmAndDelete(context),
          ),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    );
  }

  Future<void> _confirmAndDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Kommentar löschen?',
              style: TextStyle(color: Colors.black),
            ),
            content: const Text(
              'Möchtest du diesen Kommentar wirklich entfernen?',
              style: TextStyle(color: Colors.black87),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Abbrechen',
                    style: TextStyle(color: Colors.green)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Löschen',
                    style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) return;

    await CommentService.deleteComment(widget.comment.data.comment.id);

    if (!mounted) return;

    setState(() => isDeleted = true);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kommentar gelöscht'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  Widget _buildRecipeImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return const Icon(Icons.image, size: 40);
    }

    final isNetworkImage = imageUrl.contains('http');
    final assetPath = 'assets/$imageUrl';

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: isNetworkImage
          ? Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported, size: 40),
            )
          : Image.asset(
              assetPath,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.image_not_supported, size: 40),
            ),
    );
  }
}
