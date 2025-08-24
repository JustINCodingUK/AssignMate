import 'package:assignmate/model/assignment.dart';

abstract interface class AssignmentState {}

class AssignmentsLoadedState implements AssignmentState {
  final List<Assignment> assignments;
  final bool areRemindersUnread;
  AssignmentsLoadedState(this.assignments, this.areRemindersUnread);
}

class AssignmentsLoadingState implements AssignmentState {}

