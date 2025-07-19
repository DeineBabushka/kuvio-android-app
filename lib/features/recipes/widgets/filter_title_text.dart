import 'package:flutter/material.dart';

class FilterTitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;

  const FilterTitleText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
