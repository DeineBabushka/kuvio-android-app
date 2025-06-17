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
        final user = snapshot.data;
        final isLoggedIn = user != null;

        return PopupMenuButton<String>(
          color: Colors.white,
          icon: const Icon(Icons.menu, color: Colors.white),
          itemBuilder: (BuildContext context) {
            final List<PopupMenuEntry<String>> menuItems = [];

            if (isLoggedIn) {
              menuItems.addAll([
                const PopupMenuItem<String>(
                  value: 'konto',
                  child:
                      Text('Konto', style: TextStyle(color: Color(0xFF122620))),
                ),
                const PopupMenuItem<String>(
                  value: 'favoriten',
                  child: Text('Favoriten',
                      style: TextStyle(color: Color(0xFF122620))),
                ),
              ]);
            }

            menuItems.add(
              const PopupMenuItem<String>(
                value: 'darkmode',
                child: Text('Darkmode',
                    style: TextStyle(color: Color(0xFF122620))),
              ),
            );

            menuItems.add(const PopupMenuDivider());

            if (isLoggedIn) {
              menuItems.add(
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Abmelden',
                      style: TextStyle(color: Color(0xFF122620))),
                ),
              );
            } else {
              menuItems.add(
                const PopupMenuItem<String>(
                  value: 'login',
                  child: Text('Anmelden / Registrieren',
                      style: TextStyle(color: Color(0xFF122620))),
                ),
              );
            }

            return menuItems;
          },
          onSelected: (value) async {
            if (value == 'konto') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            } else if (value == 'favoriten') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Favoriten kommen bald!')),
              );
            } else if (value == 'darkmode') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Darkmode kommt bald!')),
              );
            } else if (value == 'login') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } else if (value == 'logout') {
              await FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Du wurdest abgemeldet.')),
              );
            }
          },
        );
      },
    );
  }
}
