import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/recipe.dart';
import '../screens/login_screen.dart';
import '../screens/account_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/comment_screen.dart';
import '../screens/shopping_list_screen.dart';

class BottomNavWidget extends StatefulWidget {
  final List<Recipe> allRecipes;
  final int currentIndex;

  const BottomNavWidget({
    super.key,
    required this.allRecipes,
    required this.currentIndex,
  });

  @override
  State<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  void _onItemTapped(int index) {
    final user = FirebaseAuth.instance.currentUser;

    Widget destination;

    switch (index) {
      case 0:
        destination =
            user == null ? const LoginScreen() : const AccountScreen();
        break;
      case 1:
        destination = const ShoppingListScreen();
        break;
      case 2:
        destination = CommentScreen(allRecipes: widget.allRecipes);
        break;
      case 3:
        destination = user == null
            ? const LoginScreen()
            : FavoritesScreen(allRecipes: widget.allRecipes);
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF122620),
      currentIndex: widget.currentIndex,
      selectedItemColor: const Color(0xFF6FC38D),
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Konto',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Einkaufsliste',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Kommentare',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favoriten',
        ),
      ],
    );
  }
}
