import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/style/theme.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:bilibilimusic/utils/pref_util.dart';
import 'package:bilibilimusic/models/up_user_info.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:bilibilimusic/utils/hive_pref_util.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/services/bilibili_account_service.dart';

class SettingsService extends GetxController {
  // ==============================
  // 🔹 Getter (computed properties)
  // ==============================
  ThemeMode get themeMode => AppConsts.themeModes[themeModeName.value]!;

  // ==============================
  // 🎨 主题 & 语言
  // ==============================
  final themeModeName = (HivePrefUtil.getString('themeMode') ?? "System").obs;
  final themeColorSwitch = (HivePrefUtil.getString('themeColorSwitch') ?? Colors.blue.hex).obs;

  // ==============================
  // ⚙️ 基础功能开关
  // ==============================
  final enableAutoCheckUpdate = (HivePrefUtil.getBool('enableAutoCheckUpdate') ?? true).obs;
  final enableAutoPlay = (HivePrefUtil.getBool('enableAutoPlay') ?? true).obs;
  final enableFullScreenDefault = (HivePrefUtil.getBool('enableFullScreenDefault') ?? false).obs;
  final device = (HivePrefUtil.getString('device') ?? 'phone').obs;
  final webKeyTimeStamp = (HivePrefUtil.getInt('webKeyTimeStamp') ?? 0).obs;
  final webKeys = (HivePrefUtil.getString('webKeys') ?? '').obs;
  final lrcApiIndex = (HivePrefUtil.getInt('lrcApiIndex') ?? 0).obs;
  final volume = (HivePrefUtil.getDouble('volume') ?? 0.0).obs;
  final enableStartUp = (HivePrefUtil.getBool('enableStartUp') ?? false).obs;
  final dontAskExit = (HivePrefUtil.getBool('dontAskExit') ?? false).obs;
  final exitChoose = (HivePrefUtil.getString('exitChoose') ?? '').obs;
  // ==============================
  // ⏰ 自动关机
  // ==============================
  final autoShutDownTime = (HivePrefUtil.getInt('autoShutDownTime') ?? 120).obs;
  final enableAutoShutDownTime = (HivePrefUtil.getBool('enableAutoShutDownTime') ?? false).obs;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countDown);
  StopWatchTimer get stopWatchTimer => _stopWatchTimer;

  // ==============================
  // 🍪 平台 Cookie
  // ==============================
  final bilibiliCookie = (HivePrefUtil.getString('bilibiliCookie') ?? '').obs;

  // ==============================
  // 📺 播放设置
  // ==============================
  final preferResolution = (HivePrefUtil.getString('preferResolution') ?? AppConsts.resolutions[0]).obs;
  static const List<String> resolutions = ['原画', '蓝光8M', '蓝光4M', '超清', '流畅'];

  // ==============================
  // ❤️ 关注 UP 主
  // ==============================
  final followers =
      ((HivePrefUtil.getStringList('followers') ?? []).map((e) => UpUserInfo.fromJson(jsonDecode(e))).toList()).obs;

  // ==============================
  // 🎵 音乐播放列表 & 歌单
  // ==============================
  final currentMediaIndex = (HivePrefUtil.getInt('currentMediaIndex') ?? 0).obs;
  final currentMusicPosition = (HivePrefUtil.getInt('currentMusicPosition') ?? 0).obs;
  final currentMusicDuration = (HivePrefUtil.getInt('currentMusicDuration') ?? 0).obs;

  final currentMediaList = (HivePrefUtil.getStringList('currentMediaList') ?? [])
      .map((e) => LiveMediaInfo.fromJson(jsonDecode(e)))
      .toList()
      .obs;

  final musicAlbum =
      (HivePrefUtil.getStringList('musicAlbum') ?? []).map((e) => BilibiliVideo.fromJson(jsonDecode(e))).toList().obs;

  // ==============================
  // ☁️ 备份
  // ==============================
  final backupDirectory = (HivePrefUtil.getString('backupDirectory') ?? '').obs;

  // ==============================
  // 🎨 常量
  // ==============================
  final deviceList = ['phone', 'pad', 'pc'].obs;
  final lrcApiUrl = ["https://api.lrc.cx/jsonapi", "https://tools.rangotec.com/api/anon/lrc"];
  final int favoriteId = 8888888888;

  static Map<String, ThemeMode> themeModes = {
    "System": ThemeMode.system,
    "Dark": ThemeMode.dark,
    "Light": ThemeMode.light,
  };

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

  final Map<ColorSwatch<Object>, String> colorsNameMap =
      themeColors.map((key, value) => MapEntry(ColorTools.createPrimarySwatch(value), key));
  // --- 数据迁移 ---
  Future<void> migrateOldPrefsData() async {
    if (HivePrefUtil.getBool('_migrated_from_sp') == true) {
      return;
    }
    try {
      final allKeys = PrefUtil.prefs.getKeys();
      for (final key in allKeys) {
        final value = PrefUtil.prefs.get(key);
        if (value == null) continue;
        if (value is String) {
          await HivePrefUtil.setString(key, value);
        } else if (value is int) {
          await HivePrefUtil.setInt(key, value);
        } else if (value is bool) {
          await HivePrefUtil.setBool(key, value);
        } else if (value is double) {
          await HivePrefUtil.setDouble(key, value);
        } else if (value is List<String>) {
          await HivePrefUtil.setStringList(key, value);
        }
      }
      await HivePrefUtil.setBool('_migrated_from_sp', true);
      log('旧 SharedPreferences 数据迁移到 Hive 完成！', name: 'SettingsService');
    } catch (e) {
      log('数据迁移失败: $e', name: 'SettingsService');
    }
  }

  // ==============================
  // 🧩 Lifecycle: onInit
  // ==============================
  @override
  void onInit() {
    super.onInit();
    migrateOldPrefsData().then((_) {
      update(['migrate_complete']);
    });
    initFavoriteMusic();

    // === 监听并持久化 ===
    themeColorSwitch.listen((value) {
      HivePrefUtil.setString('themeColorSwitch', value);
    });

    enableAutoCheckUpdate.listen((value) {
      HivePrefUtil.setBool('enableAutoCheckUpdate', value);
    });

    backupDirectory.listen((String value) {
      HivePrefUtil.setString('backupDirectory', value);
    });

    bilibiliCookie.listen((value) {
      HivePrefUtil.setString('bilibiliCookie', value);
    });

    device.listen((value) {
      HivePrefUtil.setString('device', value);
    });

    webKeyTimeStamp.listen((value) {
      HivePrefUtil.setInt('webKeyTimeStamp', value);
    });

    webKeys.listen((value) {
      HivePrefUtil.setString('webKeys', value);
    });

    enableAutoPlay.listen((value) {
      HivePrefUtil.setBool('enableAutoPlay', value);
    });

    dontAskExit.listen((value) {
      HivePrefUtil.setBool('dontAskExit', value);
    });

    exitChoose.listen((value) {
      HivePrefUtil.setString('exitChoose', value);
    });

    enableFullScreenDefault.listen((value) {
      HivePrefUtil.setBool('enableFullScreenDefault', value);
    });
    enableStartUp.listen((value) {
      HivePrefUtil.setBool('enableStartUp', value);
      if (value) {
        launchAtStartup.enable();
      } else {
        launchAtStartup.disable();
      }
    });

    debounce(autoShutDownTime, (callback) {
      HivePrefUtil.setInt('autoShutDownTime', autoShutDownTime.value);
      if (enableAutoShutDownTime.isTrue) {
        _stopWatchTimer.onStopTimer();
        _stopWatchTimer.setPresetMinuteTime(autoShutDownTime.value, add: false);
        _stopWatchTimer.onStartTimer();
      } else {
        _stopWatchTimer.onStopTimer();
      }
    }, time: 1.seconds);

    debounce(enableAutoShutDownTime, (callback) {
      HivePrefUtil.setBool('enableAutoShutDownTime', enableAutoShutDownTime.value);
      if (enableAutoShutDownTime.isTrue) {
        _stopWatchTimer.onStopTimer();
        _stopWatchTimer.setPresetMinuteTime(autoShutDownTime.value, add: false);
        _stopWatchTimer.onStartTimer();
      } else {
        _stopWatchTimer.onStopTimer();
      }
    }, time: 1.seconds);

    musicAlbum.listen((value) {
      HivePrefUtil.setStringList('musicAlbum', value.map((e) => jsonEncode(e.toJson())).toList());
    });

    currentMediaList.listen((medias) {
      HivePrefUtil.setStringList('currentMediaList', medias.map((e) => jsonEncode(e.toJson())).toList());
    });

    followers.listen((value) {
      HivePrefUtil.setStringList('followers', value.map((e) => jsonEncode(e.toJson())).toList());
    });

    currentMediaIndex.listen((index) {
      HivePrefUtil.setInt('currentMediaIndex', index);
    });

    currentMusicPosition.listen((value) {
      HivePrefUtil.setInt('currentMusicPosition', value);
    });

    currentMusicDuration.listen((value) {
      HivePrefUtil.setInt('currentMusicDuration', value);
    });

    lrcApiIndex.listen((value) {
      HivePrefUtil.setInt('lrcApiIndex', value);
    });

    volume.listen((value) {
      HivePrefUtil.setDouble('volume', value);
    });

    onInitShutDown();
    _stopWatchTimer.fetchEnded.listen((value) {
      _stopWatchTimer.onStopTimer();
      FlutterExitApp.exitApp();
    });
  }

  // ==============================
  // 🛠️ 方法区
  // ==============================

  // --- 主题 & 语言 ---
  void changeThemeMode(String mode) {
    themeModeName.value = mode;
    HivePrefUtil.setString('themeMode', mode);
    Get.changeThemeMode(themeMode);
  }

  void changeThemeColorSwitch(String hexColor) {
    var themeColor = HexColor(hexColor);
    var lightTheme = MyTheme(primaryColor: themeColor).lightThemeData;
    var darkTheme = MyTheme(primaryColor: themeColor).darkThemeData;
    Get.changeTheme(lightTheme);
    Get.changeTheme(darkTheme);
  }

  void changeLrcApiIndex(int index) {
    lrcApiIndex.value = index;
    HivePrefUtil.setInt('lrcApiIndex', index);
  }

  void changeDevice(String dv) {
    device.value = dv;
    HivePrefUtil.setString('device', dv);
  }

  void changePreferResolution(String name) {
    if (resolutions.contains(name)) {
      preferResolution.value = name;
      HivePrefUtil.setString('preferResolution', name);
    }
  }

  // --- 自动关机 ---
  void onInitShutDown() {
    if (enableAutoShutDownTime.isTrue) {
      _stopWatchTimer.setPresetMinuteTime(autoShutDownTime.value, add: false);
      _stopWatchTimer.onStartTimer();
    }
  }

  void changeShutDownConfig(int minutes, bool isAutoShutDown) {
    autoShutDownTime.value = minutes;
    enableAutoShutDownTime.value = isAutoShutDown;
    HivePrefUtil.setInt('autoShutDownTime', minutes);
    HivePrefUtil.setBool('enableAutoShutDownTime', isAutoShutDown);
    onInitShutDown();
  }

  // --- 关注 UP 主 ---
  bool isFollowed(String mid) {
    return followers.any((element) => element.mid == mid);
  }

  void follow(UpUserInfo user) {
    if (!isFollowed(user.mid)) {
      followers.add(user);
    }
  }

  void toggleFollow(UpUserInfo user) {
    isFollowed(user.mid) ? unFollow(user) : follow(user);
  }

  void unFollow(UpUserInfo user) {
    followers.remove(user);
  }

  // --- 播放控制 ---
  void setCurrentMusicDuration(int duration) {
    currentMusicDuration.value = duration;
  }

  void setCurrentMusicPosition(int position) {
    currentMusicPosition.value = position;
  }

  void setCurrentMediaIndex(int index) {
    currentMediaIndex.value = index;
  }

  void setCurrentMedia(LiveMediaInfo mediaInfo) {
    setCurrentMediaIndex(currentMediaList.indexWhere((e) => e.cid == mediaInfo.cid));
  }

  Future<void> startPlayVideoAtIndex(int index, List<LiveMediaInfo> currentPlaylist) async {
    currentMediaList.assignAll(currentPlaylist);
    currentMediaIndex.value = index;
  }

  LiveMediaInfo getCurrentVideoInfo() => currentMediaList[currentMediaIndex.value];

  LiveMediaInfo getNextVideoInfo() {
    int next = currentMediaIndex.value + 1;
    setCurrentMediaIndex(next < currentMediaList.length ? next : 0);
    return currentMediaList[currentMediaIndex.value];
  }

  LiveMediaInfo getPreviousVideoInfo() {
    int prev = currentMediaIndex.value - 1;
    setCurrentMediaIndex(prev >= 0 ? prev : currentMediaList.length - 1);
    return currentMediaList[currentMediaIndex.value];
  }

  bool isCurrentMedia(LiveMediaInfo mediaInfo) {
    if (currentMediaList.isEmpty) return false;
    return currentMediaList[currentMediaIndex.value].cid == mediaInfo.cid;
  }

  void setCurrentMusicList(List<LiveMediaInfo> medias) {
    currentMediaList.value = medias;
    currentMediaIndex.value = 0;
    final audioController = Get.find<AudioController>();
    audioController.startPlay(medias[0]);
  }

  // --- 音乐歌单 ---
  void initFavoriteMusic() {
    if (!musicAlbum.any((e) => e.id == favoriteId)) {
      var video = BilibiliVideo(
        id: favoriteId,
        title: '我喜欢的',
        author: '我喜欢的音乐',
        pubdate: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        status: VideoStatus.customized,
      );
      musicAlbum.insert(0, video);
    }
  }

  bool isInFavoriteMusic(LiveMediaInfo mediaInfo) {
    final album = musicAlbum.firstWhere((e) => e.id == favoriteId);
    return album.medias.any((e) => e.cid == mediaInfo.cid);
  }

  void addInFavoriteMusic(LiveMediaInfo mediaInfo) {
    final album = musicAlbum.firstWhere((e) => e.id == favoriteId);
    if (!album.medias.any((e) => e.cid == mediaInfo.cid)) {
      album.medias.add(mediaInfo);
      musicAlbum.refresh();
    }
  }

  void removeInFavoriteMusic(LiveMediaInfo mediaInfo) {
    final album = musicAlbum.firstWhere((e) => e.id == favoriteId);
    album.medias.removeWhere((e) => e.cid == mediaInfo.cid);
    musicAlbum.refresh();
  }

  void addMusicAlbum(BilibiliVideo video, List<LiveMediaInfo> medias) {
    if (!musicAlbum.any((e) => e.id == video.id)) {
      video.medias = medias;
      musicAlbum.add(video);
    }
  }

  void toggleCollectMusic(BilibiliVideo video, List<LiveMediaInfo> medias) {
    if (musicAlbum.any((e) => e.id == video.id)) {
      musicAlbum.removeWhere((e) => e.id == video.id);
    } else {
      video.medias = medias;
      musicAlbum.add(video);
    }
  }

  bool isExistMusicAlbum(BilibiliVideo video) => musicAlbum.any((e) => e.id == video.id);

  void editMusicAlbum(BilibiliVideo video) {
    final idx = musicAlbum.indexWhere((e) => e.id == video.id);
    if (idx != -1) {
      musicAlbum[idx].title = video.title;
      if (video.author?.isNotEmpty ?? false) musicAlbum[idx].author = video.author;
      musicAlbum.refresh();
      update();
    }
  }

  void removeMusicAlbum(BilibiliVideo video) {
    musicAlbum.removeWhere((e) => e.id == video.id);
  }

  bool isExistInMusicAlbum(int? id, LiveMediaInfo media) {
    final album = musicAlbum.firstWhere((e) => e.id == id);
    return album.medias.any((e) => e.cid == media.cid);
  }

  void addMusicToAlbum(int? id, List<LiveMediaInfo> medias) {
    final album = musicAlbum.firstWhere((e) => e.id == id);
    for (var m in medias) {
      if (!album.medias.any((e) => e.cid == m.cid)) {
        album.medias.add(m);
      }
    }
    musicAlbum.refresh();
  }

  List<LiveMediaInfo> deleteMusicFromAlbum(int? id, List<LiveMediaInfo> medias) {
    final album = musicAlbum.firstWhere((e) => e.id == id);
    for (var m in medias) {
      album.medias.removeWhere((e) => e.cid == m.cid);
    }
    musicAlbum.refresh();
    return album.medias;
  }

  bool isInMusicAlbum(BilibiliVideo video) => musicAlbum.any((e) => e.id == video.id);

  void moveMusicToTop(BilibiliVideo video) {
    if (musicAlbum.any((e) => e.id == video.id)) {
      musicAlbum.removeWhere((e) => e.id == video.id);
      musicAlbum.insert(0, video);
    }
  }

  // --- 账号 ---
  void setBilibiliCookie(String cookie) {
    final service = Get.find<BiliBiliAccountService>();
    if (service.cookie.isEmpty || service.uid == 0) {
      service.resetCookie(cookie);
      service.loadUserInfo();
    }
  }

  // --- 备份 & 恢复 ---
  bool backup(File file) {
    try {
      file.writeAsStringSync(jsonEncode(toJson()));
      return true;
    } catch (e) {
      log(e.toString(), name: 'SettingsService');
      return false;
    }
  }

  bool recover(File file) {
    try {
      fromJson(jsonDecode(file.readAsStringSync()));
      return true;
    } catch (e) {
      return false;
    }
  }

  // --- JSON 序列化 ---
  void fromJson(Map<String, dynamic> json) {
    final audioController = Get.find<AudioController>();
    audioController.pause();

    themeModeName.value = json['themeMode'] ?? "System";
    bilibiliCookie.value = json['bilibiliCookie'] ?? '';
    themeColorSwitch.value = json['themeColorSwitch'] ?? Colors.blue.hex;
    enableAutoPlay.value = json['enableAutoPlay'] ?? true;
    enableAutoCheckUpdate.value = json['enableAutoCheckUpdate'] ?? true;
    enableFullScreenDefault.value = json['enableFullScreenDefault'] ?? false;
    autoShutDownTime.value = json['autoShutDownTime'] ?? 120;
    enableAutoShutDownTime.value = json['enableAutoShutDownTime'] ?? false;
    preferResolution.value = json['preferResolution'] ?? resolutions[0];
    device.value = json['device'] ?? 'phone';
    webKeyTimeStamp.value = json['webKeyTimeStamp'] ?? 0;
    webKeys.value = json['webKeys'] ?? '';
    lrcApiIndex.value = json['lrcApiIndex'] ?? 0;
    volume.value = json['volume'] ?? 0.0;
    dontAskExit.value = json['dontAskExit'] ?? false;
    exitChoose.value = json['exitChoose'] ?? '';
    musicAlbum.value = (json['musicAlbum'] as List?)?.map((e) => BilibiliVideo.fromJson(jsonDecode(e))).toList() ?? [];

    currentMediaList.value =
        (json['currentMediaList'] as List?)?.map((e) => LiveMediaInfo.fromJson(jsonDecode(e))).toList() ?? [];

    followers.value = (json['followers'] as List?)?.map((e) => UpUserInfo.fromJson(jsonDecode(e))).toList() ?? [];
    enableStartUp.value = json['enableStartUp'] ?? false;
    currentMediaIndex.value = json['currentMediaIndex'] ?? 0;
    currentMusicPosition.value = json['currentMusicPosition'] ?? 0;
    currentMusicDuration.value = json['currentMusicDuration'] ?? 0;

    // 应用配置
    changeThemeMode(themeModeName.value);
    changeThemeColorSwitch(themeColorSwitch.value);
    changePreferResolution(preferResolution.value);
    changeShutDownConfig(autoShutDownTime.value, enableAutoShutDownTime.value);
    setBilibiliCookie(bilibiliCookie.value);

    // 恢复播放
    if (currentMediaList.isNotEmpty) {
      audioController.isMusicFirstLoad.value = true;
      audioController.startPlay(currentMediaList[currentMediaIndex.value]);
    }

    if (enableStartUp.value) {
      launchAtStartup.enable();
    } else {
      launchAtStartup.disable();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeModeName.value,
      'themeColorSwitch': themeColorSwitch.value,
      'bilibiliCookie': bilibiliCookie.value,
      'enableAutoPlay': enableAutoPlay.value,
      'enableAutoCheckUpdate': enableAutoCheckUpdate.value,
      'enableFullScreenDefault': enableFullScreenDefault.value,
      'autoShutDownTime': autoShutDownTime.value,
      'enableAutoShutDownTime': enableAutoShutDownTime.value,
      'preferResolution': preferResolution.value,
      'device': device.value,
      'webKeyTimeStamp': webKeyTimeStamp.value,
      'webKeys': webKeys.value,
      'lrcApiIndex': lrcApiIndex.value,
      'volume': volume.value,
      'enableStartUp': enableStartUp.value,
      'musicAlbum': musicAlbum.map((e) => jsonEncode(e.toJson())).toList(),
      'currentMediaList': currentMediaList.map((e) => jsonEncode(e.toJson())).toList(),
      'followers': followers.map((e) => jsonEncode(e.toJson())).toList(),
      'currentMediaIndex': currentMediaIndex.value,
      'currentMusicPosition': currentMusicPosition.value,
      'currentMusicDuration': currentMusicDuration.value,
      'dontAskExit': dontAskExit.value,
      'exitChoose': exitChoose.value,
    };
  }
}

/// 模拟常量类（与参考代码对齐）
class AppConsts {
  static Map<String, ThemeMode> themeModes = {
    "System": ThemeMode.system,
    "Dark": ThemeMode.dark,
    "Light": ThemeMode.light,
  };

  static List<String> resolutions = ['原画', '蓝光8M', '蓝光4M', '超清', '流畅'];
}
