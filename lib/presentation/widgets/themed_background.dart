import 'package:bilibilimusic/exports.dart';

class ThemedBackgroundData {
  final Color primaryColor;
  final Color sidebarBg;
  final Color bodyBg;
  final bool isFloat;
  final bool sidebarIsExtended;

  const ThemedBackgroundData({
    required this.primaryColor,
    required this.sidebarBg,
    required this.bodyBg,
    required this.isFloat,
    required this.sidebarIsExtended,
  });
}

class ThemedBackground extends ConsumerWidget {
  final Widget Function(BuildContext context, ThemedBackgroundData data) builder;

  const ThemedBackground({super.key, required this.builder});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color primaryColor = ThemeUtils.primaryColor(context);
    Color sidebarBg = ThemeUtils.backgroundColor(context);
    Color bodyBg = ThemeUtils.backgroundColor(context);

    if (PlatformUtils.isMobile || PlatformUtils.isMobileWidth(context)) {
      return builder(
        context,
        ThemedBackgroundData(
          primaryColor: primaryColor,
          sidebarBg: sidebarBg,
          bodyBg: bodyBg,
          isFloat: true,
          sidebarIsExtended: false,
        ),
      );
    }

    ThemeState? themeState = ref.watch(themeProvider).value;
    if (['window', 'sidebar'].contains(themeState?.opacityTarget)) {
      sidebarBg = sidebarBg.withValues(alpha: themeState?.seedAlpha);
    }
    if (['window', 'body'].contains(themeState?.opacityTarget)) {
      bodyBg = bodyBg.withValues(alpha: themeState?.seedAlpha);
    }

    final isFloat = (themeState?.opacityTarget == 'sidebar' || themeState!.seedAlpha > 0.98);

    return builder(
      context,
      ThemedBackgroundData(
        primaryColor: primaryColor,
        sidebarBg: sidebarBg,
        bodyBg: bodyBg,
        isFloat: isFloat,
        sidebarIsExtended: themeState!.sidebarIsExtended,
      ),
    );
  }
}
