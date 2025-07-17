import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../screens/account_screen.dart';
import '../screens/login_screen.dart';
import '../screens/favorites_screen.dart';
import '../models/recipe.dart';
import '../theme_provider.dart';
import '../screens/admin_dashboard_screen.dart';

class HamburgerDrawer extends StatefulWidget {
  final List<Recipe> allRecipes;

  const HamburgerDrawer({super.key, required this.allRecipes});

  @override
  State<HamburgerDrawer> createState() => _HamburgerDrawerState();
}

class _HamburgerDrawerState extends State<HamburgerDrawer> {
  Map<String, dynamic>? userData;

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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    final sectionStyle =
        const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold);
    final tileColor = const Color(0xFF2E6B4D);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ListView(
        padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
        children: [
          if (isLoggedIn && userData != null) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                    userData!['profileImage'] ?? 'assets/character_1.png',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData!['username'] ?? 'Unbekannt',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        userData!['bio']?.isNotEmpty == true
                            ? userData!['bio']
                            : 'Keine Beschreibung',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 32),
            Text("ALLGEMEIN", style: sectionStyle),
            const SizedBox(height: 12),
            _buildTile(
              context,
              icon: Icons.person,
              title: "Konto",
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AccountScreen()),
                );
                await _loadUserData();
              },
              tileColor: tileColor,
            ),
            _buildTile(
              context,
              icon: Icons.favorite,
              title: "Favoriten",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      FavoritesScreen(allRecipes: widget.allRecipes),
                ),
              ),
              tileColor: tileColor,
            ),if (userData!['isAdmin'] == true)
  _buildTile(
    context,
    icon: Icons.admin_panel_settings,
    title: "Admin-Dashboard",
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
      );
    },
    tileColor: tileColor,
  ),

            const SizedBox(height: 24),
            Text("ANPASSUNG", style: sectionStyle),
            const SizedBox(height: 12),
            _buildTileWithSwitch(
              context,
              icon: Icons.dark_mode,
              title: "Darkmode",
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) {
                final themeProvider =
                    Provider.of<ThemeProvider>(context, listen: false);
                themeProvider.toggleTheme();
              },
              tileColor: tileColor,
            ),
            const SizedBox(height: 24),
            Text("KONTO", style: sectionStyle),
            const SizedBox(height: 12),
            _buildTile(
              context,
              icon: Icons.logout,
              title: "Abmelden",
              onTap: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Du wurdest abgemeldet.")),
                );
              },
              tileColor: tileColor,
            ),
          ] else ...[
            const Center(
              child:
                  Icon(Icons.person_outline, color: Colors.white70, size: 48),
            ),
            const SizedBox(height: 3),
            const Center(
              child: Text(
                'Nicht angemeldet',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            const SizedBox(height: 32),
            Text("KONTO", style: sectionStyle),
            const SizedBox(height: 12),
            _buildTile(
              context,
              icon: Icons.login,
              title: "Anmelden / Registrieren",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              tileColor: tileColor,
            ),
            const SizedBox(height: 24),
            Text("ANPASSUNG", style: sectionStyle),
            const SizedBox(height: 12),
            _buildTileWithSwitch(
              context,
              icon: Icons.dark_mode,
              title: "Darkmode",
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) {
                final themeProvider =
                    Provider.of<ThemeProvider>(context, listen: false);
                themeProvider.toggleTheme();
              },
              tileColor: tileColor,
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color tileColor,
  }) {
    return Card(
      color: tileColor,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing:
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTileWithSwitch(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color tileColor,
  }) {
    return Card(
      color: tileColor,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          inactiveThumbColor: Colors.white54,
          inactiveTrackColor: Colors.white24,
        ),
        onTap: () => onChanged(!value),
      ),
    );
  }
}
