import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/grouped_shopping_list_service.dart';

class ByRecipeShoppingListTab extends StatelessWidget {
  const ByRecipeShoppingListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(
        child: Text('Bitte einloggen, um die Einkaufsliste zu sehen.'),
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
          return const Center(child: Text('Einkaufsliste ist leer'));
        }

        final grouped = GroupedShoppingListService.groupItemsByRecipe(docs);

        return FutureBuilder<Map<String, String>>(
          future: GroupedShoppingListService.loadRecipeTitles(grouped.keys),
          builder: (context, titleSnapshot) {
            final recipeTitles = titleSnapshot.data ?? {};

            return ListView(
              children: grouped.entries.map((entry) {
                final recipeId = entry.key;
                final items = entry.value.values.toList();
                final title = recipeTitles[recipeId] ?? recipeId;

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Text('Rezept: $title'),
                    children: [
                      ...items.map((item) {
                        return ListTile(
                          title: Text(
                              '${item['quantity']} ${item['unit']} ${item['name']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent),
                            onPressed: () async {
                              await GroupedShoppingListService.deleteSingleItem(
                                docs,
                                recipeId,
                                item['name'],
                                item['unit'],
                              );

                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${item['name']} gelöscht"),
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
                                  content:
                                      Text("Zutaten für '$title' gelöscht"),
                                ),
                              );
                            },
                            icon: const Icon(Icons.delete_forever,
                                color: Colors.redAccent),
                            label: const Text(
                              "Rezept aus Einkaufsliste entfernen",
                              style: TextStyle(color: Colors.redAccent),
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
