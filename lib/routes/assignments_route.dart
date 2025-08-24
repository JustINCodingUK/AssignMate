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
                icon: Icon(
                  !isAdmin ? Icons.admin_panel_settings : Icons.logout,
                ),
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
              context.read<AssignmentsRepository>(),
            )..add(AssignmentsInitEvent()),
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
                          onCompletionMarked: () {
                            final assignment = state.assignments[index];
                            if(!assignment.isCompleted) {
                              showDialog(
                                context: context,
                                builder: (ctx) => createCompletionDialog(
                                    assignment.title,
                                    assignment.id,
                                    context,
                                    ctx
                                ),
                              );
                            } else {
                              context.read<AssignmentsBloc>().add(ModifyAssignmentCompletion(assignment.id));
                            }
                          },
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
                        DefaultTabController(
                          length: 2,
                          child: Column(
                            children: [
                              TabBar(
                                tabs: [
                                  Tab(text: "Pending"),
                                  Tab(text: "Completed"),
                                ],
                                onTap: (idx) {
                                  context.read<AssignmentsBloc>().add(
                                    SwitchModeEvent(idx == 0),
                                  );
                                },
                              ),
                              SizedBox(height: 32,),
                              child,
                            ],
                          ),
                        ),
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

  AlertDialog createCompletionDialog(
    String title,
    String id,
    BuildContext blocContext,
    BuildContext dialogContext,
  ) {
    return AlertDialog(
      title: const Text("Mark as Completed"),
      content: Text("Are you sure you want to mark $title as completed?"),
      actions: [
        TextButton(
          onPressed: () {
            dialogContext.pop();
          },
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () {
            blocContext.read<AssignmentsBloc>().add(
              ModifyAssignmentCompletion(id),
            );
            dialogContext.pop();
          },
          child: const Text("Yes"),
        ),
      ],
    );
  }
}
