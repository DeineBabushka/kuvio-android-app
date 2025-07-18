import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import '../models/comment.dart';
import '../models/recipe.dart';
import '../models/comment_with_recipe.dart';

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

  static Future<List<CommentWithRecipe>> getAllCommentsWithRecipes(
      List<Recipe> allRecipes) async {
    final commentSnapshot = await _db
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .get();

    final List<CommentWithRecipe> loaded = [];

    for (var doc in commentSnapshot.docs) {
      final comment = Comment.fromFirestore(doc);

      final localMatch = allRecipes.firstWhere(
        (r) => r.id == comment.recipeId,
        orElse: () => Recipe(
          id: '',
          title: '',
          image: '',
          portions: 0,
          ingredients: [],
          instructions: [],
          dietTypes: [],
          categories: [],
          preparationTime: '',
          calories: 0,
          proteinG: 0,
          carbohydratesG: 0,
          fatG: 0,
        ),
      );

      if (localMatch.id.isNotEmpty) {
        loaded.add(CommentWithRecipe(comment: comment, recipe: localMatch));
        continue;
      }

      final recipeSnapshot =
          await _db.collection('recipes').doc(comment.recipeId).get();
      if (recipeSnapshot.exists) {
        final recipe = Recipe.fromFirestore(recipeSnapshot);
        loaded.add(CommentWithRecipe(comment: comment, recipe: recipe));
      }
    }

    return loaded;
  }

  static Future<void> submitComment({
    required String recipeId,
    required String text,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("Kein Benutzer eingeloggt");

    final userDoc = await _db.collection('users').doc(user.uid).get();
    final username = userDoc.data()?['username'] ?? 'Unbekannt';

    final newComment = Comment(
      id: const Uuid().v4(),
      userId: user.uid,
      username: username,
      recipeId: recipeId,
      text: text,
      timestamp: DateTime.now(),
    );

    await _db.collection('comments').doc(newComment.id).set(newComment.toMap());
  }
}
