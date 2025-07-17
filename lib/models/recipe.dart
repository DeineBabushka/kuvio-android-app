import 'ingredient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Recipe.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recipe(
      id: doc.id,
      title: data['title'] ?? '',
      image: data['image'] ?? '',
      portions: data['portions'] ?? 0,
      ingredients: (data['ingredients'] as List<dynamic>)
          .map((item) => Ingredient.fromMap(item))
          .toList(),
      instructions: List<String>.from(data['instructions'] ?? []),
      dietTypes: List<String>.from(data['diet_types'] ?? []),
      categories: List<String>.from(data['categories'] ?? []),
      preparationTime: data['preparation_time'] ?? '',
      calories: data['nutrition']?['calories'] ?? 0,
      proteinG: data['nutrition']?['protein_g'] ?? 0,
      carbohydratesG: data['nutrition']?['carbohydrates_g'] ?? 0,
      fatG: data['nutrition']?['fat_g'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'portions': portions,
      'ingredients': ingredients.map((i) => i.toMap()).toList(),
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
