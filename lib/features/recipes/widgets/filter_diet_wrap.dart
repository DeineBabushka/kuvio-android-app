import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/widgets/filter_diet_circle.dart';
import 'package:kuvio/features/recipes/utils/diet_icon_helper.dart';
import 'package:kuvio/features/favorites/models/favorites_filter.dart';
import 'package:kuvio/localization/app_localizations.dart';

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
    final diets = filterOptions.availableDietTypes;
    final textColor = Colors.white;
    final loc = AppLocalizations.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.68,
      ),
      itemCount: diets.length,
      itemBuilder: (context, index) {
        final diet = diets[index];
        return DietFilterCircle(
          assetPath: 'assets/${dietTypeToAssetName[diet]!}',
          label: localizeDiet(diet, loc),
          isSelected: selectedDiet == diet,
          textColor: textColor,
          onTap: () => onSelect(diet),
        );
      },
    );
  }
}
