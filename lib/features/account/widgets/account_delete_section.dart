import 'package:flutter/material.dart';
import 'package:kuvio/features/account/services/user_service.dart';
import 'package:kuvio/shared/widgets/confirm_button.dart';
import 'package:kuvio/features/account/widgets/account_delete_hint.dart';

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
          text: "Konto löschen",
          onPressed: () async {
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
