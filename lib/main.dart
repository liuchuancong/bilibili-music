import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/global/initialized.dart';
import 'package:bilibilimusic/router/route_observer.dart';
import 'package:bilibilimusic/services/theme_provider.dart';
import 'package:bilibilimusic/platform/desktop_manager.dart';
import 'package:bilibilimusic/widgets/keyboard_handler.dart';
import 'package:bilibilimusic/presentation/screens/home_page_mobile.dart';
import 'package:bilibilimusic/presentation/screens/home_page_desktop.dart';

// 引入你自己的文件

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 初始化
  await AppInitializer().initialize();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with DesktopWindowMixin {
  @override
  void initState() {
    super.initState();
    if (PlatformUtils.isDesktop) {
      DesktopManager.initializeListeners(this);
    }
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
    return const MyApp();
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStateAsync = ref.watch(themeProvider);
    return themeStateAsync.when(
      loading: () => const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator()))),
      error: (err, stack) => MaterialApp(home: Scaffold(body: Center(child: Text('Theme load error: $err')))),
      data: (state) {
        return MyKeyboardHandler(
          child: MaterialApp(
            title: 'LZF Music',
            theme: ref.read(themeProvider.notifier).buildLightTheme(state),
            darkTheme: ref.read(themeProvider.notifier).buildDarkTheme(state),
            themeMode: state.themeMode,
            home: const HomePageWrapper(),
            navigatorObservers: [routeObserver],
            builder: (context, child) {
              if (PlatformUtils.isDesktopNotMac) {
                return DesktopManager.buildWithTitleBar(child);
              }
              return child ?? const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}

class HomePageWrapper extends StatelessWidget {
  const HomePageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (PlatformUtils.isMobileWidth(context)) {
      // 小屏幕（手机）
      return HomePageMobile();
    } else {
      // 大屏幕（平板/桌面）
      return HomePageDesktop();
    }
  }
}
