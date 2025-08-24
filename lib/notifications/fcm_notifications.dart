import 'package:assignmate/bloc/assignments_bloc.dart';
import 'package:assignmate/bloc/events/assignment_event.dart';
import 'package:assignmate/data/assignment_repository.dart';
import 'package:assignmate/data/attachment_repository.dart';
import 'package:assignmate/db/database.dart';
import 'package:assignmate/network/firestore_client.dart';
import 'package:assignmate/network/google_api_client.dart';
import 'package:assignmate/notifications/local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> _handleFcmPayload(RemoteMessage message) async {
  final db = await getDatabase();

  final attachmentRepository = AttachmentRepository(
    FirestoreClient(),
    GoogleApiClient(),
  );
  final assignmentRepository = AssignmentsRepository(
    FirestoreClient(),
    attachmentRepository,
    db,
  );
  final payload = message.data;

  switch(payload["action"]) {
    case "create": _saveAssignment(payload["id"], assignmentRepository);
    // TODO: After merge with feature/edit
  }
}

Future<void> _saveAssignment(String id, AssignmentsRepository assignmentRepository) async {
  final assignment = await assignmentRepository.getAssignment(id);

  await assignmentRepository.saveAssignment(assignment);
  final localNotificationManager = await LocalNotificationManager.get();
  await localNotificationManager.scheduleNotification(
    assignment.id.hashCode & 0x7FFFFFFF,
    "New Assignment",
    assignment.title,
    assignment.dueDate,
  );
}

class FCMNotificationManager {
  final fcm = FirebaseMessaging.instance;

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
    fcm.subscribeToTopic("cs6");
    FirebaseMessaging.onMessage.listen((message) {
      _handleFcmPayload(message);
      if (context.mounted) {
        try {
          context.read<AssignmentsBloc>().add(
            GetAssignmentsEvent(),
          );
        } catch (e) {}
      }
    });
  }
}
