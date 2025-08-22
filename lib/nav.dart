import 'package:assignmate/bloc/assignment_creation_bloc.dart';
import 'package:assignmate/bloc/assignment_details_bloc.dart';
import 'package:assignmate/bloc/assignment_edit_bloc.dart';
import 'package:assignmate/bloc/auth_bloc.dart';
import 'package:assignmate/bloc/events/assignment_details_event.dart';
import 'package:assignmate/bloc/events/assignment_edit_event.dart';
import 'package:assignmate/bloc/states/assignment_creation_state.dart';
import 'package:assignmate/data/assignment_repository.dart';
import 'package:assignmate/routes/assignment_creation_route.dart';
import 'package:assignmate/routes/assignment_details_route.dart';
import 'package:assignmate/routes/assignment_edit_route.dart';
import 'package:assignmate/routes/assignments_route.dart';
import 'package:assignmate/routes/auth_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum Routes {
  auth,
  home,
  create,
  details,
  edit;

  String route({String arg = ""}) {
    switch (this) {
      case Routes.auth:
        return "/auth";
      case Routes.home:
        return "/";
      case Routes.create:
        return "/create";
      case Routes.details:
        return "/details/$arg";
      case Routes.edit:
        return "/edit/$arg";
    }
  }
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => AssignmentsRoute(section: "CS06"),
    ),
    GoRoute(
      path: "/create",
      builder: (context, state) {
        return BlocProvider<AssignmentCreationBloc>(
          create: (context) => AssignmentCreationBloc(
            AssignmentCreationInitialState(
              availableSubjects: ["EC101", "CO101", "CS103", "ME105", "AM101"],
            ),
            ["EC101", "CO101", "CS103", "ME105", "AM101"],
            context.read<AssignmentsRepository>()
          ),
          child: AssignmentCreationRoute(isEditMode: false),
        );
      },
    ),
    GoRoute(path: "/auth", builder: (context, state) => AuthRoute()),
    GoRoute(
      path: "/details/:id",
      builder: (context, state) {
        return BlocProvider(
          create: (context) =>
              AssignmentDetailsBloc(context.read<AssignmentsRepository>())
                ..add(GetAssignmentEvent(state.pathParameters["id"]!)),
          child: AssignmentDetailsRoute(
            assignmentId: state.pathParameters["id"]!,
          ),
        );
      },
    ),
    GoRoute(
      path: "/edit/:id",
      builder: (context, state) {
        String id = state.pathParameters["id"]!;
        return BlocProvider<AssignmentEditBloc>(
          create: (context) => AssignmentEditBloc(
            context.read<AssignmentsRepository>(),
            ["EC101", "CO101", "CS103", "ME105", "AM101"],
          )..add(BeginAssignmentEditEvent(assignmentId: id)),
          child: AssignmentEditRoute(),
        );
      },
    ),
  ],
);
