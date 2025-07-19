import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/comment.dart';
import '../../recipes/models/recipe.dart';
import '../models/comment_with_recipe.dart';
import '../models/formatted_comment.dart';

class CommentService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<List<Comment>> getCommentsForRecipe(String recipeId) async {
    final snapshot = await _db
        .collection('comments')
        .where('recipeId', isEqualTo: recipeId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map(Comment.fromFirestore).toList();
  }

  static Future<List<CommentWithRecipe>> getAllCommentsWithRecipes(
      List<Recipe> allRecipes) async {
    final commentSnapshot = await _db
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .get();

    final List<CommentWithRecipe> result = [];

    for (final doc in commentSnapshot.docs) {
      final comment = Comment.fromFirestore(doc);

      final localMatches =
          allRecipes.where((r) => r.id == comment.recipeId).toList();

      if (localMatches.isNotEmpty) {
        result
            .add(CommentWithRecipe(comment: comment, recipe: localMatches[0]));
        continue;
      }

      final remoteDoc =
          await _db.collection('recipes').doc(comment.recipeId).get();
      if (remoteDoc.exists) {
        final remoteRecipe = Recipe.fromFirestore(remoteDoc);
        result.add(CommentWithRecipe(comment: comment, recipe: remoteRecipe));
      }
    }

    return result;
  }

  static Future<List<FormattedComment>> getFormattedCommentsWithRecipes(
      List<Recipe> allRecipes) async {
    final commentPairs = await getAllCommentsWithRecipes(allRecipes);
    return commentPairs.map(FormattedComment.fromCWR).toList();
  }

  static Future<void> submitComment({
    required String recipeId,
    required String text,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Kein Benutzer eingeloggt.");

    final userDoc = await _db.collection('users').doc(user.uid).get();
    final username = userDoc.data()?['username'] ?? 'Unbekannt';

    final comment = Comment(
      id: const Uuid().v4(),
      userId: user.uid,
      username: username,
      recipeId: recipeId,
      text: text.trim(),
      timestamp: DateTime.now(),
    );

    await _db.collection('comments').doc(comment.id).set(comment.toMap());
  }
}
