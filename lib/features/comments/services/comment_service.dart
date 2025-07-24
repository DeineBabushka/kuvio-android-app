import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:kuvio/features/comments/models/comment.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';
import 'package:kuvio/features/comments/models/comment_with_recipe.dart';
import 'package:kuvio/features/comments/models/comment_formatted.dart';

class CommentService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<List<Comment>> getCommentsForRecipe(String recipeId) async {
    final snapshot = await _db
        .collection('comments')
        .where('recipeId', isEqualTo: recipeId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList();
  }

  static Future<List<Comment>> getCommentsForRecipeWithProfileImages(
      String recipeId) async {
    final snapshot = await _db
        .collection('comments')
        .where('recipeId', isEqualTo: recipeId)
        .orderBy('timestamp', descending: true)
        .get();

    final List<Comment> comments = [];

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final userId = data['userId'] ?? '';
      String profileImage = '';

      try {
        final userDoc = await _db.collection('users').doc(userId).get();
        profileImage = userDoc.data()?['profileImage'] ?? '';
      } catch (_) {}

      final comment = Comment.fromFirestore(
        doc,
        profileImage: profileImage,
      );

      comments.add(comment);
    }

    return comments;
  }

  static Future<void> deleteComment(String commentId) async {
    await _db.collection('comments').doc(commentId).delete();
  }

  static Future<List<CommentWithRecipe>> getAllCommentsWithRecipes(
      List<Recipe> allRecipes) async {
    final user = _auth.currentUser;
    if (user == null) return [];

    final commentSnapshot = await _db
        .collection('comments')
        .where('userId', isEqualTo: user.uid)
        .get();

    final recipeMap = {
      for (final recipe in allRecipes) recipe.id: recipe,
    };

    final List<CommentWithRecipe> result = [];

    for (final doc in commentSnapshot.docs) {
      final comment = Comment.fromFirestore(doc);
      final recipe = recipeMap[comment.recipeId];

      if (recipe != null) {
        result.add(CommentWithRecipe(
          comment: comment,
          recipe: recipe,
        ));
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
      profileImage: userDoc.data()?['profileImage'] ?? '',
    );

    await _db.collection('comments').doc(comment.id).set(comment.toMap());
  }
}
