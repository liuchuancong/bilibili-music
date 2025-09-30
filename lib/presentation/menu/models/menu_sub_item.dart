import 'package:flutter/material.dart';

class MenuSubItem {
  final String routeName;
  final String title;
  final Widget Function() builder;
  final IconData? icon;

  const MenuSubItem({
    required this.routeName,
    required this.title,
    required this.builder,
    this.icon,
  });

  Widget buildPage() => builder();
}
