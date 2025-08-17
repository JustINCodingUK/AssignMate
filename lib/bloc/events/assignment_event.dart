abstract interface class AssignmentEvent {}

class GetAssignmentsEvent implements AssignmentEvent {
  final bool pendingOnly;

  GetAssignmentsEvent({required this.pendingOnly});
}