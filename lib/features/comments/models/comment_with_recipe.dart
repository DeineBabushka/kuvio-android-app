import 'package:kuvio/features/comments/models/comment.dart';
import 'package:kuvio/features/recipes/models/recipe.dart';

class CommentWithRecipe {
  final Comment comment;
  final Recipe recipe;

  CommentWithRecipe({required this.comment, required this.recipe});
}
