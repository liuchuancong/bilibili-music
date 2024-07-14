import 'route_path.dart';
import 'package:get/get.dart';
import 'package:bilibilimusic/modules/home/home.dart';
import 'package:bilibilimusic/modules/playlist/playlist.dart';
import 'package:bilibilimusic/modules/search/search_page.dart';
import 'package:bilibilimusic/modules/account/account_bing.dart';
import 'package:bilibilimusic/modules/search/search_binding.dart';
import 'package:bilibilimusic/modules/live_play/live_play_page.dart';
import 'package:bilibilimusic/modules/playlist/playlist_binding.dart';
import 'package:bilibilimusic/modules/live_play/live_play_binding.dart';
import 'package:bilibilimusic/modules/account/bilibili/qr_login_page.dart';
import 'package:bilibilimusic/modules/account/bilibili/bilibili_bings.dart';
import 'package:bilibilimusic/modules/account/bilibili/web_login_page.dart';


// auth

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: RoutePath.kInitial,
      page: HomePage.new,
      participatesInRootNavigator: true,
      bindings: [AccountBinding()],
      preventDuplicates: true,
    ),
    //哔哩哔哩Web登录
    GetPage(
      name: RoutePath.kBiliBiliWebLogin,
      page: () => const BiliBiliWebLoginPage(),
      bindings: [
        BilibiliWebLoginBinding(),
      ],
    ),
    //哔哩哔哩二维码登录
    GetPage(
      name: RoutePath.kBiliBiliQRLogin,
      page: () => const BiliBiliQRLoginPage(),
      bindings: [
        BilibiliQrLoginBinding(),
      ],
    ),
    GetPage(
      name: RoutePath.kSearch,
      page: SearchPage.new,
      bindings: [SearchBinding()],
    ),
    GetPage(
      name: RoutePath.kPlayList,
      page: PlayListPage.new,
      bindings: [PlayListBinding()],
    ),
    GetPage(
      name: RoutePath.kLivePlay,
      page: () => LivePlayPage(),
      preventDuplicates: true,
      bindings: [LivePlayBinding()],
    ),
  ];
}
