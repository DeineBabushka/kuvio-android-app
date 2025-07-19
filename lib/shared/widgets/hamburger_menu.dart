import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../features/account/screens/account_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/recipes/screens/favorites_screen.dart';
import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/shopping_list/screens/shopping_list_screen.dart';
import '../../features/comments/screens/comment_screen.dart';
import '../../features/recipes/models/recipe.dart';
import '../services/theme_provider.dart';
import 'drawer_tile.dart';
import 'drawer_tile_with_switch.dart';
import 'drawer_profile_header.dart';
import '../../features/account/services/user_service.dart';
import '../../features/auth/services/auth_service.dart';

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
    final data = await UserService().fetchCurrentUserData();
    if (mounted) {
      setState(() {
        userData = data;
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
            DrawerProfileHeader(
              username: userData!['username'] ?? 'Unbekannt',
              bio: userData!['bio'],
              profileImage: userData!['profileImage'],
            ),
            const SizedBox(height: 32),
            Text("ALLGEMEIN", style: sectionStyle),
            const SizedBox(height: 12),
            DrawerTile(
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
            DrawerTile(
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
            ),
            DrawerTile(
              icon: Icons.shopping_cart,
              title: "Einkaufsliste",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShoppingListScreen()),
              ),
              tileColor: tileColor,
            ),
            DrawerTile(
              icon: Icons.comment,
              title: "Kommentare",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CommentScreen(allRecipes: widget.allRecipes),
                ),
              ),
              tileColor: tileColor,
            ),
            if (userData!['isAdmin'] == true)
              DrawerTile(
                icon: Icons.admin_panel_settings,
                title: "Admin-Dashboard",
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AdminDashboardScreen()),
                ),
                tileColor: tileColor,
              ),
            const SizedBox(height: 24),
            Text("ANPASSUNG", style: sectionStyle),
            const SizedBox(height: 12),
            DrawerTileWithSwitch(
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
            DrawerTile(
              icon: Icons.logout,
              title: "Abmelden",
              onTap: () async {
                await AuthService().signOutUser(context);
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
            DrawerTile(
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
            DrawerTileWithSwitch(
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
}
