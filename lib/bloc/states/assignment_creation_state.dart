import 'dart:io';

import '../../model/assignment.dart';

abstract interface class AssignmentScreenState {}

abstract interface class AssignmentCreationState implements AssignmentScreenState {
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

class AssignmentEditPendingState implements AssignmentCreationState {
  @override
  final List<File> attachments;

  AssignmentEditPendingState(this.attachments);
}

class AssignmentEditStartedState implements AssignmentScreenState {
  final Assignment oldAssignment;

  AssignmentEditStartedState(this.oldAssignment);
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

class DeletionSuccessfulState implements AssignmentScreenState {}

class AssignmentEditedState implements AssignmentScreenState {
  final String title;
  AssignmentEditedState(this.title);
}
