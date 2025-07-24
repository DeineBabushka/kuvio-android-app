import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/screens/recipes_detail_screen.dart';
import 'package:kuvio/features/comments/models/comment_formatted.dart';
import 'package:kuvio/features/comments/services/comment_service.dart';
import 'package:kuvio/localization/app_localizations.dart';
import 'package:kuvio/shared/utils/block_if_offline.dart';
import 'package:kuvio/shared/utils/snackbar_helper.dart';

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
    final loc = AppLocalizations.of(context)!;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final cardColor = const Color(0xFF2C2C2E);
    final cwr = widget.comment.data;

    final lang = Localizations.localeOf(context).languageCode;
    final recipeTitle = cwr.recipe.title[lang] ?? loc.unknownRecipeTitle;
    final heroTag = 'comment-${cwr.recipe.id}';

    return GestureDetector(
      onTap: () {
        if (cwr.recipe.id.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(
                recipe: cwr.recipe,
                recipeId: cwr.recipe.id,
                heroTag: heroTag,
              ),
            ),
          );
        }
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
                child: cwr.recipe.image.isNotEmpty
                    ? Hero(
                        tag: heroTag,
                        child: Image.asset(
                          'assets/${cwr.recipe.image}',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported,
                            size: 40,
                          ),
                        ),
                      )
                    : const Icon(Icons.image, size: 40),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipeTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cwr.comment.text,
                      style: TextStyle(
                        fontSize: 18,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.comment.formattedDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withAlpha(153),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => _confirmAndDelete(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAndDelete(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;

    if (blockIfOffline(context)) return;

    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              loc.deleteCommentTitle,
              style: const TextStyle(color: Colors.black),
            ),
            content: Text(
              loc.deleteCommentText,
              style: const TextStyle(color: Colors.black87),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  loc.cancel,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  loc.delete,
                  style: const TextStyle(color: Colors.redAccent),
                ),
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

    SnackbarHelper.showMessage(context, loc.commentDeleted);
  }
}
