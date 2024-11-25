import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/services/index.dart';
import 'package:bilibilimusic/services/audio_service.dart';

class HomeController extends GetxController {
  final SettingsService settingsService = Get.find<SettingsService>();
  final AudioController audioController = Get.find<AudioController>();

  @override
  void onInit() {
    setUI();
    super.onInit();
  }

  setUI() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Theme.of(Get.context!).navigationBarTheme.backgroundColor,
    ));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
