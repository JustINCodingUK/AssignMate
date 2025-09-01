import 'package:shared_core/bloc/auth_bloc.dart';
import 'package:shared_core/bloc/events/reminders_event.dart';
import 'package:shared_core/bloc/reminders_bloc.dart';
import 'package:shared_core/bloc/states/reminders_state.dart';
import 'package:shared_core/data/reminders_repository.dart';
import 'package:shared_core/ui/reminder_tile.dart';
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
                      builder: (ctx) =>
                          createNewReminderAlertDialog(context, ctx),
                    ),
                    icon: Icon(Icons.add),
                  )
                : Container(),
          ],
        ),
        body: BlocBuilder<RemindersBloc, RemindersState>(
          builder: (context, state) {
            if (state is RemindersLoadedState) {
              if (state.reminders.isEmpty) {
                return Center(child: Text("No reminders for now!"));
              } else {
                context.read<RemindersBloc>().add(ReadRemindersEvent());
                return ListView.builder(
                  itemCount: state.reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = state.reminders[index];
                    return ReminderTile(reminder: reminder);
                  },
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  AlertDialog createNewReminderAlertDialog(
    BuildContext blocContext,
    BuildContext dialogContext,
  ) {
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
            Navigator.of(dialogContext).pop();
          },
        ),
        TextButton(
          child: Text("Create"),
          onPressed: () {
            final reminderText = reminderController.text;
            if (reminderText.isNotEmpty) {
              blocContext.read<RemindersBloc>().add(
                CreateReminderEvent(reminderText),
              );
              Navigator.of(dialogContext).pop();
            }
          },
        ),
      ],
    );
  }
}
