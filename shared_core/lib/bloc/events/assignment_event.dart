abstract interface class AssignmentEvent {}

class AssignmentsInitEvent implements AssignmentEvent {}

class GetAssignmentsEvent implements AssignmentEvent {}

class ModifyAssignmentCompletion implements AssignmentEvent {
  final String id;

  ModifyAssignmentCompletion(this.id);
}

class SwitchModeEvent implements AssignmentEvent {
  final bool isPendingMode;

  SwitchModeEvent(this.isPendingMode);
}