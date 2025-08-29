import 'dart:developer';

import 'package:assignmate/bloc/assignments_bloc.dart';
import 'package:assignmate/bloc/events/assignment_event.dart';
import 'package:assignmate/data/assignment_repository.dart';
import 'package:assignmate/data/attachment_repository.dart';
import 'package:assignmate/data/reminders_repository.dart';
import 'package:assignmate/db/database.dart';
import 'package:assignmate/model/reminder.dart';
import 'package:assignmate/network/firestore_client.dart';
import 'package:assignmate/network/google_api_client.dart';
import 'package:assignmate/notifications/local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> _handleFcmPayload(RemoteMessage message) async {
  final db = await getDatabase();

  final payload = message.data;
  if (payload["action"] == "reminder") {
    final reminderRepository = RemindersRepository(
      db: db,
      firestoreClient: FirestoreClient(),
    );
    await reminderRepository.saveReminder(payload["id"]);
  } else {
    final attachmentRepository = AttachmentRepository(
      FirestoreClient(),
      GoogleApiClient(),
    );
    final assignmentRepository = AssignmentsRepository(
      FirestoreClient(),
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
    "New Assignment",
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
    "New Assignment",
    updatedAssignment.title,
    updatedAssignment.dueDate,
  );
}

Future<void> _deleteAssignment(
  String id,
  AssignmentsRepository assignmentRepository,
) async {
  await assignmentRepository.deleteAssignment(id);
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
    FirebaseMessaging.onBackgroundMessage(_handleFcmPayload);
  }

  void registerForegroundCallback(BuildContext context) {
    if (!_isForegroundRegistered) {
      fcm.subscribeToTopic("cs6");
      FirebaseMessaging.onMessage.listen((message) async {
        await _handleFcmPayload(message);
        if (context.mounted) {
          try {
            context.read<AssignmentsBloc>().add(GetAssignmentsEvent());
          } catch (e) {}
        }
      });
      _isForegroundRegistered = true;
    }
  }
}
