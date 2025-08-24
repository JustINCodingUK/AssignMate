import 'dart:io';

import 'package:assignmate/bloc/assignment_edit_bloc.dart';
import 'package:assignmate/bloc/events/assignment_edit_event.dart';
import 'package:assignmate/bloc/states/assignment_edit_state.dart';
import 'package:assignmate/ext/date.dart';
import 'package:assignmate/ext/pad.dart';
import 'package:assignmate/ui/assignment_creation_form.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ui/attachment_tile.dart';
import '../ui/creation_alert_dialogs.dart';
import '../ui/record_sheet.dart';

class AssignmentEditRoute extends StatelessWidget {
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dueDateController = TextEditingController();

  AssignmentEditRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AssignMate")),

      body: BlocConsumer<AssignmentEditBloc, AssignmentEditState>(
        buildWhen: (previous, current) {
          return current is AssignmentEditBaseState ||
              current is AssignmentLoadingState;
        },
        listenWhen: (previous, current) {
          return current is AssignmentEditInProgressState ||
              current is AssignmentEditedState;
        },
        builder: (context, state) {
          if (state is AssignmentLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else {
            state as AssignmentEditBaseState;

            _titleController.text = state.oldAssignment.title;
            _subjectController.text = state.oldAssignment.subject;
            _descriptionController.text = state.oldAssignment.description;
            _dueDateController.text = state.oldAssignment.dueDate.date();

            return AssignmentCreationForm(
              isEditMode: true,
              onSubmit: () {
                context.read<AssignmentEditBloc>().add(
                    EditAssignmentEvent(
                        oldAssignmentId: state.oldAssignment.id,
                        title: _titleController.text,
                        subject: _subjectController.text,
                        description: _descriptionController.text,
                        dueDate: _dueDateController.text.asDate()
                    )
                );
              },
              audioRecording: state.recording,
              titleController: _titleController,
              dueDateController: _dueDateController,
              descriptionController: _descriptionController,
              subjectController: _subjectController,

              attachmentList: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Attachments",
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium,
                      ).pad(16),
                      createControls(context),
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
                          name: state.attachments[index].filename,
                          icon: Icon(Icons.delete),
                          onAction: () =>
                              context.read<AssignmentEditBloc>().add(
                                FileDeleteEvent(
                                    fileId: state.attachments[index].id),
                              ),
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          }
        },
        listener: (context, state) {
          if (state is AssignmentEditInProgressState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => createWaitingAlertDialog(true),
            );
          } else if (state is AssignmentEditedState) {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) =>
                  createConfirmationAlertDialog(context, true, state.title),
            );
          }
        },
      ),
    );
  }

  Widget createControls(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            final fileResult = await FilePicker.platform
                .pickFiles(allowMultiple: true);
            if (fileResult != null &&
                fileResult.files.isNotEmpty) {
              if (context.mounted) {
                context.read<AssignmentEditBloc>().add(
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
                context.read<AssignmentEditBloc>().add(
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
