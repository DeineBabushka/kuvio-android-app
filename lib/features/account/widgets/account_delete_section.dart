import 'package:flutter/material.dart';
import 'package:kuvio/localization/context_extension.dart';
import 'package:kuvio/shared/services/user_service.dart';
import 'package:kuvio/features/account/widgets/confirm_button.dart';
import 'package:kuvio/features/account/widgets/account_delete_hint.dart';
import 'package:kuvio/features/recipes/screens/recipe_filter_screen.dart';
import 'package:kuvio/shared/utils/snackbar_helper.dart';

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
                SnackbarHelper.showMessage(
                  context,
                  context.loc.accountDeletedSuccess,
                );

                Future.delayed(const Duration(milliseconds: 500)).then((_) {
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const RecipesScreen(),
                      ),
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
