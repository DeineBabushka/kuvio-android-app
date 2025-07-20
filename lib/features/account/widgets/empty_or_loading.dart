import 'package:flutter/material.dart';

Widget buildLoadingIndicator(Color color) {
  return Center(child: CircularProgressIndicator(color: color));
}

Widget buildNoUserData(Color color) {
  return Center(
    child: Text('Keine Daten gefunden', style: TextStyle(color: color)),
  );
}
