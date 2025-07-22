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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 34,
            backgroundImage: AssetImage(assetPath),
            backgroundColor:
                isSelected ? const Color(0xFF2E6B4D) : Colors.transparent,
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
                color: isSelected ? const Color(0xFF2E6B4D) : textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
