import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/presentation/menu/menu_manager.dart';
import 'package:bilibilimusic/presentation/menu/models/menu_pages.dart';
// 改为 ConsumerStatefulWidget

class HomePageDesktop extends ConsumerStatefulWidget {
  const HomePageDesktop({super.key});

  @override
  ConsumerState<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends ConsumerState<HomePageDesktop> {
  late final GlobalKey<NavigatorState> navigatorKey;
  final MenuManager menuManager = MenuManager();
  @override
  void initState() {
    super.initState();
    navigatorKey = GlobalKey<NavigatorState>();
    menuManager.init(navigatorKey: navigatorKey);
  }

  void _onTabChanged(int newIndex) {
    menuManager.setPage(MenuPages.values[newIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 左侧菜单栏
          NavigationRail(
            selectedIndex: menuManager.currentPage.value.index,
            onDestinationSelected: _onTabChanged,
            labelType: NavigationRailLabelType.selected,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.music_note_outlined),
                selectedIcon: Icon(Icons.music_note),
                label: Text('库'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite),
                label: Text('喜欢'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.history),
                selectedIcon: Icon(Icons.history),
                label: Text('最近播放'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('设置'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // 右侧内容区
          // Expanded(
          //   child: ValueListenableBuilder<PlayerPage>(
          //     valueListenable: menuManager.currentPage,
          //     builder: (context, currentPage, _) {
          //       return menuManager.pages[currentPage.index];
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
