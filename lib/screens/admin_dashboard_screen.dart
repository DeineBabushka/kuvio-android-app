import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usersRef = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF122620),
      ),
      backgroundColor: const Color(0xFF122620),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data?.docs ?? [];

          if (users.isEmpty) {
            return const Center(
                child: Text('Keine Benutzer gefunden.',
                    style: TextStyle(color: Colors.white)));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userDoc = users[index];
              final userData = userDoc.data() as Map<String, dynamic>;
              final username = userData['username'] ?? 'Unbekannt';
              final isAdmin = userData['isAdmin'] == true;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.white,
                child: ListTile(
                  title: Text(username,
                      style: const TextStyle(color: Color(0xFF122620))),
                  subtitle: Text(isAdmin ? 'Admin' : 'Benutzer'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: isAdmin,
                        onChanged: (value) async {
                          await usersRef
                              .doc(userDoc.id)
                              .update({'isAdmin': value});
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Adminstatus von "$username" geändert.')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Benutzer löschen'),
                              content: Text(
                                  'Willst du "$username" wirklich löschen?'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Abbrechen')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Löschen')),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await usersRef.doc(userDoc.id).delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Benutzer "$username" wurde gelöscht.')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
