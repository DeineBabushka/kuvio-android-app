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

  String localizeDiet(String value, AppLocalizations loc) {
    switch (value) {
      case 'Rohkost':
        return loc.dietRaw;
      case 'Glutenfrei':
        return loc.dietGlutenFree;
      case 'Fisch':
        return loc.dietFish;
      case 'Keto':
        return loc.dietKeto;
      case 'Fleisch':
        return loc.dietMeat;
      case 'Vegetarisch':
        return loc.dietVegetarian;
      case 'Omnivor':
        return loc.dietOmnivore;
      case 'Vegan':
        return loc.dietVegan;
      default:
        return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final diets = FavoritesFilter.localizedDietTypes[lang] ?? [];

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
        final assetName = dietTypeToAssetName[diet];

        if (assetName == null) {
          return const SizedBox();
        }

        return DietFilterCircle(
          assetPath: 'assets/$assetName',
          label: localizeDiet(diet, loc),
          isSelected: selectedDiet == diet,
          textColor: Colors.white,
          onTap: () => onSelect(diet),
        );
      },
    );
  }
}
