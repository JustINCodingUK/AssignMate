import 'package:assignmate/bloc/assignment_creation_bloc.dart';
import 'package:assignmate/bloc/events/assignment_creation_event.dart';
import 'package:assignmate/ext/date.dart';
import 'package:assignmate/ext/pad.dart';
import 'package:assignmate/ui/attachments_list.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/states/assignment_creation_state.dart';

class AssignmentCreationRoute extends StatefulWidget {
  const AssignmentCreationRoute({super.key});

  @override
  State<AssignmentCreationRoute> createState() =>
      AssignmentCreationRouteState();
}

class AssignmentCreationRouteState extends State<AssignmentCreationRoute> {
  final _titleController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _subjectController = TextEditingController();
  DateTime? _dueDate;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AssignMate")),
      body: BlocConsumer<AssignmentCreationBloc, AssignmentCreationState>(
        buildWhen: (previous, current) {
          return current is AssignmentCreationBaseState;
        },
        listenWhen: (previous, current) {
          return current is AssignmentInCreationState ||
              current is AssignmentCreatedState;
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create Assignment",
                  style: Theme
                      .of(context)
                      .textTheme
                      .displayMedium,
                ).padSymmetric(horizontal: 16),

                Divider(thickness: 2).padSymmetric(vertical: 16, horizontal: 8),

                DropdownMenu(
                  dropdownMenuEntries: (state as AssignmentCreationBaseState)
                      .availableSubjects
                      .map((it) => DropdownMenuEntry(value: it, label: it))
                      .toList(),
                  controller: _subjectController,
                  label: SizedBox(width: 100, child: Text("Subject")),
                  leadingIcon: Icon(Icons.subject),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    constraints: BoxConstraints(maxWidth: 300),
                    filled: true,
                  ),
                ).padSymmetric(horizontal: 16, vertical: 8),

                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),

                    filled: true,
                  ),
                ).padSymmetric(horizontal: 16, vertical: 8),

                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),

                    filled: true,
                  ),
                ).padSymmetric(horizontal: 16, vertical: 8),

                TextField(
                  controller: _dueDateController,
                  decoration: InputDecoration(
                    labelText: "Due Date",
                    prefixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    filled: true,
                  ),
                  readOnly: true,
                  onTap: () async {
                    _dueDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (_dueDate != null) {
                      setState(() {
                        _dueDateController.text = _dueDate?.date() ?? "";
                      });
                    }
                  },
                ).padSymmetric(horizontal: 16, vertical: 8),

                state.audioRecording != null
                    ? Card(
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
                                UrlSource(state.audioRecording!.path),
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
                        Expanded(
                          child: Text(
                            "A word of advice from the CR",
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            context.read<AssignmentCreationBloc>().add(
                              RemoveRecordingEvent(),
                            );
                          },
                          icon: Icon(Icons.close),
                        ),
                      ],
                    ),
                  ),
                )
                    : Container(),

                AttachmentsList(showControls: true).pad(16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {}, child: Text("Cancel")).pad(16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AssignmentCreationBloc>().add(
                            CreateAssignmentEvent(
                                title: _titleController.text,
                                subject: _subjectController.text,
                                description: _descriptionController.text,
                                dueDate: _dueDate!
                            )
                        );
                      },
                      child: Text("Create"),
                    ).pad(16),
                  ],
                ),
              ],
            ),
          );
        },
        listener: (context, state) {
          if (state is AssignmentInCreationState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Creating Assignment"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                          "Please wait while your assignment is being created."),
                    ],
                  ),
                );
              },
            );
          } else if (state is AssignmentCreatedState) {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Assignment Created"),
                  content: Text("Assignment '${state.assignment
                      .title}' was created successfully!"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }
}
