import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../recipes/models/recipe.dart';
import '../models/formatted_comment.dart';
import '../services/comment_service.dart';
import '../widgets/comment_list.dart';
import '../widgets/empty_comment_placeholder.dart';

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

      debugPrint('Rezepte geladen: ${allRecipes.length}');

      final commentPairs =
          await CommentService.getAllCommentsWithRecipes(allRecipes);
      debugPrint('Kommentare mit Rezept gefunden: ${commentPairs.length}');

      final formatted = commentPairs.map(FormattedComment.fromCWR).toList();

      setState(() {
        commentData = formatted;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Fehler beim Laden der Kommentare: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine Kommentare'),
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
