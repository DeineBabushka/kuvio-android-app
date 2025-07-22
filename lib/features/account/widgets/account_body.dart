import 'package:flutter/material.dart';
import 'package:kuvio/shared/models/app_user.dart';
import 'package:kuvio/shared/widgets/app_profile_header.dart';
import 'package:kuvio/features/account/widgets/account_user_info.dart';
import 'package:kuvio/features/account/widgets/account_delete_section.dart';
import 'package:kuvio/shared/services/user_service.dart';

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
            ),
          ),
        ],
      ),
    );
  }
}
