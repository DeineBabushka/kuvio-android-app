import 'package:flutter/material.dart';
import 'package:kuvio/localization/context_extension.dart';

class ProfileService {
  List<String> getProfileImageAssets() {
    return List.generate(9, (i) => 'assets/character_${i + 1}.png');
  }

  Future<String?> openImagePickerDialog(
    BuildContext context,
    String? currentAsset,
  ) async {
    final assets = getProfileImageAssets();
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
