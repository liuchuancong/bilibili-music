import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/style/theme.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:bilibilimusic/utils/pref_util.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
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

    webKeyTimeStamp.listen((value) {
      PrefUtil.setInt('webKeyTimeStamp', value);
    });

    webKeys.listen((value) {
      PrefUtil.setString('webKeys', value);
    });

    enableBackgroundPlay.listen((value) {
      PrefUtil.setBool('enableBackgroundPlay', value);
    });

    enableScreenKeepOn.listen((value) {
      PrefUtil.setBool('enableScreenKeepOn', value);
    });
    enableFullScreenDefault.listen((value) {
      PrefUtil.setBool('enableFullScreenDefault', value);
    });
    debounce(autoShutDownTime, (callback) {
      PrefUtil.setInt('autoShutDownTime', autoShutDownTime.value);
      if (enableAutoShutDownTime.isTrue) {
        _stopWatchTimer.onStopTimer();
        _stopWatchTimer.setPresetMinuteTime(autoShutDownTime.value, add: false);
        _stopWatchTimer.onStartTimer();
      } else {
        _stopWatchTimer.onStopTimer();
      }
    }, time: 1.seconds);

    debounce(enableAutoShutDownTime, (callback) {
      PrefUtil.setBool('enableAutoShutDownTime', enableAutoShutDownTime.value);
      if (enableAutoShutDownTime.value == true) {
        _stopWatchTimer.onStopTimer();
        _stopWatchTimer.setPresetMinuteTime(autoShutDownTime.value, add: false);
        _stopWatchTimer.onStartTimer();
      } else {
        _stopWatchTimer.onStopTimer();
      }
    }, time: 1.seconds);

    backupDirectory.listen((String value) {
      PrefUtil.setString('backupDirectory', value);
    });
    onInitShutDown();
    _stopWatchTimer.fetchEnded.listen((value) {
      _stopWatchTimer.onStopTimer();
      FlutterExitApp.exitApp();
    });
    enableAutoCheckUpdate.listen((value) {
      PrefUtil.setBool('enableAutoCheckUpdate', value);
    });

    historyRooms.listen((rooms) {
      PrefUtil.setStringList('historyRooms', historyRooms.map<String>((e) => jsonEncode(e.toJson())).toList());
    });

    currentMediaList.listen((List<LiveMediaInfo> medias) {
      PrefUtil.setStringList('currentMediaList', medias.map<String>((e) => jsonEncode(e.toJson())).toList());
    });

    currentMediaIndex.listen((index) {
      PrefUtil.setInt('currentMediaIndex', index);
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
  void onInitShutDown() {
    if (enableAutoShutDownTime.isTrue) {
      _stopWatchTimer.setPresetMinuteTime(autoShutDownTime.value, add: false);
      _stopWatchTimer.onStartTimer();
    }
  }

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

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countDown); // Create instance.
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

  final enableBackgroundPlay = (PrefUtil.getBool('enableBackgroundPlay') ?? false).obs;

  final enableScreenKeepOn = (PrefUtil.getBool('enableScreenKeepOn') ?? true).obs;

  final enableFullScreenDefault = (PrefUtil.getBool('enableFullScreenDefault') ?? false).obs;

  final enableAutoShutDownTime = (PrefUtil.getBool('enableAutoShutDownTime') ?? false).obs;

  final autoShutDownTime = (PrefUtil.getInt('autoShutDownTime') ?? 120).obs;

  final historyRooms =
      ((PrefUtil.getStringList('historyRooms') ?? []).map((e) => BilibiliVideo.fromJson(jsonDecode(e))).toList()).obs;
  // cookie

  final bilibiliCookie = (PrefUtil.getString('bilibiliCookie') ?? '').obs;

  final device = (PrefUtil.getString('device') ?? 'phone').obs;

  final deviceList = ['phone', 'pad', 'pc'].obs;

  final webKeyTimeStamp = (PrefUtil.getInt('webKeyTimeStamp') ?? 0).obs;

  final webKeys = (PrefUtil.getString('webKeys') ?? '').obs;

  final preferResolution = (PrefUtil.getString('preferResolution') ?? resolutions[0]).obs;

  static const List<String> resolutions = ['原画', '蓝光8M', '蓝光4M', '超清', '流畅'];

  void changePreferResolution(String name) {
    if (resolutions.indexWhere((e) => e == name) != -1) {
      preferResolution.value = name;
      PrefUtil.setString('preferResolution', name);
    }
  }

  void changeDevice(String dv) {
    device.value = dv;
    PrefUtil.setString('device', dv);
  }

  // 当前媒体播放列表
  var currentMediaIndex = (PrefUtil.getInt('currentMediaIndex') ?? 0).obs;

  void setCurrentMediaIndex(int index) {
    currentMediaIndex.value = index;
  }

  // 当前播放媒体list相关
  final currentMediaList =
      ((PrefUtil.getStringList('currentMediaList') ?? []).map((e) => LiveMediaInfo.fromJson(jsonDecode(e))).toList())
          .obs;

  void setCurrentMedia(LiveMediaInfo mediaInfo) {
    setCurrentMediaIndex(currentMediaList.indexWhere((element) => element.cid == mediaInfo.cid));
  }

  Future<void> startPlayVideoAtIndex(int index, List<LiveMediaInfo> currentPlaylist) async {
    currentMediaList.assignAll(currentPlaylist);
    currentMediaIndex.value = index;
  }

  final videoAlbum =
      ((PrefUtil.getStringList('videoAlbum') ?? []).map((e) => BilibiliVideo.fromJson(jsonDecode(e))).toList()).obs;

  void addVideoAlbum(BilibiliVideo video, List<LiveMediaInfo> medias) {
    if (!videoAlbum.any((element) => element.id == video.id)) {
      video.medias = medias;
      videoAlbum.add(video);
    }
    PrefUtil.setStringList('videoAlbum', videoAlbum.map((e) => jsonEncode(e.toJson())).toList());
  }

  void moveVideoToTop(BilibiliVideo video) {
    if (videoAlbum.any((element) => element.id == video.id)) {
      videoAlbum.removeWhere((element) => element.id == video.id);
      videoAlbum.insert(0, video);
      PrefUtil.setStringList('videoAlbum', videoAlbum.map((e) => jsonEncode(e.toJson())).toList());
    }
  }

  void editVideoAlbum(BilibiliVideo video) {
    if (videoAlbum.any((element) => element.id == video.id)) {
      final itemIndex = videoAlbum.indexWhere((item) => item.id == video.id);
      videoAlbum[itemIndex].title = video.title;
      if (video.author!.isNotEmpty) {
        videoAlbum[itemIndex].author = video.author;
      }
      videoAlbum.value = List.from(videoAlbum);
      PrefUtil.setStringList('videoAlbum', videoAlbum.map((e) => jsonEncode(e.toJson())).toList());
      update();
    }
  }

  void removeVideoAlbum(BilibiliVideo video) {
    if (isExistVideoAlbum(video)) {
      videoAlbum.remove(video);
      PrefUtil.setStringList('videoAlbum', videoAlbum.map((e) => jsonEncode(e.toJson())).toList());
    }
  }

  void toggleCollectVideo(BilibiliVideo video, List<LiveMediaInfo> medias) {
    if (!isExistVideoAlbum(video)) {
      video.medias = medias;
      videoAlbum.add(video);
      PrefUtil.setStringList('videoAlbum', videoAlbum.map((e) => jsonEncode(e.toJson())).toList());
    } else {
      videoAlbum.removeWhere((element) => element.id == video.id);
      PrefUtil.setStringList('videoAlbum', videoAlbum.map((e) => jsonEncode(e.toJson())).toList());
    }
  }

  bool isExistVideoAlbum(BilibiliVideo video) {
    return videoAlbum.any((element) => element.id == video.id);
  }

  LiveMediaInfo getNextVideoInfo() {
    if (currentMediaIndex.value + 1 < currentMediaList.length) {
      setCurrentMediaIndex(currentMediaIndex.value + 1);
      return currentMediaList[currentMediaIndex.value + 1];
    }
    setCurrentMediaIndex(0);
    return currentMediaList[0];
  }

  LiveMediaInfo getCurrentVideoInfo() {
    return currentMediaList[currentMediaIndex.value];
  }

  LiveMediaInfo getPreviousVideoInfo() {
    if (currentMediaIndex.value - 1 >= 0) {
      setCurrentMediaIndex(currentMediaIndex.value - 1);
      return currentMediaList[currentMediaIndex.value - 1];
    }
    setCurrentMediaIndex(currentMediaList.length - 1);
    return currentMediaList[currentMediaList.length - 1];
  }

  bool isCurrentMediia(LiveMediaInfo mediaInfo) {
    if (currentMediaList.isEmpty) {
      return false;
    }
    return currentMediaList[currentMediaIndex.value].cid == mediaInfo.cid;
  }

  // 音乐相关
  final musicAlbum =
      ((PrefUtil.getStringList('musicAlbum') ?? []).map((e) => BilibiliVideo.fromJson(jsonDecode(e))).toList()).obs;

  void addMusicAlbum(BilibiliVideo video, List<LiveMediaInfo> medias) {
    if (!musicAlbum.any((element) => element.id == video.id)) {
      video.medias = medias;
      musicAlbum.add(video);
    }
    PrefUtil.setStringList('musicAlbum', musicAlbum.map((e) => jsonEncode(e.toJson())).toList());
  }

  void moveMusicToTop(BilibiliVideo video) {
    if (musicAlbum.any((element) => element.id == video.id)) {
      musicAlbum.removeWhere((element) => element.id == video.id);
      musicAlbum.insert(0, video);
      PrefUtil.setStringList('musicAlbum', musicAlbum.map((e) => jsonEncode(e.toJson())).toList());
    }
  }

  void toggleCollectMusic(BilibiliVideo video, List<LiveMediaInfo> medias) {
    if (!musicAlbum.any((element) => element.id == video.id)) {
      video.medias = medias;
      musicAlbum.add(video);
    } else {
      musicAlbum.removeWhere((element) => element.id == video.id);
    }
    PrefUtil.setStringList('musicAlbum', musicAlbum.map((e) => jsonEncode(e.toJson())).toList());
  }

  bool isExistMusicAlbum(BilibiliVideo video) {
    return musicAlbum.any((element) => element.id == video.id);
  }

  void editMusicAlbum(BilibiliVideo video) {
    if (musicAlbum.any((element) => element.id == video.id)) {
      final itemIndex = musicAlbum.indexWhere((item) => item.id == video.id);
      musicAlbum[itemIndex].title = video.title;
      if (video.author!.isNotEmpty) {
        musicAlbum[itemIndex].author = video.author;
      }
      musicAlbum.value = List.from(musicAlbum);
      PrefUtil.setStringList('musicAlbum', musicAlbum.map((e) => jsonEncode(e.toJson())).toList());
      update();
    }
  }

  void removeMusicAlbum(BilibiliVideo video) {
    if (musicAlbum.any((element) => element.id == video.id)) {
      musicAlbum.removeWhere((element) => element.id == video.id);
      PrefUtil.setStringList('musicAlbum', musicAlbum.map((e) => jsonEncode(e.toJson())).toList());
    }
  }

  bool isInMusicAlbum(BilibiliVideo video) {
    return musicAlbum.any((element) => element.id == video.id);
  }

  setCurreentMusicList(List<LiveMediaInfo> medias) {
    currentMediaList.value = medias;
    currentMediaIndex.value = 0;
    final AudioController audioController = Get.find<AudioController>();
    setCurrentMedia(medias[0]);
    audioController.startPlay(medias[0]);
    PrefUtil.setStringList('currentMediaList', currentMediaList.map((e) => jsonEncode(e.toJson())).toList());
    PrefUtil.setInt('currentMediaIndex', 0);
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

  void changeShutDownConfig(int minutes, bool isAutoShutDown) {
    autoShutDownTime.value = minutes;
    enableAutoShutDownTime.value = isAutoShutDown;
    PrefUtil.setInt('autoShutDownTime', minutes);
    PrefUtil.setBool('enableAutoShutDownTime', isAutoShutDown);
    onInitShutDown();
  }

  void fromJson(Map<String, dynamic> json) {
    themeModeName.value = json['themeMode'] ?? "System";
    bilibiliCookie.value = json['bilibiliCookie'] ?? '';
    themeColorSwitch.value = json['themeColorSwitch'] ?? Colors.blue.hex;
    enableBackgroundPlay.value = json['enableBackgroundPlay'] ?? false;
    enableScreenKeepOn.value = json['enableScreenKeepOn'] ?? true;
    enableAutoCheckUpdate.value = json['enableAutoCheckUpdate'] ?? true;
    enableFullScreenDefault.value = json['enableFullScreenDefault'] ?? false;
    autoShutDownTime.value = json['autoShutDownTime'] ?? 120;
    enableAutoShutDownTime.value = json['enableAutoShutDownTime'] ?? false;
    preferResolution.value = json['preferResolution'] ?? resolutions[0];
    videoAlbum.value = (json['videoAlbum'] ?? []).map((e) => BilibiliVideo.fromJson(jsonDecode(e))).toList();
    historyRooms.value = (json['historyRooms'] ?? []).map((e) => BilibiliVideo.fromJson(jsonDecode(e))).toList();
    device.value = json['device'] ?? 'phone';
    webKeyTimeStamp.value = json['webKeyTimeStamp'] ?? 0;
    webKeys.value = json['webKeys'] ?? '';

    changeThemeMode(themeModeName.value);
    changeThemeColorSwitch(themeColorSwitch.value);
    changePreferResolution(preferResolution.value);
    changeShutDownConfig(autoShutDownTime.value, enableAutoShutDownTime.value);
    setBilibiliCookit(bilibiliCookie.value);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['videoAlbum'] = videoAlbum.map<String>((e) => jsonEncode(e.toJson())).toList();
    json['historyRooms'] = historyRooms.map<String>((e) => jsonEncode(e.toJson())).toList();
    json['themeMode'] = themeModeName.value;
    json['autoShutDownTime'] = autoShutDownTime.value;
    json['enableAutoShutDownTime'] = enableAutoShutDownTime.value;
    json['enableBackgroundPlay'] = enableBackgroundPlay.value;
    json['enableScreenKeepOn'] = enableScreenKeepOn.value;
    json['enableAutoCheckUpdate'] = enableAutoCheckUpdate.value;
    json['enableFullScreenDefault'] = enableFullScreenDefault.value;
    json['preferResolution'] = preferResolution.value;
    json['bilibiliCookie'] = bilibiliCookie.value;
    json['themeColorSwitch'] = themeColorSwitch.value;
    json['device'] = device.value;
    json['webKeyTimeStamp'] = webKeyTimeStamp.value;
    json['webKeys'] = webKeys.value;

    return json;
  }
}
