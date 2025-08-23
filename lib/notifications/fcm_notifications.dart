import 'package:assignmate/bloc/assignments_bloc.dart';
import 'package:assignmate/bloc/events/assignment_event.dart';
import 'package:assignmate/data/assignment_repository.dart';
import 'package:assignmate/data/attachment_repository.dart';
import 'package:assignmate/db/database.dart';
import 'package:assignmate/db/entity/assignment_entity.dart';
import 'package:assignmate/db/entity/attachment_entity.dart';
import 'package:assignmate/ext/date.dart';
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

  final assignmentEntity = AssignmentEntity(
    id: assignment.id,
    title: assignment.title,
    subject: assignment.subject,
    description: assignment.description,
    dueDate: assignment.dueDate.date(),
    isCompleted: false,
  );

  assignment.attachments.map((it) async {
    final attachment = AttachmentEntity(
      id: it.id,
      assignmentId: assignment.id,
      driveFileId: it.driveFileId,
      filename: it.filename,
      uri: it.uri.toString(),
    );
    await assignmentRepository.db.attachmentDao.insertAttachment(attachment);
  });

  await assignmentRepository.db.assignmentDao.insertAssignment(assignmentEntity);
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
    FirebaseMessaging.onBackgroundMessage(_handleFcmPayload);
  }

  void registerForegroundCallback(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      _handleFcmPayload(message);
      if (context.mounted) {
        try {
          context.read<AssignmentsBloc>().add(
            GetAssignmentsEvent(pendingOnly: true),
          );
        } catch (e) {}
      }
    });
  }
}
