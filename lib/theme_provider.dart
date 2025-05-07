import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkMode = true; // Startet im Dark Mode

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
}
