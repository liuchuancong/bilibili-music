import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart' as media_kit_video;
import 'package:bilibilimusic/modules/live_play/widgets/video_player/video_controller.dart';

class VideoPlayer extends StatefulWidget {
  final VideoController controller;

  const VideoPlayer({
    super.key,
    required this.controller,
  });

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  bool hasRender = false;

  @override
  Widget build(BuildContext context) {
    return media_kit_video.Video(
      key: widget.controller.key,
      controller: widget.controller.mediaPlayerController,
      controls: media_kit_video.MaterialVideoControls,
    );
  }
}
