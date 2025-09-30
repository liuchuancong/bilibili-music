import 'package:flutter/material.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/global/initialized.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bilibilimusic/router/route_observer.dart';
import 'package:bilibilimusic/services/theme_provider.dart';
import 'package:bilibilimusic/platform/desktop_manager.dart';
import 'package:bilibilimusic/widgets/keyboard_handler.dart';

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

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStateAsync = ref.watch(themeProvider);
    return themeStateAsync.when(
      loading: () => const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator()))),
      error: (err, stack) => MaterialApp(home: Scaffold(body: Center(child: Text('Theme load error: $err')))),
      data: (state) {
        return const MaterialApp();
        // return MyKeyboardHandler(
        //   child: MaterialApp(
        //     color: Colors.transparent,
        //     title: 'LZF Music',
        //     theme: ref.read(themeProvider.notifier).buildLightTheme(state),
        //     darkTheme: ref.read(themeProvider.notifier).buildDarkTheme(state),
        //     themeMode: state.themeMode,
        //     home: const HomePageWrapper(),
        //     navigatorObservers: [routeObserver],
        //     builder: (context, child) {
        //       if (PlatformUtils.isDesktopNotMac) {
        //         return DesktopManager.buildWithTitleBar(child);
        //       }
        //       return child ?? const SizedBox.shrink();
        //     },
        //   ),
        // );
      },
    );
  }
}
