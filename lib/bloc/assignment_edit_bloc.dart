import 'dart:io';

import 'package:assignmate/bloc/events/assignment_edit_event.dart';
import 'package:assignmate/bloc/states/assignment_edit_state.dart';
import 'package:assignmate/data/assignment_repository.dart';
import 'package:assignmate/ext/filename.dart';
import 'package:assignmate/model/assignment.dart';
import 'package:assignmate/model/attachment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignmentEditBloc
    extends Bloc<AssignmentEditEvent, AssignmentEditState> {
  final List<String> subjects;
  final List<Attachment> _attachments=[];
  int _tempId = 1;
  late final Assignment _oldAssignment;
  Uri? _recording;

  final AssignmentsRepository _assignmentsRepository;

  AssignmentEditBloc(this._assignmentsRepository, this.subjects)
    : super(AssignmentLoadingState()) {
    on<BeginAssignmentEditEvent>((event, emit) async {
      emit(AssignmentLoadingState());
      final assignment = await _assignmentsRepository.getAssignment(
        event.assignmentId,
      );
      if (assignment.recording != null) {
        final attachmentFile = await _assignmentsRepository.getAttachment(
          assignment.recording!,
        );
        _recording = attachmentFile.uri;
      }
      _oldAssignment = assignment;
      for(Attachment attachment in _oldAssignment.attachments) {
        if(attachment.filename != "audio.m4a") {
          _attachments.add(attachment);
        }
      }
      emit(
        AssignmentEditBaseState(
          oldAssignment: assignment,
          attachments: _attachments,
          recording: _recording,
        ),
      );
    });

    on<FileUploadEvent>((event, emit) {
      for (File file in event.files) {
        final attachment = Attachment(
          id: (_tempId++).toString(),
          driveFileId: "",
          filename: file.name,
          uri: file.uri,
        );
        _attachments.add(attachment);
      }
      emit(
        AssignmentEditBaseState(
          oldAssignment: _oldAssignment,
          attachments: _attachments,
          recording: _recording,
        ),
      );
    });

    on<FileDeleteEvent>((event, emit) {
      _attachments.removeWhere((element) => element.id == event.fileId);
      emit(
        AssignmentEditBaseState(
          oldAssignment: _oldAssignment,
          attachments: _attachments,
        ),
      );
    });

    on<AddRecordingEvent>((event, emit) {
      _recording = event.uri;
      emit(
        AssignmentEditBaseState(
          oldAssignment: _oldAssignment,
          attachments: _attachments,
        ),
      );
    });

    on<RemoveRecordingEvent>((event, emit) {
      _recording = null;
      emit(
        AssignmentEditBaseState(
          oldAssignment: _oldAssignment,
          attachments: _attachments,
        ),
      );
    });

    on<EditAssignmentEvent>((event, emit) async {
      final assignment = Assignment(
        id: _oldAssignment.id,
        title: event.title,
        subject: event.subject,
        description: event.description,
        dueDate: event.dueDate,
        attachments: _attachments,
      );
      emit(AssignmentEditInProgressState());
      await _assignmentsRepository.editAssignment(assignment, _oldAssignment);

      emit(AssignmentEditedState(event.title));
    });
  }
}
