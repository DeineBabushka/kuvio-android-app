import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/widgets/diet_filter_circle.dart';
import 'package:kuvio/features/recipes/utils/diet_icon_helper.dart';
import 'package:kuvio/features/recipes/models/favorites_filter.dart';

class DietFilterWrap extends StatelessWidget {
  final String? selectedDiet;
  final void Function(String) onSelect;
  final bool isDark;

  const DietFilterWrap({
    super.key,
    required this.selectedDiet,
    required this.onSelect,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final filterOptions = FavoritesFilter();
    final textColor = Colors.white;

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        for (var diet in filterOptions.availableDietTypes)
          DietFilterCircle(
            assetPath:
                'assets/${isDark ? dietTypeToAssetName[diet]!.replaceAll('.png', '_dark.png') : dietTypeToAssetName[diet]!}',
            label: diet,
            isSelected: selectedDiet == diet,
            textColor: textColor,
            onTap: () => onSelect(diet),
          ),
      ],
    );
  }
}
