import 'package:flutter/material.dart';
import 'package:bilibilimusic/presentation/menu/models/menu_sub_item.dart';
import 'package:bilibilimusic/presentation/menu/utils/show_aware_page.dart';

class NestedNavigatorWrapper extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String initialRoute;
  final List<MenuSubItem> subItems;

  const NestedNavigatorWrapper({
    super.key,
    required this.navigatorKey,
    required this.initialRoute,
    required this.subItems,
  });

  @override
  NestedNavigatorWrapperState createState() => NestedNavigatorWrapperState();
}

class NestedNavigatorWrapperState extends State<NestedNavigatorWrapper> with ShowAwarePage {
  GlobalKey<NavigatorState> get navigatorKey => widget.navigatorKey;

  @override
  void onPageShow() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyFirstSubPageShow();
    });
  }

  void _notifyFirstSubPageShow() {
    final navigator = navigatorKey.currentState;
    if (navigator != null) {
      _findAndNotifyShowAwarePage(navigator.context);
    }
  }

  void _findAndNotifyShowAwarePage(BuildContext context) {
    void visitor(Element element) {
      final state = element is StatefulElement ? element.state : null;
      if (state is ShowAwarePage) {
        state.onPageShow();
        return; // 找到即停止
      }
      element.visitChildren(visitor);
    }

    try {
      context.visitChildElements(visitor);
    } catch (e) {
      debugPrint('查找 ShowAwarePage 失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final enterTween =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(CurveTween(curve: Curves.fastOutSlowIn));
    final exitTween =
        Tween<Offset>(begin: Offset.zero, end: const Offset(-1.0, 0.0)).chain(CurveTween(curve: Curves.fastOutSlowIn));

    return Navigator(
      key: widget.navigatorKey,
      initialRoute: widget.initialRoute,
      onGenerateRoute: (settings) {
        Widget page;
        try {
          final item = widget.subItems.firstWhere((i) => i.routeName == settings.name);
          page = item.buildPage();
        } catch (e) {
          page = Scaffold(body: Center(child: Text('未知页面: ${settings.name}')));
        }

        return PageRouteBuilder(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, a, __) => page,
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: animation.drive(enterTween),
              child: SlideTransition(
                position: secondaryAnimation.drive(exitTween),
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}
