import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/comments/models/comment_formatted.dart';
import 'package:kuvio/features/comments/services/comment_service.dart';
import 'package:kuvio/features/comments/widgets/comment_list.dart';
import 'package:kuvio/features/comments/widgets/comment_empty_placeholder.dart';
import 'package:kuvio/l10n/app_localizations.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<FormattedComment> commentData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      final recipeDocs =
          await FirebaseFirestore.instance.collection('recipes').get();
      final allRecipes =
          recipeDocs.docs.map((doc) => Recipe.fromFirestore(doc)).toList();

      final commentPairs =
          await CommentService.getAllCommentsWithRecipes(allRecipes);

      final formatted = commentPairs.map(FormattedComment.fromCWR).toList();

      setState(() {
        commentData = formatted;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final loc = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc?.myCommentsTitle ?? 'Meine Kommentare'),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : commentData.isEmpty
              ? const EmptyCommentPlaceholder()
              : CommentList(comments: commentData),
    );
  }
}
