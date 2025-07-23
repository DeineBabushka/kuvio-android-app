import 'package:flutter/material.dart';
import 'package:kuvio/localization/context_extension.dart';

class EmptyCommentPlaceholder extends StatelessWidget {
  const EmptyCommentPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(context.loc.noCommentsFound),
    );
  }
}
