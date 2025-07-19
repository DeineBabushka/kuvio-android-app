import 'package:flutter/material.dart';

class LoginColors {
  final Color backgroundColor;
  final Color cardColor;
  final Color textColor;
  final Color labelColor;
  final Color headingColor;
  final Color iconColor;
  final Color buttonBackground;
  final Color buttonTextColor;

  LoginColors(BuildContext context)
      : backgroundColor = Theme.of(context).scaffoldBackgroundColor,
        cardColor = Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]!
            : Colors.white,
        textColor = Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        labelColor = Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : const Color(0xFF122620),
        headingColor = Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : const Color(0xFF122620),
        iconColor = Theme.of(context).brightness == Brightness.dark
            ? Colors.white60
            : const Color(0xFF122620),
        buttonBackground = Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.primary
            : const Color(0xFF122620),
        buttonTextColor = Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white;
}
