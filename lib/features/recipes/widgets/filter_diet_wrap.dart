import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/widgets/filter_diet_circle.dart';
import 'package:kuvio/features/recipes/utils/diet_icon_helper.dart';
import 'package:kuvio/shared/models/favorites_filter.dart';
import 'package:kuvio/l10n/app_localizations.dart';

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

  String localizeDiet(String value, AppLocalizations? loc) {
    switch (value) {
      case 'Rohkost':
        return loc?.dietRaw ?? value;
      case 'Glutenfrei':
        return loc?.dietGlutenFree ?? value;
      case 'Fisch':
        return loc?.dietFish ?? value;
      case 'Keto':
        return loc?.dietKeto ?? value;
      case 'Fleisch':
        return loc?.dietMeat ?? value;
      case 'Vegetarisch':
        return loc?.dietVegetarian ?? value;
      case 'Omnivor':
        return loc?.dietOmnivore ?? value;
      case 'Vegan':
        return loc?.dietVegan ?? value;
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterOptions = FavoritesFilter();
    final textColor = Colors.white;
    final loc = AppLocalizations.of(context);

    return Wrap(
      spacing: 20,
      runSpacing: 20,
      alignment: WrapAlignment.center,
      children: [
        for (var diet in filterOptions.availableDietTypes)
          DietFilterCircle(
            assetPath:
                'assets/${isDark ? dietTypeToAssetName[diet]!.replaceAll('.png', '_dark.png') : dietTypeToAssetName[diet]!}',
            label: localizeDiet(diet, loc),
            isSelected: selectedDiet == diet,
            textColor: textColor,
            onTap: () => onSelect(diet),
          ),
      ],
    );
  }
}
