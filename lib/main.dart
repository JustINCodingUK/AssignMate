import 'package:assignmate/bloc/auth_bloc.dart';
import 'package:assignmate/bloc/events/auth_event.dart';
import 'package:assignmate/data/assignment_repository.dart';
import 'package:assignmate/data/attachment_repository.dart';
import 'package:assignmate/db/database.dart';
import 'package:assignmate/firebase_options.dart';
import 'package:assignmate/nav.dart';
import 'package:assignmate/network/firestore_client.dart';
import 'package:assignmate/theme/theme.dart';
import 'package:assignmate/theme/util.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final appDb = await getDatabase();
  runApp(AssignmateApplication(appDb));
}

class AssignmateApplication extends StatelessWidget {

  final AppDatabase db;

  const AssignmateApplication(this.db, {super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final textTheme = createTextTheme(context, "Nunito", "Montserrat");
    final theme = MaterialTheme(textTheme);

    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc()..add(AuthCheckEvent()),
      child: RepositoryProvider<AssignmentsRepository>(
        create: (context) => AssignmentsRepository(
          FirestoreClient(),
          AttachmentRepository(
            FirestoreClient(),
            context.read<AuthBloc>().googleApiClient,
          ),
          db
        ),
        child: MaterialApp.router(
          theme: brightness == Brightness.light ? theme.light() : theme.dark(),
          routerConfig: router,
        ),
      ),
    );
  }
}
