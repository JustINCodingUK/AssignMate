import '../model/assignment.dart';

extension DateSort on List<Assignment> {
  void sortByDate() {
    sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }
}