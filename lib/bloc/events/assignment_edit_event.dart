import 'dart:io';

abstract interface class AssignmentEditEvent {}

class EditAssignmentEvent implements AssignmentEditEvent {
  final String oldAssignmentId;
  final String title;
  final String subject;
  final DateTime dueDate;
  final String description;

  EditAssignmentEvent({
    required this.oldAssignmentId,
    required this.title,
    required this.subject,
    required this.description,
    required this.dueDate,
  });
}

class BeginAssignmentEditEvent implements AssignmentEditEvent {
  final String assignmentId;

  BeginAssignmentEditEvent({required this.assignmentId});
}

class FileUploadEvent implements AssignmentEditEvent {
  final List<File> files;

  FileUploadEvent({required this.files});
}

class FileDeleteEvent implements AssignmentEditEvent {
  final String fileId;

  FileDeleteEvent({required this.fileId});
}

class AddRecordingEvent implements AssignmentEditEvent {
  final Uri uri;

  AddRecordingEvent({required this.uri});
}

class RemoveRecordingEvent implements AssignmentEditEvent {}