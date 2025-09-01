import 'package:shared_core/bloc/assignment_creation_bloc.dart';
import 'package:shared_core/bloc/events/assignment_creation_event.dart';
import 'package:shared_core/ext/date.dart';
import 'package:shared_core/ui/assignment_creation_form.dart';
import 'package:shared_core/ui/creation_alert_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_core/bloc/states/assignment_creation_state.dart';

class AssignmentCreationRoute extends StatefulWidget {
  final bool isEditMode;
  final String? oldAssignmentId;

  const AssignmentCreationRoute({
    super.key,
    required this.isEditMode,
    this.oldAssignmentId,
  });

  @override
  State<AssignmentCreationRoute> createState() =>
      AssignmentCreationRouteState();
}

class AssignmentCreationRouteState extends State<AssignmentCreationRoute> {
  final _titleController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _subjectController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AssignMate")),
      body: BlocConsumer<AssignmentCreationBloc, AssignmentCreationState>(
        buildWhen: (previous, current) {
          return current is AssignmentCreationInitialState;
        },
        listenWhen: (previous, current) {
          return current is AssignmentInCreationState ||
              current is AssignmentCreatedState;
        },
        builder: (context, state) {
          if (state is AssignmentCreationInitialState) {
            return AssignmentCreationForm(
              titleController: _titleController,
              descriptionController: _descriptionController,
              dueDateController: _dueDateController,
              subjectController: _subjectController,
              isEditMode: false,
              audioRecording: state.audioRecording,
              showCustomAttachments: true,
              onSubmit: () {
                context.read<AssignmentCreationBloc>().add(
                  CreateAssignmentEvent(
                    title: _titleController.text,
                    subject: _subjectController.text,
                    description: _descriptionController.text,
                    dueDate: _dueDateController.text.asDate(),
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        },
        listener: (context, state) {
          if (state is AssignmentInCreationState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => createWaitingAlertDialog(false),
            );
          } else if (state is AssignmentCreatedState) {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => createConfirmationAlertDialog(context, false, state.assignment.title),
            );
          }
        },
      ),
    );
  }
}
