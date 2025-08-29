abstract interface class RemindersEvent {}

class GetRemindersEvent implements RemindersEvent {
  final bool isAdmin;

  GetRemindersEvent(this.isAdmin);
}

class ReadRemindersEvent implements RemindersEvent {}

class CreateReminderEvent implements RemindersEvent {
  final String content;

  CreateReminderEvent(this.content);
}