import 'dart:io';
import 'package:get/get.dart';
import 'package:bilibilimusic/plugins/utils.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/models/live_media_info.dart';

/// APP页面跳转封装
/// * 需要参数的页面都应使用此类
/// * 如不需要参数，可以使用Get.toNamed
class AppNavigator {
  /// 跳转至分类详
  /// 跳转至直播间
  static Future<void> toLiveRoomDetailList({required BilibiliVideo bilibiliVideo}) async {
    Get.toNamed(RoutePath.kPlayList, arguments: bilibiliVideo);
  }

  static Future<void> toLiveRoomDetail({required LiveMediaInfo mediaInfo}) async {
    Get.toNamed(RoutePath.kLivePlay, arguments: mediaInfo);
  }

  /// 跳转至哔哩哔哩登录
  static Future toBiliBiliLogin() async {
    var contents = ['短信登陆', '二维码登陆'];
    if (Platform.isAndroid || Platform.isIOS) {
      var result = await Utils.showOptionDialog(contents, '', title: '请选择登陆方式');
      if (result == '短信登陆') {
        await Get.toNamed(RoutePath.kBiliBiliWebLogin);
      } else if (result == '二维码登陆') {
        await Get.toNamed(RoutePath.kBiliBiliQRLogin);
      }
    } else {
      await Get.toNamed(RoutePath.kBiliBiliQRLogin);
    }
  }
}
