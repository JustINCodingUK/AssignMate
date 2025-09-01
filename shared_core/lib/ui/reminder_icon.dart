import 'package:flutter/material.dart';

class ReminderIcon extends StatelessWidget {
  final bool isUnread;

  const ReminderIcon({super.key, required this.isUnread});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Icon(Icons.notifications),
        if (isUnread)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
            ),
          )
      ],
    );
  }
}
