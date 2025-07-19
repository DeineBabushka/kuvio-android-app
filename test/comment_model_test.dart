import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuvio/features/comments/models/comment.dart';

void main() {
  test('Comment model roundtrip: toMap -> manuelle Rekonstruktion', () {
    final now = DateTime.now();

    final original = Comment(
      id: 'abc123',
      userId: 'user001',
      username: 'Max Mustermann',
      recipeId: 'recipe123',
      text: 'Tolles Rezept!',
      timestamp: now,
    );

    final map = original.toMap();

    final recreated = Comment(
      id: 'abc123',
      userId: map['userId'] as String,
      username: map['username'] as String,
      recipeId: map['recipeId'] as String,
      text: map['text'] as String,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );

    expect(recreated.id, original.id);
    expect(recreated.userId, original.userId);
    expect(recreated.username, original.username);
    expect(recreated.recipeId, original.recipeId);
    expect(recreated.text, original.text);
    expect(recreated.timestamp.toIso8601String(), now.toIso8601String());
  });
}
