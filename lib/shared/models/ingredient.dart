class Ingredient {
  final double? quantity;
  final String unit;
  final String name;

  Ingredient({
    required this.quantity,
    required this.unit,
    required this.name,
  });

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      quantity: (map['quantity'] as num?)?.toDouble(),
      unit: map['unit'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'quantity': quantity,
      'unit': unit,
      'name': name,
    };
  }
}
