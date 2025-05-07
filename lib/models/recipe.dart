class Recipe {
  final String? id;
  final String title;
  final String image;
  final String portions;
  final List<String> dietTypes;
  final List<String> categories;
  final List<String> ingredients;
  final List<String> instructions;
  final String preparationTime;
  final int calories;
  final int proteinG;
  final int carbohydratesG;
  final int fatG;

  Recipe({
    this.id,
    required this.title,
    required this.image,
    required this.dietTypes,
    required this.portions,
    required this.categories,
    required this.ingredients,
    required this.instructions,
    required this.preparationTime,
    required this.calories,
    required this.proteinG,
    required this.carbohydratesG,
    required this.fatG,
  });

  factory Recipe.fromJson(Map<String, dynamic> json, [String? id]) {
    return Recipe(
      id: id,
      title: json['title'],
      image: json['image'],
      portions: json['portions'].toString(),
      dietTypes: List<String>.from(json['diet_types']),
      categories: List<String>.from(json['categories']),
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      preparationTime: json['preparation_time'],
      calories: json['nutrition']['calories'],
      proteinG: json['nutrition']['protein_g'],
      carbohydratesG: json['nutrition']['carbohydrates_g'],
      fatG: json['nutrition']['fat_g'],
    );
  }
}
