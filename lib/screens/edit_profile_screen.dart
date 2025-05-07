import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _ageController = TextEditingController();
  final _bioController = TextEditingController();
  final _experienceController = TextEditingController();
  final _dishController = TextEditingController();

  File? _profileImage;
  String _selectedKitchen = 'Nicht angegeben';

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

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
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
          _ageController.text = data['age']?.toString() ?? '';
          _bioController.text = data['bio'] ?? '';
          _experienceController.text = data['experience']?.toString() ?? '';
          _dishController.text = data['favdish'] ?? '';
          _selectedKitchen = data['kitchen'] ?? 'Nicht angegeben';
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
        'username': _usernameController.text.trim(),
        'age': int.tryParse(_ageController.text.trim()) ?? 0,
        'bio': _bioController.text.trim(),
        'kitchen': _selectedKitchen,
        'experience': int.tryParse(_experienceController.text.trim()) ?? 0,
        'favdish': _dishController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil aktualisiert'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(top: 16, right: 16, left: 16),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF122620),
      appBar: AppBar(
        title: const Text('Profil bearbeiten'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/profile_placeholder.png')
                              as ImageProvider,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Profilinformationen',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF122620)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Benutzername',
                    labelStyle: TextStyle(color: Color(0xFF122620)),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Pflichtfeld' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _bioController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Über mich',
                    labelStyle: TextStyle(color: Color(0xFF122620)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Alter',
                    labelStyle: TextStyle(color: Color(0xFF122620)),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedKitchen,
                  style: const TextStyle(color: Colors.black),
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
                  decoration: const InputDecoration(
                    labelText: 'Lieblingsküche',
                    labelStyle: TextStyle(color: Color(0xFF122620)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _experienceController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Kocherfahrung (Jahre)',
                    labelStyle: TextStyle(color: Color(0xFF122620)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dishController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: 'Lieblingsgericht',
                    labelStyle: TextStyle(color: Color(0xFF122620)),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF122620),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Speichern'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
