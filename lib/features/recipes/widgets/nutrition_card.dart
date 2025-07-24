import 'package:flutter/material.dart';
import 'package:kuvio/localization/app_localizations.dart';

class NutritionCard extends StatelessWidget {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final Color textColor;
  final Color cardColor;

  const NutritionCard({
    super.key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.textColor,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    final values = [
      "${loc?.nutritionCalories ?? 'Kalorien'}: $calories kcal",
      "${loc?.nutritionProtein ?? 'Protein'}: $protein g",
      "${loc?.nutritionCarbs ?? 'Kohlenhydrate'}: $carbs g",
      "${loc?.nutritionFat ?? 'Fett'}: $fat g",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: values
          .map((info) => Card(
                color: cardColor,
                margin: const EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      info,
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
