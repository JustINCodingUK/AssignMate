import 'package:app_desktop/network/firestore_client.dart';
import 'package:app_desktop/network/google_api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/bloc/auth_bloc.dart';
import 'package:shared_core/data/assignment_repository.dart';
import 'package:shared_core/data/attachment_repository.dart';
import 'package:shared_core/data/reminders_repository.dart';
import 'package:shared_core/db/database.dart';
import 'package:shared_core/theme/theme.dart';
import 'package:shared_core/theme/util.dart';

void main() async {
  final db = await getDatabase();

  runApp(AssignMateDesktopApplication(db: db));
}

class AssignMateDesktopApplication extends StatelessWidget {
  final AppDatabase db;

  const AssignMateDesktopApplication({super.key, required this.db});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final textTheme = createTextTheme(context, "Nunito", "Montserrat");
    final theme = MaterialTheme(textTheme);

    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(DesktopGoogleApiClient()),
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => AssignmentsRepository(
              DesktopFirestoreClient(),
              AttachmentRepository(
                DesktopFirestoreClient(),
                context.read<AuthBloc>().googleApiClient,
              ),
              db,
            ),
          ),

          RepositoryProvider(
            create: (context) => RemindersRepository(
              db: db,
              firestoreClient: DesktopFirestoreClient(),
            ),
          ),
        ],
        child: MaterialApp(
          theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        ),
      ),
    );
  }
}
