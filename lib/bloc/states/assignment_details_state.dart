import 'dart:io';

import 'package:assignmate/model/assignment.dart';

abstract interface class AssignmentDetailsState {}

class AssignmentDetailsLoadingState implements AssignmentDetailsState {}

class AssignmentDetailsLoadedState implements AssignmentDetailsState {
  final Assignment assignment;
  final File? recording;

  AssignmentDetailsLoadedState(this.assignment, {this.recording});
}

class FileDownloadedState implements AssignmentDetailsLoadedState {
  @override
  final Assignment assignment;
  final File file;
  @override
  final File? recording;

  FileDownloadedState(this.file, this.assignment, {this.recording});
}

class FileDownloadingState implements AssignmentDetailsLoadedState {
  @override
  final Assignment assignment;
  @override
  final File? recording;
  final String loadingId;

  FileDownloadingState(this.assignment, {this.recording, required this.loadingId});
}

class DeletionSuccessfulState implements AssignmentDetailsState {}
