import 'package:get/get.dart';
import 'package:bilibilimusic/services/settings_service.dart';

class BiliBiliSite {
  String name = "哔哩哔哩直播";
  String cookie = "";
  int userId = 0;
  final SettingsService settings = Get.find<SettingsService>();
}
