class Ingredient {
  final double? quantity;
  final String unit;
  final String name;

  Ingredient({
    required this.quantity,
    required this.unit,
    required this.name,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      quantity: (json['quantity'] as num?)?.toDouble(),
      unit: json['unit'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'unit': unit,
      'name': name,
    };
  }
}
