import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kuvio/features/shopping_list/models/shopping_list_item.dart';
import 'package:kuvio/l10n/app_localizations.dart';
import 'package:kuvio/shared/utils/block_if_offline.dart';
import 'package:kuvio/shared/utils/snackbar_helper.dart';

class GroupedShoppingListTab extends StatefulWidget {
  const GroupedShoppingListTab({super.key});

  @override
  State<GroupedShoppingListTab> createState() => _GroupedShoppingListTabState();
}

class _GroupedShoppingListTabState extends State<GroupedShoppingListTab> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(child: Text(loc.loginToViewShoppingList));
    }

    final lang = Localizations.localeOf(context).languageCode;

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
          final key = item.key(lang);

          if (groupedItems.containsKey(key)) {
            groupedItems[key] = ShoppingListItem(
              nameRaw: item.nameRaw,
              unitRaw: item.unitRaw,
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
                        '${item.quantity.toStringAsFixed(2)} ${item.unit(lang)} ${item.name(lang)}',
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
                          if (blockIfOffline(context)) return;

                          final matchingDocs = docs.where((doc) {
                            final docItem = ShoppingListItem.fromMap(
                                doc.data() as Map<String, dynamic>);
                            return docItem.name(lang) == item.name(lang) &&
                                docItem.unit(lang) == item.unit(lang);
                          });

                          for (var doc in matchingDocs) {
                            await doc.reference.delete();
                          }

                          if (!mounted) return;
                          SnackbarHelper.showMessage(
                            this.context,
                            loc.itemDeleted(item.name(lang)),
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
                  if (blockIfOffline(context)) return;

                  final batch = FirebaseFirestore.instance.batch();
                  for (var doc in docs) {
                    batch.delete(doc.reference);
                  }
                  await batch.commit();

                  if (!mounted) return;
                  SnackbarHelper.showMessage(
                    this.context,
                    loc.shoppingListCleared,
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
