import 'package:assignmate/bloc/auth_bloc.dart';
import 'package:assignmate/bloc/events/reminders_event.dart';
import 'package:assignmate/bloc/reminders_bloc.dart';
import 'package:assignmate/bloc/states/reminders_state.dart';
import 'package:assignmate/data/reminders_repository.dart';
import 'package:assignmate/ui/reminder_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RemindersRoute extends StatelessWidget {
  const RemindersRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.read<AuthBloc>().isAdmin();

    return BlocProvider<RemindersBloc>(
      create: (context) =>
          RemindersBloc(context.read<RemindersRepository>())
            ..add(GetRemindersEvent(isAdmin)),

      child: Scaffold(
        appBar: AppBar(
          title: Text("AssignMate: Reminders"),
          actions: [
            isAdmin
                ? IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) =>
                          createNewReminderAlertDialog(context),
                    ),
                    icon: Icon(Icons.add),
                  )
                : Container(),
          ],
        ),
        body: BlocBuilder<RemindersBloc, RemindersState>(
          builder: (context, state) {
            if (state is RemindersLoadedState) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.reminders.length,
                itemBuilder: (context, index) {
                  final reminder = state.reminders[index];
                  return ReminderTile(reminder: reminder);
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  AlertDialog createNewReminderAlertDialog(BuildContext context) {
    final TextEditingController reminderController = TextEditingController();

    return AlertDialog(
      title: Text("Create New Reminder"),
      content: TextField(
        controller: reminderController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
          label: Text("Content"),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text("Create"),
          onPressed: () {
            final reminderText = reminderController.text;
            if (reminderText.isNotEmpty) {
              context.read<RemindersBloc>().add(
                CreateReminderEvent(reminderText),
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
