import 'dart:io';

import 'package:assignmate/model/assignment.dart';

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

class EditAssignmentEvent implements AssignmentCreationEvent {
  final Assignment oldAssignment;
  final String title;
  final String subject;
  final DateTime dueDate;
  final String description;
  final List<String> attachments;

  EditAssignmentEvent({
    required this.oldAssignment,
    required this.title,
    required this.subject,
    required this.description,
    required this.dueDate,
    required this.attachments,
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
