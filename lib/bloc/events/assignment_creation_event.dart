import 'dart:io';

abstract interface class AssignmentCreationEvent {}

class CreateAssignmentEvent implements AssignmentCreationEvent {
  final String title;
  final String subject;
  final DateTime dueDate;
  final String description;

  CreateAssignmentEvent({
    required this.title,
    required this.subject,
    required this.description,
    required this.dueDate,
  });

}

class FileUploadEvent implements AssignmentCreationEvent {
  final List<File> files;

  FileUploadEvent({required this.files});
}

class FileDeleteEvent implements AssignmentCreationEvent {
  final File file;

  FileDeleteEvent({required this.file});
}

class AddRecordingEvent implements AssignmentCreationEvent {
  final Uri uri;
  AddRecordingEvent({required this.uri});
}

class RemoveRecordingEvent implements AssignmentCreationEvent {}