import 'package:assignmate/bloc/assignment_details_bloc.dart';
import 'package:assignmate/ext/pad.dart';
import 'package:assignmate/ui/attachment_tile.dart';
import 'package:assignmate/ui/attachments_list.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/events/assignment_details_event.dart';
import '../bloc/states/assignment_details_state.dart';

class AssignmentDetailsRoute extends StatefulWidget {
  final String assignmentId;

  const AssignmentDetailsRoute({super.key, required this.assignmentId});

  @override
  State<AssignmentDetailsRoute> createState() => AssignmentDetailsRouteState();
}

class AssignmentDetailsRouteState extends State<AssignmentDetailsRoute> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AssignMate")),

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

                state.recording != null ? Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            final player = AudioPlayer();
                            if (_isPlaying) {
                              await player.stop();
                              setState(() {
                                _isPlaying = false;
                              });
                            } else {
                              await player.play(
                                UrlSource(state.recording!.path),
                              );
                              setState(() {
                                _isPlaying = true;
                              });
                            }
                          },
                          icon: _isPlaying
                              ? Icon(Icons.pause)
                              : Icon(Icons.play_arrow),
                        ),
                        Expanded(child: Text("A word of advice from the CR")),
                      ],
                    ),
                  ),
                ) : Container(),

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
                        await launchUrl(attachment.uri, mode: LaunchMode.externalApplication);
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
}
