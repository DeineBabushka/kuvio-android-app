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
    final buttonTextColor = isDark ? theme.colorScheme.primary : const Color(0xFF122620);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Mein Konto', style: TextStyle(color: textColor, fontSize: 20)),
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
                      _buildInfoRow("Über mich", userData!['bio'], textColor, labelColor),
                      Divider(color: dividerColor),
                      _buildInfoRow("Lieblingsküche", userData!['kitchen'], textColor, labelColor),
                      Divider(color: dividerColor),
                      _buildInfoRow("Lieblingsgericht", userData!['favdish'], textColor, labelColor),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: _navigateToEditProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBackground,
                          foregroundColor: buttonTextColor,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Profil bearbeiten',
                            style: TextStyle(fontSize: 16, color: buttonTextColor)),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoRow(String label, String? value, Color textColor, Color labelColor) {
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
}
