import 'package:get/get.dart';
import 'package:bilibilimusic/style/theme.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:audio_service/audio_service.dart';
import 'package:bilibilimusic/routes/app_pages.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/routes/app_navigation.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:bilibilimusic/services/audio_background.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:bilibilimusic/services/bilibili_account_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PrefUtil.prefs = await SharedPreferences.getInstance();
  // 初始化服务
  initService();
  await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.mystyle.bilibili.music',
      androidNotificationChannelName: 'bilibili audio playback',
      androidNotificationOngoing: true,
    ),
  );
  initRefresh();
  runApp(const MyApp());
}

void initService() {
  Get.put(SettingsService());
  Get.put(BiliBiliAccountService());
  Get.put(AudioController());
}

void initRefresh() {
  EasyRefresh.defaultHeaderBuilder = () => const ClassicHeader(
        armedText: '松开加载',
        dragText: '上拉刷新',
        readyText: '加载中...',
        processingText: '正在刷新...',
        noMoreText: '没有更多数据了',
        failedText: '加载失败',
        messageText: '上次加载时间 %T',
        processedText: '加载成功',
      );
  EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(
        armedText: '松开加载',
        dragText: '下拉刷新',
        readyText: '加载中...',
        processingText: '正在刷新...',
        noMoreText: '没有更多数据了',
        failedText: '加载失败',
        messageText: '上次加载时间 %T',
        processedText: '加载成功',
      );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final settings = Get.find<SettingsService>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var themeColor = HexColor(settings.themeColorSwitch.value);
      var lightTheme = MyTheme(primaryColor: themeColor).lightThemeData;
      var darkTheme = MyTheme(primaryColor: themeColor).darkThemeData;
      return GetMaterialApp(
        title: 'Bilibili Music',
        debugShowCheckedModeBanner: false,
        themeMode: SettingsService.themeModes[settings.themeModeName.value]!,
        theme: lightTheme,
        darkTheme: darkTheme,
        navigatorObservers: [FlutterSmartDialog.observer, MyPageRouteObserver()],
        builder: FlutterSmartDialog.init(),
        initialRoute: RoutePath.kInitial,
        defaultTransition: Transition.native,
        getPages: AppPages.routes,
      );
    });
  }
}
