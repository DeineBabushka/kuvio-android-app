import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GroupedShoppingListTab extends StatelessWidget {
  const GroupedShoppingListTab({super.key});

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

        final Map<String, Map<String, dynamic>> groupedItems = {};

        for (var doc in docs) {
          final data = doc.data() as Map<String, dynamic>;
          final name = data['name'];
          final unit = data['unit'];
          final quantity = (data['quantity'] as num?)?.toDouble() ?? 0.0;

          if (name == null || unit == null) continue;

          final key = '$name|$unit';

          if (groupedItems.containsKey(key)) {
            groupedItems[key]!['quantity'] += quantity;
          } else {
            groupedItems[key] = {
              'name': name,
              'unit': unit,
              'quantity': quantity,
            };
          }
        }

        return ListView(
          children: groupedItems.values.map((item) {
            final name = item['name'];
            final unit = item['unit'];
            final quantity = item['quantity'];

            bool isChecked = false;

            return StatefulBuilder(
              builder: (context, setState) => CheckboxListTile(
                value: isChecked,
                onChanged: (val) => setState(() => isChecked = val ?? false),
                title: Text(
                  '$quantity $unit $name',
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
                      return data['name'] == name && data['unit'] == unit;
                    });

                    for (var doc in matchingDocs) {
                      await doc.reference.delete();
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Zutat(en) entfernt")),
                    );
                  },
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                activeColor: Colors.greenAccent,
                checkColor: Colors.black,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
