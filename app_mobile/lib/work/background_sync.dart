import 'package:app_mobile/network/firestore_client.dart';
import 'package:app_mobile/network/google_api_client.dart';
import 'package:app_mobile/notifications/local_notifications.dart';
import 'package:shared_core/data/assignment_repository.dart';
import 'package:shared_core/data/attachment_repository.dart';
import 'package:shared_core/db/database.dart';
import 'package:shared_core/shared_prefs/shared_prefs.dart';
import 'package:workmanager/workmanager.dart';

void workDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == "sync") {
      final db = await getDatabase();
      final attachmentRepository = AttachmentRepository(
        MobileFirestoreClient(),
        MobileGoogleApiClient(),
      );
      final assignmentRepository = AssignmentsRepository(
        MobileFirestoreClient(),
        attachmentRepository,
        db,
      );

      final updates = await assignmentRepository.performSync();
      if(updates) {
        final notifManager = await LocalNotificationManager.get();
        await notifManager.createNotification("New Changes", "Some changes were made while you were offline");
      }
    }
    return Future.value(true);
  });
}

void registerWorkManager() {
  final workManager = Workmanager();
  workManager.initialize(workDispatcher);
  workManager.registerPeriodicTask(
    "syncAssignmentsAssignmate",
    "sync",
    frequency: const Duration(hours: 2)
  );
}
