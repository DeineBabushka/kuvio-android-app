import 'package:flutter/material.dart';

class DrawerTileWithSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color tileColor;

  const DrawerTileWithSwitch({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    required this.tileColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: tileColor,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          inactiveThumbColor: Colors.white54,
          inactiveTrackColor: Colors.white24,
        ),
        onTap: () => onChanged(!value),
      ),
    );
  }
}
