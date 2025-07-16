import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> addComment(String recipeID, String commentText) async {
    final userID = _auth.currentUser!.uid;

    await _db.collection('comments').add({
      'userID': userID,
      'recipeID': recipeID,
      'comment': commentText,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Comment>> getCommentsForRecipe(String recipeID) async {
    final snapshot = await _db
        .collection('comments')
        .where('recipeID', isEqualTo: recipeID)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Comment(
        userID: data['userID'],
        recipeID: data['recipeID'],
        text: data['comment'],
        timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  }
}
