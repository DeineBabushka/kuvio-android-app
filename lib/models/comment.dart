import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String userId;
  final String username;
  final String recipeId;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.recipeId,
    required this.text,
    required this.timestamp,
  });

  /// Konvertieren für Firestore (zum Speichern)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'recipeId': recipeId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  /// Erzeugen aus Firestore-Daten (beim Abrufen)
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      recipeId: map['recipeId'] ?? '',
      text: map['text'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  /// Kopieren + einzelnes Feld ersetzen
  Comment copyWith({
    String? id,
    String? userId,
    String? username,
    String? recipeId,
    String? text,
    DateTime? timestamp,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      recipeId: recipeId ?? this.recipeId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
