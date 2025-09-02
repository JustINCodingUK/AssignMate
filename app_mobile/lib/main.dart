import 'dart:developer';

import 'package:app_mobile/network/firestore_client.dart';
import 'package:app_mobile/network/google_api_client.dart';
import 'package:app_mobile/work/background_sync.dart';
import 'package:shared_core/bloc/auth_bloc.dart';
import 'package:shared_core/bloc/events/auth_event.dart';
import 'package:shared_core/data/assignment_repository.dart';
import 'package:shared_core/data/attachment_repository.dart';
import 'package:shared_core/db/database.dart';
import 'firebase_options.dart';
import 'nav.dart';
import 'notifications/fcm_notifications.dart';
import 'package:shared_core/theme/theme.dart';
import 'package:shared_core/theme/util.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_core/data/reminders_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate();
  final appDb = await getDatabase();

  final fcmNotificationManager = FCMNotificationManager.get();

  await fcmNotificationManager.checkPermission();
  fcmNotificationManager.registerBackgroundCallback();
  registerWorkManager();
  runApp(AssignMateMobileApplication(db: appDb));
}

class AssignMateMobileApplication extends StatelessWidget {
  final AppDatabase db;

  const AssignMateMobileApplication({
    super.key,
    required this.db
  });

  @override
  Widget build(BuildContext context) {

    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final textTheme = createTextTheme(context, "Nunito", "Montserrat");
    final theme = MaterialTheme(textTheme);

    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(MobileGoogleApiClient())..add(AuthCheckEvent()),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => AssignmentsRepository(
              MobileFirestoreClient(),
              AttachmentRepository(
                MobileFirestoreClient(),
                context.read<AuthBloc>().googleApiClient,
              ),
              db,
            ),
          ),

          RepositoryProvider(
            create: (context) => RemindersRepository(
              db: db,
              firestoreClient: MobileFirestoreClient(),
            ),
          )
        ],
        child: MaterialApp.router(
          theme: brightness == Brightness.light ? theme.light() : theme.dark(),
          routerConfig: router,
        ),
      ),
    );
  }
}
