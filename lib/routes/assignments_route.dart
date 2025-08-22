import 'package:assignmate/bloc/assignments_bloc.dart';
import 'package:assignmate/bloc/auth_bloc.dart';
import 'package:assignmate/bloc/events/assignment_event.dart';
import 'package:assignmate/bloc/events/auth_event.dart';
import 'package:assignmate/data/assignment_repository.dart';
import 'package:assignmate/ext/pad.dart';
import 'package:assignmate/ui/assignment_card.dart';
import 'package:assignmate/ui/timed_greeting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/states/assignment_state.dart';
import '../bloc/states/auth_state.dart';

class AssignmentsRoute extends StatelessWidget {
  final String section;

  const AssignmentsRoute({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final isAdmin = context.read<AuthBloc>().isAdmin();

        return Scaffold(
          appBar: AppBar(
            title: Text("AssignMate: $section"),
            actions: [
              IconButton(
                onPressed: () {
                  if (!isAdmin) {
                    context.push("/auth");
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => createLogoutDialog(context),
                    );
                  }
                },
                icon: Icon(!isAdmin ? Icons.admin_panel_settings : Icons.logout),
              ),
            ],
          ),
          floatingActionButton: isAdmin
              ? FloatingActionButton(
                  onPressed: () {
                    context.push("/create");
                  },
                  child: Icon(Icons.add),
                )
              : null,
          body: BlocProvider<AssignmentsBloc>(
            create: (context) => AssignmentsBloc(
              AssignmentsLoadingState(),
              context.read<AssignmentsRepository>()
            )..add(GetAssignmentsEvent(pendingOnly: false)),
            child: BlocBuilder<AssignmentsBloc, AssignmentState>(
              builder: (context, state) {
                Widget child = Container();

                if (state is AssignmentsLoadingState) {
                  child = Center(child: CircularProgressIndicator());
                } else if (state is AssignmentsLoadedState) {
                  if (state.assignments.isEmpty) {
                    child = Center(child: Text("No assignments found"));
                  } else {
                    child = ListView.builder(
                      itemCount: state.assignments.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return AssignmentCard(
                          assignment: state.assignments[index],
                          onCompletionMarked: () {},
                          onClick: () {
                            final assignment = state.assignments[index];
                            context.push("/details/${assignment.id}");
                          },
                        ).pad(2);
                      },
                    );
                  }
                }

                return Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 25),
                        TimedGreeting(),
                        Divider(thickness: 2).padSymmetric(horizontal: 8),
                        child,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  AlertDialog createLogoutDialog(BuildContext context) {
    return AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to logout?"),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(LogoutEvent());
            context.pop();
          },
          child: Text("Logout"),
        ),
      ],
    );
  }
}
