import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  final List<String> items;
  final String? selected;
  final String label;
  final void Function(String?) onChanged;
  final String Function(String)? itemToString;

  const FilterDropdown({
    super.key,
    required this.items,
    required this.selected,
    required this.label,
    required this.onChanged,
    this.itemToString,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selected,
      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      items: [
        DropdownMenuItem(
          value: null,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        ...items.map(
          (val) => DropdownMenuItem(
            value: val,
            child: Text(
              itemToString?.call(val) ?? val,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
