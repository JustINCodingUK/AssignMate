import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/assignment_creation_bloc.dart';
import '../bloc/events/assignment_creation_event.dart';

class MediaPlayerCard extends StatefulWidget {
  final Uri source;
  final bool isRemovable;

  const MediaPlayerCard({
    super.key,
    required this.source,
    this.isRemovable = false,
  });

  @override
  State<MediaPlayerCard> createState() => _MediaPlayerCardState();
}

class _MediaPlayerCardState extends State<MediaPlayerCard> {
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () async {
                final player = AudioPlayer();
                if (_isPlaying) {
                  await player.stop();
                  setState(() {
                    _isPlaying = false;
                  });
                } else {
                  await player.play(UrlSource(widget.source.path));
                  setState(() {
                    _isPlaying = true;
                  });
                }
              },
              icon: _isPlaying ? Icon(Icons.pause) : Icon(Icons.play_arrow),
            ),
            Expanded(child: Text("A word of advice from the CR")),
            widget.isRemovable
                ? IconButton(
                    onPressed: () {
                      context.read<AssignmentCreationBloc>().add(
                        RemoveRecordingEvent(),
                      );
                    },
                    icon: Icon(Icons.close),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
