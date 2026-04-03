import 'package:flutter/material.dart';
import 'package:bilibilimusic/common/global/platform_utils.dart';
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
  VideoController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return media_kit_video.MaterialVideoControlsTheme(
      normal: media_kit_video.MaterialVideoControlsThemeData(
        topButtonBar: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
          ),
        ],
        bottomButtonBar: [
          media_kit_video.MaterialPositionIndicator(),
          Spacer(),
          PlatformUtils.isAndroid
              ? media_kit_video.MaterialFullscreenButton()
              : IconButton(
                  onPressed: () async {
                    controller.toggleFullScreen();
                  },
                  icon: const Icon(Icons.fullscreen),
                  color: Colors.white,
                  iconSize: 24.0,
                ),
        ],
      ),
      fullscreen: media_kit_video.MaterialVideoControlsThemeData(
        topButtonBar: [
          IconButton(
            onPressed: () {
              controller.toggleFullScreen();
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
          ),
        ],
        bottomButtonBar: [
          media_kit_video.MaterialPositionIndicator(),
          Spacer(),
          PlatformUtils.isAndroid
              ? media_kit_video.MaterialFullscreenButton()
              : IconButton(
                  onPressed: () async {
                    controller.toggleFullScreen();
                  },
                  icon: const Icon(Icons.fullscreen_exit_rounded),
                  color: Colors.white,
                  iconSize: 24.0,
                ),
        ],
      ),
      child: media_kit_video.Video(
        key: widget.controller.key,
        controller: widget.controller.mediaPlayerController,
        controls: media_kit_video.MaterialVideoControls,
      ),
    );
  }
}
