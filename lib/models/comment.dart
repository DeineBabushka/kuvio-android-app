class Comment {
  final String id; // Eindeutige ID des Kommentars
  final String userId; // ID des Users, der kommentiert
  final String username; // Anzeigename
  final String text; // Der eigentliche Kommentartext
  final DateTime timestamp; // Wann der Kommentar geschrieben wurde

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.text,
    required this.timestamp,
  });

  // Zum Speichern in einer Datenbank wie Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Zum Laden aus der Datenbank
  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      text: map['text'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
