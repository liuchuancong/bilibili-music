import 'route_path.dart';
import 'package:get/get.dart';
import 'package:bilibilimusic/play/music_page.dart';
import 'package:bilibilimusic/modules/home/home.dart';
import 'package:bilibilimusic/modules/home/home_bing.dart';
import 'package:bilibilimusic/modules/about/about_page.dart';
import 'package:bilibilimusic/modules/playlist/playlist.dart';
import 'package:bilibilimusic/modules/search/search_page.dart';
import 'package:bilibilimusic/modules/history/history_page.dart';
import 'package:bilibilimusic/modules/history/history_bing.dart';
import 'package:bilibilimusic/modules/account/account_bing.dart';
import 'package:bilibilimusic/modules/account/account_page.dart';
import 'package:bilibilimusic/modules/about/version_history.dart';
import 'package:bilibilimusic/modules/search/search_binding.dart';
import 'package:bilibilimusic/modules/settings/settings_page.dart';
import 'package:bilibilimusic/modules/live_play/live_play_page.dart';
import 'package:bilibilimusic/modules/settings/settings_binding.dart';
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
      bindings: [HomeBinding()],
      preventDuplicates: true,
    ),
    //账号设置
    GetPage(
      name: RoutePath.kSettingsAccount,
      page: () => const AccountPage(),
      bindings: [AccountBinding()],
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
    GetPage(
      name: RoutePath.kSettings,
      page: SettingsPage.new,
      bindings: [SettingsBinding()],
    ),
    GetPage(
      name: RoutePath.kAbout,
      page: AboutPage.new,
    ),
    GetPage(
      name: RoutePath.kmusicPage,
      page: MusicPage.new,
    ),
    GetPage(
      name: RoutePath.kHistory,
      page: HistoryPage.new,
      bindings: [HistoryBinding()],
    ),
    GetPage(name: RoutePath.kVersionHistory, page: () => const VersionHistoryPage()),
  ];
}
