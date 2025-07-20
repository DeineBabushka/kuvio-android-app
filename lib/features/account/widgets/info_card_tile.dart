import 'package:flutter/material.dart';

class InfoCardTile extends StatelessWidget {
  final String label;
  final String? value;
  final Color textColor;
  final Color tileColor;

  const InfoCardTile({
    super.key,
    required this.label,
    required this.value,
    required this.textColor,
    required this.tileColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: tileColor,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        subtitle: Text(value?.isNotEmpty == true ? value! : 'Nicht angegeben',
            style: TextStyle(color: textColor, fontSize: 16)),
      ),
    );
  }
}
