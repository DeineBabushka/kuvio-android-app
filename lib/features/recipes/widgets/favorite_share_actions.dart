import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:kuvio/shared/utils/block_if_offline.dart';

class FavoriteShareActions extends StatelessWidget {
  final String title;
  final String shareText;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final bool isLoggedIn;
  final bool isOnline;

  const FavoriteShareActions({
    super.key,
    required this.title,
    required this.shareText,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.isLoggedIn,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {
            if (blockIfOffline(context)) return;

            SharePlus.instance.share(
              ShareParams(
                text: shareText,
                subject: title,
              ),
            );
          },
        ),
        if (isLoggedIn && isOnline)
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
