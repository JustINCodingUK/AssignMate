import 'dart:io';

import '../../model/assignment.dart';

abstract interface class AssignmentCreationState {
  final List<File> attachments;

  AssignmentCreationState({required this.attachments});
}

class AssignmentCreationInitialState implements AssignmentCreationState {
  @override
  final List<File> attachments;
  final List<String> availableSubjects;
  final Uri? audioRecording;

  AssignmentCreationInitialState({this.availableSubjects = const [], this.attachments = const [], this.audioRecording});
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

class DeletionSuccessfulState implements AssignmentCreationState {
  @override
  final attachments = [];
}
