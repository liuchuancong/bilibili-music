import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/services/index.dart';

class HistoryController extends GetxController with GetTickerProviderStateMixin {
  final SettingsService settingsService = Get.find<SettingsService>();
  late TabController tabController;
  final tabIndex = 0.obs;
  HistoryController() {
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onInit() {
    setUI();
    tabController.addListener(() {
      tabIndex.value = tabController.index;
    });
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
