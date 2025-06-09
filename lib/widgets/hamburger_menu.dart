import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/account_screen.dart';
import '../screens/login_screen.dart';

class HamburgerMenu extends StatelessWidget {
  const HamburgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final isLoggedIn = snapshot.hasData;

        return PopupMenuButton<String>(
          color: Colors.white,
          icon: const Icon(Icons.menu, color: Colors.white),
          onSelected: (value) {
            if (value == 'konto') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      isLoggedIn ? const AccountScreen() : const LoginScreen(),
                ),
              );
            } else if (value == 'favoriten') {
              // TODO: Favoriten anzeigen
            } else if (value == 'darkmode') {
              // TODO: Darkmode toggeln
            } else if (value == 'login') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } else if (value == 'logout') {
              FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Color(0xFF2E6B4D),
                  content: Text(
                    'Erfolgreich ausgeloggt',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
          },
          itemBuilder: (context) => [
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
              child:
                  Text('Darkmode', style: TextStyle(color: Color(0xFF122620))),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: isLoggedIn ? 'logout' : 'login',
              child: Text(
                isLoggedIn ? 'Logout' : 'Anmelden / Registrieren',
                style: const TextStyle(color: Color(0xFF122620)),
              ),
            ),
          ],
        );
      },
    );
  }
}
