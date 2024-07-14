import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/utils/cache_manager.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                imageUrl: widget.controller.videoInfo.firstFrame,
                fit: BoxFit.fill,
                errorWidget: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.live_tv_rounded, size: 48),
                ),
              ),
            ),
    );
  }
}
