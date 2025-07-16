import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ByRecipeShoppingListTab extends StatelessWidget {
  const ByRecipeShoppingListTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final itemsRef = FirebaseFirestore.instance
        .collection('shopping_list')
        .doc(user!.uid)
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
          return const Center(child: Text('Einkaufsliste ist leer'));
        }

        final Map<String, List<Map<String, dynamic>>> itemsByRecipe = {};

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final recipeId = data['fromRecipeId'] ?? 'Unbekannt';
          itemsByRecipe.putIfAbsent(recipeId, () => []).add(data);
        }

        return ListView(
          children: itemsByRecipe.entries.map((entry) {
            final recipeId = entry.key;
            final items = entry.value;

            return Card(
              margin: const EdgeInsets.all(8),
              child: ExpansionTile(
                title: Text('Rezept: $recipeId'),
                children: items.map((item) {
                  return ListTile(
                    title: Text(
                        '${item['quantity']} ${item['unit']} ${item['name']}'),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
