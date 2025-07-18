import 'comment_with_recipe.dart';

class FormattedComment {
  final String formattedDate;
  final CommentWithRecipe data;

  FormattedComment({
    required this.formattedDate,
    required this.data,
  });

  static FormattedComment fromCWR(CommentWithRecipe cwr) {
    final localDate = cwr.comment.timestamp.add(const Duration(hours: 2));
    final formatted = '${localDate.day.toString().padLeft(2, '0')}.'
        '${localDate.month.toString().padLeft(2, '0')}.'
        '${localDate.year} '
        '${localDate.hour.toString().padLeft(2, '0')}:'
        '${localDate.minute.toString().padLeft(2, '0')}';
    return FormattedComment(formattedDate: formatted, data: cwr);
  }
}
