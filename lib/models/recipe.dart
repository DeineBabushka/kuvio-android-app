import 'ingredient.dart';

class Recipe {
  final String id;
  final String title;
  final String image;
  final int portions;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final List<String> dietTypes;
  final List<String> categories;
  final String preparationTime;
  final int calories;
  final int proteinG;
  final int carbohydratesG;
  final int fatG;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.portions,
    required this.ingredients,
    required this.instructions,
    required this.dietTypes,
    required this.categories,
    required this.preparationTime,
    required this.calories,
    required this.proteinG,
    required this.carbohydratesG,
    required this.fatG,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<String> convertToStringList(dynamic input) {
      if (input is List) {
        return input.map((item) => item.toString()).toList();
      }
      return [];
    }

    return Recipe(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      portions: json['portions'] ?? 0,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((item) => Ingredient.fromJson(item))
          .toList(),
      instructions: convertToStringList(json['instructions']),
      dietTypes: convertToStringList(json['diet_types']),
      categories: convertToStringList(json['categories']),
      preparationTime: json['preparation_time'] ?? '',
      calories: json['nutrition']?['calories'] ?? 0,
      proteinG: json['nutrition']?['protein_g'] ?? 0,
      carbohydratesG: json['nutrition']?['carbohydrates_g'] ?? 0,
      fatG: json['nutrition']?['fat_g'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'portions': portions,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'instructions': instructions,
      'diet_types': dietTypes,
      'categories': categories,
      'preparation_time': preparationTime,
      'nutrition': {
        'calories': calories,
        'protein_g': proteinG,
        'carbohydrates_g': carbohydratesG,
        'fat_g': fatG,
      },
    };
  }
}
