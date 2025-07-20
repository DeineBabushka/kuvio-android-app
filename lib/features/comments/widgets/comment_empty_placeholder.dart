import 'package:flutter/material.dart';

class EmptyCommentPlaceholder extends StatelessWidget {
  const EmptyCommentPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Keine Kommentare gefunden."),
    );
  }
}
