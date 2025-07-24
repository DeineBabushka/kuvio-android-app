import 'package:flutter/material.dart';

InputDecoration buildPasswordInputDecoration({
  required String label,
  required String hint,
  required Color labelColor,
  required Color fillColor,
  required Color focusColor,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: TextStyle(color: labelColor),
    hintStyle: TextStyle(color: labelColor.withAlpha(153)),
    filled: true,
    fillColor: fillColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: labelColor.withAlpha(128)),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: focusColor),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
