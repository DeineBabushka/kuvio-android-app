import 'package:flutter/material.dart';
import '../../recipes/models/recipe.dart';
import '../models/formatted_comment.dart';
import '../services/comment_service.dart';
import '../widgets/comment_list.dart';
import '../widgets/empty_comment_placeholder.dart';

class CommentScreen extends StatefulWidget {
  final List<Recipe> allRecipes;

  const CommentScreen({super.key, required this.allRecipes});

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
      final formatted = await CommentService.getFormattedCommentsWithRecipes(
        widget.allRecipes,
      );
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
