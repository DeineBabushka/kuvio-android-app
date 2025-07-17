import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kuvio/models/comment.dart';

class FakeDocumentSnapshot implements DocumentSnapshot<Map<String, dynamic>> {
  final String _id;
  final Map<String, dynamic> _data;

  FakeDocumentSnapshot(this._id, this._data);

  @override
  String get id => _id;

  @override
  Map<String, dynamic>? data([GetOptions? options]) => _data;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('Comment model roundtrip: toMap -> fromFirestore', () {
    final now = DateTime.now();
    final comment = Comment(
      id: 'abc123',
      userId: 'user001',
      username: 'Max Mustermann',
      recipeId: 'recipe123',
      text: 'Tolles Rezept!',
      timestamp: now,
    );

    final map = comment.toMap();

    final fakeDoc = FakeDocumentSnapshot('abc123', {
      'userId': 'user001',
      'username': 'Max Mustermann',
      'recipeId': 'recipe123',
      'text': 'Tolles Rezept!',
      'timestamp': Timestamp.fromDate(now),
    });

    final recreated = Comment.fromFirestore(fakeDoc);

    expect(recreated.id, comment.id);
    expect(recreated.userId, comment.userId);
    expect(recreated.username, comment.username);
    expect(recreated.recipeId, comment.recipeId);
    expect(recreated.text, comment.text);
    expect(recreated.timestamp.toIso8601String(), now.toIso8601String());
  });
}
