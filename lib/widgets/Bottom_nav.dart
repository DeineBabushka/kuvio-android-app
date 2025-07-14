import 'package:flutter/material.dart';
import '../screens/start_screen.dart';
import '../screens/filter_screen.dart';
import '../screens/favorites_screen.dart';
import '../models/recipe.dart';

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
    if (index == widget.currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const StartScreen(),
          ),
        );
        break;

      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const RecipesScreen(),
          ),
        );
        break;

      case 2:
        // TODO: Navigation zu Kommentare
        break;

      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => FavoritesScreen(allRecipes: widget.allRecipes),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF1B1B1B),
      currentIndex: widget.currentIndex,
      selectedItemColor: const Color(0xFF6FC38D),
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Start',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Suche',
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
