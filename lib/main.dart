import 'dart:developer';

import 'package:assignmate/bloc/auth_bloc.dart';
import 'package:assignmate/bloc/events/auth_event.dart';
import 'package:assignmate/data/assignment_repository.dart';
import 'package:assignmate/data/attachment_repository.dart';
import 'package:assignmate/db/database.dart';
import 'package:assignmate/firebase_options.dart';
import 'package:assignmate/nav.dart';
import 'package:assignmate/network/firestore_client.dart';
import 'package:assignmate/notifications/fcm_notifications.dart';
import 'package:assignmate/theme/theme.dart';
import 'package:assignmate/theme/util.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/reminders_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate();
  final appDb = await getDatabase();

  final fcmNotificationManager = FCMNotificationManager.get();

  await fcmNotificationManager.checkPermission();
  fcmNotificationManager.registerBackgroundCallback();

  runApp(AssignMateApplication(db: appDb));
}

class AssignMateApplication extends StatelessWidget {
  final AppDatabase db;

  const AssignMateApplication({
    super.key,
    required this.db
  });

  @override
  Widget build(BuildContext context) {

    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final textTheme = createTextTheme(context, "Nunito", "Montserrat");
    final theme = MaterialTheme(textTheme);

    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc()..add(AuthCheckEvent()),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => AssignmentsRepository(
              FirestoreClient(),
              AttachmentRepository(
                FirestoreClient(),
                context.read<AuthBloc>().googleApiClient,
              ),
              db,
            ),
          ),

          RepositoryProvider(
            create: (context) => RemindersRepository(
              db: db,
              firestoreClient: FirestoreClient(),
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
