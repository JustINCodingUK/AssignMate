import 'dart:io';

import 'package:assignmate/bloc/assignment_creation_bloc.dart';
import 'package:assignmate/bloc/states/assignment_creation_state.dart';
import 'package:assignmate/ext/filename.dart';
import 'package:assignmate/ext/pad.dart';
import 'package:assignmate/ui/attachment_tile.dart';
import 'package:assignmate/ui/record_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/events/assignment_creation_event.dart';

class AttachmentsList extends StatelessWidget {
  final bool showControls;

  const AttachmentsList({super.key, this.showControls = false});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssignmentCreationBloc, AssignmentScreenState>(
      listenWhen: (previous, current) {
        return (previous is FileUploadingState);
      },
      listener: (context, state) {
        if (state is FileUploadingState) {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Uploading files..."),
                  ],
                ),
              );
            },
          );
        } else {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if(state is AssignmentCreationState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Attachments",
                    style: Theme.of(context).textTheme.titleMedium,
                  ).pad(16),
                  showControls
                      ? createControls(context)
                      : Container(),
                ],
              ),

              ListView.builder(
                shrinkWrap: true,
                itemCount: state.attachments.isEmpty
                    ? 1
                    : state.attachments.length,
                itemBuilder: (context, index) {
                  if (state.attachments.isEmpty) {
                    return SizedBox(
                      width: double.infinity,
                      child: Text(
                        "No Attachments, yet",
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return AttachmentTile(
                      onClick: () {},
                      name: state.attachments[index].name,
                      icon: Icon(Icons.delete),
                      onAction: () => context.read<AssignmentCreationBloc>().add(
                        FileDeleteEvent(file: state.attachments[index]),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        } else if(state is AssignmentEditStartedState) {
          return Container(); // TODO
        } else {
          return Container();
        }
      },
    );
  }

  Widget createControls(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            final fileResult = await FilePicker.platform
                .pickFiles();
            if (fileResult != null &&
                fileResult.files.isNotEmpty) {
              if (context.mounted) {
                context.read<AssignmentCreationBloc>().add(
                  FileUploadEvent(
                    files: fileResult.files
                        .map((e) => File(e.path!))
                        .toList(),
                  ),
                );
              }
            }
          },
          icon: Icon(Icons.add),
        ),

        IconButton(
          onPressed: () async {
            final uri = await AudioRecorderSheet.show(
              context,
            );
            if (uri != null) {
              if (context.mounted) {
                context.read<AssignmentCreationBloc>().add(
                  AddRecordingEvent(uri: Uri.parse(uri)),
                );
              }
            }
          },
          icon: Icon(Icons.mic),
        ),
      ],
    );
  }
}
