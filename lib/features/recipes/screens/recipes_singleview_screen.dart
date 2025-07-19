import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe.dart';
import '../services/recipe_detail_controller.dart';
import '../widgets/recipe_detail_body.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe recipe;
  final String? recipeId;
  final String heroTag;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.recipeId,
    required this.heroTag,
  });

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late RecipeDetailController controller;
  late int portionCount;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    controller = RecipeDetailController(
      context: context,
      recipe: widget.recipe,
      recipeId: widget.recipeId,
    );
    portionCount = controller.initialPortions;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final fav = await controller.loadFavoriteStatus();
      if (mounted) setState(() => isFavorite = fav);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return RecipeDetailBody(
      recipe: widget.recipe,
      heroTag: widget.heroTag,
      isFavorite: isFavorite,
      portionCount: portionCount,
      isLoggedIn: isLoggedIn,
      controller: controller,
      onPortionChange: (newCount) => setState(() => portionCount = newCount),
      onToggleFavorite: () async {
        final updated = await controller.toggleFavorite();
        if (mounted) setState(() => isFavorite = updated);
      },
    );
  }
}
