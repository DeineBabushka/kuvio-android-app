import 'package:flutter/material.dart';
import 'package:kuvio/features/account/utils/kitchen_options.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: selectedKitchen,
        dropdownColor: AppColors.cardColor,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: Colors.white,
        decoration: const InputDecoration(
          labelText: 'Lieblingsküche',
          labelStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
        items: kitchenOptions
            .map((kitchen) => DropdownMenuItem<String>(
                  value: kitchen,
                  child: Text(kitchen),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
