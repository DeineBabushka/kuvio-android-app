import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/user_service.dart';
import '../widgets/login_form_card.dart'; // Neues Widget importieren

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final UserService _userService = UserService();

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return;

      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final doc = await userRef.get();

      if (!doc.exists) {
        await userRef.set({
          'username': user.displayName ?? 'Google Nutzer',
          'email': user.email,
          'createdAt': Timestamp.now(),
          'bio': '',
          'kitchen': 'Nicht angegeben',
          'favdish': '',
          'isAdmin': false,
          'favorites': [],
        });
        debugPrint('Neuer Google-Nutzer in Firestore angelegt.');
      }

      final userData = (await userRef.get()).data();
      final isAdmin = userData?['isAdmin'] ?? false;

      debugPrint('Angemeldeter Google-Nutzer ist Admin: $isAdmin');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color(0xFF2E6B4D),
          content: Text(
            'Erfolgreich mit Google eingeloggt',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google-Login fehlgeschlagen: $e')),
      );
    }
  }

  Future<void> _handleLogin() async {
    try {
      final credential = await _userService.loginWithEmail(
        _emailController.text,
        _passwordController.text,
      );

      final user = credential.user;
      if (user == null) return;

      final isAdmin = await _userService.isAdmin(user.uid);
      debugPrint('Angemeldeter Benutzer ist Admin: $isAdmin');

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
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final message = _userService.getErrorMessage(e.code);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unbekannter Fehler')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = theme.scaffoldBackgroundColor;
    final cardColor = isDark ? Colors.grey[900]! : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final labelColor = isDark ? Colors.white70 : const Color(0xFF122620);
    final headingColor = isDark ? Colors.white : const Color(0xFF122620);
    final iconColor = isDark ? Colors.white60 : const Color(0xFF122620);
    final buttonBackground =
        isDark ? theme.colorScheme.primary : const Color(0xFF122620);
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
                      LoginFormCard(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        obscurePassword: _obscurePassword,
                        onTogglePasswordVisibility: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        onLogin: _handleLogin,
                        onGoogleLogin: _signInWithGoogle,
                        onNavigateToRegister: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterScreen()),
                          );
                        },
                        cardColor: cardColor,
                        textColor: textColor,
                        labelColor: labelColor,
                        headingColor: headingColor,
                        iconColor: iconColor,
                        buttonBackground: buttonBackground,
                        buttonTextColor: buttonTextColor,
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
