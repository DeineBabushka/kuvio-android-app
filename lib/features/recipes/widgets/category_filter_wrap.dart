import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/widgets/category_filter_chip.dart';
import 'package:kuvio/shared/models/favorites_filter.dart';
import 'package:kuvio/l10n/app_localizations.dart';

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

  String localizeCategory(String value, AppLocalizations? loc) {
    switch (value) {
      case 'Vorspeise':
        return loc?.categoryStarter ?? value;
      case 'Hauptgericht':
        return loc?.categoryMain ?? value;
      case 'Dessert':
        return loc?.categoryDessert ?? value;
      case 'Beilage':
        return loc?.categorySide ?? value;
      case 'Snack':
        return loc?.categorySnack ?? value;
      case 'Frühstück':
        return loc?.categoryBreakfast ?? value;
      case 'Kalorienarm':
        return loc?.categoryLowCalorie ?? value;
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterOptions = FavoritesFilter();
    final loc = AppLocalizations.of(context);

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        for (var category in filterOptions.availableCategories)
          CategoryFilterChip(
            category: localizeCategory(category, loc),
            isSelected: selectedCategory == category,
            textColor: textColor,
            onTap: () => onSelect(category),
            theme: theme,
          ),
      ],
    );
  }
}
