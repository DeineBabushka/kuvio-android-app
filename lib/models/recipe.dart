class Recipe {
  final String id;
  final String title;
  final String image;
  final int portions;
  final List<String> ingredients;
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
    return Recipe(
      id: json['id'] ?? '', // <-- wichtig!
      title: json['title'],
      image: json['image'],
      portions: json['portions'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      dietTypes: List<String>.from(json['diet_types']),
      categories: List<String>.from(json['categories']),
      preparationTime: json['preparation_time'],
      calories: json['nutrition']['calories'],
      proteinG: json['nutrition']['protein_g'],
      carbohydratesG: json['nutrition']['carbohydrates_g'],
      fatG: json['nutrition']['fat_g'],
    );
  }
}
