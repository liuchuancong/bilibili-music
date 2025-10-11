import 'dart:io';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:media_kit/media_kit.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/utils/theme_utils.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:palette_generator_master/palette_generator_master.dart';

@immutable
class ThemeState {
  // 原有主题属性
  final ThemeMode themeMode;
  final Color seedColor;
  final double seedAlpha;
  final String opacityTarget;
  final bool sidebarIsExtended;
  final BackgroundType backgroundType;
  final String? backgroundPath;
  final bool isBackgroundAsset;
  final bool isPresetBackground;
  final Color? extractedPrimaryColor;
  final Color? extractedSecondaryColor;

  // 新增：和谐色彩相关属性（适配提取结果）
  final List<Color>? harmonyColors; // 扁平后的和谐色列表（直接用于UI）
  final List<ColorHarmonyMaster>? harmonyMasters; // 原始和谐色对象（备用）
  final List<Color>? allBaseColors; // 所有基础提取色（备用）

  // 构造函数（带默认值，确保兼容性）
  const ThemeState({
    this.themeMode = ThemeMode.system,
    this.seedColor = const Color(0xFF016B5B),
    this.seedAlpha = 1.0,
    this.opacityTarget = 'window',
    this.sidebarIsExtended = true,
    this.backgroundType = BackgroundType.none,
    this.backgroundPath,
    this.isBackgroundAsset = false,
    this.isPresetBackground = false,
    this.extractedPrimaryColor,
    this.extractedSecondaryColor,
    this.harmonyColors,
    this.harmonyMasters,
    this.allBaseColors,
  });

  // copyWith 方法（更新属性时保留原有值）
  ThemeState copyWith({
    ThemeMode? themeMode,
    Color? seedColor,
    double? seedAlpha,
    String? opacityTarget,
    bool? sidebarIsExtended,
    BackgroundType? backgroundType,
    String? backgroundPath,
    bool? isBackgroundAsset,
    bool? isPresetBackground,
    Color? extractedPrimaryColor,
    Color? extractedSecondaryColor,
    List<Color>? harmonyColors,
    List<ColorHarmonyMaster>? harmonyMasters,
    List<Color>? allBaseColors,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      seedColor: seedColor ?? this.seedColor,
      seedAlpha: seedAlpha ?? this.seedAlpha,
      opacityTarget: opacityTarget ?? this.opacityTarget,
      sidebarIsExtended: sidebarIsExtended ?? this.sidebarIsExtended,
      backgroundType: backgroundType ?? this.backgroundType,
      backgroundPath: backgroundPath ?? this.backgroundPath,
      isBackgroundAsset: isBackgroundAsset ?? this.isBackgroundAsset,
      isPresetBackground: isPresetBackground ?? this.isPresetBackground,
      extractedPrimaryColor: extractedPrimaryColor ?? this.extractedPrimaryColor,
      extractedSecondaryColor: extractedSecondaryColor ?? this.extractedSecondaryColor,
      harmonyColors: harmonyColors ?? this.harmonyColors,
      harmonyMasters: harmonyMasters ?? this.harmonyMasters,
      allBaseColors: allBaseColors ?? this.allBaseColors,
    );
  }
}

// 背景类型枚举（原有，确保存在）
enum BackgroundType { none, image, video }

final themeProvider = AsyncNotifierProvider<ThemeProvider, ThemeState>(
  () => ThemeProvider(),
);

class ThemeProvider extends AsyncNotifier<ThemeState> {
  // 视频播放器实例
  Player? _videoPlayer;
  VideoController? _videoController;

  Player? get videoPlayer => _videoPlayer;
  VideoController? get videoController => _videoController;

  @override
  Future<ThemeState> build() async {
    final state = await _loadFromPrefs();
    _updateWindowEffect(state.themeMode);
    _disposeVideoPlayer(); // 释放视频播放器（确保只有一个播放器实例）
    // 如果是视频背景，初始化播放器
    if (state.backgroundType == BackgroundType.video && state.backgroundPath != null) {
      await _initVideoPlayer(state.backgroundPath!, state.isBackgroundAsset);
    }

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

    // 加载背景相关设置
    final backgroundTypeIndex = PrefUtil.getInt(AppConstants.backgroundTypeKey) ?? BackgroundType.none.index;
    final backgroundType = BackgroundType.values[backgroundTypeIndex];
    final backgroundPath = PrefUtil.getString(AppConstants.backgroundPathKey);
    final isBackgroundAsset = PrefUtil.getBool(AppConstants.isBackgroundAssetKey) ?? false;
    final isPresetBackground = PrefUtil.getBool(AppConstants.isPresetBackgroundKey) ?? false;

    // 加载提取的颜色
    final primaryColorValue = PrefUtil.getInt(AppConstants.extractedPrimaryColorKey);
    final secondaryColorValue = PrefUtil.getInt(AppConstants.extractedSecondaryColorKey);

    return ThemeState(
      themeMode: themeMode,
      seedColor: color,
      seedAlpha: alpha,
      opacityTarget: opacityTarget,
      sidebarIsExtended: sidebarIsExtended,
      backgroundType: backgroundType,
      backgroundPath: backgroundPath,
      isBackgroundAsset: isBackgroundAsset,
      isPresetBackground: isPresetBackground,
      extractedPrimaryColor: primaryColorValue != null ? Color(primaryColorValue) : null,
      extractedSecondaryColor: secondaryColorValue != null ? Color(secondaryColorValue) : null,
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

  // 初始化视频播放器
  Future<void> _initVideoPlayer(String pathStr, bool isAsset) async {
    // 释放现有播放器，避免资源泄漏
    await _disposeVideoPlayer();

    try {
      _videoPlayer = Player();
      _videoController = VideoController(_videoPlayer!);
      final Media media;
      if (isAsset) {
        media = Media('asset:///$pathStr');
      } else if (pathStr.startsWith(RegExp(r'https?://'))) {
        media = Media(pathStr);
      } else {
        final file = File(pathStr);
        final absolutePath = file.isAbsolute ? file.path : path.absolute(file.path);
        final normalizedPath =
            Platform.isWindows ? absolutePath.replaceFirst(RegExp(r'^([A-Za-z]):\\'), r'/$1:/') : absolutePath;
        // 构建本地文件的 Media 源（格式："file:///绝对路径"）
        media = Media('file:///$normalizedPath');
      }
      // 打开媒体并自动播放
      await _videoPlayer!.open(
        media,
        play: true,
      );

      _videoPlayer!.stream.completed.listen((_) {
        if (state.value?.backgroundType == BackgroundType.video) {
          _videoPlayer?.seek(Duration.zero); // 跳转到视频开头
          _videoPlayer?.play(); // 重新播放
        }
      });

      // 设置视频静音（背景视频默认静音）
      await _videoPlayer!.setVolume(0);
    } catch (e, stackTrace) {
      // 打印详细错误日志（含堆栈），便于调试路径或视频格式问题
      debugPrint('初始化视频播放器失败：$e\n堆栈信息：$stackTrace');
      // 出错时释放播放器资源
      await _disposeVideoPlayer();
    }
  }

  // 释放视频播放器
  Future<void> _disposeVideoPlayer() async {
    if (_videoPlayer != null) {
      await _videoPlayer!.dispose();
      _videoPlayer = null;
    }
  }

  // 从图片中提取主题色（优化版）
  Future<Map<String, dynamic>> _extractColorsFromImage(String path, bool isAsset) async {
    try {
      // 1. 根据路径类型初始化图片提供者
      ImageProvider imageProvider;
      if (isAsset) {
        // 处理应用内资源图片（路径格式："assets/images/bg.jpg"）
        imageProvider = AssetImage(path);
      } else if (path.startsWith(RegExp(r'https?://'))) {
        // 处理网络图片（http/https 链接）
        imageProvider = NetworkImage(path);
      } else {
        // 处理本地文件图片（绝对路径）
        imageProvider = FileImage(File(path));
      }

      // 2. 使用 palette_generator_master 提取颜色（严格遵循库API）
      final PaletteGeneratorMaster paletteGenerator = await PaletteGeneratorMaster.fromImageProvider(
        imageProvider,
        maximumColorCount: 16, // 提取的最大颜色数量（越多越精准）
        colorSpace: ColorSpace.lab, // LAB色彩空间：比RGB更符合人眼对颜色的感知
        generateHarmony: true, // 启用和谐色彩生成
      );

      // 3. 提取核心基础颜色（主色、活力色、柔和色）
      final Color? dominantColor = paletteGenerator.dominantColor?.color; // 图片主导色
      final Color? vibrantColor = paletteGenerator.vibrantColor?.color; // 鲜艳活力色
      final Color? mutedColor = paletteGenerator.mutedColor?.color; // 柔和低饱和色
      final Color? lightVibrant = paletteGenerator.lightVibrantColor?.color; // 亮活力色
      final Color? darkMuted = paletteGenerator.darkMutedColor?.color; // 暗柔和色

      // 4. 提取和谐色彩
      final List<ColorHarmonyMaster> harmonyColorMasters = paletteGenerator.harmonyColors;
      // 将每个 ColorHarmonyMaster 的 colors 列表扁平化为一个整体 Color 列表
      final List<Color> harmonyColors = harmonyColorMasters
          .expand((harmony) => harmony.colors) // 展开 List<List<Color>> 为 List<Color>
          .toSet() // 去重：避免和谐色彩中出现重复颜色
          .toList(); // 转回列表

      // 5. 智能选择主题主色和辅助色（保证对比度和可用性）
      // 主色优先级：主导色 > 活力色 > 亮活力色（优先选择视觉突出的颜色）
      Color? primaryColor = dominantColor ?? vibrantColor ?? lightVibrant;
      // 辅助色：从和谐色中选与主色对比度 ≥ 4.5:1 的颜色（符合WCAG accessibility标准）
      Color? secondaryColor;
      if (primaryColor != null && harmonyColors.isNotEmpty) {
        secondaryColor = harmonyColors.firstWhere(
          (color) => ThemeUtils.getContrastRatio(primaryColor, color) >= 4.5,
          orElse: () => harmonyColors.first, // 无符合条件时取第一个
        );
      } else {
        // 无和谐色时：柔和色 > 暗柔和色（保证与主色区分度）
        secondaryColor = mutedColor ?? darkMuted;
      }

      // 6. 返回提取结果（包含原始对象和处理后的颜色列表）
      return {
        'primary': primaryColor, // 主题主色
        'secondary': secondaryColor, // 主题辅助色
        'harmonyColors': harmonyColors, // 处理后的扁平和谐色列表
        'harmonyMasters': harmonyColorMasters, // 原始 ColorHarmonyMaster 列表
        'allBaseColors': [
          // 所有基础提取色（备用）
          dominantColor, vibrantColor, mutedColor, lightVibrant, darkMuted
        ].whereType<Color>().toList(),
      };
    } catch (e, stackTrace) {
      debugPrint('图片颜色提取失败：$e\n堆栈信息：$stackTrace');
      return {
        'primary': null,
        'secondary': null,
        'harmonyColors': null,
        'harmonyMasters': null,
        'allBaseColors': null,
      };
    }
  }

  // 设置主题模式
  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncData(state.value!.copyWith(themeMode: mode));
    await PrefUtil.setInt(AppConstants.themeKey, mode.index);
    _updateWindowEffect(mode);
  }

  // 设置种子颜色
  Future<void> setSeedColor(Color color) async {
    final newState = state.value!.copyWith(
      seedColor: color,
      seedAlpha: color.a,
    );
    state = AsyncData(newState);
    await PrefUtil.setInt(AppConstants.seedColorKey, color.toARGB32());
    await PrefUtil.setDouble(AppConstants.seedAlphaKey, color.a / 255.0);
  }

  // 设置不透明度目标
  Future<void> setOpacityTarget(String target) async {
    state = AsyncData(state.value!.copyWith(opacityTarget: target));
    await PrefUtil.setString(AppConstants.opacityTargetKey, target);
  }

  // 切换侧边栏展开状态
  Future<void> toggleSidebarExtended() async {
    final newValue = !state.value!.sidebarIsExtended;
    state = AsyncData(state.value!.copyWith(sidebarIsExtended: newValue));
    await PrefUtil.setBool(AppConstants.sidebarIsExtendedKey, newValue);
  }

  // 设置图片背景（包含颜色提取逻辑）
  Future<void> setImageBackground({
    required String path,
    bool isAsset = false,
    bool isPreset = false,
  }) async {
    // 1. 先释放视频播放器（避免资源泄漏）
    await _disposeVideoPlayer();

    // 2. 提取图片颜色（调用修正后的方法）
    final colorResult = await _extractColorsFromImage(path, isAsset);

    // 3. 更新 ThemeState 状态
    final newState = state.value!.copyWith(
      backgroundType: BackgroundType.image,
      backgroundPath: path,
      isBackgroundAsset: isAsset,
      isPresetBackground: isPreset,
      extractedPrimaryColor: colorResult['primary'] as Color?,
      extractedSecondaryColor: colorResult['secondary'] as Color?,
      harmonyColors: colorResult['harmonyColors'] as List<Color>?,
      harmonyMasters: colorResult['harmonyMasters'] as List<ColorHarmonyMaster>?,
      allBaseColors: colorResult['allBaseColors'] as List<Color>?,
    );
    state = AsyncData(newState);

    // 4. 保存到本地偏好设置（持久化）
    await PrefUtil.setInt(AppConstants.backgroundTypeKey, BackgroundType.image.index);
    await PrefUtil.setString(AppConstants.backgroundPathKey, path);
    await PrefUtil.setBool(AppConstants.isBackgroundAssetKey, isAsset);
    await PrefUtil.setBool(AppConstants.isPresetBackgroundKey, isPreset);
    // 保存提取的颜色（用 value 存储 Color 的整数表示）
    await PrefUtil.setInt(
      AppConstants.extractedPrimaryColorKey,
      newState.extractedPrimaryColor!.toARGB32(),
    );
    await PrefUtil.setInt(
      AppConstants.extractedSecondaryColorKey,
      newState.extractedSecondaryColor!.toARGB32(),
    );
    // 和谐色列表保存（需序列化，这里用逗号分隔的十六进制字符串）
    if (newState.harmonyColors != null) {
      final harmonyHexStr = newState.harmonyColors!.map((color) => color.toARGB32().toRadixString(16)).join(',');
      await PrefUtil.setString(AppConstants.harmonyColorsKey, harmonyHexStr);
    } else {
      await PrefUtil.remove(AppConstants.harmonyColorsKey);
    }
  }

  // 设置视频背景
  Future<void> setVideoBackground({
    required String path,
    bool isAsset = false,
    bool isPreset = false,
  }) async {
    // 初始化视频播放器
    await _initVideoPlayer(path, isAsset);

    // 更新状态
    final newState = state.value!.copyWith(
      backgroundType: BackgroundType.video,
      backgroundPath: path,
      isBackgroundAsset: isAsset,
      isPresetBackground: isPreset,
      // 视频不提取颜色
      extractedPrimaryColor: null,
      extractedSecondaryColor: null,
    );

    state = AsyncData(newState);

    // 保存到偏好设置
    await PrefUtil.setInt(AppConstants.backgroundTypeKey, BackgroundType.video.index);
    await PrefUtil.setString(AppConstants.backgroundPathKey, path);
    await PrefUtil.setBool(AppConstants.isBackgroundAssetKey, isAsset);
    await PrefUtil.setBool(AppConstants.isPresetBackgroundKey, isPreset);
    await PrefUtil.remove(AppConstants.extractedPrimaryColorKey);
    await PrefUtil.remove(AppConstants.extractedSecondaryColorKey);
    await PrefUtil.remove(AppConstants.harmonyColorsKey);
  }

  // 清除背景
  Future<void> clearBackground() async {
    await _disposeVideoPlayer();

    final newState = state.value!.copyWith(
      backgroundType: BackgroundType.none,
      backgroundPath: null,
      isBackgroundAsset: false,
      isPresetBackground: false,
      extractedPrimaryColor: null,
      extractedSecondaryColor: null,
    );

    state = AsyncData(newState);

    await PrefUtil.setInt(AppConstants.backgroundTypeKey, BackgroundType.none.index);
    await PrefUtil.remove(AppConstants.backgroundPathKey);
    await PrefUtil.setBool(AppConstants.isBackgroundAssetKey, false);
    await PrefUtil.setBool(AppConstants.isPresetBackgroundKey, false);
    await PrefUtil.remove(AppConstants.extractedPrimaryColorKey);
    await PrefUtil.remove(AppConstants.extractedSecondaryColorKey);
    await PrefUtil.remove(AppConstants.harmonyColorsKey);
  }

  // 获取主题名称
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

  // 获取主题图标
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

  // 获取适合的文本颜色（基于背景）
  Color getTextColor() {
    // 如果有提取的颜色，使用对比度计算
    if (state.value?.extractedPrimaryColor != null) {
      return ThemeUtils.getContrastColor(state.value!.extractedPrimaryColor!);
    }

    // 否则使用当前主题模式
    final isDark = state.value?.themeMode == ThemeMode.dark ||
        (state.value?.themeMode == ThemeMode.system &&
            PlatformDispatcher.instance.platformBrightness == Brightness.dark);
    return isDark ? Colors.white : Colors.black;
  }

  // 构建亮色主题
  ThemeData buildLightTheme(ThemeState state) {
    // 如果有提取的主色，使用它作为种子色
    final seedColor = state.extractedPrimaryColor ?? state.seedColor;

    return ThemeData(
      popupMenuTheme: const PopupMenuThemeData(
        color: Color(0xffe0e0e0),
        shadowColor: Color(0xffe0e0e0),
        position: PopupMenuPosition.under,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ThemeUtils.lightBg,
        titleTextStyle: TextStyle(
          color: getTextColor(),
        ),
      ),
      fontFamily: PlatformUtils.getFontFamily(),
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: PlatformUtils.isDesktopNotMac ? 56 : null,
        titleTextStyle: TextStyle(
          color: getTextColor(),
          fontSize: 18,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: getTextColor()),
        bodyMedium: TextStyle(color: getTextColor()),
        titleLarge: TextStyle(color: getTextColor()),
      ),
    );
  }

  // 构建暗色主题
  ThemeData buildDarkTheme(ThemeState state) {
    // 如果有提取的主色，使用它作为种子色
    final seedColor = state.extractedPrimaryColor ?? state.seedColor;

    return ThemeData(
      popupMenuTheme: const PopupMenuThemeData(
        color: Color(0xff2f2f2f),
        shadowColor: Color(0xff2f2f2f),
        position: PopupMenuPosition.under,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ThemeUtils.darkBg,
        titleTextStyle: TextStyle(
          color: getTextColor(),
        ),
      ),
      fontFamily: PlatformUtils.getFontFamily(),
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: PlatformUtils.isDesktop ? 56 : null,
        titleTextStyle: TextStyle(
          color: getTextColor(),
          fontSize: 18,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: getTextColor()),
        bodyMedium: TextStyle(color: getTextColor()),
        titleLarge: TextStyle(color: getTextColor()),
      ),
    );
  }
}
