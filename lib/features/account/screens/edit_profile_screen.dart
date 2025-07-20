import 'package:flutter/material.dart';
import 'package:kuvio/features/account/services/edit_profile_controller.dart';
import 'package:kuvio/shared/utils/navigation_utils.dart';
import 'package:kuvio/features/recipes/utils/snackbar_utils.dart';
import 'package:kuvio/features/recipes/widgets/profile_avatar.dart';
import 'package:kuvio/features/account/widgets/edit_profile_form.dart';
import 'package:kuvio/features/account/widgets/transparent_app_bar.dart';
import 'package:kuvio/features/account/widgets/screen_wrapper.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final controller = EditProfileController();

  @override
  void initState() {
    super.initState();
    controller.loadUserData(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const TransparentAppBar(title: 'Profil bearbeiten'),
      body: ScreenWrapper(
        child: Column(
          children: [
            ProfileAvatar(
              assetPath: controller.selectedProfileAsset,
              onEdit: () =>
                  controller.pickImage(context, () => setState(() {})),
            ),
            const SizedBox(height: 24),
            EditProfileForm(
              formKey: controller.formKey,
              usernameController: controller.usernameController,
              bioController: controller.bioController,
              dishController: controller.dishController,
              selectedKitchen: controller.selectedKitchen,
              onKitchenChanged: (value) {
                setState(() {
                  controller.selectedKitchen = value ?? 'Nicht angegeben';
                });
              },
              onSave: () {
                controller.saveProfile(
                  context: context,
                  onSuccess: () => navigateToHomeAndClearStack(context),
                  showMessage: (msg) => showSuccessMessage(context, msg),
                );
              },
              onChangePassword: () => navigateToChangePassword(context),
            ),
          ],
        ),
      ),
    );
  }
}
