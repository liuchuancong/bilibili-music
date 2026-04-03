import 'dart:io';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:audio_service/audio_service.dart';
import 'package:bilibilimusic/plugins/global.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:bilibilimusic/play/player_state.dart';
import 'package:bilibilimusic/utils/hive_pref_util.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:bilibilimusic/services/audio_background.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:bilibilimusic/common/global/windows_utils.dart';
import 'package:bilibilimusic/common/global/platform_utils.dart';
import 'package:bilibilimusic/services/bilibili_account_service.dart';
import 'package:bilibilimusic/common/global/platform/mobile_manager.dart';
import 'package:bilibilimusic/common/global/platform/desktop_manager.dart';
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;

class AppInitializer {
  static final AppInitializer _instance = AppInitializer._internal();
  bool _isInitialized = false;

  factory AppInitializer() => _instance;
  AppInitializer._internal();

  Future<void> initialize(List<String> args) async {
    if (_isInitialized) return;
    WidgetsFlutterBinding.ensureInitialized();

    MediaKit.ensureInitialized();
    String instanceId = getInstanceIdFromArgs(args);

    if (PlatformUtils.isDesktopNotMac) {
      if (WindowUtils.wakeUpByProp(instanceId)) {
        log("Instance [$instanceId] already running. Waking up and exiting.");
        exit(0);
      }
    }

    final appDir = await getApplicationDocumentsDirectory();
    String path =
        '${appDir.path}${Platform.pathSeparator}bilibili-music${instanceId.isNotEmpty ? "${Platform.pathSeparator}$instanceId" : ""}';

    try {
      await Hive.initFlutter(path);
      await HivePrefUtil.init();
      initService();
    } catch (e) {
      log("Hive Init Error: $e");
      exit(0);
    }
    if (PlatformUtils.isDesktop) {
      await DesktopManager.initialize();
      await DesktopManager.postInitialize();
      Future.delayed(const Duration(milliseconds: 800), () {
        WindowUtils.markCurrentWindow(instanceId);
      });
    } else if (PlatformUtils.isMobile) {
      await MobileManager.initialize();
      await AudioService.init(
        builder: () => AudioPlayerHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.mystyle.bilibili.music',
          androidNotificationChannelName: 'bilibili audio playback',
          androidNotificationOngoing: true,
          androidNotificationIcon: 'mipmap/launcher_icon',
        ),
      );
    }

    initRefresh();

    if (PlatformUtils.isDesktopNotMac) {
      // 只有主实例（instanceId 为空）才注册自启，避免多个实例互相覆盖注册表
      if (instanceId.isEmpty) {
        await _setupLaunchAtStartup();
      }
    }
    _isInitialized = true;
  }

  String getInstanceIdFromArgs(List<String> args) {
    for (var arg in args) {
      if (arg.startsWith('--instance=')) {
        var parts = arg.split('=');
        return parts.length > 1 ? parts[1] : '';
      }
    }
    return '';
  }

  Future<void> _setupLaunchAtStartup() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      launchAtStartup.setup(
        appName: packageInfo.appName,
        appPath: Platform.resolvedExecutable,
        packageName: 'dev.leanflutter.puretech.bilibili-music',
      );
      var settings = Get.find<AppSettingsService>();
      if (settings.enableLaunchAtStartup.value) {
        if (!await launchAtStartup.isEnabled()) {
          await launchAtStartup.enable();
        }
      }
    } catch (e) {
      log("Auto-start error: $e");
    }
  }

  void initService() {
    Get.put(AppSettingsService(), permanent: true);
    Get.put(BiliBiliAccountService(), permanent: true);
    Get.put(AudioController(), permanent: true);
    Get.put(GlobalPlayerState(), permanent: true);
  }

  bool get isInitialized => _isInitialized;
}
