import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
          return const Center(child: Text('Einkaufsliste ist leer'));
        }

        final Map<String, Map<String, Map<String, dynamic>>> grouped = {};

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final recipeId = data['fromRecipeId'] ?? 'Unbekannt';
          final name = data['name'];
          final unit = data['unit'];
          final quantity = (data['quantity'] as num?)?.toDouble() ?? 0.0;

          if (name == null || unit == null) continue;

          final key = '$name|$unit';

          grouped.putIfAbsent(recipeId, () => {});
          if (grouped[recipeId]!.containsKey(key)) {
            grouped[recipeId]![key]!['quantity'] += quantity;
          } else {
            grouped[recipeId]![key] = {
              'name': name,
              'unit': unit,
              'quantity': quantity,
            };
          }
        }

        return FutureBuilder<Map<String, String>>(
          future: _loadRecipeTitles(grouped.keys),
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
                    children: items.map((item) {
                      return ListTile(
                        title: Text(
                          '${item['quantity']} ${item['unit']} ${item['name']}',
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }

  Future<Map<String, String>> _loadRecipeTitles(Iterable<String> ids) async {
    final Map<String, String> titles = {};

    for (final id in ids) {
      if (id == 'Unbekannt') {
        titles[id] = 'Unbekanntes Rezept';
        continue;
      }

      try {
        final doc = await FirebaseFirestore.instance
            .collection('recipes')
            .doc(id)
            .get();

        final data = doc.data();
        titles[id] = data != null && data['title'] != null
            ? data['title'] as String
            : 'Rezept ohne Titel';
      } catch (e) {
        titles[id] = 'Fehler beim Laden';
      }
    }

    return titles;
  }
}
