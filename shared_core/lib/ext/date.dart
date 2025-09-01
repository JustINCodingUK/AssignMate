extension Date on DateTime {
  String date() {
    return "$day/$month/$year";
  }

  bool isTomorrowOrToday() {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    final today = DateTime.now();
    return (day == tomorrow.day && month == tomorrow.month && year == tomorrow.year) ||
        (day == today.day && month == today.month && year == today.year);
  }
}

extension ToDate on String {
  DateTime asDate() {
    final splitDate = split("/");
    return DateTime(
      int.parse(splitDate[2]),
      int.parse(splitDate[1]),
      int.parse(splitDate[0]),
    );
  }
}