import '../../model/reminder.dart';

abstract interface class RemindersState {}

class RemindersLoadedState implements RemindersState {
  List<Reminder> reminders;

  RemindersLoadedState(this.reminders);
}

class RemindersLoadingState implements RemindersState {}