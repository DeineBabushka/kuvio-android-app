import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/recipes/screens/recipes_singleview_screen.dart';
import 'package:kuvio/l10n/app_localizations.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final Color cardBackground;
  final Color titleColor;
  final Color subtitleColor;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.cardBackground,
    required this.titleColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    final heroTag = 'recipe-image-${recipe.id}';
    final loc = AppLocalizations.of(context);

    final recipeTitle = recipe.getTitle(context);
    final prepTime = recipe.getPreparationTime(context);
    final portionsLabel = loc?.portionsLabel ?? 'Portionen';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(
              recipe: recipe,
              recipeId: recipe.id,
              heroTag: heroTag,
            ),
          ),
        );
      },
      child: Card(
        color: cardBackground,
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
                child: Hero(
                  tag: heroTag,
                  child: Image.asset(
                    'assets/${recipe.image}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipeTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${recipe.portions} $portionsLabel • $prepTime',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: subtitleColor,
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
  }
}
