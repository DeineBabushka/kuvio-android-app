import 'package:flutter/material.dart';
import 'package:kuvio/l10n/context_extension.dart';
import 'package:kuvio/shared/services/user_service.dart';
import 'package:kuvio/features/account/widgets/confirm_button.dart';
import 'package:kuvio/features/account/widgets/account_delete_hint.dart';
import 'package:kuvio/shared/utils/block_if_offline.dart';

class AccountDeleteSection extends StatelessWidget {
  final UserService userService;
  final BuildContext contextRef;

  const AccountDeleteSection({
    super.key,
    required this.userService,
    required this.contextRef,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConfirmButton(
          text: context.loc.deleteAccount,
          onPressed: () async {
            if (blockIfOffline(contextRef)) return;
            final success =
                await userService.deleteAccountWithConfirmation(contextRef);
            if (success && contextRef.mounted) {
              Navigator.of(contextRef).pushNamedAndRemoveUntil(
                '/login',
                (_) => false,
              );
            }
          },
          bgColor: Colors.red,
          textColor: Colors.white,
        ),
        const SizedBox(height: 10),
        const AccountDeleteHint(),
      ],
    );
  }
}
