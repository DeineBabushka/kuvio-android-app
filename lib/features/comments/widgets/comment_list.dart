import 'package:flutter/material.dart';
import 'package:kuvio/features/comments/models/formatted_comment.dart';
import 'package:kuvio/features/comments/widgets/comment_card.dart';

class CommentList extends StatelessWidget {
  final List<FormattedComment> comments;

  const CommentList({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: comments.length,
      itemBuilder: (context, index) => CommentCard(comment: comments[index]),
    );
  }
}
