import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuvio/features/shopping_list/models/shopping_list_item.dart';
import 'package:kuvio/l10n/app_localizations.dart';

class GroupedShoppingListTab extends StatelessWidget {
  const GroupedShoppingListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text(loc.loginToViewShoppingList),
      );
    }

    final itemsRef = FirebaseFirestore.instance
        .collection('shopping_list')
        .doc(user.uid)
        .collection('items')
        .orderBy('addedAt');

    return StreamBuilder<QuerySnapshot>(
      stream: itemsRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        if (docs.isEmpty) {
          return Center(child: Text(loc.shoppingListEmpty));
        }

        final Map<String, ShoppingListItem> groupedItems = {};

        for (var doc in docs) {
          final item =
              ShoppingListItem.fromMap(doc.data() as Map<String, dynamic>);
          final key = item.key;

          if (groupedItems.containsKey(key)) {
            groupedItems[key] = ShoppingListItem(
              name: item.name,
              unit: item.unit,
              quantity: groupedItems[key]!.quantity + item.quantity,
            );
          } else {
            groupedItems[key] = item;
          }
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                children: groupedItems.values.map((item) {
                  bool isChecked = false;

                  return StatefulBuilder(
                    builder: (context, setState) => CheckboxListTile(
                      value: isChecked,
                      onChanged: (val) =>
                          setState(() => isChecked = val ?? false),
                      title: Text(
                        '${item.quantity} ${item.unit} ${item.name}',
                        style: TextStyle(
                          color: Colors.white,
                          decoration: isChecked
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      secondary: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          final matchingDocs = docs.where((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return data['name'] == item.name &&
                                data['unit'] == item.unit;
                          });

                          for (var doc in matchingDocs) {
                            await doc.reference.delete();
                          }

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(loc.itemDeleted(item.name))),
                          );
                        },
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      activeColor: Colors.greenAccent,
                      checkColor: Colors.black,
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  final batch = FirebaseFirestore.instance.batch();
                  for (var doc in docs) {
                    batch.delete(doc.reference);
                  }
                  await batch.commit();

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.shoppingListCleared)),
                  );
                },
                icon: const Icon(Icons.delete_forever),
                label: Text(loc.deleteAllIngredients),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
