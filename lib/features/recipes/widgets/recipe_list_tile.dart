import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/models/recipe_list_item.dart';

class RecipeListTile extends StatelessWidget {
  final RecipeListItem item;

  const RecipeListTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: Image.asset(
          item.imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (ctx, error, stack) =>
              const Icon(Icons.broken_image, size: 60),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Image.asset(
              item.iconUrl,
              width: 20,
              height: 20,
              fit: BoxFit.cover,
              errorBuilder: (ctx, error, stack) =>
                  const Icon(Icons.category, size: 20),
            ),
            const SizedBox(width: 8),
            Text(
              item.category,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
