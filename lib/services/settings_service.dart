import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/style/theme.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:bilibilimusic/utils/pref_util.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:bilibilimusic/models/live_video_info.dart';
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

    device.listen((value) {
      PrefUtil.setString('device', value);
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

  final device = (PrefUtil.getString('device') ?? 'phone').obs;

  final deviceList = ['phone', 'pad', 'pc'].obs;

  void changeDevice(String device) {
    this.device.value = device;
    PrefUtil.setString('device', device);
  }

  // 当前视频播放列表
  var videoInfos = [].obs;
  var currentVideoIndex = 0.obs;

  void addVideoInfo(VideoInfo videoInfo) {
    videoInfos.add(videoInfo);
  }

  void removeVideoInfo(VideoInfo videoInfo) {
    videoInfos.remove(videoInfo);
  }

  void setCurrentVideoIndex(int index) {
    currentVideoIndex.value = index;
  }

  void setCurrentVideo(VideoInfo videoInfo) {
    setCurrentVideoIndex(videoInfos.indexWhere((element) => element == videoInfo));
  }

  final videoAlbum =
      ((PrefUtil.getStringList('videoAlbum') ?? []).map((e) => BilibiliVideo.fromJson(jsonDecode(e))).toList()).obs;

  void addVideoAlbum(BilibiliVideo video) {
    if (!isExistVideoAlbum(video)) {
      videoAlbum.add(video);
      PrefUtil.setStringList('videoAlbum', videoAlbum.map((e) => jsonEncode(e.toJson())).toList());
    }
  }

  void removeVideoAlbum(BilibiliVideo video) {
    if (isExistVideoAlbum(video)) {
      videoAlbum.remove(video);
      PrefUtil.setStringList('videoAlbum', videoAlbum.map((e) => jsonEncode(e.toJson())).toList());
    }
  }

  bool isExistVideoAlbum(BilibiliVideo video) {
    return videoAlbum.contains(video);
  }

  VideoInfo getCurrentVideoInfo() {
    return videoInfos[currentVideoIndex.value];
  }

  VideoInfo getNextVideoInfo() {
    if (currentVideoIndex.value + 1 < videoInfos.length) {
      setCurrentVideoIndex(currentVideoIndex.value + 1);
      return videoInfos[currentVideoIndex.value + 1];
    }
    setCurrentVideoIndex(0);
    return videoInfos[0];
  }

  VideoInfo getPreviousVideoInfo() {
    if (currentVideoIndex.value - 1 >= 0) {
      setCurrentVideoIndex(currentVideoIndex.value - 1);
      return videoInfos[currentVideoIndex.value - 1];
    }
    setCurrentVideoIndex(videoInfos.length - 1);
    return videoInfos[videoInfos.length - 1];
  }

  bool isCurrentVideoInfo(VideoInfo videoInfo) {
    return videoInfo == getCurrentVideoInfo();
  }

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
