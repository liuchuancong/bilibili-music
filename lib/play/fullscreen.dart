import 'dart:io';
import 'package:window_manager/window_manager.dart';
import 'package:bilibilimusic/play/win32_window.dart';

class WindowService {
  static final WindowService _instance = WindowService._internal();
  factory WindowService() => _instance;
  WindowService._internal();

  Future<void> doExitWindowFullScreen() async {
    if (Platform.isWindows) {
      WinFullscreen.exitFullscreen();
      return;
    }
    if (Platform.isMacOS || Platform.isLinux) {
      await windowManager.setFullScreen(false);
    }
  }

  Future<void> doEnterWindowFullScreen() async {
    if (Platform.isWindows) {
      WinFullscreen.enterFullscreen();
      return;
    }
    if (Platform.isMacOS || Platform.isLinux) {
      await windowManager.setFullScreen(true);
    }
  }
}
