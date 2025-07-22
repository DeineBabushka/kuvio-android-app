import 'package:flutter/material.dart';
import 'package:kuvio/l10n/app_localizations.dart';

class FavoritesFilterHelper {
  static List<String> availableDietTypes(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return [
      loc.dietVegan,
      loc.dietVegetarian,
      loc.dietKeto,
      loc.dietMeat,
      loc.dietFish,
      loc.dietOmnivore,
      loc.dietGlutenFree,
      loc.dietRaw,
    ];
  }

  static List<String> availableCategories(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return [
      loc.categoryMain,
      loc.categorySnack,
      loc.categoryBreakfast,
      loc.categorySide,
      loc.categoryDessert,
      loc.categoryStarter,
      loc.categoryLowCalorie,
    ];
  }
}
