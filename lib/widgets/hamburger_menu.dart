import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu(
      {super.key}); // <- const ist erlaubt, weil keine Felder drin sind

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: const Icon(Icons.menu, color: Colors.white),
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
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            value: 'login',
            child: Text('Anmelden / Registrieren',
                style: TextStyle(color: Color(0xFF122620))),
          ),
        ];
      },

      // Aktionen bei Auswahl
      onSelected: (value) {
        if (value == 'konto') {
          final user = FirebaseAuth.instance.currentUser;
          final isLoggedIn = user != null;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  isLoggedIn ? const AccountScreen() : const LoginScreen(),
            ),
          );
        } else if (value == 'favoriten') {
          // TODO: Navigation zu Favoriten
        } else if (value == 'darkmode') {
          // TODO: Darkmode umschalten
        } else if (value == 'login') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      },
    );
  }
}
