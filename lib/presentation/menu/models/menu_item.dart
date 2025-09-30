import 'package:flutter/material.dart';
import 'package:bilibilimusic/presentation/menu/models/menu_pages.dart';
// lib/menu/models/menu_item.dart

class MenuItem {
  final IconData icon;
  final double iconSize;
  final String label;
  final MenuPages key;
  final GlobalKey pageKey;
  final Widget Function(GlobalKey) builder;

  const MenuItem({
    required this.icon,
    required this.iconSize,
    required this.label,
    required this.key,
    required this.pageKey,
    required this.builder,
  });

  Widget buildPage() => builder(pageKey);
}
