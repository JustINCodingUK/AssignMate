import 'package:assignmate/ext/date.dart';
import 'package:assignmate/model/reminder.dart';
import 'package:floor/floor.dart';

@entity
class ReminderEntity {
  @primaryKey final String id;
  final String content;
  final bool isRead;
  final String creationDate;

  ReminderEntity({
    required this.id,
    required this.content,
    required this.isRead,
    required this.creationDate
  });
}

extension EntityToModel on ReminderEntity {
  Reminder toModel() {
    return Reminder(
      id: id,
      content: content,
      isRead: isRead,
      creationDate: creationDate.asDate()
    );
  }
}