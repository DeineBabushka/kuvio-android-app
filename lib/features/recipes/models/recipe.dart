import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kuvio/shared/models/ingredient.dart';

class Recipe {
  final String id;
  final Map<String, String> title;
  final String image;
  final int portions;
  final List<Ingredient> ingredients;
  final Map<String, List<String>> instructions;
  final Map<String, List<String>> dietTypes;
  final Map<String, List<String>> categories;
  final Map<String, String> preparationTime;
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
      title: Map<String, String>.from(data['title'] ?? {}),
      image: data['image'] ?? '',
      portions: data['portions'] ?? 0,
      ingredients: (data['ingredients'] as List).map((item) {
        try {
          return Ingredient.fromMap(item);
        } catch (_) {
          return Ingredient(
            quantity: 0,
            name: {'de': 'Unbekannt', 'en': 'Unknown'},
            unit: {'de': '-', 'en': '-'},
          );
        }
      }).toList(),
      instructions: (data['instructions'] as Map).map(
        (key, val) => MapEntry(key, List<String>.from(val)),
      ),
      dietTypes: (data['diet_types'] as Map).map(
        (key, val) => MapEntry(key, List<String>.from(val)),
      ),
      categories: (data['categories'] as Map).map(
        (key, val) => MapEntry(key, List<String>.from(val)),
      ),
      preparationTime: Map<String, String>.from(data['preparation_time']),
      calories: data['nutrition']?['calories'],
      proteinG: data['nutrition']?['protein_g'],
      carbohydratesG: data['nutrition']?['carbohydrates_g'],
      fatG: data['nutrition']?['fat_g'],
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

  String getTitle(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return title[lang] ?? title.values.firstOrNull ?? 'Unbekanntes Rezept';
  }

  List<String> getInstructions(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return instructions[lang] ?? instructions.values.firstOrNull ?? [];
  }

  List<String> getCategories(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return categories[lang] ?? categories.values.firstOrNull ?? [];
  }

  List<String> getDietTypes(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return dietTypes[lang] ?? dietTypes.values.firstOrNull ?? [];
  }

  String getPreparationTime(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return preparationTime[lang] ?? preparationTime.values.firstOrNull ?? '';
  }
}
