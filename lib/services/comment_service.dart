import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/comment.dart';

Future<List<Comment>> loadComments(String recipeId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('recipes')
      .doc(recipeId)
      .collection('comments')
      .orderBy('timestamp', descending: true)
      .get();

  return snapshot.docs.map((doc) => Comment.fromMap(doc.data())).toList();
}
