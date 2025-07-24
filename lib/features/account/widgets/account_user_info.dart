import 'package:flutter/material.dart';
import 'package:kuvio/localization/context_extension.dart';
import 'package:kuvio/shared/models/app_user.dart';
import 'package:kuvio/features/account/widgets/info_card_tile.dart';
import 'package:kuvio/features/account/widgets/account_edit_button.dart';
import 'package:kuvio/features/account/widgets/section_title.dart';
import 'package:kuvio/shared/utils/constants.dart';

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
        SectionTitle(text: context.loc.accountSectionTitle),
        const SizedBox(height: 12),
        InfoCardTile(
          label: context.loc.accountBio,
          value: getLocalizedText(context, appUser.bio),
          textColor: textColor,
          tileColor: cardColor,
        ),
        InfoCardTile(
          label: context.loc.accountFavoriteKitchen,
          value: getLocalizedKitchen(context, appUser.favoriteKitchen),
          textColor: textColor,
          tileColor: cardColor,
        ),
        InfoCardTile(
          label: context.loc.accountFavoriteDish,
          value: getLocalizedText(context, appUser.favoriteDish),
          textColor: textColor,
          tileColor: cardColor,
        ),
        const SizedBox(height: 10),
        EditProfileButton(onTap: onEditProfile),
      ],
    );
  }

  String getLocalizedKitchen(BuildContext context, String? raw) {
    if (raw == null || raw.trim().isEmpty || raw == 'not_set') {
      return context.loc.notSpecified;
    }

    final key = kitchenInternalToKey[raw];
    if (key == null) return raw;

    return context.loc.getString(key);
  }

  String getLocalizedText(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty || value == 'not_set') {
      return context.loc.notSpecified;
    }

    return value;
  }
}
