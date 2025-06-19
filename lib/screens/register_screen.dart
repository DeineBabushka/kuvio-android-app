import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/edit_profile_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? Colors.grey[900] : Colors.white;
    final labelColor = isDark ? Colors.white70 : const Color(0xFF122620);
    final fieldTextColor = isDark ? Colors.white : Colors.black;
    final buttonBackground = isDark ? theme.colorScheme.primary : const Color(0xFF122620);
    final buttonTextColor = isDark ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Konto erstellen',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _usernameController,
                                style: TextStyle(color: fieldTextColor),
                                decoration: InputDecoration(
                                  labelText: 'Benutzername',
                                  labelStyle: TextStyle(color: labelColor),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Benutzername eingeben';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                style: TextStyle(color: fieldTextColor),
                                decoration: InputDecoration(
                                  labelText: 'E-Mail',
                                  labelStyle: TextStyle(color: labelColor),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'E-Mail eingeben';
                                  }
                                  final emailRegex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Ungültige E-Mail-Adresse';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                style: TextStyle(color: fieldTextColor),
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Passwort',
                                  labelStyle: TextStyle(color: labelColor),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: labelColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Passwort eingeben';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      final userCredential = await FirebaseAuth
                                          .instance
                                          .createUserWithEmailAndPassword(
                                        email: _emailController.text.trim(),
                                        password:
                                            _passwordController.text.trim(),
                                      );

                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userCredential.user!.uid)
                                          .set({
                                        'username':
                                            _usernameController.text.trim(),
                                        'email': _emailController.text.trim(),
                                        'createdAt': Timestamp.now(),
                                        'bio': '',
                                        'kitchen': 'Nicht angegeben',
                                        'favdish': '',
                                        'isAdmin': false,
                                        'favorites': [],
                                      });

                                      if (!mounted) return;

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const EditProfileScreen()),
                                      );
                                    } catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('Fehler: $e')),
                                      );
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonBackground,
                                  foregroundColor: buttonTextColor,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text('Registrieren',
                                    style:
                                        TextStyle(color: buttonTextColor)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
