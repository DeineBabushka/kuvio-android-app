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
    _loadUserData(); // Nach Rückkehr neu laden
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF122620),
      appBar: AppBar(
        title: const Text('Mein Konto'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : userData == null
              ? const Center(
                  child: Text('Keine Daten gefunden',
                      style: TextStyle(color: Colors.white)))
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
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: Colors.white54),
                      _buildInfoRow("Über mich", userData!['bio']),
                      const Divider(color: Colors.white54),
                      _buildInfoRow("Lieblingsküche", userData!['kitchen']),
                      const Divider(color: Colors.white54),
                      _buildInfoRow("Lieblingsgericht", userData!['favdish']),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _navigateToEditProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF122620),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Profil bearbeiten',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          value?.isNotEmpty == true ? value! : 'Nicht angegeben',
          style: const TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
