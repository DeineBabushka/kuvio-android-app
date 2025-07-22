import 'package:flutter/material.dart';
import 'package:kuvio/features/account/services/edit_profile_controller.dart';
import 'package:kuvio/shared/utils/navigation_utils.dart';
import 'package:kuvio/features/recipes/utils/snackbar_utils.dart';
import 'package:kuvio/features/recipes/widgets/profile_avatar.dart';
import 'package:kuvio/features/account/widgets/account_edit_form.dart';
import 'package:kuvio/features/account/widgets/transparent_app_bar.dart';
import 'package:kuvio/features/account/widgets/screen_wrapper.dart';
import 'package:kuvio/l10n/context_extension.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final controller = EditProfileController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      controller.loadUserData(
        context: context,
        onUpdate: () => setState(() {}),
        defaultKitchen: 'not_set',
      );
    }
  }

  void refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: TransparentAppBar(title: context.loc.editProfile),
      body: ScreenWrapper(
        child: Column(
          children: [
            ProfileAvatar(
              assetPath: controller.selectedProfileAsset,
              onEdit: () => controller.pickImage(context, mounted, refresh),
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
                  controller.selectedKitchen = value ?? 'not_set';
                });
              },
              onSave: () {
                controller.saveProfile(
                  context: context,
                  isMounted: mounted,
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
