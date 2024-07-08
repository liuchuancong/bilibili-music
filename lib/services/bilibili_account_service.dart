import 'dart:async';
import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/plugins/http_client.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:bilibilimusic/models/bilibili_user_info_page.dart';

class BiliBiliAccountService extends GetxController {
  static BiliBiliAccountService get instance => Get.find<BiliBiliAccountService>();
  final SettingsService settingsService = Get.find<SettingsService>();

  var logined = false.obs;

  var cookie = "".obs;
  var uid = 0;
  var name = "未登录".obs;
  static const String kBilibiliCookie = "bilibiliCookie";
  @override
  void onInit() {
    cookie.value = PrefUtil.getString(kBilibiliCookie) ?? '';
    logined.value = cookie.isNotEmpty;
    loadUserInfo();
    super.onInit();
  }

  Future loadUserInfo() async {
    if (cookie.isEmpty) {
      return;
    }
    Timer(const Duration(seconds: 1), () async {
      try {
        var result = await HttpClient.instance.getJson(
          "https://api.bilibili.com/x/member/web/account",
          header: {
            "Cookie": cookie,
          },
        );
        if (result["code"] == 0) {
          var info = BiliBiliUserInfoModel.fromJson(result["data"]);
          name.value = info.uname ?? "未登录";
          uid = info.mid ?? 0;
        } else {
          SmartDialog.showToast("哔哩哔哩登录已失效，请重新登录");
          logout();
        }
      } catch (e) {
        SmartDialog.showToast("获取哔哩哔哩用户信息失败，可前往账号管理重试");
      }
    });
  }

  void setCookie(String cookie) {
    this.cookie.value = cookie;
    settingsService.bilibiliCookie.value = cookie;
    logined.value = cookie.isNotEmpty;
  }

  void resetCookie(String cookie) {
    this.cookie.value = cookie;
    logined.value = cookie.isNotEmpty;
  }

  void logout() async {
    cookie.value = "";
    uid = 0;
    name.value = "未登录";
    PrefUtil.setString(kBilibiliCookie, '');
    logined.value = false;
    CookieManager cookieManager = CookieManager.instance();
    await cookieManager.deleteAllCookies();
  }
}
