import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

class LocalNotificationManager {
  late final FlutterLocalNotificationsPlugin localNotificationsPlugin;

  Future<void> init() async {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );
    const settings = InitializationSettings(android: androidSettings);
    await localNotificationsPlugin.initialize(settings);
  }

  Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime time,
  ) async {
    final androidDetails = AndroidNotificationDetails(
      "assignmate_assignment_due",
      "Assignments Due",
      channelDescription: "Reminder for assignments due tomorrow",
      importance: Importance.max,
      priority: Priority.max,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      TZDateTime.now(local).add(time.difference(DateTime.now())),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
