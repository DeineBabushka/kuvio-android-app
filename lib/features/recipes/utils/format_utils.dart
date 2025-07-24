String formatDate(DateTime date) {
  final d = date.add(const Duration(hours: 2));

  return '${d.day.toString().padLeft(2, '0')}'
      '.${d.month.toString().padLeft(2, '0')}'
      '.${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:'
      '${d.minute.toString().padLeft(2, '0')}';
}
