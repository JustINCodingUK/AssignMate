import 'package:assignmate/ext/date.dart';
import 'package:assignmate/ext/pad.dart';
import 'package:flutter/material.dart';

import '../model/assignment.dart';

class AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final void Function() onCompletionMarked;
  final void Function() onClick;

  const AssignmentCard(
    this.assignment, {
    super.key,
    required this.onClick,
    required this.onCompletionMarked,
  });

  @override
  Widget build(BuildContext context) {
    final buttonLabel = assignment.isCompleted
        ? "Mark Incomplete"
        : "Mark Complete";

    return Card(
      shape: !assignment.isCompleted
          ? RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            )
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onClick,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded),
                    SizedBox(width: 8),
                    Text(
                      "Due: ${assignment.dueDate.date()}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Chip(
                  label: Text(
                    assignment.subject,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              assignment.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.attachment),
                    SizedBox(width: 8),
                    Text(
                      "${assignment.attachments.length} Attachments",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                FilledButton(
                  onPressed: onCompletionMarked,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    )
                  ),
                  child: Text(buttonLabel)
                ),
              ],
            ),
          ],
        ).pad(16),
      ),
    ).pad(8);
  }
}
