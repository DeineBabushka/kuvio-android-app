import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/recipes/widgets/favorite_share_actions.dart';
import 'package:kuvio/localization/app_localizations.dart';

class RecipeSliverAppBar extends StatelessWidget {
  final Recipe recipe;
  final String heroTag;
  final bool isFavorite;
  final bool isLoggedIn;
  final VoidCallback onToggleFavorite;
  final String lang;
  final bool isOnline;

  const RecipeSliverAppBar(
      {super.key,
      required this.recipe,
      required this.heroTag,
      required this.isFavorite,
      required this.isLoggedIn,
      required this.onToggleFavorite,
      required this.lang,
      required this.isOnline});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    final recipeTitle = recipe.title[lang] ?? '';
    final instructions = recipe.instructions[lang] ?? [];
    final ingredients = recipe.ingredients
        .map((e) => "${e.quantity} ${e.unit[lang] ?? ''} ${e.name[lang] ?? ''}")
        .join(', ');

    final shareText = "🥗 $recipeTitle\n"
        "${loc?.ingredientsLabel ?? 'Zutaten'}: $ingredients\n"
        "${loc?.instructionsLabel ?? 'Zubereitung'}: ${instructions.take(3).join(' ')}...\n"
        "${loc?.cookedWithKuvio ?? 'Gekocht mit der Kuvio App!'}";

    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      stretch: true,
      backgroundColor: backgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: const [StretchMode.zoomBackground, StretchMode.fadeTitle],
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
        centerTitle: true,
        title: LayoutBuilder(
          builder: (context, constraints) {
            final isCollapsed = constraints.maxHeight < 140;
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: ConstrainedBox(
                key: ValueKey(isCollapsed ? 'collapsed' : 'expanded'),
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth - (isCollapsed ? 140 : 12),
                ),
                child: Text(
                  recipeTitle,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isCollapsed ? 20 : 24,
                    fontWeight: FontWeight.w700,
                    shadows: const [Shadow(blurRadius: 4, color: Colors.black)],
                  ),
                ),
              ),
            );
          },
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: heroTag,
              child: Image.asset('assets/${recipe.image}', fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withAlpha(153),
                    Colors.transparent,
                    Colors.black.withAlpha(153),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        FavoriteShareActions(
          title: recipeTitle,
          shareText: shareText,
          isFavorite: isFavorite,
          isLoggedIn: isLoggedIn,
          isOnline: isOnline,
          onToggleFavorite: onToggleFavorite,
        ),
      ],
    );
  }
}
