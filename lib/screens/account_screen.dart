import 'package:flutter/material.dart';
import 'package:kuvio/services/user_service.dart';
import 'package:kuvio/services/dialog_service.dart'; // <-- NEU
import 'edit_profile_screen.dart';
import '../widgets/profile_header.dart';
import '../widgets/info_card_tile.dart';
import '../widgets/confirm_button.dart';
import '../models/app_user.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final UserService _userService = UserService();
  AppUser? appUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final doc = await _userService.loadUserData();
    if (!mounted) return;

    setState(() {
      appUser = doc != null && doc.exists ? AppUser.fromSnapshot(doc) : null;
      isLoading = false;
    });
  }

  Future<void> _navigateToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
    if (mounted) _loadUserData();
  }

  Future<void> _deleteAccount() async {
    final password = await DialogService.askForPassword(context);
    if (password == null) return;

    try {
      await _userService.deleteUserAndData(password);
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Löschen: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final sectionStyle = const TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    const cardColor = Color(0xFF2E6B4D);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Profil', style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: textColor))
          : appUser == null
              ? Center(
                  child: Text('Keine Daten gefunden',
                      style: TextStyle(color: textColor)))
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ProfileHeader(
                          username: appUser!.username,
                          profileImage: appUser!.profileImage,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text("DEIN KONTO", style: sectionStyle),
                      const SizedBox(height: 12),
                      InfoCardTile(
                        label: "Über mich",
                        value: appUser!.bio,
                        textColor: textColor,
                        tileColor: cardColor,
                      ),
                      InfoCardTile(
                        label: "Lieblingsküche",
                        value: appUser!.favoriteKitchen,
                        textColor: textColor,
                        tileColor: cardColor,
                      ),
                      InfoCardTile(
                        label: "Lieblingsgericht",
                        value: appUser!.favoriteDish,
                        textColor: textColor,
                        tileColor: cardColor,
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton.icon(
                          onPressed: _navigateToEditProfile,
                          icon: const Icon(Icons.edit, color: Colors.white70),
                          label: const Text(
                            "Profil bearbeiten",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      Center(
                        child: ConfirmButton(
                          text: "Konto löschen",
                          onPressed: () async {
                            final confirm =
                                await DialogService.confirmAccountDeletion(
                                    context);
                            if (confirm) _deleteAccount();
                          },
                          bgColor: Colors.red,
                          textColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          "Wenn du dein Konto löscht, werden all deine\nBenutzerdaten und dein Zugang unwiderruflich gelöscht.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white60, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
