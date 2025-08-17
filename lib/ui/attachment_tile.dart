import 'package:assignmate/ext/pad.dart';
import 'package:flutter/material.dart';

class AttachmentTile extends StatelessWidget {

  final String name;
  final Icon icon;
  final void Function() onAction;
  final void Function() onClick;

  const AttachmentTile({super.key, required this.name, required this.icon, required this.onAction, required this.onClick});

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onClick,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.file_open),
                  SizedBox(width: 8),
                  Text(name, style: Theme.of(context).textTheme.bodyLarge)
                ],
              ).pad(16),
              IconButton(
                onPressed: onAction,
                icon: icon,
              ).pad(16)
            ],
          ),
          Divider(height: 1)
        ],
      ),
    );
  }
}
