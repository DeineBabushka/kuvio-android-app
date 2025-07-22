class Ingredient {
  final double? quantity;
  final Map<String, String> unit;
  final Map<String, String> name;

  Ingredient({
    required this.quantity,
    required this.unit,
    required this.name,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      quantity:
          map['quantity'] != null ? (map['quantity'] as num).toDouble() : null,
      unit: Map<String, String>.from(map['unit'] ?? {}),
      name: Map<String, String>.from(map['name'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'unit': unit,
      'name': name,
    };
  }

  String getName(String lang) => name[lang] ?? '';
  String getUnit(String lang) => unit[lang] ?? '';
}
