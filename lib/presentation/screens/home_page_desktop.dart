import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/utils/theme_utils.dart';
import 'package:bilibilimusic/utils/common_utils.dart';
import 'package:bilibilimusic/widgets/mini_player.dart';
import 'package:bilibilimusic/services/theme_provider.dart';
import 'package:bilibilimusic/widgets/frosted_container.dart';
import 'package:bilibilimusic/presentation/menu/menu_manager.dart';
import 'package:bilibilimusic/presentation/menu/models/menu_pages.dart';
import 'package:bilibilimusic/presentation/widgets/themed_background.dart';

class HomePageDesktop extends ConsumerStatefulWidget {
  const HomePageDesktop({super.key});

  @override
  ConsumerState<HomePageDesktop> createState() => _HomePageDesktopState();
}

class _HomePageDesktopState extends ConsumerState<HomePageDesktop> {
  @override
  void initState() {
    super.initState();
    ref.read(menuManagerProvider.notifier).init(navigatorKey: GlobalKey<NavigatorState>());
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
          return ThemedBackground(
            builder: (BuildContext context, ThemedBackgroundData theme) {
              return Scaffold(
                body: Row(
                  children: [
                    AnimatedContainer(
                      color: theme.sidebarBg,
                      duration: const Duration(milliseconds: 200),
                      width: CommonUtils.select(theme.sidebarIsExtended, t: 220, f: 70),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 40.0,
                              bottom: 12.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'LZF',
                                  style: TextStyle(
                                    height: 2,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (Widget child, Animation<double> anim) {
                                    return FadeTransition(
                                      opacity: anim,
                                      child: SizeTransition(
                                        axis: Axis.horizontal,
                                        sizeFactor: anim,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: CommonUtils.select(
                                    theme.sidebarIsExtended,
                                    t: const Text(
                                      ' Music',
                                      style: TextStyle(
                                        height: 2,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    f: const SizedBox(key: ValueKey('empty')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ValueListenableBuilder<MenuPages>(
                              valueListenable: menuState.currentPage,
                              builder: (context, currentPage, _) {
                                return ListView.builder(
                                  itemCount: menuState.items.length,
                                  itemBuilder: (context, index) {
                                    final item = menuState.items[index];
                                    final isSelected = index == currentPage.index;
                                    final isHovered = index == menuState.hoverIndex;
                                    Color bgColor;
                                    Color textColor;
                                    if (isSelected) {
                                      bgColor = theme.primaryColor.withValues(
                                        alpha: 0.2,
                                      );
                                      textColor = theme.primaryColor;
                                    } else if (isHovered) {
                                      bgColor = Colors.grey.withValues(
                                        alpha: 0.2,
                                      );
                                      textColor = ThemeUtils.select(
                                        context,
                                        light: Colors.black,
                                        dark: Colors.white,
                                      );
                                    } else {
                                      bgColor = Colors.transparent;
                                      textColor = ThemeUtils.select(
                                        context,
                                        light: Colors.black,
                                        dark: Colors.white,
                                      );
                                    }

                                    return MouseRegion(
                                      onEnter: (_) => {ref.read(menuManagerProvider.notifier).setHoverIndex(index)},
                                      onExit: (_) => {ref.read(menuManagerProvider.notifier).setHoverIndex(-1)},
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: bgColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(8),
                                          onTap: () => _onTabChanged(index),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  item.icon,
                                                  color: textColor,
                                                  size: item.iconSize,
                                                ),
                                                Flexible(
                                                  child: AnimatedSwitcher(
                                                    duration: const Duration(
                                                      milliseconds: 200,
                                                    ),
                                                    child: CommonUtils.select(
                                                      theme.sidebarIsExtended,
                                                      t: Padding(
                                                        key: const ValueKey(
                                                          'text',
                                                        ),
                                                        padding: const EdgeInsets.only(
                                                          left: 12,
                                                        ),
                                                        child: Text(
                                                          item.label,
                                                          style: TextStyle(
                                                            color: textColor,
                                                            fontWeight:
                                                                isSelected ? FontWeight.bold : FontWeight.normal,
                                                          ),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      f: const SizedBox(
                                                        width: 0,
                                                        key: ValueKey('empty'),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: IconButton(
                              icon: Icon(
                                CommonUtils.select(
                                  theme.sidebarIsExtended,
                                  t: Icons.arrow_back_rounded,
                                  f: Icons.menu_rounded,
                                ),
                              ),
                              onPressed: () => {
                                // theme.themeProvider.toggleExtended()
                                ref.read(themeProvider.notifier).toggleSidebarExtended()
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(width: 1, thickness: 1),
                    Expanded(
                      child: Stack(
                        children: [
                          // 主内容区域
                          Container(
                            color: theme.bodyBg,
                            child: ValueListenableBuilder<MenuPages>(
                              valueListenable: menuState.currentPage,
                              builder: (context, currentPage, _) {
                                return IndexedStack(
                                  index: currentPage.index,
                                  children: menuState.pages,
                                );
                              },
                            ),
                          ),

                          // 逻辑分辨率显示
                          // Positioned(
                          //   top: 8,
                          //   right: 8,
                          //   child: ResolutionDisplay(
                          //     isMinimized: true,
                          //   ),
                          // ),

                          // MiniPlayer
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return FrostedContainer(
                                  enabled: theme.isFloat,
                                  child: MiniPlayer(
                                    containerWidth: constraints.maxWidth,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    });
  }
}
