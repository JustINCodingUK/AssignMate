import 'package:assignmate/bloc/assignment_edit_bloc.dart';
import 'package:assignmate/ext/date.dart';
import 'package:assignmate/ext/pad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'attachments_list.dart';
import 'media_player_card.dart';

class AssignmentCreationForm extends StatefulWidget {
  final bool isEditMode;
  final String? oldAssignmentId;

  final Uri? audioRecording;
  final void Function() onSubmit;

  final bool showCustomAttachments;
  final Widget? attachmentList;

  final TextEditingController _titleController;
  final TextEditingController _dueDateController;
  final TextEditingController _descriptionController;
  final TextEditingController _subjectController;

  const AssignmentCreationForm({
    super.key,
    required this.isEditMode,
    this.oldAssignmentId,
    this.audioRecording,
    this.attachmentList,
    required this.onSubmit,
    required TextEditingController titleController,
    required TextEditingController dueDateController,
    required TextEditingController descriptionController,
    required TextEditingController subjectController,
    this.showCustomAttachments = false,
  }) : _titleController = titleController,
       _dueDateController = dueDateController,
       _descriptionController = descriptionController,
       _subjectController = subjectController;

  @override
  State<AssignmentCreationForm> createState() => AssignmentCreationFormState();
}

class AssignmentCreationFormState extends State<AssignmentCreationForm> {
  DateTime? _dueDate;

  @override
  Widget build(BuildContext context) {
    final subjects = widget.isEditMode
        ? context.read<AssignmentEditBloc>().subjects
        : context.read<AssignmentEditBloc>().subjects;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.isEditMode ? "Edit" : "Create"} Assignment",
            style: Theme.of(context).textTheme.displayMedium,
          ).padSymmetric(horizontal: 16),

          Divider(thickness: 2).padSymmetric(vertical: 16, horizontal: 8),

          DropdownMenu(
            dropdownMenuEntries:
                subjects
                .map((it) => DropdownMenuEntry(value: it, label: it))
                .toList(),
            controller: widget._subjectController,
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
            controller: widget._titleController,
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
            controller: widget._descriptionController,
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
            controller: widget._dueDateController,
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
                  widget._dueDateController.text = _dueDate?.date() ?? "";
                });
              }
            },
          ).padSymmetric(horizontal: 16, vertical: 8),

          widget.audioRecording != null
              ? MediaPlayerCard(
                  source: widget.audioRecording!,
                  isRemovable: true,
                )
              : Container(),

          widget.showCustomAttachments
              ? AttachmentsList(showControls: true).pad(16)
              : widget.attachmentList!,

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () {}, child: Text("Cancel")).pad(16),
              ElevatedButton(
                onPressed: widget.onSubmit,
                child: Text(widget.isEditMode ? "Edit" : "Create"),
              ).pad(16),
            ],
          ),
        ],
      ),
    );
  }
}
