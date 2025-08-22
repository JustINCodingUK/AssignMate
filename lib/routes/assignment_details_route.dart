import 'package:assignmate/bloc/assignment_creation_bloc.dart';
import 'package:assignmate/bloc/assignment_details_bloc.dart';
import 'package:assignmate/bloc/auth_bloc.dart';
import 'package:assignmate/bloc/events/assignment_creation_event.dart';
import 'package:assignmate/ext/pad.dart';
import 'package:assignmate/nav.dart';
import 'package:assignmate/ui/attachment_tile.dart';
import 'package:assignmate/ui/media_player_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/states/assignment_details_state.dart';

class AssignmentDetailsRoute extends StatefulWidget {
  final String assignmentId;

  const AssignmentDetailsRoute({super.key, required this.assignmentId});

  @override
  State<AssignmentDetailsRoute> createState() => AssignmentDetailsRouteState();
}

class AssignmentDetailsRouteState extends State<AssignmentDetailsRoute> {

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.read<AuthBloc>().isAdmin();

    return Scaffold(
      appBar: AppBar(
        title: Text("AssignMate"),
        actions: isAdmin
            ? [
                IconButton(
                  onPressed: () {
                    context.push(Routes.edit.route(arg: widget.assignmentId));
                  },
                  icon: Icon(Icons.edit),
                ),

                IconButton(
                  onPressed: () => createDeletionDialog(context),
                  icon: Icon(Icons.delete),
                ),
              ]
            : [],
      ),

      body: BlocBuilder<AssignmentDetailsBloc, AssignmentDetailsState>(
        builder: (context, state) {
          if (state is AssignmentDetailsLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AssignmentDetailsLoadedState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Assignment: ${state.assignment.title}",
                  style: Theme.of(context).textTheme.titleLarge,
                ).pad(16),

                Text(
                  state.assignment.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ).pad(16),

                state.recording != null
                    ? MediaPlayerCard(source: state.recording!.uri)
                    : Container(),

                Divider(thickness: 2).padSymmetric(horizontal: 8, vertical: 16),

                Text(
                  "Attachments",
                  style: Theme.of(context).textTheme.bodyMedium,
                ).pad(16),

                ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.assignment.attachments.length,
                  itemBuilder: (context, index) {
                    final attachment = state.assignment.attachments[index];
                    return AttachmentTile(
                      onClick: () async {
                        await launchUrl(
                          attachment.uri,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      name: attachment.filename,
                      icon: Icon(Icons.download),
                      onAction: () {
                        // TODO
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Feature to be implemented shortly!"),
                          ),
                        );
                      },
                    );
                  },
                ).padSymmetric(horizontal: 16, vertical: 8),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  AlertDialog createDeletionDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Assignment"),
      content: const Text(
        "Are you sure you want to delete this assignment? This action cannot be undone.",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            context.read<AssignmentCreationBloc>().add(
              DeleteAssignmentEvent(id: widget.assignmentId),
            );
            Navigator.of(context).pop();
            context.pop();
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
