import 'dart:isolate';

import 'package:assignmate/bloc/events/reminders_event.dart';
import 'package:assignmate/bloc/states/reminders_state.dart';
import 'package:assignmate/data/reminders_repository.dart';
import 'package:assignmate/ext/date.dart';
import 'package:assignmate/model/reminder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemindersBloc extends Bloc<RemindersEvent, RemindersState> {
  final RemindersRepository _remindersRepository;

  RemindersBloc(this._remindersRepository) : super(RemindersLoadingState()) {
    on<GetRemindersEvent>((event, emit) async {
      final reminders = await _remindersRepository.getReminders();
      Isolate.run(
        () => _remindersRepository.deleteOutdatedReminders(event.isAdmin),
      );
      emit(RemindersLoadedState(reminders));
    });

    on<ReadRemindersEvent>((event, emit) async {
      await _remindersRepository.markAllAsRead();
    });

    on<CreateReminderEvent>((event, emit) async {
      final currentDateTime = DateTime.now();
      final currentDate = DateTime(currentDateTime.year, currentDateTime.month, currentDateTime.day);
      final reminder = Reminder(
        id: "0",
        content: event.content,
        creationDate: currentDate,
      );
      await _remindersRepository.createReminder(reminder);
    });
  }
}
