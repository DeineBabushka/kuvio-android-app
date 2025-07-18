import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/edit_profile_screen.dart';
import '../widgets/register_form_card.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();

  void _toggleObscurePassword() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userCredential = await _authService.registerUser(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (!context.mounted) return;

        await _authService.saveInitialUserData(
          uid: userCredential.user!.uid,
          username: _usernameController.text,
          email: _emailController.text,
        );

        if (!context.mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const EditProfileScreen(),
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                      RegisterFormCard(
                        formKey: _formKey,
                        usernameController: _usernameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        obscurePassword: _obscurePassword,
                        toggleObscurePassword: _toggleObscurePassword,
                        onSubmit: _register,
                        cardColor: isDark ? Colors.grey[900]! : Colors.white,
                        textColor: isDark ? Colors.white : Colors.black,
                        labelColor:
                            isDark ? Colors.white70 : const Color(0xFF122620),
                        fieldTextColor: isDark ? Colors.white : Colors.black,
                        buttonBackground: isDark
                            ? theme.colorScheme.primary
                            : const Color(0xFF122620),
                        buttonTextColor: isDark ? Colors.black : Colors.white,
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
