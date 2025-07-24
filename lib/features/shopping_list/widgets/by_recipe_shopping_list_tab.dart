import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuvio/features/shopping_list/services/grouped_shopping_list_service.dart';
import 'package:kuvio/features/shopping_list/models/shopping_list_item.dart';
import 'package:kuvio/localization/app_localizations.dart';
import 'package:kuvio/shared/utils/block_if_offline.dart';
import 'package:kuvio/shared/utils/snackbar_helper.dart';

class ByRecipeShoppingListTab extends StatefulWidget {
  const ByRecipeShoppingListTab({super.key});

  @override
  State<ByRecipeShoppingListTab> createState() =>
      _ByRecipeShoppingListTabState();
}

class _ByRecipeShoppingListTabState extends State<ByRecipeShoppingListTab> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text(loc.loginToViewShoppingList));
    }

    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: GroupedShoppingListService.getUserShoppingItemsStream(user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(child: Text(loc.shoppingListEmpty));
          }

          final grouped =
              GroupedShoppingListService.groupItemsByRecipe(docs, lang);
          final recipeTitles =
              GroupedShoppingListService.extractStoredRecipeTitles(docs, lang);

          return ListView(
            children: grouped.entries.map((entry) {
              final recipeId = entry.key;
              final items = entry.value.values
                  .map((e) => ShoppingListItem.fromMap(e))
                  .toList();
              final title = recipeTitles[recipeId] ?? recipeId;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ExpansionTile(
                  title: Text('${loc.recipe}: $title'),
                  children: [
                    ...items.map((item) => ListTile(
                          title: Text(
                            '${item.quantity.toStringAsFixed(2)} '
                            '${item.unit(lang)} ${item.name(lang)}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onPressed: () {
                              _deleteSingleItem(
                                docs: docs,
                                recipeId: recipeId,
                                itemName: item.name(lang),
                                itemUnit: item.unit(lang),
                                lang: lang,
                              );
                            },
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Center(
                        child: TextButton.icon(
                          onPressed: () {
                            _deleteAllItemsForRecipe(
                              docs: docs,
                              recipeId: recipeId,
                              recipeTitle: recipeTitles[recipeId] ?? recipeId,
                            );
                          },
                          icon: const Icon(Icons.delete_forever,
                              color: Colors.redAccent),
                          label: Text(
                            loc.removeRecipeFromShoppingList,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> _deleteSingleItem({
    required List<QueryDocumentSnapshot> docs,
    required String recipeId,
    required String itemName,
    required String itemUnit,
    required String lang,
  }) async {
    if (!mounted || blockIfOffline(context)) return;

    final loc = AppLocalizations.of(context)!;

    await GroupedShoppingListService.deleteSingleItem(
      docs,
      recipeId,
      itemName,
      itemUnit,
      lang,
    );

    if (!mounted) return;
    SnackbarHelper.showMessage(context, loc.itemDeleted(itemName));
  }

  Future<void> _deleteAllItemsForRecipe({
    required List<QueryDocumentSnapshot> docs,
    required String recipeId,
    required String recipeTitle,
  }) async {
    if (!mounted || blockIfOffline(context)) return;

    final loc = AppLocalizations.of(context)!;

    await GroupedShoppingListService.deleteItemsForRecipe(docs, recipeId);

    if (!mounted) return;
    SnackbarHelper.showMessage(context, loc.recipeItemsDeleted(recipeTitle));
  }
}
