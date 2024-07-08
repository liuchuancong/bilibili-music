import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/style/theme.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:bilibilimusic/utils/pref_util.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:bilibilimusic/services/bilibili_account_service.dart';

class SettingsService extends GetxController {
  SettingsService() {
    themeColorSwitch.listen((value) {
      themeColorSwitch.value = value;
      PrefUtil.setString('themeColorSwitch', value);
    });
    enableAutoCheckUpdate.listen((value) {
      PrefUtil.setBool('enableAutoCheckUpdate', value);
    });

    backupDirectory.listen((String value) {
      PrefUtil.setString('backupDirectory', value);
    });

    bilibiliCookie.listen((value) {
      PrefUtil.setString('bilibiliCookie', value);
    });
  }

  // Theme settings
  static Map<String, ThemeMode> themeModes = {
    "System": ThemeMode.system,
    "Dark": ThemeMode.dark,
    "Light": ThemeMode.light,
  };
  final themeModeName = (PrefUtil.getString('themeMode') ?? "System").obs;

  get themeMode => SettingsService.themeModes[themeModeName.value]!;

  void changeThemeMode(String mode) {
    themeModeName.value = mode;
    PrefUtil.setString('themeMode', mode);
    Get.changeThemeMode(themeMode);
  }

  void changeThemeColorSwitch(String hexColor) {
    var themeColor = HexColor(hexColor);
    var lightTheme = MyTheme(primaryColor: themeColor).lightThemeData;
    var darkTheme = MyTheme(primaryColor: themeColor).darkThemeData;
    Get.changeTheme(lightTheme);
    Get.changeTheme(darkTheme);
  }

  static Map<String, Color> themeColors = {
    "Crimson": const Color.fromARGB(255, 220, 20, 60),
    "Orange": Colors.orange,
    "Chrome": const Color.fromARGB(255, 230, 184, 0),
    "Grass": Colors.lightGreen,
    "Teal": Colors.teal,
    "SeaFoam": const Color.fromARGB(255, 112, 193, 207),
    "Ice": const Color.fromARGB(255, 115, 155, 208),
    "Blue": Colors.blue,
    "Indigo": Colors.indigo,
    "Violet": Colors.deepPurple,
    "Primary": const Color(0xFF6200EE),
    "Orchid": const Color.fromARGB(255, 218, 112, 214),
    "Variant": const Color(0xFF3700B3),
    "Secondary": const Color(0xFF03DAC6),
  };
  // Backup & recover storage
  final backupDirectory = (PrefUtil.getString('backupDirectory') ?? '').obs;
  // Make a custom ColorSwatch to name map from the above custom colors.
  final Map<ColorSwatch<Object>, String> colorsNameMap =
      themeColors.map((key, value) => MapEntry(ColorTools.createPrimarySwatch(value), key));

  final themeColorSwitch = (PrefUtil.getString('themeColorSwitch') ?? Colors.blue.hex).obs;

  final enableAutoCheckUpdate = (PrefUtil.getBool('enableAutoCheckUpdate') ?? true).obs;

  // cookie

  final bilibiliCookie = (PrefUtil.getString('bilibiliCookie') ?? '').obs;

  bool backup(File file) {
    try {
      final json = toJson();
      file.writeAsStringSync(jsonEncode(json));
    } catch (e) {
      return false;
    }
    return true;
  }

  bool recover(File file) {
    try {
      final json = file.readAsStringSync();
      fromJson(jsonDecode(json));
    } catch (e) {
      return false;
    }
    return true;
  }

  setBilibiliCookit(cookie) {
    final BiliBiliAccountService biliAccountService = Get.find<BiliBiliAccountService>();
    if (biliAccountService.cookie.isEmpty || biliAccountService.uid == 0) {
      biliAccountService.resetCookie(cookie);
      biliAccountService.loadUserInfo();
    }
  }

  void fromJson(Map<String, dynamic> json) {
    themeModeName.value = json['themeMode'] ?? "System";
    enableAutoCheckUpdate.value = json['enableAutoCheckUpdate'] ?? true;
    bilibiliCookie.value = json['bilibiliCookie'] ?? '';
    themeColorSwitch.value = json['themeColorSwitch'] ?? Colors.blue.hex;
    changeThemeMode(themeModeName.value);
    changeThemeColorSwitch(themeColorSwitch.value);
    setBilibiliCookit(bilibiliCookie.value);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['themeMode'] = themeModeName.value;
    json['bilibiliCookie'] = bilibiliCookie.value;
    json['themeColorSwitch'] = themeColorSwitch.value;
    return json;
  }

  defaultConfig() {
    Map<String, dynamic> json = {
      "themeMode": "Light",
      "themeColor": "Chrome",
      'bilibiliCookie': '',
    };
    return json;
  }
}
