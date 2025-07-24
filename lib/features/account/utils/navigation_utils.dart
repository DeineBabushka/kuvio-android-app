import 'package:flutter/material.dart';
import 'package:kuvio/features/recipes/screens/recipe_filter_screen.dart';
import 'package:kuvio/features/account/screens/change_password_screen.dart';

void navigateToHomeAndClearStack(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => const RecipesScreen()),
    (route) => false,
  );
}

void navigateToChangePassword(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
  );
}
