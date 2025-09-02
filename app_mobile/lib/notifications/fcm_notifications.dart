import 'dart:developer';

import 'package:app_mobile/network/google_api_client.dart';
import 'package:shared_core/bloc/assignments_bloc.dart';
import 'package:shared_core/bloc/events/assignment_event.dart';
import 'package:shared_core/data/assignment_repository.dart';
import 'package:shared_core/data/attachment_repository.dart';
import 'package:shared_core/data/reminders_repository.dart';
import 'package:shared_core/db/database.dart';
import 'package:app_mobile/notifications/local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/firestore_client.dart';

@pragma("vm:entry-point")
Future<void> _handleBackgroundPayload(RemoteMessage message) async {
  await Firebase.initializeApp();
  await _handlePayload(message);
}

Future<void> _handlePayload(RemoteMessage message) async {
  final db = await getDatabase();
  final payload = message.data;
  if (payload["action"] == "reminder") {
    final reminderRepository = RemindersRepository(
      db: db,
      firestoreClient: MobileFirestoreClient(),
    );
    await reminderRepository.saveReminder(payload["id"]);
  } else {
    final attachmentRepository = AttachmentRepository(
      MobileFirestoreClient(),
      MobileGoogleApiClient(),
    );
    final assignmentRepository = AssignmentsRepository(
      MobileFirestoreClient(),
      attachmentRepository,
      db,
    );

    switch (payload["action"]) {
      case "create":
        await _saveAssignment(payload["id"], assignmentRepository);
      case "edit":
        await _editAssignment(payload["id"], assignmentRepository);
      case "delete":
        await _deleteAssignment(payload["id"], assignmentRepository);
    }

    await assignmentRepository.updateVersion();
  }
}

Future<void> _saveAssignment(
  String id,
  AssignmentsRepository assignmentRepository,
) async {
  final assignment = await assignmentRepository.getFirestoreAssignmentById(id);

  await assignmentRepository.saveAssignment(assignment);
  final localNotificationManager = await LocalNotificationManager.get();
  await localNotificationManager.scheduleNotification(
    assignment.id.hashCode & 0x7FFFFFFF,
    "Assignment Due Tomorrow",
    assignment.title,
    assignment.dueDate,
  );
}

Future<void> _editAssignment(
  String id,
  AssignmentsRepository assignmentRepository,
) async {
  final updatedAssignment = await assignmentRepository
      .getFirestoreAssignmentById(id);

  await assignmentRepository.updateLocalAssignment(updatedAssignment);

  final localNotificationManager = await LocalNotificationManager.get();
  await localNotificationManager.scheduleNotification(
    updatedAssignment.id.hashCode & 0x7FFFFFFF,
    "Assignment Due Tomorrow",
    updatedAssignment.title,
    updatedAssignment.dueDate,
  );
}

Future<void> _deleteAssignment(
  String id,
  AssignmentsRepository assignmentRepository,
) async {
  await assignmentRepository.deleteLocalAssignment(id);
  final localNotificationManager = await LocalNotificationManager.get();
  await localNotificationManager.cancelNotification(id.hashCode & 0x7FFFFFFF);
}

class FCMNotificationManager {
  static FCMNotificationManager? _instance;

  FCMNotificationManager._();

  static FCMNotificationManager get() {
    _instance ??= FCMNotificationManager._();
    return _instance!;
  }

  final fcm = FirebaseMessaging.instance;
  bool _isForegroundRegistered = false;

  Future<bool> checkPermission() async {
    final permissionStatus = await fcm.requestPermission();
    return permissionStatus.authorizationStatus ==
        AuthorizationStatus.authorized;
  }

  void registerBackgroundCallback() {
    fcm.subscribeToTopic("cs6");
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundPayload);
  }

  void registerForegroundCallback(BuildContext context) {
    if (!_isForegroundRegistered) {
      fcm.subscribeToTopic("cs6");
      FirebaseMessaging.onMessage.listen((message) async {
        await _handlePayload(message);
        if (context.mounted) {
          try {
            context.read<AssignmentsBloc>().add(GetAssignmentsEvent());
          } catch (e) {
            log(e.toString());
          }
        }
      });
      _isForegroundRegistered = true;
    }
  }
}
