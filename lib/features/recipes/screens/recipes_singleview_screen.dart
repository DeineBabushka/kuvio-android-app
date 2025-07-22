import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/recipes/services/recipe_detail_controller.dart';
import 'package:kuvio/features/recipes/widgets/recipe_detail_body.dart';
import 'package:kuvio/shared/utils/connectivity_provider.dart';
import 'package:provider/provider.dart';

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
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    controller = RecipeDetailController(
      context: context,
      recipe: widget.recipe,
      recipeId: widget.recipeId ?? '',
    );
    portionCount = controller.initialPortions;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final connectivity =
          Provider.of<ConnectivityProvider>(context, listen: false);
      final online = connectivity.isOnline;

      final isLoggedIn = FirebaseAuth.instance.currentUser != null;
      if (online && isLoggedIn) {
        final fav = await controller.loadFavoriteStatus();
        if (mounted) {
          setState(() {
            isOnline = online;
            isFavorite = fav;
          });
        }
      } else {
        setState(() => isOnline = online);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    return Scaffold(
      body: RecipeDetailBody(
        recipe: widget.recipe,
        heroTag: widget.heroTag,
        isFavorite: isFavorite,
        portionCount: portionCount,
        isLoggedIn: isLoggedIn,
        isOnline: isOnline,
        controller: controller,
        onPortionChange: (newCount) => setState(() => portionCount = newCount),
        onToggleFavorite: () async {
          if (!isOnline) {
            // Optional: blockIfOffline(context); // Nur wenn du willst
            return;
          }
          final updated = await controller.toggleFavorite();
          if (mounted) setState(() => isFavorite = updated);
        },
      ),
    );
  }
}
