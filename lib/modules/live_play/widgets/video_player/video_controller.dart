import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'video_controller_panel.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:bilibilimusic/models/live_video_info.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

class VideoController with ChangeNotifier {
  final VideoInfo videoInfo;

  final VideoInfoData videoInfoData;
  var initialized = false.obs;
  ScreenBrightness brightnessController = ScreenBrightness();
  late BetterPlayerController betterPlayerController;

  VideoController({
    required this.videoInfo,
    required this.videoInfoData,
  }) {
    initVideoController();
  }
  // Battery level control
  final batteryLevel = 100.obs;
  final showController = true.obs;
  final hasError = false.obs;
  final isPlaying = false.obs;
  Timer? showControllerTimer;

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
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoInfoData.url,
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: true,
        title: videoInfo.title,
        author: videoInfo.name,
        imageUrl: videoInfo.pic,
      ),
    );
    betterPlayerController.setupDataSource(dataSource);
    betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
        initialized.value = true;
      } else if (event.betterPlayerEventType == BetterPlayerEventType.play) {
        isPlaying.value = true;
      } else if (event.betterPlayerEventType == BetterPlayerEventType.pause) {
        isPlaying.value = false;
      } else if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
        hasError.value = false;
      }
    });
  }

  void togglePlayPause() {
    var isPlaying = betterPlayerController.isPlaying();
    if (isPlaying!) {
      betterPlayerController.pause();
    } else {
      betterPlayerController.play();
    }
  }

  refreshView() {
    betterPlayerController.retryDataSource();
  }

  @override
  void dispose() async {
    await destory();
    super.dispose();
  }

  void refresh() {
    destory();
  }

  void changeLine({bool active = false}) async {
    // 播放错误 不一定是线路问题 先切换路线解决 后面尝试通知用户切换播放器
    await destory();
  }

  destory() async {}

  void setDataSource(String url) async {}

  exitFullScreen() {}

  void toggleFullScreen() {
    if (betterPlayerController.isFullScreen) {
      betterPlayerController.exitFullScreen();
    } else {
      betterPlayerController.enterFullScreen();
    }

    isFullscreen.toggle();
  }

  void toggleWindowFullScreen() {}

  void enterPipMode(BuildContext context) async {}

  // volumn & brightness
  Future<double?> volumn() async {
    return await FlutterVolumeController.getVolume();
  }

  Future<double> brightness() async {
    return await brightnessController.current;
  }

  void setVolumn(double value) async {
    await FlutterVolumeController.setVolume(value);
  }

  void setBrightness(double value) async {
    if (Platform.isAndroid || Platform.isIOS) {
      await brightnessController.setScreenBrightness(value);
    }
  }
}


// use fullscreen with controller provider
