import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'change_password_screen.dart';

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
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          _usernameController.text = data['username'] ?? '';
          _bioController.text = data['bio'] ?? '';
          _dishController.text = data['favdish'] ?? '';
          _selectedKitchen = data['kitchen'] ?? 'Nicht angegeben';
          _selectedProfileAsset = data['profileImage'];
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'bio': _bioController.text.trim(),
        'kitchen': _selectedKitchen,
        'favdish': _dishController.text.trim(),
        'profileImage': _selectedProfileAsset,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF2E6B4D),
          content: Text(
            'Profil aktualisiert',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      Navigator.pop(context);
    }
  }

  void _openImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Profilbild auswählen'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final assetName = 'assets/character_${index + 1}.png';
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedProfileAsset = assetName;
                    });
                    Navigator.pop(context);
                  },
                  child: Image.asset(assetName),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = const Color(0xFF0D2B20);
    final iconColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Profil bearbeiten'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: iconColor),
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
                        onTap: _openImagePickerDialog,
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveProfile,
                  icon: const Icon(Icons.save),
                  label: const Text('Speichern'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.lock),
                  label: const Text('Passwort ändern'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
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
}
