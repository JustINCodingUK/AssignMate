import 'package:assignmate/bloc/states/assignment_state.dart';
import 'package:assignmate/data/assignment_repository.dart';
import 'package:assignmate/model/assignment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events/assignment_event.dart';

class AssignmentsBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final AssignmentsRepository _assignmentsRepository;

  final _assignments = <Assignment>[];

  AssignmentsBloc(super.initialState, this._assignmentsRepository) {

    on<GetAssignmentsEvent>((event, emit) async {
      emit(AssignmentsLoadingState());
      _assignmentsRepository.getLocalAssignments().listen((it) {
        _assignments.add(it);
        emit(AssignmentsLoadedState(_assignments));
      });
    });
  }
}
