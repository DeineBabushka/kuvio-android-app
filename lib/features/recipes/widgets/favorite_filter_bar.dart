import 'package:flutter/material.dart';
import 'package:kuvio/shared/models/favorites_filter.dart';
import 'package:kuvio/features/recipes/widgets/filter_dropdown.dart';
import 'package:kuvio/l10n/app_localizations.dart';

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
    final loc = AppLocalizations.of(context);

    String localizeCategory(String key) {
      switch (key) {
        case 'Vorspeise':
          return loc?.categoryStarter ?? key;
        case 'Hauptgericht':
          return loc?.categoryMain ?? key;
        case 'Dessert':
          return loc?.categoryDessert ?? key;
        case 'Beilage':
          return loc?.categorySide ?? key;
        case 'Snack':
          return loc?.categorySnack ?? key;
        case 'Frühstück':
          return loc?.categoryBreakfast ?? key;
        case 'Kalorienarm':
          return loc?.categoryLowCalorie ?? key;
        default:
          return key;
      }
    }

    String localizeDiet(String key) {
      switch (key) {
        case 'Rohkost':
          return loc?.dietRaw ?? key;
        case 'Glutenfrei':
          return loc?.dietGlutenFree ?? key;
        case 'Fisch':
          return loc?.dietFish ?? key;
        case 'Keto':
          return loc?.dietKeto ?? key;
        case 'Fleisch':
          return loc?.dietMeat ?? key;
        case 'Vegetarisch':
          return loc?.dietVegetarian ?? key;
        case 'Omnivor':
          return loc?.dietOmnivore ?? key;
        case 'Vegan':
          return loc?.dietVegan ?? key;
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
              hintText: loc?.searchRecipesHint ?? 'Suche nach Rezepten...',
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
                  items: filter.availableCategories,
                  selected: filter.category,
                  label: loc?.categoryLabel ?? 'Kategorie',
                  onChanged: (val) =>
                      onFilterChanged(filter.copyWith(category: val)),
                  itemToString: localizeCategory,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilterDropdown(
                  items: filter.availableDietTypes,
                  selected: filter.dietType,
                  label: loc?.dietTypeLabel ?? 'Ernährungsform',
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
