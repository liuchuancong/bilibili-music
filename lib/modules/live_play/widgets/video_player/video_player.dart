import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/utils/cache_manager.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
    if (Platform.isWindows) {
      return media_kit_video.Video(
          key: widget.controller.key,
          controller: widget.controller.mediaPlayerController,
          controls: media_kit_video.MaterialVideoControls);
    }
    return Obx(
      () => widget.controller.initialized.value
          ? BetterPlayer(controller: widget.controller.betterPlayerController)
          : Card(
              elevation: 0,
              margin: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              clipBehavior: Clip.antiAlias,
              color: Get.theme.focusColor,
              child: CachedNetworkImage(
                cacheManager: CustomCacheManager.instance,
                imageUrl: widget.controller.mediaInfo.firstFrame,
                fit: BoxFit.fill,
                errorWidget: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.live_tv_rounded, size: 48),
                ),
              ),
            ),
    );
  }
}
