import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

        // Nur wenn eingeloggt: Adminstatus prüfen
        if (!isLoggedIn) {
          return _buildMenu(context, false, false);
        }

        return FutureBuilder<bool>(
          future: _checkIfAdmin(user),
          builder: (context, adminSnapshot) {
            final isAdmin = adminSnapshot.data ?? false;
            return _buildMenu(context, isAdmin, isLoggedIn);
          },
        );
      },
    );
  }

  /// Menüaufbau je nach Status
  Widget _buildMenu(BuildContext context, bool isAdmin, bool isLoggedIn) {
    return PopupMenuButton<String>(
      color: Colors.white,
      icon: const Icon(Icons.menu, color: Colors.white),
      itemBuilder: (BuildContext context) {
        final List<PopupMenuEntry<String>> menuItems = [];

        if (isLoggedIn) {
          menuItems.addAll([
            const PopupMenuItem<String>(
              value: 'konto',
              child: Text('Konto', style: TextStyle(color: Color(0xFF122620))),
            ),
            const PopupMenuItem<String>(
              value: 'favoriten',
              child: Text('Meine Favoriten',
                  style: TextStyle(color: Color(0xFF122620))),
            ),
          ]);

          if (isAdmin) {
            menuItems.add(
              const PopupMenuItem<String>(
                value: 'admin',
                child: Text('Admin Dashboard',
                    style: TextStyle(color: Color(0xFF122620))),
              ),
            );
          }
        }

        menuItems.add(
          const PopupMenuItem<String>(
            value: 'darkmode',
            child: Text('Darkmode', style: TextStyle(color: Color(0xFF122620))),
          ),
        );

        menuItems.add(const PopupMenuDivider());

        if (isLoggedIn) {
          menuItems.add(
            const PopupMenuItem<String>(
              value: 'logout',
              child:
                  Text('Abmelden', style: TextStyle(color: Color(0xFF122620))),
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
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AccountScreen()));
        } else if (value == 'favoriten') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Favoriten kommen bald!')));
        } else if (value == 'darkmode') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Darkmode kommt bald!')));
        } else if (value == 'login') {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        } else if (value == 'logout') {
          await FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Du wurdest abgemeldet.')));
        } else if (value == 'admin') {
          Navigator.pushNamed(context, '/admin');
        }
      },
    );
  }

  /// Holt den Admin-Status aus Firestore
  Future<bool> _checkIfAdmin(User? user) async {
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.data()?['isAdmin'] == true;
  }
}
