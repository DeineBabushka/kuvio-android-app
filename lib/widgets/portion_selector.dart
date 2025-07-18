import 'package:flutter/material.dart';

class PortionSelector extends StatelessWidget {
  final int portionCount;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Color textColor;

  const PortionSelector({
    super.key,
    required this.portionCount,
    required this.onIncrement,
    required this.onDecrement,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Portionen: ', style: TextStyle(color: textColor, fontSize: 16)),
        IconButton(
          onPressed: onDecrement,
          icon: const Icon(Icons.remove_circle_outline),
          color: textColor,
        ),
        Text('$portionCount', style: TextStyle(color: textColor, fontSize: 16)),
        IconButton(
          onPressed: onIncrement,
          icon: const Icon(Icons.add_circle_outline),
          color: textColor,
        ),
      ],
    );
  }
}
