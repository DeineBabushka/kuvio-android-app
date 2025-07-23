import 'package:flutter/material.dart';
import 'package:kuvio/localization/context_extension.dart';
import 'package:kuvio/shared/utils/constants.dart';

class KitchenDropdownCard extends StatelessWidget {
  final String selectedKitchen;
  final void Function(String?) onChanged;

  const KitchenDropdownCard({
    super.key,
    required this.selectedKitchen,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: DropdownButtonFormField<String>(
        value: selectedKitchen == 'not_set' ? null : selectedKitchen,
        decoration: InputDecoration(
          labelText: context.loc.accountFavoriteKitchen,
          border: InputBorder.none,
          isDense: true,
          labelStyle: const TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
        dropdownColor: AppColors.cardColor,
        style: const TextStyle(color: Colors.white),
        items: kitchenInternalToKey.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(context.loc.getString(entry.value)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
