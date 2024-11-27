import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'video_controller_panel.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:better_player_plus/better_player_plus.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:media_kit_video/media_kit_video.dart' as media_kit_video;
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:bilibilimusic/modules/live_play/live_play_controller.dart';

class VideoController with ChangeNotifier {
  final LiveMediaInfo mediaInfo;

  final LiveMediaInfoData videoInfoData;
  var initialized = false.obs;
  ScreenBrightness brightnessController = ScreenBrightness();
  late BetterPlayerController betterPlayerController;
  final int initPosition;

  SettingsService settingsService = Get.find<SettingsService>();
  VideoController({required this.mediaInfo, required this.videoInfoData, required this.initPosition}) {
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
  // Create a [Player] to control playback.
  late Player player;
  // CeoController] to handle video output from [Player].
  late media_kit_video.VideoController mediaPlayerController;
  late final GlobalKey<media_kit_video.VideoState> key = GlobalKey<media_kit_video.VideoState>();
  void enableController() {
    showControllerTimer?.cancel();
    showControllerTimer = Timer(const Duration(seconds: 3), () {
      showController.value = false;
    });
    showController.value = true;
  }

  void initVideoController() async {
    FlutterVolumeController.updateShowSystemUI(false);
    if (Platform.isWindows) {
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
    } else {
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
    }
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
    if (Platform.isWindows) {
      // fix datasource empty error
      if (videoInfoData.url.isEmpty) {
        hasError.value = true;
        return;
      } else {
        hasError.value = false;
      }
      player.pause();
      player.open(Media(videoInfoData.url, httpHeaders: headers));
    } else {
      BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        videoInfoData.url,
        notificationConfiguration: BetterPlayerNotificationConfiguration(
          showNotification: true,
          title: mediaInfo.title,
          author: mediaInfo.name,
          imageUrl: mediaInfo.pic,
        ),
        headers: headers,
      );
      betterPlayerController.setupDataSource(dataSource);
      betterPlayerController.addEventsListener(mobileStateListener);
    }
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
      livePlayController.replay();
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
    if (Platform.isWindows) {
      mediaPlayerController.player.setVolume(isMuted.value ? 100 : 0);
    } else {
      if (isMuted.value) {
        betterPlayerController.setVolume(volume.value);
      } else {
        volume.value = betterPlayerController.videoPlayerController!.value.volume;
        betterPlayerController.setVolume(0.0);
      }
    }
    isMuted.toggle();
  }

  void togglePlayPause() {
    if (Platform.isWindows) {
      mediaPlayerController.player.playOrPause();
    } else {
      var isPlaying = betterPlayerController.isPlaying();
      if (isPlaying!) {
        betterPlayerController.pause();
      } else {
        betterPlayerController.play();
      }
    }
  }

  void skipBack() async {
    if (Platform.isWindows) {
      Duration? videoPosition = await betterPlayerController.videoPlayerController!.position;
      if (videoPosition!.inSeconds > 5) {
        mediaPlayerController.player.seek(videoPosition - const Duration(seconds: 5));
      } else {
        mediaPlayerController.player.seek(const Duration(seconds: 0));
      }
    } else {
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
  }

  void skipForward() async {
    if (Platform.isWindows) {
      Duration? videoPosition = await betterPlayerController.videoPlayerController!.position;
      if (videoPosition!.inSeconds < duration.value - 5) {
        mediaPlayerController.player.seek(videoPosition + const Duration(seconds: 5));
      } else {
        mediaPlayerController.player.seek(Duration(seconds: duration.value));
      }
    } else {
      var isPlaying = betterPlayerController.isPlaying();
      if (isPlaying!) {
        Duration? videoDuration = await betterPlayerController.videoPlayerController!.position;
        Duration forwardDuration = Duration(seconds: (videoDuration!.inSeconds + 5));
        if (forwardDuration < betterPlayerController.videoPlayerController!.value.duration!) {
          betterPlayerController.seekTo(forwardDuration);
        } else {
          betterPlayerController.seekTo(const Duration(seconds: 0));
          betterPlayerController.pause();
        }
      }
    }
  }

  refreshView() {
    if (Platform.isWindows) {
      // do nothing
    } else {
      betterPlayerController.retryDataSource();
    }
  }

  @override
  void dispose() async {
    if (!hasDestory.value) {
      await destory();
    }
    super.dispose();
  }

  void refresh() {
    if (Platform.isWindows) {
    } else {
      betterPlayerController.retryDataSource();
    }
  }

  destory() async {
    if (Platform.isWindows) {
      if (key.currentState?.isFullscreen() ?? false) {
        key.currentState?.exitFullscreen();
      }
      player.dispose();
    } else {
      betterPlayerController.removeEventsListener(mobileStateListener);
      betterPlayerController.dispose();
    }
    isPlaying.value = false;
    hasDestory.value = true;
  }

  void toggleFullScreen() {
    if (Platform.isAndroid || Platform.isIOS) {
      if (betterPlayerController.isFullScreen) {
        betterPlayerController.exitFullScreen();
      } else {
        betterPlayerController.enterFullScreen();
      }
    } else {
      if (isFullscreen.value) {
        key.currentState?.exitFullscreen();
      } else {
        key.currentState?.enterFullscreen();
      }
    }

    isFullscreen.toggle();
  }

  exitFullScreen() {
    if (Platform.isAndroid || Platform.isIOS) {
      betterPlayerController.exitFullScreen();
      isFullscreen.value = false;
    } else {
      isFullscreen.value = false;
      if (key.currentState?.isFullscreen() ?? false) {
        key.currentState?.exitFullscreen();
      }
    }
  }

  // volumn & brightness
  Future<double?> volumn() async {
    return await FlutterVolumeController.getVolume();
  }

  Future<double> brightness() async {
    return await brightnessController.application;
  }

  void setVolumn(double value) async {
    await betterPlayerController.setVolume(value);
  }

  void setBrightness(double value) async {
    if (Platform.isAndroid || Platform.isIOS) {
      await brightnessController.setApplicationScreenBrightness(value);
    }
  }
}
