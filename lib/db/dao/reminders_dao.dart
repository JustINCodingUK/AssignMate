import 'package:assignmate/db/entity/reminder_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class RemindersDao {

  @Query("SELECT * FROM ReminderEntity")
  Future<List<ReminderEntity>> getReminders();

  @Query("SELECT COUNT(*) FROM ReminderEntity WHERE isRead = 0")
  Future<int?> getUnreadRemindersCount();

  @Query("UPDATE ReminderEntity SET isRead = 1 WHERE isRead = 0")
  Future<void> markAllAsRead();

  @insert
  Future<void> insertReminder(ReminderEntity reminder);

  @delete
  Future<void> deleteReminder(ReminderEntity reminder);

}