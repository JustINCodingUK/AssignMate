import 'package:flutter/material.dart';

AlertDialog createWaitingAlertDialog(bool isEditMode) {
  return AlertDialog(
    title: Text(
      isEditMode
          ? "Editing Assignment"
          : "Creating Assignment",
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text(
          "Please wait while your assignment is being ${isEditMode ? "edited" : "created"}.",
        ),
      ],
    ),
  );
}

AlertDialog createConfirmationAlertDialog(BuildContext context, bool isEditMode, String title) {
  return AlertDialog(
    title: Text(
      "Assignment ${isEditMode ? "Edited" : "Created"}",
    ),
    content: Text(
      "Assignment '$title was ${isEditMode ? "edited" : "created"} successfully!",
    ),
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
}