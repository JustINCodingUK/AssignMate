import 'package:assignmate/model/assignment.dart';

abstract interface class AssignmentState {}

class AssignmentsLoadedState implements AssignmentState {
  final List<Assignment> assignments;
  AssignmentsLoadedState(this.assignments);
}

class AssignmentsLoadingState implements AssignmentState {}

