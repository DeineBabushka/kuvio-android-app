import 'package:flutter/material.dart';
import 'package:kuvio/shared/utils/constants.dart';
import 'package:kuvio/features/account/widgets/editable_card.dart';
import 'package:kuvio/features/account/widgets/kitchen_dropdown_card.dart';
import 'package:kuvio/features/account/widgets/form_button.dart';
import 'package:kuvio/l10n/context_extension.dart';

class EditProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController bioController;
  final TextEditingController dishController;
  final String selectedKitchen;
  final VoidCallback onSave;
  final VoidCallback onChangePassword;
  final void Function(String?) onKitchenChanged;

  const EditProfileForm({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.bioController,
    required this.dishController,
    required this.selectedKitchen,
    required this.onSave,
    required this.onChangePassword,
    required this.onKitchenChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          EditableCard(
            label: context.loc.account,
            controller: usernameController,
            readOnly: true,
          ),
          const SizedBox(height: 16),
          EditableCard(
            label: context.loc.accountBio,
            controller: bioController,
          ),
          const SizedBox(height: 16),
          KitchenDropdownCard(
            selectedKitchen: selectedKitchen,
            onChanged: onKitchenChanged,
          ),
          const SizedBox(height: 16),
          EditableCard(
            label: context.loc.accountFavoriteDish,
            controller: dishController,
          ),
          const SizedBox(height: 24),
          FormButton(
            icon: Icons.save,
            text: context.loc.confirm,
            background: Colors.white,
            foreground: AppColors.backgroundColor,
            onPressed: onSave,
          ),
          const SizedBox(height: 16),
          FormButton(
            icon: Icons.lock,
            text: context.loc.changePassword,
            background: Colors.redAccent,
            foreground: Colors.white,
            onPressed: onChangePassword,
          ),
        ],
      ),
    );
  }
}
