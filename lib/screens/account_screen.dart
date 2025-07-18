import 'package:flutter/material.dart';
import 'package:kuvio/services/user_service.dart';
import 'edit_profile_screen.dart';
import '../widgets/profile_header.dart';
import '../widgets/info_card_tile.dart';
import '../widgets/confirm_button.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final UserService _userService = UserService();
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await _userService.loadUserData();
    if (!mounted) return;
    setState(() {
      userData = data;
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

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konto wirklich löschen?',
              style: TextStyle(color: Colors.black)),
          content: const Text(
              'Dieser Vorgang kann nicht rückgängig gemacht werden.',
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Löschen', style: TextStyle(color: Colors.red)),
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

  Future<void> _deleteAccount() async {
    final password = await _askForPassword();
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
              const Text('Passwort bestätigen',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                obscureText: true,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
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
                    child: const Text('Abbrechen'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    child: const Text('Bestätigen'),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final sectionStyle = const TextStyle(
      color: Colors.white70,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    final cardColor = const Color(0xFF2E6B4D);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Profil', style: TextStyle(color: textColor)),
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
              : SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ProfileHeader(
                          username: userData!['username'] ?? 'Unbekannt',
                          profileImage: userData!['profileImage'],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text("DEIN KONTO", style: sectionStyle),
                      const SizedBox(height: 12),
                      InfoCardTile(
                        label: "Über mich",
                        value: userData!['bio'],
                        textColor: textColor,
                        tileColor: cardColor,
                      ),
                      InfoCardTile(
                        label: "Lieblingsküche",
                        value: userData!['kitchen'],
                        textColor: textColor,
                        tileColor: cardColor,
                      ),
                      InfoCardTile(
                        label: "Lieblingsgericht",
                        value: userData!['favdish'],
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
                          onPressed: _showDeleteConfirmationDialog,
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
