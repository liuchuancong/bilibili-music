import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/utils/theme_utils.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class ThemeState {
  final ThemeMode themeMode;
  final Color seedColor;
  final double seedAlpha;
  final String opacityTarget;
  final bool sidebarIsExtended;

  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.seedColor = const Color(0xFF016B5B),
    this.seedAlpha = 1.0,
    this.opacityTarget = 'window',
    this.sidebarIsExtended = true,
  });

  ThemeState copyWith({
    ThemeMode? themeMode,
    Color? seedColor,
    double? seedAlpha,
    String? opacityTarget,
    bool? sidebarIsExtended,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
      seedAlpha: seedAlpha ?? this.seedAlpha,
      opacityTarget: opacityTarget ?? this.opacityTarget,
      sidebarIsExtended: sidebarIsExtended ?? this.sidebarIsExtended,
    );
  }
}

final themeProvider = AsyncNotifierProvider<ThemeProvider, ThemeState>(
  () => ThemeProvider(),
);

class ThemeProvider extends AsyncNotifier<ThemeState> {
  @override
  Future<ThemeState> build() async {
    final state = await _loadFromPrefs();
    _updateWindowEffect(state.themeMode);
    return state;
  }

  Future<ThemeState> _loadFromPrefs() async {
    final savedThemeIndex = PrefUtil.getInt(AppConstants.themeKey) ?? ThemeMode.system.index;
    final themeMode = ThemeMode.values[savedThemeIndex];

    final savedColorValue = PrefUtil.getInt(AppConstants.seedColorKey);
    final color = savedColorValue != null ? Color(savedColorValue) : const Color(0xFF016B5B);

    final alpha = PrefUtil.getDouble(AppConstants.seedAlphaKey) ?? 1.0;
    final opacityTarget = PrefUtil.getString(AppConstants.opacityTargetKey) ?? 'window';
    final sidebarIsExtended = PrefUtil.getBool(AppConstants.sidebarIsExtendedKey) ?? true;

    return ThemeState(
      themeMode: themeMode,
      seedColor: color,
      seedAlpha: alpha,
      opacityTarget: opacityTarget,
      sidebarIsExtended: sidebarIsExtended,
    );
  }

  void _updateWindowEffect(ThemeMode mode) {
    final isDark = PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    if (isDark) {
      if (PlatformUtils.isMacOS) {
        Window.setEffect(effect: WindowEffect.hudWindow, dark: isDark);
        Window.setBlurViewState(MacOSBlurViewState.active);
      }
      if (PlatformUtils.isWindows) {
        Window.setEffect(effect: WindowEffect.mica, dark: isDark);
        Window.setBlurViewState(MacOSBlurViewState.active);
      }
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncData(state.value!.copyWith(themeMode: mode));
    await PrefUtil.setInt(AppConstants.themeKey, mode.index);
    _updateWindowEffect(mode);
  }

  Future<void> setSeedColor(Color color) async {
    final newState = state.value!.copyWith(
      seedColor: color,
      seedAlpha: color.a,
    );
    state = AsyncData(newState);
    await PrefUtil.setInt(AppConstants.seedColorKey, color.toARGB32());
    await PrefUtil.setDouble(AppConstants.seedAlphaKey, color.a);
  }

  Future<void> setOpacityTarget(String target) async {
    state = AsyncData(state.value!.copyWith(opacityTarget: target));
    await PrefUtil.setString(AppConstants.opacityTargetKey, target);
  }

  Future<void> toggleSidebarExtended() async {
    final newValue = !state.value!.sidebarIsExtended;
    state = AsyncData(state.value!.copyWith(sidebarIsExtended: newValue));
    await PrefUtil.setBool(AppConstants.sidebarIsExtendedKey, newValue);
  }

  String getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return '亮色模式';
      case ThemeMode.dark:
        return '深色模式';
      case ThemeMode.system:
        return '跟随系统';
    }
  }

  IconData getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  ThemeData buildLightTheme(ThemeState state) {
    return ThemeData(
      popupMenuTheme: const PopupMenuThemeData(
        color: Color(0xffe0e0e0),
        shadowColor: Color(0xffe0e0e0),
        position: PopupMenuPosition.under,
      ),
      dialogTheme: const DialogThemeData(backgroundColor: ThemeUtils.lightBg),
      fontFamily: PlatformUtils.getFontFamily(),
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: state.seedColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: PlatformUtils.isDesktopNotMac ? 56 : null,
      ),
    );
  }

  ThemeData buildDarkTheme(ThemeState state) {
    return ThemeData(
      popupMenuTheme: const PopupMenuThemeData(
        color: Color(0xff2f2f2f),
        shadowColor: Color(0xff2f2f2f),
        position: PopupMenuPosition.under,
      ),
      dialogTheme: const DialogThemeData(backgroundColor: ThemeUtils.darkBg),
      fontFamily: PlatformUtils.getFontFamily(),
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: state.seedColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: PlatformUtils.isDesktop ? 56 : null,
      ),
    );
  }
}
