import 'package:flutter/material.dart';
import 'user_service.dart';
import 'profile_service.dart';
import '../models/app_user.dart';

class EditProfileController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final bioController = TextEditingController();
  final dishController = TextEditingController();

  final userService = UserService();
  final profileService = ProfileService();

  String selectedKitchen = 'Nicht angegeben';
  String? selectedProfileAsset;

  Future<void> loadUserData(VoidCallback onUpdate) async {
    final doc = await userService.loadUserData();
    if (doc != null && doc.exists) {
      final user = AppUser.fromSnapshot(doc);
      usernameController.text = user.username;
      bioController.text = user.bio ?? '';
      dishController.text = user.favoriteDish ?? '';
      selectedKitchen = user.favoriteKitchen ?? 'Nicht angegeben';
      selectedProfileAsset = user.profileImage;
      onUpdate();
    }
  }

  Future<void> saveProfile({
    required BuildContext context,
    required VoidCallback onSuccess,
    required void Function(String message) showMessage,
  }) async {
    if (!formKey.currentState!.validate()) return;

    await userService.updateProfile(
      bio: bioController.text,
      kitchen: selectedKitchen,
      favdish: dishController.text,
      profileImage: selectedProfileAsset,
    );

    onSuccess();
    showMessage('Profil aktualisiert');
  }

  Future<void> pickImage(BuildContext context, VoidCallback onUpdate) async {
    final selected = await profileService.openImagePickerDialog(
      context,
      selectedProfileAsset,
    );
    if (selected != null) {
      selectedProfileAsset = selected;
      onUpdate();
    }
  }
}
