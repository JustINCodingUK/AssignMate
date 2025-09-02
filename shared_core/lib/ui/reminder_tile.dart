import '../ext/pad.dart';
import '../model/reminder.dart';
import 'package:flutter/material.dart';

class ReminderTile extends StatelessWidget {
  final Reminder reminder;

  const ReminderTile({super.key, required this.reminder});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            reminder.isRead
                ? Icon(Icons.notifications)
                : Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 24,
                      minHeight: 24,
                    ),
                  ),
            const SizedBox(width: 8),
            Text(
              reminder.content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: reminder.isRead
                    ? FontWeight.normal
                    : FontWeight.bold,
              ),
            ),
          ],
        ).pad(8),

        Divider(thickness: 2)
      ],
    );
  }
}
