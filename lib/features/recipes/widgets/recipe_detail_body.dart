import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/recipes/services/recipe_detail_controller.dart';
import 'package:kuvio/features/recipes/widgets/recipe_detail_content.dart';
import 'package:kuvio/features/recipes/widgets/recipe_sliver_appbar.dart';

class RecipeDetailBody extends StatelessWidget {
  final Recipe recipe;
  final String heroTag;
  final bool isFavorite;
  final int portionCount;
  final bool isLoggedIn;
  final RecipeDetailController controller;
  final ValueChanged<int> onPortionChange;
  final VoidCallback onToggleFavorite;
  final bool isOnline;

  const RecipeDetailBody(
      {super.key,
      required this.recipe,
      required this.heroTag,
      required this.isFavorite,
      required this.portionCount,
      required this.isLoggedIn,
      required this.controller,
      required this.onPortionChange,
      required this.onToggleFavorite,
      required this.isOnline});

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = const Color(0xFF2C2C2E);
    final scaled = controller.getScaledIngredients(portionCount);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          RecipeSliverAppBar(
            recipe: recipe,
            heroTag: heroTag,
            isFavorite: isFavorite,
            isLoggedIn: isLoggedIn,
            onToggleFavorite: onToggleFavorite,
            lang: lang,
            isOnline: isOnline,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RecipeDetailContent(
                recipe: recipe,
                textColor: textColor,
                cardColor: cardColor,
                isLoggedIn: isLoggedIn,
                scaledIngredients: scaled,
                portionCount: portionCount,
                onPortionChange: onPortionChange,
                onAddAll: () => controller.addAllToShoppingList(scaled, lang),
                onAddSingle: (context, ingredient) => controller
                    .addSingleToShoppingList(context, ingredient, lang),
                lang: lang,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
