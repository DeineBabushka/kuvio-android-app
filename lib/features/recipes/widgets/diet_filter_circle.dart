import 'package:flutter/material.dart';

class DietFilterCircle extends StatelessWidget {
  final String assetPath;
  final String label;
  final bool isSelected;
  final Color textColor;
  final VoidCallback onTap;

  const DietFilterCircle({
    super.key,
    required this.assetPath,
    required this.label,
    required this.isSelected,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(assetPath),
            backgroundColor:
                isSelected ? const Color(0xFF2E6B4D) : Colors.transparent,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF2E6B4D) : textColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
