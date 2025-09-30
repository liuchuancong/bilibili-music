import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/widgets/sf_icon.dart';
import 'package:bilibilimusic/contants/app_contants.dart';
import 'package:bilibilimusic/services/player_state_storage.dart';
import 'package:bilibilimusic/presentation/menu/models/menu_item.dart';
import 'package:bilibilimusic/presentation/menu/models/menu_pages.dart';
import 'package:bilibilimusic/presentation/menu/models/menu_sub_item.dart';
import 'package:bilibilimusic/presentation/menu/utils/show_aware_page.dart';
import 'package:bilibilimusic/presentation/menu/navigation/nested_navigator_wrapper.dart';

class MenuManager {
  MenuManager._();

  static final MenuManager _instance = MenuManager._();

  factory MenuManager() => _instance;

  final ValueNotifier<MenuPages> currentPage = ValueNotifier(MenuPages.library);
  final ValueNotifier<int> hoverIndex = ValueNotifier(-1);

  late final List<Widget> pages; // 懒加载初始化
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late final List<MenuItem> items = [
    // MenuItem(
    //   icon: SFIcons.sf_icon_musicpages,
    //   iconSize: 22.0,
    //   label: '库',
    //   key: MenuPages.library,
    //   pageKey: GlobalKey<LibraryViewState>(),
    //   builder: (key) => LibraryView(key: key),
    // ),
    // MenuItem(
    //   icon: Icons.favorite_rounded,
    //   iconSize: 22.0,
    //   label: '喜欢',
    //   key: MenuPages.favorite,
    //   pageKey: GlobalKey<FavoritesViewState>(),
    //   builder: (key) => FavoritesView(key: key),
    // ),
    // MenuItem(
    //   icon: Icons.history_rounded,
    //   iconSize: 22.0,
    //   label: '最近播放',
    //   key: MenuPages.recently,
    //   pageKey: GlobalKey<RecentlyPlayedViewState>(),
    //   builder: (key) => RecentlyPlayedView(key: key),
    // ),
    MenuItem(
      icon: Icons.settings_rounded,
      iconSize: 22.0,
      label: '系统设置',
      key: MenuPages.settings,
      pageKey: GlobalKey<NestedNavigatorWrapperState>(),
      builder: (key) => NestedNavigatorWrapper(
        key: key,
        navigatorKey: navigatorKey,
        initialRoute: '/',
        subItems: subItems,
      ),
    ),
    MenuItem(
      icon: Icons.settings_rounded,
      iconSize: 22.0,
      label: '系统设置',
      key: MenuPages.settings,
      pageKey: GlobalKey<NestedNavigatorWrapperState>(),
      builder: (key) => NestedNavigatorWrapper(
        key: key,
        navigatorKey: navigatorKey,
        initialRoute: '/',
        subItems: subItems,
      ),
    ),
    MenuItem(
      icon: Icons.settings_rounded,
      iconSize: 22.0,
      label: '系统设置',
      key: MenuPages.settings,
      pageKey: GlobalKey<NestedNavigatorWrapperState>(),
      builder: (key) => NestedNavigatorWrapper(
        key: key,
        navigatorKey: navigatorKey,
        initialRoute: '/',
        subItems: subItems,
      ),
    ),
    MenuItem(
      icon: Icons.settings_rounded,
      iconSize: 22.0,
      label: '系统设置',
      key: MenuPages.settings,
      pageKey: GlobalKey<NestedNavigatorWrapperState>(),
      builder: (key) => NestedNavigatorWrapper(
        key: key,
        navigatorKey: navigatorKey,
        initialRoute: '/',
        subItems: subItems,
      ),
    ),

    MenuItem(
      icon: Icons.settings_rounded,
      iconSize: 22.0,
      label: '系统设置',
      key: MenuPages.settings,
      pageKey: GlobalKey<NestedNavigatorWrapperState>(),
      builder: (key) => NestedNavigatorWrapper(
        key: key,
        navigatorKey: navigatorKey,
        initialRoute: '/',
        subItems: subItems,
      ),
    ),
  ];

  late final List<MenuSubItem> subItems = _createDefaultSubItems();

  Future<void> init({
    required GlobalKey<NavigatorState> navigatorKey,
    List<MenuSubItem>? customSubItems,
  }) async {
    subItems
      ..clear()
      ..addAll(customSubItems ?? _createDefaultSubItems());

    final playerState = await PlayerStateStorage.getInstance();
    currentPage.value = playerState.currentPage;

    // 初始化页面缓存（延迟加载）
    pages = items.map((item) => item.buildPage()).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyPageShow(items[currentPage.value.index].pageKey);
    });
  }

  List<MenuSubItem> _createDefaultSubItems() {
    return [
      // MenuSubItem(
      //   routeName: '/',
      //   title: '设置首页',
      //   builder: () => SettingsPage(key: GlobalKey<SettingsPageState>()),
      //   icon: Icons.settings,
      // ),
      // MenuSubItem(
      //   routeName: '/settings/storage',
      //   title: '存储设置',
      //   builder: () => const StorageSettingPage(),
      //   icon: Icons.storage,
      // ),
    ];
  }

  Widget? getPageByRoute(String routeName) {
    try {
      return subItems.firstWhere((item) => item.routeName == routeName).buildPage();
    } catch (e) {
      return null;
    }
  }

  List<String> getAllRoutes() => subItems.map((item) => item.routeName).toList();

  void setPage(MenuPages page) {
    if (page == currentPage.value) return;

    final oldPage = currentPage.value;
    currentPage.value = page;

    PlayerStateStorage.getInstance().then((s) => s.setCurrentPage(page));

    final oldItem = items[oldPage.index];
    if (oldItem.key == MenuPages.settings && oldItem.pageKey.currentState is NestedNavigatorWrapperState) {
      final navState = (oldItem.pageKey.currentState as NestedNavigatorWrapperState).navigatorKey.currentState;
      navState?.popUntil((route) => route.isFirst);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyPageShow(items[page.index].pageKey);
    });
  }

  void _notifyPageShow(GlobalKey key) {
    final state = key.currentState;
    if (state is ShowAwarePage) {
      state.onPageShow();
    }
  }
}
