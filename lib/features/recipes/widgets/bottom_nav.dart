import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/auth/screens/login_screen.dart';
import 'package:kuvio/features/account/screens/account_screen.dart';
import 'package:kuvio/features/recipes/screens/favorites_screen.dart';
import 'package:kuvio/features/comments/screens/comment_screen.dart';
import 'package:kuvio/features/shopping_list/screens/shopping_list_screen.dart';
import 'package:kuvio/l10n/app_localizations.dart';

class BottomNavWidget extends StatelessWidget {
  final List<Recipe> allRecipes;

  const BottomNavWidget({
    super.key,
    required this.allRecipes,
  });

  void _onItemTapped(BuildContext context, int index) {
    final user = FirebaseAuth.instance.currentUser;

    Widget destination;

    switch (index) {
      case 0:
        destination =
            user == null ? const LoginScreen() : const AccountScreen();
        break;
      case 1:
        destination =
            user == null ? const LoginScreen() : const ShoppingListScreen();
        break;
      case 2:
        destination =
            user == null ? const LoginScreen() : const CommentScreen();
        break;
      case 3:
        destination = user == null
            ? const LoginScreen()
            : FavoritesScreen(allRecipes: allRecipes);
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
    final loc = AppLocalizations.of(context);

    return BottomNavigationBar(
      backgroundColor: const Color(0xFF122620),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _onItemTapped(context, index),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: loc?.navAccount ?? 'Konto',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_cart),
          label: loc?.navShoppingList ?? 'Einkaufsliste',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat_bubble_outline),
          label: loc?.navComments ?? 'Kommentare',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite_border),
          label: loc?.navFavorites ?? 'Favoriten',
        ),
      ],
    );
  }
}
