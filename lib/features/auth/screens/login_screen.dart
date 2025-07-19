import 'package:flutter/material.dart';
import '../../account/services/user_service.dart';
import '../services/google_auth_service.dart';
import '../widgets/login_form_card.dart';
import '../utils/login_colors.dart';
import '../utils/login_actions.dart';
import '../utils/login_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final _userService = UserService();
  final _googleAuthService = GoogleAuthService();

  late final LoginActions _loginActions;

  @override
  void initState() {
    super.initState();
    _loginActions = LoginActions(_userService, _googleAuthService);
  }

  @override
  Widget build(BuildContext context) {
    final colors = LoginColors(context);

    return Scaffold(
      backgroundColor: colors.backgroundColor,
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
                        onLogin: () => _loginActions.handleLogin(
                          context: context,
                          emailController: _emailController,
                          passwordController: _passwordController,
                        ),
                        onGoogleLogin: () =>
                            _loginActions.signInWithGoogle(context),
                        onNavigateToRegister: () => navigateToRegister(context),
                        cardColor: colors.cardColor,
                        textColor: colors.textColor,
                        labelColor: colors.labelColor,
                        headingColor: colors.headingColor,
                        iconColor: colors.iconColor,
                        buttonBackground: colors.buttonBackground,
                        buttonTextColor: colors.buttonTextColor,
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
