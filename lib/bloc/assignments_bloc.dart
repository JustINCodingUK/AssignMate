import 'dart:developer';
import 'dart:io';

import 'package:assignmate/bloc/states/assignment_state.dart';
import 'package:assignmate/data/assignment_repository.dart';
import 'package:assignmate/model/assignment.dart';
import 'package:assignmate/network/google_api_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/attachment_repository.dart';
import '../model/attachment.dart';
import '../network/firestore_client.dart';
import 'events/assignment_event.dart';

class AssignmentsBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final GoogleApiClient _driveClient;
  final _firestoreAssignmentClient = FirestoreClient<Assignment>();
  final _firestoreAttachmentClient = FirestoreClient<Attachment>();
  late final AttachmentRepository _attachmentRepository;
  late final AssignmentsRepository _assignmentsRepository;

  final _assignments = <Assignment>[];

  AssignmentsBloc(super.initialState, this._driveClient) {
    _attachmentRepository = AttachmentRepository(
      _firestoreAttachmentClient,
      _driveClient,
    );
    _assignmentsRepository = AssignmentsRepository(
      _firestoreAssignmentClient,
      _attachmentRepository,
    );

    on<GetAssignmentsEvent>((event, emit) async {
      emit(AssignmentsLoadingState());

      // TODO: DO NOT SPAM FIRESTORE, add a floor database someday, "hopefully"
      final assignments = await _assignmentsRepository.getAssignments();
      emit(AssignmentsLoadedState(assignments));
    });
  }
}
