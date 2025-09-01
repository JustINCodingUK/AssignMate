import '../../model/attachment.dart';

import '../../model/assignment.dart';

abstract interface class AssignmentEditState {}

class AssignmentEditBaseState implements AssignmentEditState {
  final Assignment oldAssignment;
  final List<Attachment> attachments;
  final Uri? recording;
  AssignmentEditBaseState({required this.oldAssignment, required this.attachments, this.recording});
}

class AssignmentLoadingState implements AssignmentEditState {}

class AssignmentEditInProgressState implements AssignmentEditState {}

class AssignmentEditedState implements AssignmentEditState {
  final String title;

  AssignmentEditedState(this.title);
}