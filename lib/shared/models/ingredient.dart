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
    final unitData = map['unit'];
    final nameData = map['name'];

    return Ingredient(
      quantity:
          map['quantity'] != null ? (map['quantity'] as num).toDouble() : null,
      unit:
          (unitData is Map) ? unitData['de'] ?? '' : unitData?.toString() ?? '',
      name:
          (nameData is Map) ? nameData['de'] ?? '' : nameData?.toString() ?? '',
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
