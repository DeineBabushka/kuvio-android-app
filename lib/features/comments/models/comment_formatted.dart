import 'package:kuvio/features/comments/models/comment_with_recipe.dart';
import 'package:kuvio/features/comments/utils/comment_date_formatter.dart';

class FormattedComment {
  final String formattedDate;
  final CommentWithRecipe data;

  FormattedComment({
    required this.formattedDate,
    required this.data,
  });

  static FormattedComment fromCWR(CommentWithRecipe cwr) {
    return FormattedComment(
      formattedDate: DateFormatter.format(cwr.comment.timestamp),
      data: cwr,
    );
  }
}
