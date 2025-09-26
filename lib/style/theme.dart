import 'package:flutter/material.dart';

class MyTheme {
  Color? primaryColor;
  ColorScheme? colorScheme;
  String? fontFamily;

  MyTheme({
    this.primaryColor,
    this.colorScheme,
  }) : assert(colorScheme == null || primaryColor == null);

  ThemeData get lightThemeData {
    return ThemeData(
      useMaterial3: true,
      splashFactory: NoSplash.splashFactory,
      colorSchemeSeed: primaryColor,
      colorScheme: colorScheme,
      brightness: Brightness.light,
      tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
      appBarTheme: const AppBarTheme(scrolledUnderElevation: 0.0, surfaceTintColor: Colors.transparent),
      fontFamily: fontFamily,
    );
  }

  ThemeData get darkThemeData {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: primaryColor,
      splashFactory: NoSplash.splashFactory,
      colorScheme: colorScheme?.copyWith(
        error: const Color.fromARGB(255, 255, 99, 71),
      ),
      tabBarTheme: const TabBarThemeData(dividerColor: Colors.transparent),
      appBarTheme: const AppBarTheme(scrolledUnderElevation: 0.0, surfaceTintColor: Colors.transparent),
      brightness: Brightness.dark,
      fontFamily: fontFamily,
    );
  }
}
