import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuvio/features/shopping_list/widgets/grouped_shopping_list_tab.dart';
import 'package:kuvio/features/shopping_list/widgets/by_recipe_shopping_list_tab.dart';
import 'package:kuvio/l10n/app_localizations.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final loc = AppLocalizations.of(context)!;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(loc.shoppingList),
          leading: const BackButton(),
        ),
        body: Center(
          child: Text(loc.loginToViewShoppingList),
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.shoppingList),
          bottom: TabBar(
            tabs: [
              Tab(text: loc.tabAllItems),
              Tab(text: loc.tabByRecipe),
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
