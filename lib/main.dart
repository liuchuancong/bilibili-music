import 'dart:io';
import 'package:get/get.dart';
import 'package:bilibilimusic/style/theme.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/routes/app_pages.dart';
import 'package:bilibilimusic/routes/route_path.dart';
import 'package:bilibilimusic/common/global/initialized.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:bilibilimusic/common/global/platform_utils.dart';
import 'package:bilibilimusic/common/global/platform/desktop_manager.dart';
import 'package:bilibilimusic/common/global/platform/background_server.dart';

void main(List<String> args) async {
  // 初始化
  await AppInitializer().initialize(args);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with DesktopWindowMixin {
  final settings = Get.find<AppSettingsService>();

  @override
  void initState() {
    super.initState();
    if (Platform.isWindows) {
      _init();
    }
  }

  @override
  void onWindowFocus() {
    setState(() {});
  }

  void _init() async {
    if (PlatformUtils.isDesktop) {
      DesktopManager.initializeListeners(this);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (Platform.isAndroid && settings.enableBackgroundPlay.value) {
        bool hasPermission = await BackgroundService.requestPlatformPermissions();
        if (!hasPermission) {
          SmartDialog.showToast("如果需要后台播放，建议开启此权限");
        }
      }
    });
  }

  @override
  void dispose() {
    if (PlatformUtils.isDesktop) {
      DesktopManager.disposeListeners();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var themeColor = HexColor(settings.themeColorHex.value);
      var lightTheme = MyTheme(primaryColor: themeColor).lightThemeData;
      var darkTheme = MyTheme(primaryColor: themeColor).darkThemeData;
      return GetMaterialApp(
        title: 'Bilibili Music',
        debugShowCheckedModeBanner: false,
        themeMode: AppThemeConstants.themeModes[settings.themeModeName.value]!,
        theme: lightTheme.copyWith(
          appBarTheme: AppBarTheme(surfaceTintColor: Colors.transparent),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: <TargetPlatform, PageTransitionsBuilder>{
              TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
            },
          ),
        ),
        darkTheme: darkTheme,
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(
          builder: (context, child) {
            if (PlatformUtils.isDesktopNotMac) {
              return DesktopManager.buildWithTitleBar(child);
            }
            return child ?? const SizedBox.shrink();
          },
        ),
        initialRoute: RoutePath.kInitial,
        defaultTransition: Transition.native,
        getPages: AppPages.routes,
      );
    });
  }
}
