import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bilibilimusic/utils/platform_utils.dart';

class MobileManager {
  static Future<void> initialize() async {
    if (!PlatformUtils.isMobile) return;

    try {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
      );

      if (Platform.isIOS) {
        await _initializeIOS();
      }

      if (Platform.isAndroid) {
        await _initializeAndroid();
      }
    } catch (e) {
      debugPrint('移动端初始化失败: $e');
    }
  }

  static Future<void> _initializeIOS() async {
    try {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
        ),
      );
    } catch (e) {
      debugPrint('iOS 初始化失败: $e');
    }
  }

  static Future<void> _initializeAndroid() async {
    try {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } catch (e) {
      debugPrint('Android 初始化失败: $e');
    }
  }

  static void setStatusBarStyle({required bool isDarkTheme}) {
    if (!PlatformUtils.isMobile) return;

    try {
      if (Platform.isIOS) {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarBrightness: isDarkTheme ? Brightness.dark : Brightness.light,
            statusBarIconBrightness: isDarkTheme ? Brightness.light : Brightness.dark,
            statusBarColor: Colors.transparent,
          ),
        );
      } else if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Colors.transparent,
            statusBarIconBrightness: isDarkTheme ? Brightness.light : Brightness.dark,
            systemNavigationBarIconBrightness: isDarkTheme ? Brightness.light : Brightness.dark,
          ),
        );
      }
    } catch (e) {
      debugPrint('状态栏样式设置失败: $e');
    }
  }
}
