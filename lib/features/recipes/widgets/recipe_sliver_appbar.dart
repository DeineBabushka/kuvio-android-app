import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/recipes/widgets/favorite_share_actions.dart';

class RecipeSliverAppBar extends StatelessWidget {
  final Recipe recipe;
  final String heroTag;
  final bool isFavorite;
  final bool isLoggedIn;
  final VoidCallback onToggleFavorite;

  const RecipeSliverAppBar({
    super.key,
    required this.recipe,
    required this.heroTag,
    required this.isFavorite,
    required this.isLoggedIn,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final shareText = "🥗 ${recipe.title}\n"
        "📋 Zutaten: ${recipe.ingredients.map((e) => "${e.quantity} ${e.unit} ${e.name}").join(', ')}\n"
        "📖 Zubereitung: ${recipe.instructions.take(3).join(' ')}...\n"
        "✨ Gekocht mit der Kuvio App!";

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
                    maxWidth: constraints.maxWidth - (isCollapsed ? 140 : 12)),
                child: Text(
                  recipe.title,
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
          title: recipe.title,
          shareText: shareText,
          isFavorite: isFavorite,
          isLoggedIn: isLoggedIn,
          onToggleFavorite: onToggleFavorite,
        ),
      ],
    );
  }
}
