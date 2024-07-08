import 'package:get/get.dart';
import 'package:bilibilimusic/plugins/utils.dart';
import 'package:bilibilimusic/routes/app_navigation.dart';
import 'package:bilibilimusic/services/bilibili_account_service.dart';

class AccountController extends GetxController {
  void bilibiliTap() async {
    if (BiliBiliAccountService.instance.logined.value) {
      var result = await Utils.showAlertDialog("确定要退出哔哩哔哩账号吗？", title: "退出登录");
      if (result) {
        BiliBiliAccountService.instance.logout();
      }
    } else {
      AppNavigator.toBiliBiliLogin();
    }
  }
}
