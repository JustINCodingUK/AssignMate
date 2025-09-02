import 'dart:io';

import 'events/assignment_details_event.dart';
import 'states/assignment_details_state.dart';
import '../data/assignment_repository.dart';
import '../model/assignment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignmentDetailsBloc
    extends Bloc<AssignmentDetailsEvent, AssignmentDetailsState> {
  late Assignment _assignment;
  File? _recording;
  final AssignmentsRepository _assignmentsRepository;

  AssignmentDetailsBloc(this._assignmentsRepository) : super(AssignmentDetailsLoadingState()) {
    on<GetAssignmentEvent>((event, emit) async {
      emit(AssignmentDetailsLoadingState());
      _assignment = await _assignmentsRepository.getLocalAssignmentById(event.id);
      if(_assignment.recording!=null) {
        _recording = await _assignmentsRepository.getAttachment(_assignment.recording!);
      }
      emit(AssignmentDetailsLoadedState(_assignment, recording: _recording));
    });

    on<DownloadFileEvent>((event, emit) async {
      emit(FileDownloadingState(_assignment, recording: _recording, loadingId: event.id));
      final attachment = _assignment.attachments.where((e) => e.id == event.id);
      final file = await _assignmentsRepository.getAttachment(attachment.first);
      emit(FileDownloadedState(file, _assignment, recording: _recording));
    });

    on<DeleteAssignmentEvent>((event, emit) async {
      await _assignmentsRepository.deleteAssignment(_assignment);
      emit(DeletionSuccessfulState());
    });
  }
}
