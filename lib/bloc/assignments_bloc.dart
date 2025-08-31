import 'package:assignmate/bloc/states/assignment_state.dart';
import 'package:assignmate/data/assignment_repository.dart';
import 'package:assignmate/data/reminders_repository.dart';
import 'package:assignmate/ext/date_sort.dart';
import 'package:assignmate/model/assignment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events/assignment_event.dart';

class AssignmentsBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final AssignmentsRepository _assignmentsRepository;
  final RemindersRepository _remindersRepository;

  final _assignments = <Assignment>[];
  bool _unreadCached = false;
  bool _isPendingMode = true;

  AssignmentsBloc(super.initialState, this._assignmentsRepository, this._remindersRepository) {

    on<AssignmentsInitEvent>((event, emit) async {
      await _assignmentsRepository.refreshAssignments();
      add(GetAssignmentsEvent());
    });

    on<GetAssignmentsEvent>((event, emit) async {
      emit(AssignmentsLoadingState());
      final assignments = await _assignmentsRepository.getLocalAssignments();
      _unreadCached = await _remindersRepository.areRemindersUnread();
      _assignments.clear();
      _assignments.addAll(assignments);
      emit(AssignmentsLoadedState(_getAssignments(), _unreadCached));
    });

    on<ModifyAssignmentCompletion>((event, emit) async {
      final assignment = _assignments.where((it) => it.id == event.id).first;
      _assignments.remove(assignment);
      _assignments.add(assignment.copyWith(isCompleted: !assignment.isCompleted));
      await _assignmentsRepository.modifyAssignmentCompletion(assignment);
      emit(AssignmentsLoadedState(_getAssignments(), _unreadCached));
    });

    on<SwitchModeEvent>((event, emit) async {
      _isPendingMode = event.isPendingMode;
      emit(AssignmentsLoadedState(_getAssignments(), _unreadCached));
    });
  }

  List<Assignment> _getAssignments() {
    _assignments.sortByDate();
    if(_isPendingMode) {
      return _assignments.where((it) => !it.isCompleted).toList();
    } else {
      return _assignments.where((it) => it.isCompleted).toList();
    }
  }
}
