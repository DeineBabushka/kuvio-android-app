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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundColor = theme.scaffoldBackgroundColor;
    final containerColor = isDarkMode ? theme.cardColor : Colors.white;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final labelColor = isDarkMode ? Colors.white70 : const Color(0xFF122620);
    final inputTextColor = isDarkMode ? Colors.white : Colors.black;
    final buttonBackground =
        isDarkMode ? theme.cardColor : const Color(0xFF122620);
    final buttonTextColor =
        isDarkMode ? theme.colorScheme.primary : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Profil bearbeiten', style: TextStyle(color: textColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: containerColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
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
                            decoration: BoxDecoration(
                              color: containerColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: labelColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Profilinformationen',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: labelColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  readOnly: true,
                  style: TextStyle(color: inputTextColor),
                  decoration: InputDecoration(
                    labelText: 'Benutzername',
                    labelStyle: TextStyle(color: labelColor),
                    border: const OutlineInputBorder(),
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  style: TextStyle(color: inputTextColor),
                  decoration: InputDecoration(
                    labelText: 'Über mich',
                    labelStyle: TextStyle(color: labelColor),
                  ),
                  minLines: 1,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  dropdownColor: containerColor,
                  value: _selectedKitchen,
                  style: TextStyle(color: inputTextColor),
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
                  decoration: InputDecoration(
                    labelText: 'Lieblingsküche',
                    labelStyle: TextStyle(color: labelColor),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dishController,
                  style: TextStyle(color: inputTextColor),
                  decoration: InputDecoration(
                    labelText: 'Lieblingsgericht',
                    labelStyle: TextStyle(color: labelColor),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBackground,
                    foregroundColor: buttonTextColor,
                  ),
                  child: Text('Speichern',
                      style: TextStyle(color: buttonTextColor)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Passwort ändern'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
