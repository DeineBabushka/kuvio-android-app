import 'package:flutter/material.dart';

class AddAllIngredientsButton extends StatelessWidget {
  final void Function() onPressed;

  const AddAllIngredientsButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Alle Zutaten hinzufügen'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
