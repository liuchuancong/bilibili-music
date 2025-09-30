import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/utils/theme_utils.dart';
import 'package:bilibilimusic/utils/platform_utils.dart';

class FrostedContainer extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final Color? backgroundColor;

  const FrostedContainer({
    super.key,
    required this.child,
    this.enabled = true,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled && PlatformUtils.isDesktop) return child;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: (backgroundColor ?? ThemeUtils.backgroundColor(context)).withValues(alpha: 0.6),
          ),
          child: child,
        ),
      ),
    );
  }
}
