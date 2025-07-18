class ShoppingListItem {
  final String name;
  final String unit;
  final double quantity;

  ShoppingListItem({
    required this.name,
    required this.unit,
    required this.quantity,
  });

  factory ShoppingListItem.fromMap(Map<String, dynamic> map) {
    return ShoppingListItem(
      name: map['name'] ?? '',
      unit: map['unit'] ?? '',
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'unit': unit,
      'quantity': quantity,
    };
  }

  String get key => '$name|$unit';
}
