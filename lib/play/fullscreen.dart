import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';
import 'package:bilibilimusic/play/win32_window.dart';
import 'package:auto_orientation_v2/auto_orientation_v2.dart';
import 'package:bilibilimusic/modules/live_play/live_play_controller.dart';

class WindowService {
  static final WindowService _instance = WindowService._internal();
  factory WindowService() => _instance;
  WindowService._internal();
  //横屏
  Future<void> landScape() async {
    dynamic document;
    try {
      if (kIsWeb) {
        await document.documentElement?.requestFullscreen();
      } else if (Platform.isAndroid || Platform.isIOS) {
        await AutoOrientation.landscapeAutoMode(forceSensor: true);
      } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        await doEnterWindowFullScreen();
      }
    } catch (exception, stacktrace) {
      debugPrint(exception.toString());
      debugPrint(stacktrace.toString());
    }
  }

  //竖屏
  Future<void> verticalScreen() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> doEnterFullScreen() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      await doEnterWindowFullScreen();
    }
  }

  //退出全屏显示
  Future<void> doExitFullScreen() async {
    dynamic document;
    late SystemUiMode mode = SystemUiMode.edgeToEdge;
    try {
      if (kIsWeb) {
        document.exitFullscreen();
      } else if (Platform.isAndroid || Platform.isIOS) {
        await SystemChrome.setEnabledSystemUIMode(mode, overlays: SystemUiOverlay.values);
        await SystemChrome.setPreferredOrientations([]);
      } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        await doExitWindowFullScreen();
      }
    } catch (exception, stacktrace) {
      debugPrint(exception.toString());
      debugPrint(stacktrace.toString());
    }
  }

  Future<void> doExitWindowFullScreen() async {
    if (Platform.isWindows) {
      WinFullscreen.exitFullscreen();
      WinFullscreen.stopEscListener();
      return;
    }
    if (Platform.isMacOS || Platform.isLinux) {
      await windowManager.setFullScreen(false);
    }
  }

  Future<void> doEnterWindowFullScreen() async {
    if (Platform.isWindows) {
      WinFullscreen.enterFullscreen();
      final LivePlayController livePlayController = Get.find<LivePlayController>();
      WinFullscreen.startEscListener(() => livePlayController.videoController!.toggleFullScreen());
      return;
    }
    if (Platform.isMacOS || Platform.isLinux) {
      await windowManager.setFullScreen(true);
    }
  }
}
