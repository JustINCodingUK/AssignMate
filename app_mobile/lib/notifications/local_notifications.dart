import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

class LocalNotificationManager {
  late final FlutterLocalNotificationsPlugin localNotificationsPlugin;
  static LocalNotificationManager? _instance;

  static Future<LocalNotificationManager> get() async {
    if (_instance == null) {
      initializeTimeZones();
      _instance = LocalNotificationManager._();
      _instance!.localNotificationsPlugin = FlutterLocalNotificationsPlugin();
      const androidSettings = AndroidInitializationSettings(
        "@mipmap/ic_launcher",
      );
      const settings = InitializationSettings(android: androidSettings);
      await _instance!.localNotificationsPlugin.initialize(settings);
    }
    return _instance!;
  }

  LocalNotificationManager._();

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
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> createNotification(String title, String body) async {
    final androidDetails = AndroidNotificationDetails(
      "assignmate_update",
      "Offline Changes",
      channelDescription: "Some changes were made while you were offline",
      importance: Importance.max,
      priority: Priority.max,
    );
    await localNotificationsPlugin.show(
      Random().nextInt(10000),
      title,
      body,
      NotificationDetails(android: androidDetails),
    );
  }

  Future<void> cancelNotification(int id) async {
    await localNotificationsPlugin.cancel(id);
  }
}
