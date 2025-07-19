import 'package:flutter/material.dart';
import '../../../shared/utils/constants.dart';
import '../../../shared/widgets/editable_card.dart';
import 'kitchen_dropdown_card.dart';
import '../../../shared/widgets/form_button.dart';

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
            label: 'Benutzername',
            controller: usernameController,
            readOnly: true,
          ),
          const SizedBox(height: 16),
          EditableCard(
            label: 'Über mich',
            controller: bioController,
          ),
          const SizedBox(height: 16),
          KitchenDropdownCard(
            selectedKitchen: selectedKitchen,
            onChanged: onKitchenChanged,
          ),
          const SizedBox(height: 16),
          EditableCard(
            label: 'Lieblingsgericht',
            controller: dishController,
          ),
          const SizedBox(height: 24),
          FormButton(
            icon: Icons.save,
            text: 'Speichern',
            background: Colors.white,
            foreground: AppColors.backgroundColor,
            onPressed: onSave,
          ),
          const SizedBox(height: 16),
          FormButton(
            icon: Icons.lock,
            text: 'Passwort ändern',
            background: Colors.redAccent,
            foreground: Colors.white,
            onPressed: onChangePassword,
          ),
        ],
      ),
    );
  }
}
