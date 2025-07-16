import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import '../models/recipe.dart';
import '../comment_section.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final String? recipeId;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.recipeId,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkIfFavorite());
  }

  Future<void> checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.recipeId == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final List<dynamic> favorites = userDoc.data()?['favorites'] ?? [];

    setState(() {
      isFavorite = favorites.contains(widget.recipeId);
    });
  }

  Future<void> toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.recipeId == null) return;

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final favoritesCollection =
        FirebaseFirestore.instance.collection('favorites');

    final userDoc = await userDocRef.get();
    final List<dynamic> favorites = userDoc.data()?['favorites'] ?? [];

    final isCurrentlyFavorite = favorites.contains(widget.recipeId);

    if (isCurrentlyFavorite) {
      await userDocRef.update({
        'favorites': FieldValue.arrayRemove([widget.recipeId]),
      });

      final favSnapshot = await favoritesCollection
          .where('userId', isEqualTo: user.uid)
          .where('recipeId', isEqualTo: widget.recipeId)
          .get();

      for (var doc in favSnapshot.docs) {
        await doc.reference.delete();
      }

      setState(() => isFavorite = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Aus Favoriten entfernt")),
      );
    } else {
      await userDocRef.update({
        'favorites': FieldValue.arrayUnion([widget.recipeId]),
      });

      await favoritesCollection.add({
        'userId': user.uid,
        'recipeId': widget.recipeId,
        'addedAt': FieldValue.serverTimestamp(),
      });

      setState(() => isFavorite = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Zu Favoriten hinzugefügt")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = const Color(0xFF2C2C2E);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            stretch: true,
            backgroundColor: backgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
              centerTitle: true,
              title: LayoutBuilder(
                builder: (context, constraints) {
                  final isCollapsed = constraints.maxHeight < 140;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    child: isCollapsed
                        ? ConstrainedBox(
                            key: const ValueKey('collapsed'),
                            constraints: BoxConstraints(maxWidth: constraints.maxWidth - 140),
                            child: Text(
                              widget.recipe.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                              ),
                            ),
                          )
                        : ConstrainedBox(
                            key: const ValueKey('expanded'),
                            constraints: BoxConstraints(maxWidth: constraints.maxWidth - 32),
                            child: Text(
                              widget.recipe.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                              ),
                            ),
                          ),
                  );
                },
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/${widget.recipe.image}',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
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
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                    final shareText = "🥗 ${widget.recipe.title}\n"
                    "📋 Zutaten: ${widget.recipe.ingredients.join(', ')}\n"
                    "📖 Zubereitung: ${widget.recipe.instructions.take(3).join('')}...\n"
                    "✨ Gekocht mit der Kuvio App!";
                  Share.share(shareText);
                },
              ),
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Colors.redAccent,
                ),
                onPressed: toggleFavorite,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildRecipeContent(context, textColor, cardColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeContent(BuildContext context, Color textColor, Color cardColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Portionen: ${widget.recipe.portions}', style: TextStyle(color: textColor, fontSize: 16)),
            Text('Dauer: ${widget.recipe.preparationTime}', style: TextStyle(color: textColor, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 20),
        Text('Zutaten', style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...widget.recipe.ingredients.map((ingredient) => Card(
              color: cardColor,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: ListTile(
                leading: const Icon(Icons.restaurant_menu, color: Colors.white),
                title: Text(ingredient, style: TextStyle(fontSize: 16, color: textColor)),
              ),
            )),
        const SizedBox(height: 20),
        Text('Zubereitung', style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...widget.recipe.instructions.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final rawStep = entry.value;
          final step = rawStep.replaceFirst(RegExp(r'^\d+[\.\)]?\s*'), '');
          return Card(
            color: cardColor,
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text('$index', style: const TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(step, style: TextStyle(fontSize: 16, color: textColor))),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 20),
        Text('Nährwerte (pro Portion)', style: TextStyle(color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...[
          "🔥 Kalorien: ${widget.recipe.calories} kcal",
          "💪 Protein: ${widget.recipe.proteinG} g",
          "🍞 Kohlenhydrate: ${widget.recipe.carbohydratesG} g",
          "🧈 Fett: ${widget.recipe.fatG} g",
        ].map((info) => Card(
              color: cardColor,
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(info, style: TextStyle(fontSize: 16, color: textColor)),
              ),
            )),
        CommentSection(recipeId: widget.recipeId!),
      ],
    );
  }
}