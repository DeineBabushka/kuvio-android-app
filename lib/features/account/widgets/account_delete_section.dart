import 'package:flutter/material.dart';
import 'package:kuvio/l10n/context_extension.dart';
import 'package:kuvio/shared/services/user_service.dart';
import 'package:kuvio/features/account/widgets/confirm_button.dart';
import 'package:kuvio/features/account/widgets/account_delete_hint.dart';
import 'package:kuvio/features/recipes/screens/filter_screen.dart';

class AccountDeleteSection extends StatelessWidget {
  final UserService userService;

  const AccountDeleteSection({
    super.key,
    required this.userService,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConfirmButton(
          text: context.loc.deleteAccount,
          onPressed: () async {
            if (!context.mounted) return;

            await userService.deleteAccountWithConfirmation(
              context: context,
              onSuccess: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.loc.accountDeletedSuccess),
                    backgroundColor: const Color(0xFF122620),
                  ),
                );

                Future.delayed(const Duration(milliseconds: 500)).then((_) {
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const RecipesScreen()),
                      (_) => false,
                    );
                  }
                });
              },
            );
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
