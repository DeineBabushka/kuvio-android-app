import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/comment.dart';

class CommentSection extends StatelessWidget {
  final List<Comment> comments;
  final bool isLoading;
  final TextEditingController controller;
  final Color textColor;
  final Color cardColor;
  final String recipeId;
  final Function(Comment) onSubmit;

  const CommentSection({
    super.key,
    required this.comments,
    required this.isLoading,
    required this.controller,
    required this.textColor,
    required this.cardColor,
    required this.recipeId,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: textColor.withOpacity(0.5)),
        Text('Kommentare',
            style: TextStyle(
                color: textColor, fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        if (isLoading)
          const CircularProgressIndicator()
        else if (comments.isEmpty)
          Text("Keine Kommentare vorhanden.",
              style: TextStyle(color: textColor))
        else
          ...comments.map((comment) => ListTile(
                tileColor: cardColor,
                title:
                    Text(comment.username, style: TextStyle(color: textColor)),
                subtitle: Text(comment.text,
                    style: TextStyle(color: textColor.withOpacity(0.7))),
                trailing: Text(
                  '${comment.timestamp.day.toString().padLeft(2, '0')}.${comment.timestamp.month.toString().padLeft(2, '0')}.${comment.timestamp.year} – '
                  '${comment.timestamp.hour.toString().padLeft(2, '0')}:${comment.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                      color: textColor.withOpacity(0.5), fontSize: 12),
                ),
              )),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
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
              onPressed: () async {
                final text = controller.text.trim();
                if (text.isEmpty) return;

                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('❌ Du musst eingeloggt sein.')),
                  );
                  return;
                }

                final userDoc = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get();

                final newComment = Comment(
                  id: '',
                  userId: user.uid,
                  username: userDoc.data()?['username'] ?? 'Unbekannt',
                  recipeId: recipeId,
                  text: text,
                  timestamp: DateTime.now(),
                );

                onSubmit(newComment);
              },
            )
          ],
        ),
      ],
    );
  }
}
