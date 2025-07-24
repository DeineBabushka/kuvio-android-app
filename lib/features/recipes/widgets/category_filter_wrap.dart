import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/widgets/category_filter_chip.dart';
import 'package:kuvio/features/favorites/models/favorites_filter.dart';
import 'package:kuvio/localization/app_localizations.dart';

class CategoryFilterWrap extends StatelessWidget {
  final String? selectedCategory;
  final void Function(String) onSelect;
  final Color textColor;
  final ThemeData theme;

  const CategoryFilterWrap({
    super.key,
    required this.selectedCategory,
    required this.onSelect,
    required this.textColor,
    required this.theme,
  });

  String localizeCategory(String value, AppLocalizations loc) {
    switch (value) {
      case 'Vorspeise':
        return loc.categoryStarter;
      case 'Hauptgericht':
        return loc.categoryMain;
      case 'Dessert':
        return loc.categoryDessert;
      case 'Beilage':
        return loc.categorySide;
      case 'Snack':
        return loc.categorySnack;
      case 'Frühstück':
        return loc.categoryBreakfast;
      case 'Kalorienarm':
        return loc.categoryLowCalorie;
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final categories = FavoritesFilter().availableCategories(context);

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: categories.map((category) {
        return CategoryFilterChip(
          category: localizeCategory(category, loc),
          isSelected: selectedCategory == category,
          textColor: textColor,
          onTap: () => onSelect(category),
          theme: theme,
        );
      }).toList(),
    );
  }
}
