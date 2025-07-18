import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../services/profile_service.dart';
import '../models/app_user.dart';
import 'change_password_screen.dart';
import 'filter_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _bioController = TextEditingController();
  final _dishController = TextEditingController();
  final _userService = UserService();
  final _profileService = ProfileService();

  String _selectedKitchen = 'Nicht angegeben';
  String? _selectedProfileAsset;

  final List<String> _kitchenOptions = [
    'Nicht angegeben',
    'Italienisch',
    'Chinesisch',
    'Indisch',
    'Mexikanisch',
    'Japanisch',
    'Deutsch',
    'Türkisch',
    'Vegan',
    'Vegetarisch',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await _userService.loadUserData();
    if (data != null) {
      final user = AppUser.fromMap(data['id'] ?? 'unknown', data);

      setState(() {
        _usernameController.text = user.username;
        _bioController.text = user.bio ?? '';
        _dishController.text = user.favoriteDish ?? '';
        _selectedKitchen = user.favoriteKitchen ?? 'Nicht angegeben';
        _selectedProfileAsset = user.profileImage;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    await _userService.updateProfile(
      bio: _bioController.text,
      kitchen: _selectedKitchen,
      favdish: _dishController.text,
      profileImage: _selectedProfileAsset,
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const RecipesScreen()),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Color(0xFF2E6B4D),
        content: Text(
          'Profil aktualisiert',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future<void> _selectProfileImage() async {
    final selected = await _profileService.openImagePickerDialog(
      context,
      _selectedProfileAsset,
    );
    if (selected != null) {
      setState(() => _selectedProfileAsset = selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF0D2B20);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Profil bearbeiten'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        _selectedProfileAsset ?? 'assets/character_1.png',
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _selectProfileImage,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              buildEditableCard(
                label: 'Benutzername',
                controller: _usernameController,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              buildEditableCard(
                label: 'Über mich',
                controller: _bioController,
              ),
              const SizedBox(height: 16),
              buildDropdownCard(),
              const SizedBox(height: 16),
              buildEditableCard(
                label: 'Lieblingsgericht',
                controller: _dishController,
              ),
              const SizedBox(height: 24),
              buildButton(
                icon: Icons.save,
                text: 'Speichern',
                background: Colors.white,
                foreground: backgroundColor,
                onPressed: _saveProfile,
              ),
              const SizedBox(height: 16),
              buildButton(
                icon: Icons.lock,
                text: 'Passwort ändern',
                background: Colors.redAccent,
                foreground: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChangePasswordScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditableCard({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2E6B4D),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildDropdownCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2E6B4D),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonFormField<String>(
        value: _selectedKitchen,
        dropdownColor: const Color(0xFF2E6B4D),
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: Colors.white,
        decoration: const InputDecoration(
          labelText: 'Lieblingsküche',
          labelStyle: TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
        items: _kitchenOptions
            .map((kitchen) => DropdownMenuItem<String>(
                  value: kitchen,
                  child: Text(kitchen),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedKitchen = value ?? 'Nicht angegeben';
          });
        },
      ),
    );
  }

  Widget buildButton({
    required IconData icon,
    required String text,
    required Color background,
    required Color foreground,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
