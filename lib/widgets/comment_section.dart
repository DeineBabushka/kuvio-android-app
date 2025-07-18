import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/comment.dart';
import '../services/comment_service.dart';

class CommentSection extends StatefulWidget {
  final String recipeId;

  const CommentSection({super.key, required this.recipeId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _controller = TextEditingController();
  List<Comment> _comments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    final comments = await CommentService.getCommentsForRecipe(widget.recipeId);
    setState(() {
      _comments = comments;
      _loading = false;
    });
  }

  Future<void> _submitComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    try {
      await CommentService.submitComment(
        recipeId: widget.recipeId,
        text: text,
      );

      _controller.clear();
      _loadComments();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Du musst eingeloggt sein.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    final cardColor = const Color(0xFF2C2C2E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Divider(color: textColor.withAlpha((0.5 * 255).toInt())),
        Text(
          'Kommentare',
          style: TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        if (_loading)
          const CircularProgressIndicator()
        else if (_comments.isEmpty)
          Text(
            "Keine Kommentare vorhanden.",
            style: TextStyle(color: textColor),
          )
        else
          ..._comments.map((comment) {
            final ts = comment.timestamp.add(const Duration(hours: 2));
            return ListTile(
              tileColor: cardColor,
              title: Text(
                comment.username,
                style: TextStyle(color: textColor),
              ),
              subtitle: Text(
                comment.text,
                style:
                    TextStyle(color: textColor.withAlpha((0.7 * 255).toInt())),
              ),
              trailing: Text(
                '${ts.day.toString().padLeft(2, '0')}.${ts.month.toString().padLeft(2, '0')}.${ts.year} – '
                '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                    color: textColor.withAlpha((0.5 * 255).toInt()),
                    fontSize: 12),
              ),
            );
          }),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Kommentar schreiben...',
                  hintStyle: TextStyle(
                      color: textColor.withAlpha((0.5 * 255).toInt())),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: textColor),
              onPressed: _submitComment,
            ),
          ],
        ),
      ],
    );
  }
}
