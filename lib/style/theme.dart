import 'dart:io';
import 'package:flutter/material.dart';

class MyTheme {
  Color? primaryColor;
  ColorScheme? colorScheme;
  String? fontFamily;

  MyTheme({
    this.primaryColor,
    this.colorScheme,
  }) : assert(colorScheme == null || primaryColor == null);

  get lightThemeData {
    return ThemeData(
      useMaterial3: true,
      splashFactory: NoSplash.splashFactory,
      colorSchemeSeed: primaryColor,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      fontFamily: fontFamily,
    );
  }

  get darkThemeData {
    if (Platform.isWindows) {
      fontFamily = 'PingFang';
    }
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primaryColor,
      splashFactory: NoSplash.splashFactory,
      colorScheme: colorScheme?.copyWith(
        error: const Color.fromARGB(255, 255, 99, 71),
      ),
      brightness: Brightness.dark,
      fontFamily: fontFamily,
    );
  }
}
