import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuvio/features/recipes/utils/format_utils.dart';
import 'package:kuvio/features/recipes/utils/favorite_navigation.dart';
import 'package:kuvio/features/recipes/services/favorites_controller.dart';
import 'package:kuvio/features/recipes/widgets/favorite_delete_icon.dart';
import 'package:kuvio/features/recipes/services/favorite_service.dart';

class FavoriteRecipeCard extends StatelessWidget {
  final FavoriteItem item;
  final Color cardColor;
  final Color textColor;
  final Color subtitleColor;
  final Color timestampColor;
  final FavoritesController controller;
  final VoidCallback onUpdate;

  const FavoriteRecipeCard({
    super.key,
    required this.item,
    required this.cardColor,
    required this.textColor,
    required this.subtitleColor,
    required this.timestampColor,
    required this.controller,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final r = item.recipe;

    return GestureDetector(
      onTap: () => navigateToFavoriteRecipeDetail(context, r, 'fav-${r.id}'),
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
                child: r.image.isNotEmpty
                    ? Hero(
                        tag: 'fav-${r.id}',
                        child: Image.asset(
                          'assets/${r.image}',
                          fit: BoxFit.cover,
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${r.portions} Portionen • ${r.preparationTime}',
                      style: TextStyle(fontSize: 14, color: subtitleColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hinzugefügt am: ${formatDate(item.addedAt)}',
                      style: TextStyle(fontSize: 12, color: timestampColor),
                    ),
                  ],
                ),
              ),
            ),
            DeleteFavoriteIcon(
              onDelete: () async {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await controller.removeFavorite(
                    userId: user.uid,
                    recipeId: r.id,
                    onUpdate: onUpdate,
                  );

                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Favorit entfernt'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
