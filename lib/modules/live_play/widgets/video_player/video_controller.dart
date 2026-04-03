import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:bilibilimusic/play/fullscreen.dart';
import 'package:bilibilimusic/play/player_state.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:bilibilimusic/models/video_media_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:media_kit_video/media_kit_video.dart' as media_kit_video;
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:bilibilimusic/modules/live_play/live_play_controller.dart';

class VideoController with ChangeNotifier {
  final VideoMediaInfo mediaInfo;

  final VideoPlaySource videoInfoData;
  var initialized = false.obs;
  ScreenBrightness brightnessController = ScreenBrightness();
  final int initPosition;

  AppSettingsService settingsService = Get.find<AppSettingsService>();
  VideoController({required this.mediaInfo, required this.videoInfoData, required this.initPosition}) {
    initVideoController();
  }

  LivePlayController livePlayController = Get.find<LivePlayController>();
  // Battery level control
  final batteryLevel = 100.obs;
  final hasError = false.obs;
  final isPlaying = false.obs;
  final isMuted = false.obs;
  final hasDestory = false.obs;
  var duration = 0.obs;
  var position = 0.obs;
  var volume = 0.0.obs;
  final isFullscreen = false.obs;
  // Create a [Player] to control playback.
  late Player player;
  // CeoController] to handle video output from [Player].
  late media_kit_video.VideoController mediaPlayerController;
  late final GlobalKey<media_kit_video.VideoState> key = GlobalKey<media_kit_video.VideoState>();

  void initVideoController() async {
    FlutterVolumeController.updateShowSystemUI(false);
    player = Player();
    if (player.platform is NativePlayer) {
      (player.platform as dynamic).setProperty('cache', 'no'); // --cache=<yes|no|auto>
      (player.platform as dynamic).setProperty('cache-secs', '0'); // --cache-secs=<seconds> with cache but why not.
      (player.platform as dynamic).setProperty('demuxer-seekable-cache', 'no');
      (player.platform as dynamic).setProperty('demuxer-max-back-bytes', '0'); // --demuxer-max-back-bytes=<bytesize>
      (player.platform as dynamic).setProperty('demuxer-donate-buffer', 'no'); // --demuxer-donate-buffer==<yes|no>
    }
    mediaPlayerController =
        media_kit_video.VideoController(player, configuration: const VideoControllerConfiguration());
    mediaPlayerController.player.stream.playing.listen((bool playing) {
      isPlaying.value = playing;
    });
    mediaPlayerController.player.stream.error.listen((event) {
      if (event.toString().contains('Failed to open')) {
        hasError.value = true;
        isPlaying.value = false;
      }
    });
    setupDataSource();
  }

  void setupDataSource() async {
    var headers = {
      "cookie": settingsService.bilibiliCookie.value,
      "authority": "api.bilibili.com",
      "accept":
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
      "accept-language": "zh-CN,zh;q=0.9",
      "cache-control": "no-cache",
      "dnt": "1",
      "pragma": "no-cache",
      "sec-ch-ua": '"Not A(Brand";v="99", "Google Chrome";v="121", "Chromium";v="121"',
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": '"macOS"',
      "sec-fetch-dest": "document",
      "sec-fetch-mode": "navigate",
      "sec-fetch-site": "none",
      "sec-fetch-user": "?1",
      "upgrade-insecure-requests": "1",
      "user-agent":
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
      "Referer": "https://www.bilibili.com/video/${mediaInfo.bvid}",
    };
    if (videoInfoData.url.isEmpty) {
      hasError.value = true;
      return;
    } else {
      hasError.value = false;
    }
    player.pause();
    player.open(Media(videoInfoData.url, httpHeaders: headers));
  }

  void toggleFullScreen() async {
    if (GlobalPlayerState.to.isFullscreen.value) {
      livePlayController.setNormalScreen();
      WindowService().doExitWindowFullScreen();
      GlobalPlayerState.to.isFullscreen.value = false;
    } else {
      livePlayController.setFullScreen();
      WindowService().doEnterWindowFullScreen();
      GlobalPlayerState.to.isFullscreen.value = true;
    }
  }

  Future<void> toggleMute() async {
    mediaPlayerController.player.setVolume(isMuted.value ? 100 : 0);
    isMuted.toggle();
  }

  @override
  void dispose() async {
    if (!hasDestory.value) {
      await destory();
    }
    super.dispose();
  }

  Future<void> destory() async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (key.currentState?.isFullscreen() ?? false) {
        key.currentState?.exitFullscreen();
      }
    } else {
      if (GlobalPlayerState.to.isFullscreen.value) {
        WindowService().doExitWindowFullScreen();
        GlobalPlayerState.to.isFullscreen.value = false;
        livePlayController.setNormalScreen();
      }
    }

    player.dispose();
    isPlaying.value = false;
    hasDestory.value = true;
  }

  void setBrightness(double value) async {
    if (Platform.isAndroid || Platform.isIOS) {
      await brightnessController.setApplicationScreenBrightness(value);
    }
  }
}
