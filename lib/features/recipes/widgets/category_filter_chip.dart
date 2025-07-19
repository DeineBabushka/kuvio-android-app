import 'package:flutter/material.dart';

class CategoryFilterChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final Color textColor;
  final VoidCallback onTap;
  final ThemeData theme;

  const CategoryFilterChip({
    super.key,
    required this.category,
    required this.isSelected,
    required this.textColor,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E6B4D) : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
