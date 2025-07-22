class ShoppingListItem {
  final dynamic nameRaw;
  final dynamic unitRaw;
  final double quantity;

  ShoppingListItem({
    required this.nameRaw,
    required this.unitRaw,
    required this.quantity,
  });

  factory ShoppingListItem.fromMap(Map<String, dynamic> map) {
    return ShoppingListItem(
      nameRaw: map['name'],
      unitRaw: map['unit'],
      quantity: (map['quantity'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': nameRaw,
      'unit': unitRaw,
      'quantity': quantity,
    };
  }

  String _localized(dynamic raw, String lang, String fallback) {
    if (raw is String) return raw;
    if (raw is Map) return raw[lang] ?? raw['en'] ?? raw['de'] ?? fallback;
    return fallback;
  }

  String name(String lang) => _localized(nameRaw, lang, '???');
  String unit(String lang) => _localized(unitRaw, lang, '');
  String key(String lang) => '${name(lang)}|${unit(lang)}';
}
