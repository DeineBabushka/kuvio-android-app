import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class FavoriteShareActions extends StatelessWidget {
  final String title;
  final String shareText;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final bool isLoggedIn;

  const FavoriteShareActions({
    super.key,
    required this.title,
    required this.shareText,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () => SharePlus.instance.share(
            ShareParams(
              text: shareText,
              subject: title,
            ),
          ),
        ),
        if (isLoggedIn)
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.redAccent,
            ),
            onPressed: onToggleFavorite,
          ),
      ],
    );
  }
}
