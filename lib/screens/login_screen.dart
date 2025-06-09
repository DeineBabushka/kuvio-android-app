import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF122620),
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
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Anmelden',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF122620),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                labelText: 'Email-Adresse',
                                labelStyle: TextStyle(color: Color(0xFF122620)),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _passwordController,
                              style: const TextStyle(color: Colors.black),
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Passwort',
                                labelStyle:
                                    const TextStyle(color: Color(0xFF122620)),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: const Color(0xFF122620),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  );

                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Color(0xFF2E6B4D),
                                      content: Text(
                                        'Erfolgreich eingeloggt',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );

                                  Navigator.pop(
                                      context); // oder zur Startseite, wenn gewünscht
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Fehler: $e')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF122620),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Einloggen'),
                            ),
                            const SizedBox(height: 16),

                            // ✅ Der ursprüngliche Text-Link, aber „Registrieren“ ist fett
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen(),
                                  ),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: 'Noch kein Konto? ',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Registrieren',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
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
