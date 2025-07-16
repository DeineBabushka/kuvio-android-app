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
  List<String> convertToStringList(dynamic input) {
    if (input is List) {
      return input.map((item) {
        if (item is String) return item;
        if (item is Map && item.containsKey('name')) return item['name'].toString();
        return item.toString();
      }).toList();
    }
    return [];
  }

  return Recipe(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    image: json['image'] ?? '',
    portions: json['portions'] ?? 0,
    ingredients: convertToStringList(json['ingredients']),
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

}
