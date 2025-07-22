import 'package:flutter/material.dart';
import 'package:kuvio/l10n/context_extension.dart';
import 'package:kuvio/shared/models/app_user.dart';
import 'package:kuvio/shared/services/user_service.dart';
import 'package:kuvio/features/account/utils/account_user_loader.dart';
import 'package:kuvio/features/account/widgets/account_app_bar.dart';
import 'package:kuvio/features/account/widgets/account_user_info.dart';
import 'package:kuvio/features/account/widgets/account_delete_section.dart';
import 'package:kuvio/features/account/screens/edit_profile_screen.dart';
import 'package:kuvio/shared/widgets/app_profile_header.dart';
import 'package:kuvio/shared/utils/block_if_offline.dart';

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
    if (blockIfOffline(context)) return;

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
          ? _buildLoadingIndicator(context, textColor)
          : appUser == null
              ? _buildNoUserData(context, textColor)
              : AccountBody(
                  appUser: appUser!,
                  onEdit: _navigateToEditProfile,
                  userService: _userService,
                ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context, Color textColor) {
    return Center(
      child: Text(
        context.loc.loading,
        style: TextStyle(color: textColor),
      ),
    );
  }

  Widget _buildNoUserData(BuildContext context, Color textColor) {
    return Center(
      child: Text(
        context.loc.noUserDataFound,
        style: TextStyle(color: textColor),
      ),
    );
  }
}

class AccountBody extends StatelessWidget {
  final AppUser appUser;
  final VoidCallback onEdit;
  final UserService userService;

  const AccountBody({
    super.key,
    required this.appUser,
    required this.onEdit,
    required this.userService,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ProfileHeader(
              username: appUser.username,
              profileImage: appUser.profileImage,
            ),
          ),
          const SizedBox(height: 32),
          AccountUserInfo(
            appUser: appUser,
            onEditProfile: onEdit,
          ),
          const SizedBox(height: 60),
          Center(
            child: AccountDeleteSection(
              userService: userService,
              contextRef: context,
            ),
          ),
        ],
      ),
    );
  }
}
