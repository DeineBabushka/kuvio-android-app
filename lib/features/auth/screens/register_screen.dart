import 'package:flutter/material.dart';
import 'package:kuvio/features/auth/services/auth_service.dart';
import 'package:kuvio/features/auth/widgets/register_form_card.dart';
import 'package:kuvio/features/auth/models/register_user_data.dart';
import 'package:kuvio/features/account/screens/edit_profile_screen.dart';
import 'package:kuvio/l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  void _toggleObscurePassword() =>
      setState(() => _obscurePassword = !_obscurePassword);

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final userData = RegisterUserData(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    try {
      final userCredential = await _authService.registerUser(
        email: userData.email,
        password: userData.password,
      );

      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;

      await _authService.saveInitialUserData(
        uid: userCredential.user!.uid,
        username: userData.username,
        email: userData.email,
        kitchenPlaceholder: loc.notSpecified,
      );

      if (!mounted) return;

      // Snackbar anzeigen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.registrationSuccess),
          duration: const Duration(seconds: 2),
        ),
      );

      // Snackbar zeigen lassen, dann weiter
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${loc.registrationFailed}: $e')),
      );
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
        iconTheme: IconThemeData(color: theme.iconTheme.color),
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
