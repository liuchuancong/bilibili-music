import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/services/player_provider.dart';
import 'package:bilibilimusic/platform/desktop_manager.dart';

class LoggingShortcutManager extends ShortcutManager {
  @override
  KeyEventResult handleKeypress(BuildContext context, KeyEvent event) {
    final KeyEventResult result = super.handleKeypress(context, event);
    if (result == KeyEventResult.handled) {
      debugPrint('Handled shortcut $event in $context');
    }
    return result;
  }
}

class MyKeyboardHandler extends ConsumerStatefulWidget {
  final Widget child;

  const MyKeyboardHandler({super.key, required this.child});

  @override
  ConsumerState<MyKeyboardHandler> createState() => _MyKeyboardHandlerState();
}

class _MyKeyboardHandlerState extends ConsumerState<MyKeyboardHandler> {
  final Set<LogicalKeyboardKey> _pressedKeys = <LogicalKeyboardKey>{};

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      _pressedKeys.add(event.logicalKey);
    } else if (event is KeyUpEvent) {
      _pressedKeys.remove(event.logicalKey);
    }

    if (event is KeyDownEvent) {
      return _handleKeyDown(event);
    }

    return KeyEventResult.ignored;
  }

  KeyEventResult _handleKeyDown(KeyDownEvent event) {
    // 检查修饰键状态
    final isCommandPressed =
        _pressedKeys.contains(LogicalKeyboardKey.metaLeft) || _pressedKeys.contains(LogicalKeyboardKey.metaRight);
    final isControlPressed =
        _pressedKeys.contains(LogicalKeyboardKey.controlLeft) || _pressedKeys.contains(LogicalKeyboardKey.controlRight);
    final isPrimaryModifierPressed =
        (Platform.isMacOS && isCommandPressed) || ((Platform.isWindows || Platform.isLinux) && isControlPressed);

    // 桌面端特有快捷键
    if (PlatformUtils.isDesktop) {
      // Command/Ctrl + W 隐藏窗口
      if (event.logicalKey == LogicalKeyboardKey.keyW && isPrimaryModifierPressed) {
        return _handleHideWindow();
      }
    }

    // 通用媒体控制快捷键
    return _handleMediaControls(
      event,
      isPrimaryModifierPressed,
    );
  }

  KeyEventResult _handleHideWindow() {
    if (!PlatformUtils.isDesktop) return KeyEventResult.ignored;
    try {
      DesktopManager.hideWindow();
    } catch (e) {
      debugPrint('隐藏窗口失败: $e');
    }
    return KeyEventResult.handled;
  }

  KeyEventResult _handleMediaControls(
    KeyDownEvent event,
    bool isPrimaryModifierPressed,
  ) {
    final playerProvider = ref.read(playerNotifierProvider.notifier);
    final playerState = ref.watch(playerNotifierProvider);
    // 空格键：播放/暂停
    if (event.physicalKey == PhysicalKeyboardKey.space) {
      playerProvider.togglePlay();
      return KeyEventResult.handled;
    }

    // 需要修饰键的媒体控制
    if (isPrimaryModifierPressed) {
      switch (event.physicalKey) {
        case PhysicalKeyboardKey.arrowLeft:
          // 后退10秒
          playerProvider.seekTo(
            Duration(seconds: max(playerState.position.inSeconds - 10, 0)),
          );
          return KeyEventResult.handled;

        case PhysicalKeyboardKey.arrowRight:
          // 前进10秒
          playerProvider.seekTo(
            Duration(
              seconds: min(
                playerState.position.inSeconds + 10,
                playerState.duration.inSeconds,
              ),
            ),
          );
          return KeyEventResult.handled;

        case PhysicalKeyboardKey.arrowUp:
          // 上一曲
          playerProvider.previous();
          return KeyEventResult.handled;

        case PhysicalKeyboardKey.arrowDown:
          // 下一曲
          playerProvider.next();
          return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: widget.child,
    );
  }
}
