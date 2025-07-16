import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/grouped_shopping_list_tab.dart';
import '../widgets/by_recipe_shopping_list_tab.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
            child: Text('Bitte einloggen, um die Einkaufsliste zu sehen.')),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Einkaufsliste'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Gesamtliste'),
              Tab(text: 'Nach Rezept'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            GroupedShoppingListTab(),
            ByRecipeShoppingListTab(),
          ],
        ),
      ),
    );
  }
}
