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
      ingredients: (data['ingredients'] as List<dynamic>).map((item) {
        try {
          return Ingredient.fromMap(item);
        } catch (e) {
          return Ingredient(
            quantity: 0,
            name: {'de': 'Unbekannt', 'en': 'Unknown'},
            unit: {'de': '-', 'en': '-'},
          );
        }
      }).toList(),
      instructions: Map<String, List<String>>.fromEntries(
        (data['instructions'] as Map<String, dynamic>).entries.map(
              (e) => MapEntry(e.key, List<String>.from(e.value)),
            ),
      ),
      dietTypes: Map<String, List<String>>.fromEntries(
        (data['diet_types'] as Map<String, dynamic>).entries.map(
              (e) => MapEntry(e.key, List<String>.from(e.value)),
            ),
      ),
      categories: Map<String, List<String>>.fromEntries(
        (data['categories'] as Map<String, dynamic>).entries.map(
              (e) => MapEntry(e.key, List<String>.from(e.value)),
            ),
      ),
      preparationTime: Map<String, String>.from(data['preparation_time'] ?? {}),
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
    return categories[lang] ?? [];
  }

  List<String> getDietTypes(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return dietTypes[lang] ?? [];
  }

  String getPreparationTime(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return preparationTime[lang] ?? preparationTime.values.firstOrNull ?? '';
  }
}
