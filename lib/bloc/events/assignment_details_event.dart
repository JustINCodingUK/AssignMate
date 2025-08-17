abstract interface class AssignmentDetailsEvent {}

class GetAssignmentEvent implements AssignmentDetailsEvent {
  final String id;

  GetAssignmentEvent(this.id);
}

class DownloadFileEvent implements AssignmentDetailsEvent {
  final String id;

  DownloadFileEvent(this.id);
}