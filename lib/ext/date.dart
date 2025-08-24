extension Date on DateTime {
  String date() {
    return "$day/$month/$year";
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