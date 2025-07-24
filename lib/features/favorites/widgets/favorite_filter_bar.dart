import 'package:flutter/material.dart';
import 'package:kuvio/features/favorites/models/favorites_filter.dart';
import 'package:kuvio/features/favorites/widgets/filter_dropdown.dart';
import 'package:kuvio/localization/app_localizations.dart';

class FavoritesFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final FavoritesFilter filter;
  final void Function(FavoritesFilter) onFilterChanged;

  const FavoritesFilterBar({
    super.key,
    required this.searchController,
    required this.filter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    String localizeCategory(String key) {
      switch (key) {
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
          return key;
      }
    }

    String localizeDiet(String key) {
      switch (key) {
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
          return key;
      }
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: searchController,
            onChanged: (val) => onFilterChanged(
              filter.copyWith(searchQuery: val.toLowerCase()),
            ),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: loc.searchRecipesHint,
              hintStyle: const TextStyle(color: Colors.white70),
              filled: true,
              fillColor: Colors.white10,
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: FilterDropdown(
                  items: filter.availableCategories(context),
                  selected: filter.category,
                  label: loc.categoryLabel,
                  onChanged: (val) =>
                      onFilterChanged(filter.copyWith(category: val)),
                  itemToString: localizeCategory,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilterDropdown(
                  items: filter.availableDietTypes(context),
                  selected: filter.dietType,
                  label: loc.dietTypeLabel,
                  onChanged: (val) =>
                      onFilterChanged(filter.copyWith(dietType: val)),
                  itemToString: localizeDiet,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
