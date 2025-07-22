import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:kuvio/l10n/context_extension.dart';
import 'package:kuvio/features/account/screens/account_screen.dart';
import 'package:kuvio/features/auth/screens/login_screen.dart';
import 'package:kuvio/features/recipes/screens/favorites_screen.dart';
import 'package:kuvio/features/admin/screens/admin_dashboard_screen.dart';
import 'package:kuvio/features/shopping_list/screens/shopping_list_screen.dart';
import 'package:kuvio/features/comments/screens/comment_screen.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/shared/services/theme_provider.dart';
import 'package:kuvio/shared/widgets/drawer_tile.dart';
import 'package:kuvio/shared/widgets/drawer_tile_with_switch.dart';
import 'package:kuvio/shared/widgets/drawer_profile_header.dart';
import 'package:kuvio/shared/services/user_service.dart';
import 'package:kuvio/features/auth/services/auth_service.dart';
import 'package:kuvio/shared/widgets/language_dialog.dart';
import 'package:kuvio/shared/utils/connectivity_provider.dart';
import 'package:kuvio/shared/utils/block_if_offline.dart';

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
    final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
    final sectionStyle =
        const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold);
    final tileColor = const Color(0xFF2E6B4D);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: ListView(
        padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
        children: [
          if (isLoggedIn && isOnline && userData != null) ...[
            DrawerProfileHeader(
              username: userData!['username'] ?? 'Unbekannt',
              bio: userData!['bio'],
              profileImage: userData!['profileImage'],
            ),
          ] else if (isLoggedIn && !isOnline) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_off, color: Colors.white70, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    context.loc.profileOfflineNotAvailable,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ] else ...[
            const Center(
              child:
                  Icon(Icons.person_outline, color: Colors.white70, size: 48),
            ),
            const SizedBox(height: 3),
            Center(
              child: Text(
                context.loc.notLoggedIn,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
          ],
          const SizedBox(height: 32),
          if (isLoggedIn) ...[
            Text(context.loc.general, style: sectionStyle),
            const SizedBox(height: 12),
            DrawerTile(
              icon: Icons.person,
              title: context.loc.account,
              onTap: () async {
                if (blockIfOffline(context)) return;
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
              title: context.loc.favorites,
              onTap: () {
                if (blockIfOffline(context)) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        FavoritesScreen(allRecipes: widget.allRecipes),
                  ),
                );
              },
              tileColor: tileColor,
            ),
            DrawerTile(
              icon: Icons.shopping_cart,
              title: context.loc.shoppingList,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ShoppingListScreen()),
                );
              },
              tileColor: tileColor,
            ),
            DrawerTile(
              icon: Icons.comment,
              title: context.loc.comments,
              onTap: () {
                if (blockIfOffline(context)) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CommentScreen()),
                );
              },
              tileColor: tileColor,
            ),
            if (userData?['isAdmin'] == true)
              DrawerTile(
                icon: Icons.admin_panel_settings,
                title: context.loc.adminDashboard,
                onTap: () {
                  if (blockIfOffline(context)) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AdminDashboardScreen()),
                  );
                },
                tileColor: tileColor,
              ),
          ],
          const SizedBox(height: 24),
          Text(context.loc.customization, style: sectionStyle),
          const SizedBox(height: 12),
          DrawerTileWithSwitch(
            icon: Icons.dark_mode,
            title: context.loc.darkMode,
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) {
              final themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
            },
            tileColor: tileColor,
          ),
          DrawerTile(
            icon: Icons.language,
            title: context.loc.language,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => const LanguageDialog(),
              );
            },
            tileColor: tileColor,
          ),
          const SizedBox(height: 24),
          Text(context.loc.settings, style: sectionStyle),
          const SizedBox(height: 12),
          if (isLoggedIn)
            DrawerTile(
              icon: Icons.logout,
              title: context.loc.logout,
              onTap: () async {
                if (blockIfOffline(context)) return;
                await AuthService().signOutUser(context);
              },
              tileColor: tileColor,
            )
          else
            DrawerTile(
              icon: Icons.login,
              title: context.loc.loginRegister,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              tileColor: tileColor,
            ),
        ],
      ),
    );
  }
}
