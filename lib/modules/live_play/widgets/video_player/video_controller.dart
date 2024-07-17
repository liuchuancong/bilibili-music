import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'video_controller_panel.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:bilibilimusic/modules/live_play/live_play_controller.dart';

class VideoController with ChangeNotifier {
  final LiveMediaInfo videoInfo;

  final LiveMediaInfoData videoInfoData;
  var initialized = false.obs;
  ScreenBrightness brightnessController = ScreenBrightness();
  late BetterPlayerController betterPlayerController;
  final int initPosition;

  SettingsService settingsService = Get.find<SettingsService>();
  VideoController({required this.videoInfo, required this.videoInfoData, required this.initPosition}) {
    initVideoController();
  }

  LivePlayController livePlayController = Get.find<LivePlayController>();
  // Battery level control
  final batteryLevel = 100.obs;
  final showController = true.obs;
  final hasError = false.obs;
  final isPlaying = false.obs;
  Timer? showControllerTimer;
  final isMuted = false.obs;
  final hasDestory = false.obs;
  var duration = 0.obs;
  var position = 0.obs;
  var volume = 0.0.obs;
  final isFullscreen = false.obs;

  void enableController() {
    showControllerTimer?.cancel();
    showControllerTimer = Timer(const Duration(seconds: 3), () {
      showController.value = false;
    });
    showController.value = true;
  }

  void initVideoController() async {
    FlutterVolumeController.updateShowSystemUI(false);
    BetterPlayerConfiguration betterPlayerConfiguration = BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      handleLifecycle: true,
      autoPlay: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        playerTheme: BetterPlayerTheme.custom,
        customControlsBuilder: (controller, onControlsVisibilityChanged) => VideoControllerPanel(controller: this),
      ),
    );
    betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    setupDataSource();
  }

  void setupDataSource() async {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.network, videoInfoData.url,
        notificationConfiguration: BetterPlayerNotificationConfiguration(
          showNotification: true,
          title: videoInfo.title,
          author: videoInfo.name,
          imageUrl: videoInfo.pic,
        ),
        headers: {
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
          "Referer": "https://www.bilibili.com/video/${videoInfo.bvid}",
        });
    betterPlayerController.setupDataSource(dataSource);

    betterPlayerController.addEventsListener(mobileStateListener);
  }

  dynamic mobileStateListener(event) {
    getCurrentPosition();
    if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
      initialized.value = true;
    } else if (event.betterPlayerEventType == BetterPlayerEventType.play) {
      isPlaying.value = true;
    } else if (event.betterPlayerEventType == BetterPlayerEventType.pause) {
      isPlaying.value = false;
    } else if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
      hasError.value = false;
    } else if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
      isPlaying.value = false;
      livePlayController.playNext();
    }
  }

  getCurrentPosition() async {
    if (betterPlayerController.videoPlayerController == null) {
      return 0;
    }
    Duration? videoPosition = await betterPlayerController.videoPlayerController!.position;
    Duration? videoDuration = betterPlayerController.videoPlayerController!.value.duration;
    position.value = videoPosition!.inSeconds;
    duration.value = videoDuration!.inSeconds;
  }

  String zeroFill(int i) {
    return i >= 10 ? "$i" : "0$i";
  }

  String second2HMS(int sec, {bool isEasy = true}) {
    String hms = "00:00:00";
    if (!isEasy) hms = "00时00分00秒";
    if (sec > 0) {
      int h = sec ~/ 3600;
      int m = (sec % 3600) ~/ 60;
      int s = sec % 60;
      hms = "${zeroFill(h)}:${zeroFill(m)}:${zeroFill(s)}";
      if (!isEasy) hms = "${zeroFill(h)}时${zeroFill(m)}分${zeroFill(s)}秒";
    }
    return hms;
  }

  Future<void> toggleMute() async {
    if (isMuted.value) {
      betterPlayerController.setVolume(volume.value);
    } else {
      volume.value = betterPlayerController.videoPlayerController!.value.volume;
      betterPlayerController.setVolume(0.0);
    }
    isMuted.toggle();
  }

  void togglePlayPause() {
    var isPlaying = betterPlayerController.isPlaying();
    if (isPlaying!) {
      betterPlayerController.pause();
    } else {
      betterPlayerController.play();
    }
  }

  void skipBack() async {
    var isPlaying = betterPlayerController.isPlaying();
    if (isPlaying!) {
      Duration? videoDuration = await betterPlayerController.videoPlayerController!.position;
      Duration rewindDuration = Duration(seconds: (videoDuration!.inSeconds - 5));
      if (rewindDuration < betterPlayerController.videoPlayerController!.value.duration!) {
        betterPlayerController.seekTo(const Duration(seconds: 0));
      } else {
        betterPlayerController.seekTo(rewindDuration);
      }
    }
  }

  void skipForward() async {
    var isPlaying = betterPlayerController.isPlaying();
    if (isPlaying!) {
      Duration? videoDuration = await betterPlayerController.videoPlayerController!.position;
      Duration forwardDuration = Duration(seconds: (videoDuration!.inSeconds + 5));
      if (forwardDuration > betterPlayerController.videoPlayerController!.value.duration!) {
        betterPlayerController.seekTo(const Duration(seconds: 0));
        betterPlayerController.pause();
      } else {
        betterPlayerController.seekTo(forwardDuration);
      }
    }
  }

  refreshView() {
    betterPlayerController.retryDataSource();
  }

  @override
  void dispose() async {
    if (!hasDestory.value) {
      await destory();
    }
    super.dispose();
  }

  void refresh() {
    betterPlayerController.retryDataSource();
  }

  destory() async {
    betterPlayerController.removeEventsListener(mobileStateListener);
    betterPlayerController.dispose();
    hasDestory.value = true;
  }

  void toggleFullScreen() {
    if (betterPlayerController.isFullScreen) {
      betterPlayerController.exitFullScreen();
    } else {
      betterPlayerController.enterFullScreen();
    }

    isFullscreen.toggle();
  }

  exitFullScreen() {
    betterPlayerController.exitFullScreen();
    isFullscreen.value = false;
  }

  // volumn & brightness
  Future<double?> volumn() async {
    return await FlutterVolumeController.getVolume();
  }

  Future<double> brightness() async {
    return await brightnessController.current;
  }

  void setVolumn(double value) async {
    await betterPlayerController.setVolume(value);
  }

  void setBrightness(double value) async {
    if (Platform.isAndroid || Platform.isIOS) {
      await brightnessController.setScreenBrightness(value);
    }
  }
}
