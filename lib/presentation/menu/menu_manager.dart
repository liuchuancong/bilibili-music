import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/widgets/sf_icon.dart';
import 'package:bilibilimusic/services/player_state_storage.dart';
import 'package:bilibilimusic/presentation/screens/library_page.dart';
import 'package:bilibilimusic/presentation/screens/setting_page.dart';
import 'package:bilibilimusic/presentation/menu/models/menu_item.dart';
import 'package:bilibilimusic/presentation/menu/models/menu_pages.dart';
import 'package:bilibilimusic/presentation/screens/favorites_page.dart';
import 'package:bilibilimusic/presentation/menu/models/menu_sub_item.dart';
import 'package:bilibilimusic/presentation/menu/utils/show_aware_page.dart';
import 'package:bilibilimusic/presentation/screens/recently_played_page.dart';
import 'package:bilibilimusic/presentation/menu/navigation/nested_navigator_wrapper.dart';

class MenuManagerState {
  final List<Widget> pages;
  final ValueNotifier<MenuPages> currentPage;
  final List<MenuItem> items;
  final List<MenuSubItem> subItems;
  final GlobalKey<NavigatorState> navigatorKey;
  final int hoverIndex;
  MenuManagerState({
    required this.pages,
    required this.currentPage,
    required this.items,
    required this.subItems,
    required this.navigatorKey,
    required this.hoverIndex,
  });
}

class MenuManagerNotifier extends AsyncNotifier<MenuManagerState> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  late final List<MenuItem> items = [
    MenuItem(
      icon: SFIcons.sf_icon_musicpages,
      iconSize: 22.0,
      label: '库',
      key: MenuPages.library,
      pageKey: GlobalKey<LibraryPageState>(),
      builder: (key) => LibraryPage(key: key),
    ),
    MenuItem(
      icon: Icons.favorite_rounded,
      iconSize: 22.0,
      label: '喜欢',
      key: MenuPages.favorite,
      pageKey: GlobalKey<FavoritesPageState>(),
      builder: (key) => FavoritesPage(key: key),
    ),
    MenuItem(
      icon: Icons.history_rounded,
      iconSize: 22.0,
      label: '最近播放',
      key: MenuPages.recently,
      pageKey: GlobalKey<RecentlyPlayedPageState>(),
      builder: (key) => RecentlyPlayedPage(key: key),
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
  late final List<Widget> pages = items.map((item) => item.buildPage()).toList();
  late final List<MenuSubItem> subItems = _createDefaultSubItems();

  Future<void> init({
    required GlobalKey<NavigatorState> navigatorKey,
    List<MenuSubItem>? subMenuItems, // 可选参数，允许从外部传入
  }) async {
    final playerState = await PlayerStateStorage.getInstance();
    final currentPage = ValueNotifier(playerState.currentPage);
    final subItems = subMenuItems ?? _createDefaultSubItems();
    final state = MenuManagerState(
      pages: pages,
      currentPage: currentPage,
      items: items,
      subItems: subItems,
      navigatorKey: navigatorKey,
      hoverIndex: -1,
    );
    this.state = AsyncData(state);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyPageShow(items[currentPage.value.index].pageKey);
    });
  }

  @override
  Future<MenuManagerState> build() async {
    final stateData = state.value;
    if (stateData == null) {
      return MenuManagerState(
        pages: pages,
        currentPage: ValueNotifier(MenuPages.library),
        items: items,
        subItems: subItems,
        navigatorKey: navigatorKey,
        hoverIndex: -1,
      );
    }

    return stateData;
  }

  void setHoverIndex(int index) {
    final stateData = state.value;
    if (stateData == null) return;
    state = AsyncData(stateData.copyWith(hoverIndex: index));
  }

  void setPage(MenuPages page) {
    final stateData = state.value;
    if (stateData == null || page == stateData.currentPage.value) return;

    // 更新状态
    state = AsyncData(stateData.copyWith(currentPage: page, hoverIndex: page.index));

    PlayerStateStorage.getInstance().then((s) => s.setCurrentPage(page));

    final oldItem = stateData.items[stateData.currentPage.value.index];
    if (oldItem.key == MenuPages.settings && oldItem.pageKey.currentState is NestedNavigatorWrapperState) {
      final navState = (oldItem.pageKey.currentState as NestedNavigatorWrapperState).navigatorKey.currentState;
      navState?.popUntil((route) => route.isFirst);
    }

    // 触发 onPageShow
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyPageShow(stateData.items[page.index].pageKey);
    });
  }

  void _notifyPageShow(GlobalKey key) {
    final state = key.currentState;
    if (state is ShowAwarePage) {
      state.onPageShow();
    }
  }

  List<MenuSubItem> _createDefaultSubItems() {
    return [
      MenuSubItem(
        routeName: '/',
        title: '设置首页',
        builder: () => SettingPage(key: GlobalKey<SettingPageState>()),
        icon: Icons.settings,
      ),
    ];
  }
}

final menuManagerProvider = AsyncNotifierProvider<MenuManagerNotifier, MenuManagerState>(
  () => MenuManagerNotifier(),
);

extension MenuManagerStateCopyWith on MenuManagerState {
  MenuManagerState copyWith({MenuPages? currentPage, required int hoverIndex}) {
    return MenuManagerState(
      pages: pages,
      currentPage: currentPage != null ? ValueNotifier(currentPage) : this.currentPage,
      items: items,
      subItems: subItems,
      navigatorKey: navigatorKey,
      hoverIndex: hoverIndex,
    );
  }
}
