import 'package:flutter/material.dart';
import 'package:kuvio/features/account/models/app_user.dart';
import 'package:kuvio/shared/widgets/info_card_tile.dart';
import 'package:kuvio/features/account/widgets/edit_profile_button.dart';
import 'package:kuvio/features/account/widgets/section_title.dart';

class AccountUserInfo extends StatelessWidget {
  final AppUser appUser;
  final VoidCallback onEditProfile;

  const AccountUserInfo({
    super.key,
    required this.appUser,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    const cardColor = Color(0xFF2E6B4D);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(text: "DEIN KONTO"),
        const SizedBox(height: 12),
        InfoCardTile(
          label: "Über mich",
          value: appUser.bio,
          textColor: textColor,
          tileColor: cardColor,
        ),
        InfoCardTile(
          label: "Lieblingsküche",
          value: appUser.favoriteKitchen,
          textColor: textColor,
          tileColor: cardColor,
        ),
        InfoCardTile(
          label: "Lieblingsgericht",
          value: appUser.favoriteDish,
          textColor: textColor,
          tileColor: cardColor,
        ),
        const SizedBox(height: 10),
        EditProfileButton(onTap: onEditProfile),
      ],
    );
  }
}
