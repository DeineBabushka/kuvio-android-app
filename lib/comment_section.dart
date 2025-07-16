import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/comment.dart';

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
    final snapshot = await FirebaseFirestore.instance
        .collection('comments')
        .where('recipeId', isEqualTo: widget.recipeId)
        .orderBy('timestamp', descending: true)
        .get();

    setState(() {
      _comments = snapshot.docs.map((doc) => Comment.fromMap(doc.data())).toList();
      _loading = false;
    });
  }

  Future<void> _submitComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Du musst eingeloggt sein.')),
      );
      return;
    }

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    final newComment = Comment(
      id: const Uuid().v4(),
      userId: user.uid,
      username: userDoc.data()?['username'] ?? 'Unbekannt',
      recipeId: widget.recipeId,
      text: text,
      timestamp: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('comments')
        .doc(newComment.id)
        .set(newComment.toMap());

    _controller.clear();
    _loadComments();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white;
    final cardColor = const Color(0xFF2C2C2E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Divider(color: textColor.withOpacity(0.5)),
        Text('Kommentare',
            style: TextStyle(
                color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        if (_loading)
          const CircularProgressIndicator()
        else if (_comments.isEmpty)
          Text("Keine Kommentare vorhanden.", style: TextStyle(color: textColor))
        else
          ..._comments.map((comment) {
            final ts = comment.timestamp.add(const Duration(hours: 2));
            return ListTile(
              tileColor: cardColor,
              title: Text(comment.username, style: TextStyle(color: textColor)),
              subtitle:
                  Text(comment.text, style: TextStyle(color: textColor.withOpacity(0.7))),
              trailing: Text(
                '${ts.day.toString().padLeft(2, '0')}.${ts.month.toString().padLeft(2, '0')}.${ts.year} – '
                '${ts.hour.toString().padLeft(2, '0')}:${ts.minute.toString().padLeft(2, '0')}',
                style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12),
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
                  hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: textColor),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send, color: textColor),
              onPressed: _submitComment,
            )
          ],
        ),
      ],
    );
  }
}