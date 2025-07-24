import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String userId;
  final String username;
  final String recipeId;
  final String text;
  final DateTime timestamp;
  final String profileImage;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.recipeId,
    required this.text,
    required this.timestamp,
    required this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'recipeId': recipeId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory Comment.fromFirestore(
    DocumentSnapshot doc, {
    String profileImage = '',
  }) {
    final data = doc.data() as Map<String, dynamic>;

    return Comment(
      id: doc.id,
      userId: data['userId'],
      username: data['username'],
      recipeId: data['recipeId'],
      text: data['text'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      profileImage: profileImage,
    );
  }
}
