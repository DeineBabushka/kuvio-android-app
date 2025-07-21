import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuvio/features/shopping_list/services/grouped_shopping_list_service.dart';
import 'package:kuvio/features/shopping_list/models/shopping_list_item.dart';
import 'package:kuvio/l10n/app_localizations.dart';

class ByRecipeShoppingListTab extends StatelessWidget {
  const ByRecipeShoppingListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text(loc.loginToViewShoppingList),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: GroupedShoppingListService.getUserShoppingItemsStream(user.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return Center(child: Text(loc.shoppingListEmpty));
        }

        final grouped = GroupedShoppingListService.groupItemsByRecipe(docs);

        return FutureBuilder<Map<String, String>>(
          future: GroupedShoppingListService.loadRecipeTitles(grouped.keys),
          builder: (context, titleSnapshot) {
            final recipeTitles = titleSnapshot.data ?? {};

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
                      ...items.map((item) {
                        return ListTile(
                          title: Text(
                              '${item.quantity} ${item.unit} ${item.name}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onPressed: () async {
                              await GroupedShoppingListService.deleteSingleItem(
                                docs,
                                recipeId,
                                item.name,
                                item.unit,
                              );

                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    loc.itemDeleted(item.name),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Center(
                          child: TextButton.icon(
                            onPressed: () async {
                              await GroupedShoppingListService
                                  .deleteItemsForRecipe(docs, recipeId);

                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    loc.recipeItemsDeleted(title),
                                  ),
                                ),
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
        );
      },
    );
  }
}
