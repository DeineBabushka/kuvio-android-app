import 'package:flutter/material.dart';
import 'category_filter_chip.dart';
import '../models/favorites_filter.dart';

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

  @override
  Widget build(BuildContext context) {
    final filterOptions = FavoritesFilter();

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      children: [
        for (var category in filterOptions.availableCategories)
          CategoryFilterChip(
            category: category,
            isSelected: selectedCategory == category,
            textColor: textColor,
            onTap: () => onSelect(category),
            theme: theme,
          ),
      ],
    );
  }
}
