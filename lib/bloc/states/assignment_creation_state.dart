import 'dart:io';

import 'package:assignmate/model/attachment.dart';

import '../../model/assignment.dart';

abstract interface class AssignmentCreationState {
  final List<File> attachments;

  AssignmentCreationState(this.attachments);
}

class AssignmentCreationBaseState implements AssignmentCreationState {
  final List<String> availableSubjects;

  @override
  final List<File> attachments;
  final Uri? audioRecording;

  AssignmentCreationBaseState(this.availableSubjects, this.attachments, this.audioRecording);
}

class AssignmentInCreationState implements AssignmentCreationState {
  @override
  final List<File> attachments;

  AssignmentInCreationState(this.attachments);
}

class AssignmentCreatedState implements AssignmentCreationState {
  final Assignment assignment;
  @override
  final List<File> attachments;

  AssignmentCreatedState(this.assignment, this.attachments);
}

class FileUploadingState implements AssignmentCreationState {
  @override
  final List<File> attachments;

  FileUploadingState(this.attachments);
}
