import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/widgets/sf_icon.dart';
import 'package:bilibilimusic/presentation/menu/menu_manager.dart';
import 'package:bilibilimusic/presentation/menu/models/menu_pages.dart';

class HomePageMobile extends ConsumerStatefulWidget {
  const HomePageMobile({super.key});

  @override
  ConsumerState<HomePageMobile> createState() => _HomePageMobileState();
}

class _HomePageMobileState extends ConsumerState<HomePageMobile> {
  late final GlobalKey<NavigatorState> navigatorKey;
  @override
  void initState() {
    super.initState();
    navigatorKey = GlobalKey<NavigatorState>();
  }

  void _onTabChanged(int newIndex) {
    ref.read(menuManagerProvider.notifier).setPage(MenuPages.values[newIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final menuStateAsync = ref.watch(menuManagerProvider);
      return menuStateAsync.when(
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (err, stack) => Scaffold(
          body: Center(child: Text('加载失败: $err')),
        ),
        data: (menuState) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: menuState.currentPage.value.index,
                  onDestinationSelected: _onTabChanged,
                  labelType: NavigationRailLabelType.selected,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(SFIcons.sf_icon_musicpages),
                      selectedIcon: Icon(SFIcons.sf_icon_musicpages),
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
                Expanded(
                  child: ValueListenableBuilder<MenuPages>(
                    valueListenable: menuState.currentPage,
                    builder: (context, currentPage, _) {
                      return menuState.pages[currentPage.index];
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
