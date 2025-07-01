import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_profile_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userData = doc.data();
        isLoading = false;
      });
    }
  }

  void _navigateToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final labelColor = Colors.white;
    final dividerColor = isDark ? Colors.white54 : Colors.black26;
    final buttonBackground = isDark ? theme.cardColor : Colors.white;
    final buttonTextColor =
        isDark ? theme.colorScheme.primary : const Color(0xFF122620);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Mein Konto',
            style: TextStyle(color: textColor, fontSize: 20)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: textColor))
          : userData == null
              ? Center(
                  child: Text('Keine Daten gefunden',
                      style: TextStyle(color: textColor)))
              : Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                          userData!['profileImage'] ?? 'assets/character_1.png',
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        userData!['username'] ?? 'Unbekannt',
                        style: TextStyle(
                          fontSize: 22,
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Divider(color: dividerColor),
                      _buildInfoRow(
                          "Über mich", userData!['bio'], textColor, labelColor),
                      Divider(color: dividerColor),
                      _buildInfoRow("Lieblingsküche", userData!['kitchen'],
                          textColor, labelColor),
                      Divider(color: dividerColor),
                      _buildInfoRow("Lieblingsgericht", userData!['favdish'],
                          textColor, labelColor),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _navigateToEditProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBackground,
                          foregroundColor: buttonTextColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Profil bearbeiten',
                            style: TextStyle(
                                fontSize: 16, color: buttonTextColor)),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: Icon(Icons.delete),
                        label: Text('Konto löschen'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _showDeleteConfirmationDialog,
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoRow(
      String label, String? value, Color textColor, Color labelColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(color: labelColor, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          value?.isNotEmpty == true ? value! : 'Nicht angegeben',
          style: TextStyle(color: textColor, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Konto wirklich löschen?',
            style: TextStyle(color: Colors.black),
          ),
          content: Text(
            'Dieser Vorgang kann nicht rückgängig gemacht werden.',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              child: Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Löschen', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteAccount();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kein Benutzer angemeldet.')),
      );
      return;
    }

    final password = await _askForPassword();
    if (password == null) return;

    try {
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(cred);

      // Firestore-Daten löschen
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      await FirebaseFirestore.instance
          .collection('favorites')
          .doc(user.uid)
          .delete();

      // Auth-Konto löschen
      await user.delete();

      // Zur Login-Seite weiterleiten
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Löschen: $e')),
      );
    }
  }

  Future<String?> _askForPassword() async {
    final controller = TextEditingController();
    String? result;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Passwort bestätigen',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                obscureText: true,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Passwort',
                  border: OutlineInputBorder(),
                  labelStyle: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: Text('Abbrechen'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    child: Text('Bestätigen'),
                    onPressed: () {
                      result = controller.text;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );

    return result;
  }
}
