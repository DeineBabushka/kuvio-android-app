import 'comment.dart';
import '../../recipes/models/recipe.dart';

class CommentWithRecipe {
  final Comment comment;
  final Recipe recipe;

  CommentWithRecipe({required this.comment, required this.recipe});
}
