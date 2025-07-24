import 'package:flutter/material.dart';

class InstructionList extends StatelessWidget {
  final List<String> instructions;
  final Color textColor;
  final Color cardColor;

  const InstructionList({
    super.key,
    required this.instructions,
    required this.textColor,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final stepCards = instructions.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final step = entry.value.length > 3
          ? entry.value.substring(3).trim()
          : entry.value.trim();

      return Card(
        color: cardColor,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  '$index',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stepCards,
    );
  }
}
