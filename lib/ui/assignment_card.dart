import 'package:assignmate/ext/date.dart';
import 'package:assignmate/ext/pad.dart';
import 'package:flutter/material.dart';

import '../model/assignment.dart';

@Preview(name: "Assignment Card")
class AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final void Function() onCompletionMarked;
  final void Function() onClick;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onCompletionMarked,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final buttonLabel = assignment.isCompleted
        ? "Mark\nIncomplete"
        : "Mark\nComplete";

    return Card.filled(
      shape: !assignment.isCompleted
          ? RoundedRectangleBorder(
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(32),
            )
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      elevation: 16,
      child: InkWell(
        onTap: onClick,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    assignment.subject,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  SizedBox(height: 16),

                  Text(
                    assignment.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  SizedBox(height: 16),

                  Text("Due", style: Theme.of(context).textTheme.bodyMedium),

                  SizedBox(height: 8),

                  Text(
                    assignment.dueDate.date(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 16),

                  Text("Files", style: Theme.of(context).textTheme.bodyMedium),

                  Text(
                    assignment.attachments.length.toString(),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ).pad(16),
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: onCompletionMarked,
                child: Text(buttonLabel, textAlign: TextAlign.center).pad(8),
              ).pad(16),
            ),
          ],
        ).pad(8),
      ),
    );
  }
}
