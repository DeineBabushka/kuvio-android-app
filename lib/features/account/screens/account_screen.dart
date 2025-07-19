import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../services/user_service.dart';
import '../utils/user_loader.dart';
import '../widgets/account_app_bar.dart';
import '../widgets/account_body.dart';
import '../../../shared/widgets/empty_or_loading.dart';
import 'edit_profile_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final UserService _userService = UserService();
  late final UserLoader _userLoader = UserLoader(_userService);
  AppUser? appUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _userLoader.loadUser();
    if (!mounted) return;

    setState(() {
      appUser = user;
      isLoading = false;
    });
  }

  Future<void> _navigateToEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
    if (mounted) _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AccountAppBar(),
      body: isLoading
          ? buildLoadingIndicator(textColor)
          : appUser == null
              ? buildNoUserData(textColor)
              : AccountBody(
                  appUser: appUser!,
                  onEdit: _navigateToEditProfile,
                  userService: _userService,
                ),
    );
  }
}
