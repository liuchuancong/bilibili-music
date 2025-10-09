import 'dart:io';
import 'package:media_kit/media_kit.dart';
import 'package:snacknload/snacknload.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/utils/core_log.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:bilibilimusic/platform/mobile_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bilibilimusic/platform/desktop_manager.dart';
import 'package:bilibilimusic/services/audio_player_service.dart';
import 'package:flutter_single_instance/flutter_single_instance.dart';

class AppInitializer {
  // 单例实例
  static final AppInitializer _instance = AppInitializer._internal();

  // 是否已经初始化
  bool _isInitialized = false;

  // 工厂构造函数，返回单例
  factory AppInitializer() {
    return _instance;
  }

  // 私有构造函数
  AppInitializer._internal();

  // 初始化方法
  Future<void> initialize() async {
    if (_isInitialized) {
      // 已经初始化过，直接返回
      return;
    }

    // 执行初始化操作
    WidgetsFlutterBinding.ensureInitialized();
    if (PlatformUtils.isDesktop) {
      await DesktopManager.initialize();
    } else if (PlatformUtils.isMobile) {
      await MobileManager.initialize();
    }

    PrefUtil.prefs = await SharedPreferences.getInstance();
    MediaKit.ensureInitialized();
    AudioPlayerService.init();
    if (PlatformUtils.isDesktop) {
      await DesktopManager.postInitialize();
    }

    bool isInstanceInstalled = await FlutterSingleInstance().isFirstInstance();
    if (isInstanceInstalled) {
      final err = await FlutterSingleInstance().focus();

      if (err != null) {
        CoreLog.d('Error focusing running instance: $err');
      }
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    launchAtStartup.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
      // 设置 packageName 参数以支持 MSIX。
      packageName: 'dev.leanflutter.puretech.bilibilimusic',
    );
    // 标记为已初始化
    _isInitialized = true;
  }

  // 检查是否已初始化
  bool get isInitialized => _isInitialized;
}

void configLoading() {
  SnackNLoad.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = IndicatorType.fadingCircle
    ..loadingStyle = LoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withValues(alpha: 0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}
