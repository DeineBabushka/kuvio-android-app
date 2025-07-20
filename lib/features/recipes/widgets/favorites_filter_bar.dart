import 'package:flutter/material.dart';
import 'package:kuvio/shared/models/favorites_filter.dart';
import 'package:kuvio/features/recipes/widgets/filter_dropdown.dart';

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
              hintText: 'Suche nach Rezepten...',
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
                  label: 'Kategorie',
                  onChanged: (val) => onFilterChanged(
                    filter.copyWith(category: val),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilterDropdown(
                  items: filter.availableDietTypes,
                  selected: filter.dietType,
                  label: 'Ernährungsform',
                  onChanged: (val) => onFilterChanged(
                    filter.copyWith(dietType: val),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
