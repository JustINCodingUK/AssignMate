import 'dart:io';

import 'package:assignmate/bloc/states/assignment_creation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/assignment_repository.dart';
import '../data/attachment_repository.dart';
import '../model/assignment.dart';
import '../model/attachment.dart';
import '../network/firestore_client.dart';
import '../network/google_api_client.dart';
import 'events/assignment_creation_event.dart';

class AssignmentCreationBloc
    extends Bloc<AssignmentCreationEvent, AssignmentCreationState> {
  final GoogleApiClient _driveClient;
  final _firestoreAssignmentClient = FirestoreClient<Assignment>();
  final _firestoreAttachmentClient = FirestoreClient<Attachment>();
  late final AttachmentRepository _attachmentRepository;
  late final AssignmentsRepository _assignmentsRepository;

  final _attachments = <File>[];
  final List<String> subjects;
  Uri? _recording;

  AssignmentCreationBloc(
    super.initialState,
    this._driveClient,
    this.subjects,
  ) {
    _attachmentRepository = AttachmentRepository(
      _firestoreAttachmentClient,
      _driveClient,
    );
    _assignmentsRepository = AssignmentsRepository(
      _firestoreAssignmentClient,
      _attachmentRepository,
    );

    on<FileUploadEvent>((event, emit) {
      _attachments.addAll(event.files);
      emit(
        AssignmentCreationInitialState(
          availableSubjects: subjects,
          attachments: _attachments,
          audioRecording: _recording,
        ),
      );
    });

    on<FileDeleteEvent>((event, emit) {
      _attachments.remove(event.file);
      emit(
        AssignmentCreationInitialState(
          availableSubjects: subjects,
          attachments: _attachments,
          audioRecording: _recording,
        ),
      );
    });

    on<AddRecordingEvent>((event, emit) {
      _recording = event.uri;
      _attachments.add(File(event.uri.path));
      emit(
        AssignmentCreationInitialState(
          availableSubjects: subjects,
          attachments: _attachments,
          audioRecording: _recording,
        ),
      );
    });

    on<RemoveRecordingEvent>((event, emit) {
      _recording = null;
      _attachments.removeWhere((element) => element.path == _recording?.path);
      emit(
        AssignmentCreationInitialState(
          availableSubjects: subjects,
          attachments: _attachments,
          audioRecording: _recording,
        ),
      );
    });

    on<CreateAssignmentEvent>((event, emit) async {
      final assignmentNoFiles = Assignment(
        id: "0",
        title: event.title,
        subject: event.subject,
        dueDate: event.dueDate,
        description: event.description,
        attachments: [],
      );

      emit(AssignmentInCreationState(_attachments));

      final assignment = await _assignmentsRepository.createAssignment(
        assignmentNoFiles,
        _attachments,
        _recording == null ? null : File(_recording!.path),
      );

      emit(AssignmentCreatedState(assignment, _attachments));
    });

    on<DeleteAssignmentEvent>((event, emit) async {
      await _assignmentsRepository.deleteAssignment(event.id);
      emit(DeletionSuccessfulState());
    });
  }
}
