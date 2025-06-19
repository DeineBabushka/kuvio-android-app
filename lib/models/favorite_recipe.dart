import 'recipe.dart';

class FavoriteRecipe {
  final Recipe recipe;
  final DateTime addedAt;

  FavoriteRecipe({
    required this.recipe,
    required this.addedAt,
  });
}
