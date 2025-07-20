import 'package:kuvio/shared/models/ingredient.dart';

class RecipeDetailService {
  static List<Ingredient> getScaledIngredients(
      List<Ingredient> ingredients, int originalPortions, int newPortions) {
    final factor = newPortions / originalPortions;
    return ingredients
        .map((e) => Ingredient(
              quantity: e.quantity != null ? e.quantity! * factor : null,
              unit: e.unit,
              name: e.name,
            ))
        .toList();
  }
}
