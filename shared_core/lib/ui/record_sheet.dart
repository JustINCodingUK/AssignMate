import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart' as rec;

class AudioRecorderSheet {
  static Future<String?> show(BuildContext context) async {
    final record = rec.AudioRecorder();
    final recConfig = rec.RecordConfig();
    String? path;

    return showModalBottomSheet<String>(
      context: context,
      builder: (ctx) {
        bool isRecording = false;

        return StatefulBuilder(
          builder: (ctx, setState) {
            Future<void> toggleRecording() async {
              if (isRecording) {
                // Stop recording
                path = await record.stop();
                setState(() => isRecording = false);
                if(ctx.mounted) {
                  Navigator.pop(ctx, path); // return the URI
                }
              } else {
                // Start recording
                if (await record.hasPermission()) {
                  final directory = await getTemporaryDirectory();
                  final recFile = File("${directory.path}/audio.m4a");
                  await record.start(recConfig, path: recFile.path);
                  setState(() => isRecording = true);
                }
              }
            }

            return Container(
              padding: const EdgeInsets.all(20),
              height: 200,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: toggleRecording,
                  icon: Icon(isRecording ? Icons.stop : Icons.mic),
                  label: Text(isRecording ? "Stop Recording" : "Start Recording"),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
