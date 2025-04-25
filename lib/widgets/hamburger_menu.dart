import 'package:flutter/material.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: const Icon(Icons.menu, color: Colors.white),
      onSelected: (value) {
        // Hier kannst du Navigation oder Aktionen hinzufügen
        if (value == 'konto') {
          // TODO: Navigation zum Konto
        } else if (value == 'favoriten') {
          // TODO: Navigation zu Favoriten
        } else if (value == 'darkmode') {
          // TODO: Darkmode umschalten
        } else if (value == 'einstellungen') {
          // TODO: Einstellungen öffnen
        } else if (value == 'login') {
          // TODO: Anmelden / Registrieren
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'konto',
            child: Text('Konto', style: TextStyle(color: Color(0xFF122620))),
          ),
          const PopupMenuItem<String>(
            value: 'favoriten',
            child:
                Text('Favoriten', style: TextStyle(color: Color(0xFF122620))),
          ),
          const PopupMenuItem<String>(
            value: 'darkmode',
            child: Text('Darkmode', style: TextStyle(color: Color(0xFF122620))),
          ),
          const PopupMenuItem<String>(
            value: 'einstellungen',
            child: Text('Einstellungen',
                style: TextStyle(color: Color(0xFF122620))),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            value: 'login',
            child: Text('Anmelden / Registrieren',
                style: TextStyle(color: Color(0xFF122620))),
          ),
        ];
      },
    );
  }
}
