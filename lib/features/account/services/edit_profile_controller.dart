import 'package:flutter/material.dart';
import 'package:kuvio/shared/services/user_service.dart';
import 'package:kuvio/shared/models/app_user.dart';
import 'package:kuvio/localization/context_extension.dart';
import 'package:kuvio/shared/utils/constants.dart';

class EditProfileController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final bioController = TextEditingController();
  final dishController = TextEditingController();

  final userService = UserService();

  String selectedKitchen = 'not_set';
  String? selectedProfileAsset;

  String mapLocalizedKitchenToInternal(
    BuildContext context,
    String? localized,
  ) {
    if (localized == null || localized.trim().isEmpty) return 'not_set';

    final entry = kitchenInternalToKey.entries.firstWhere(
      (e) => context.loc.getString(e.value) == localized,
      orElse: () => const MapEntry('not_set', 'notSpecified'),
    );

    return entry.key;
  }

  Future<void> loadUserData({
    required BuildContext context,
    required VoidCallback onUpdate,
    required String defaultKitchen,
  }) async {
    final doc = await userService.loadUserData();

    if (doc != null && doc.exists) {
      final user = AppUser.fromSnapshot(doc);

      usernameController.text = user.username;
      bioController.text = user.bio ?? '';
      dishController.text = user.favoriteDish ?? '';
      selectedProfileAsset = user.profileImage;

      final localized = user.favoriteKitchen?.trim().toLowerCase();

      if (localized == null ||
          localized.isEmpty ||
          localized == 'nicht angegeben' ||
          localized == 'not specified') {
        selectedKitchen = 'not_set';
      } else {
        selectedKitchen = kitchenInternalToKey.entries
            .firstWhere(
              (e) => context.loc.getString(e.value).toLowerCase() == localized,
              orElse: () => const MapEntry('not_set', 'notSpecified'),
            )
            .key;
      }

      onUpdate();
    }
  }

  Future<void> saveProfile({
    required BuildContext context,
    required bool isMounted,
    required VoidCallback onSuccess,
    required void Function(String message) showMessage,
  }) async {
    if (!formKey.currentState!.validate()) return;

    final successMessage = context.loc.profileUpdated;

    await userService.updateProfile(
      bio: bioController.text,
      kitchen: selectedKitchen,
      favdish: dishController.text,
      profileImage: selectedProfileAsset,
    );

    if (!isMounted) return;

    onSuccess();
    showMessage(successMessage);
  }

  Future<void> pickImage(
    BuildContext context,
    bool isMounted,
    VoidCallback onUpdate,
  ) async {
    final selected =
        await _openImagePickerDialog(context, selectedProfileAsset);

    if (!isMounted) return;

    if (selected != null) {
      selectedProfileAsset = selected;
      onUpdate();
    }
  }

  Future<String?> _openImagePickerDialog(
    BuildContext context,
    String? currentAsset,
  ) async {
    final assets = List.generate(9, (i) => 'assets/character_${i + 1}.png');
    final loc = context.loc;

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(loc.selectProfileImage),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: assets.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final assetName = assets[index];
                return GestureDetector(
                  onTap: () => Navigator.pop(context, assetName),
                  child: Image.asset(assetName),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
