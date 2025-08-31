import 'package:assignmate/db/database.dart';
import 'package:assignmate/db/entity/reminder_entity.dart';
import 'package:assignmate/model/reminder.dart';
import 'package:assignmate/network/firestore_client.dart';

class RemindersRepository {

  final AppDatabase db;
  final FirestoreClient<Reminder> firestoreClient;

  RemindersRepository({required this.db, required this.firestoreClient});

  Future<void> createReminder(Reminder reminder) async {
    final newReminder = await firestoreClient.createDocument(reminder);
    await db.reminderDao.insertReminder(newReminder.toEntity());
  }

  Future<void> saveReminder(Reminder reminder) async {
    await db.reminderDao.insertReminder(reminder.toEntity());
  }

  Future<List<Reminder>> getReminders() async {
    final reminders = await db.reminderDao.getReminders();
    return reminders.map((it) => it.toModel()).toList();
  }

  Future<void> markAllAsRead() async {
    await db.reminderDao.markAllAsRead();
  }

  Future<bool> areRemindersUnread() async {
    final unreadCount = await db.reminderDao.getUnreadRemindersCount();
    return unreadCount != null && unreadCount > 0;
  }

  Future<void> deleteOutdatedReminders(bool isAdmin) async {
    final reminders = await getReminders();
    final today = DateTime.now();
    for(var reminder in reminders) {
      if(today.difference(reminder.creationDate).inHours > 24) {
        await db.reminderDao.deleteReminder(reminder.toEntity());
        if(isAdmin) {
          await firestoreClient.deleteDocument(reminder.id);
        }
      }
    }
  }
}