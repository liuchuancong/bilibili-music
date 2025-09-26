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

    enableAutoPlay.listen((value) {
      PrefUtil.setBool('enableAutoPlay', value);
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

    musicAlbum.listen((value) {
      PrefUtil.setStringList('musicAlbum', value.map((e) => jsonEncode(e.toJson())).toList());
    });

    currentMediaList.listen((List<LiveMediaInfo> medias) {
      PrefUtil.setStringList('currentMediaList', medias.map<String>((e) => jsonEncode(e.toJson())).toList());
    });

    followers.listen((List<UpUserInfo> value) {
      PrefUtil.setStringList('followers', value.map((e) => jsonEncode(e.toJson())).toList());
    });

    currentMediaIndex.listen((index) {
      PrefUtil.setInt('currentMediaIndex', index);
    });

    currentMusicPosition.listen((value) {
      PrefUtil.setInt('currentMusicPosition', value);
    });

    currentMusicDuration.listen((value) {
      PrefUtil.setInt('currentMusicDuration', value);
    });

    lrcApiIndex.listen((value) {
      PrefUtil.setInt('lrcApiIndex', value);
    });

    volume.listen((value) {
      PrefUtil.setDouble('volume', value);
    });

    initFavoriteMusic();
  }

  // Theme settings
  static Map<String, ThemeMode> themeModes = {
    "System": ThemeMode.system,
    "Dark": ThemeMode.dark,
    "Light": ThemeMode.light,
  };
  final themeModeName = (PrefUtil.getString('themeMode') ?? "System").obs;

  final volume = (PrefUtil.getDouble('volume') ?? 0.0).obs;

  ThemeMode get themeMode => SettingsService.themeModes[themeModeName.value]!;
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

  final lrcApiUrl = ["https://api.lrc.cx/jsonapi", "https://tools.rangotec.com/api/anon/lrc"];

  final lrcApiIndex = (PrefUtil.getInt('lrcApiIndex') ?? 0).obs;

  void changeLrcApiIndex(int index) {
    lrcApiIndex.value = index;
    PrefUtil.setInt('lrcApiIndex', index);
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

  final enableAutoPlay = (PrefUtil.getBool('enableAutoPlay') ?? true).obs;

  final enableFullScreenDefault = (PrefUtil.getBool('enableFullScreenDefault') ?? false).obs;

  final enableAutoShutDownTime = (PrefUtil.getBool('enableAutoShutDownTime') ?? false).obs;

  final autoShutDownTime = (PrefUtil.getInt('autoShutDownTime') ?? 120).obs;

  final bilibiliCookie = (PrefUtil.getString('bilibiliCookie') ?? '').obs;

  final device = (PrefUtil.getString('device') ?? 'phone').obs;

  final deviceList = ['phone', 'pad', 'pc'].obs;

  final webKeyTimeStamp = (PrefUtil.getInt('webKeyTimeStamp') ?? 0).obs;

  final webKeys = (PrefUtil.getString('webKeys') ?? '').obs;

  final preferResolution = (PrefUtil.getString('preferResolution') ?? resolutions[0]).obs;

  static const List<String> resolutions = ['原画', '蓝光8M', '蓝光4M', '超清', '流畅'];

  final int favoriteId = 8888888888;

  final followers =
      ((PrefUtil.getStringList('followers') ?? []).map((e) => UpUserInfo.fromJson(jsonDecode(e))).toList()).obs;

  bool isFollowed(String mid) {
    int index = followers.indexWhere((element) => element.mid == mid);
    return index != -1;
  }

  void follow(UpUserInfo user) {
    if (isFollowed(user.mid)) {
      return;
    }
    followers.add(user);
    PrefUtil.setStringList('followers', followers.map((e) => jsonEncode(e.toJson())).toList());
  }

  void toggleFollow(UpUserInfo user) {
    if (isFollowed(user.mid)) {
      unFollow(user);
    } else {
      follow(user);
    }
  }

  void unFollow(UpUserInfo user) {
    if (!isFollowed(user.mid)) {
      return;
    }
    followers.remove(user);
    PrefUtil.setStringList('followers', followers.map((e) => jsonEncode(e.toJson())).toList());
  }

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

  var currentMusicPosition = (PrefUtil.getInt('currentMusicPosition') ?? 0).obs;

  var currentMusicDuration = (PrefUtil.getInt('currentMusicDuration') ?? 0).obs;

  void setCurrentMusicDuration(int duration) {
    currentMusicDuration.value = duration;
    PrefUtil.setInt('currentMusicDuration', duration);
  }

  void setCurrentMusicPosition(int position) {
    currentMusicPosition.value = position;
    PrefUtil.setInt('currentMusicPosition', position);
  }

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

  void initFavoriteMusic() {
    if (!musicAlbum.any((element) => element.id == favoriteId)) {
      BilibiliVideo video = BilibiliVideo(
        id: favoriteId,
        title: '我喜欢的',
        author: '我喜欢的音乐',
        pubdate: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        status: VideoStatus.customized,
      );
      musicAlbum.insert(0, video);
      PrefUtil.setStringList('musicAlbum', musicAlbum.map((e) => jsonEncode(e.toJson())).toList());
    }
  }

  bool isInFavoriteMusic(LiveMediaInfo mediaInfo) {
    var album = musicAlbum.firstWhere((element) => element.id == favoriteId);
    List<LiveMediaInfo> insertMedias = album.medias;
    int index = insertMedias.indexWhere(
        (element) => element.cid == mediaInfo.cid && element.aid == mediaInfo.aid && element.bvid == mediaInfo.bvid);
    return index != -1;
  }

  void addInFavoriteMusic(LiveMediaInfo mediaInfo) {
    var album = musicAlbum.firstWhere((element) => element.id == favoriteId);
    List<LiveMediaInfo> insertMedias = album.medias;
    int index = insertMedias.indexWhere(
        (element) => element.cid == mediaInfo.cid && element.aid == mediaInfo.aid && element.bvid == mediaInfo.bvid);
    if (index == -1) {
      insertMedias.add(mediaInfo);
      album.medias = insertMedias;
      PrefUtil.setStringList('musicAlbum', musicAlbum.map((e) => jsonEncode(e.toJson())).toList());
    }
  }

  void removeInFavoriteMusic(LiveMediaInfo mediaInfo) {
    var album = musicAlbum.firstWhere((element) => element.id == favoriteId);
    List<LiveMediaInfo> insertMedias = album.medias;
    int index = insertMedias.indexWhere(
        (element) => element.cid == mediaInfo.cid && element.aid == mediaInfo.aid && element.bvid == mediaInfo.bvid);
    if (index != -1) {
      insertMedias.removeAt(index);
      album.medias = insertMedias;
      PrefUtil.setStringList('musicAlbum', musicAlbum.map((e) => jsonEncode(e.toJson())).toList());
    }
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

  bool isExitMusicAlbum(int? id, LiveMediaInfo media) {
    var album = musicAlbum.firstWhere((element) => element.id == id);
    int index = album.medias
        .indexWhere((element) => element.cid == media.cid && element.aid == media.aid && element.bvid == media.bvid);
    return index != -1;
  }

  void addMusicToAlbum(int? id, List<LiveMediaInfo> medias) {
    var album = musicAlbum.firstWhere((element) => element.id == id);
    var index = musicAlbum.indexWhere((element) => element.id == id);
    List<LiveMediaInfo> insertMedias = album.medias;
    for (var media in medias) {
      int index = insertMedias
          .indexWhere((element) => element.cid == media.cid && element.aid == media.aid && element.bvid == media.bvid);
      if (index == -1) {
        insertMedias.add(media);
      }
    }
    musicAlbum[index].medias = insertMedias;
    PrefUtil.setStringList('musicAlbum', musicAlbum.map((e) => jsonEncode(e.toJson())).toList());
  }

  List<LiveMediaInfo> deleteMusicFromAlbum(int? id, List<LiveMediaInfo> medias) {
    var album = musicAlbum.firstWhere((element) => element.id == id);
    var index = musicAlbum.indexWhere((element) => element.id == id);
    List<LiveMediaInfo> insertMedias = album.medias;
    for (var media in medias) {
      int index = insertMedias
          .indexWhere((element) => element.cid == media.cid && element.aid == media.aid && element.bvid == media.bvid);
      if (index != -1) {
        insertMedias.removeAt(index);
      }
    }
    musicAlbum[index].medias = insertMedias;
    PrefUtil.setStringList('musicAlbum', musicAlbum.map((e) => jsonEncode(e.toJson())).toList());
    return insertMedias;
  }

  bool isInMusicAlbum(BilibiliVideo video) {
    return musicAlbum.any((element) => element.id == video.id);
  }

  void setCurreentMusicList(List<LiveMediaInfo> medias) {
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
      log(e.toString(), name: 'SettingsService');
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

  void setBilibiliCookit(String cookie) {
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
    final AudioController audioController = Get.find<AudioController>();
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
    musicAlbum.value =
        (json['musicAlbum'] as List).map<BilibiliVideo>((e) => BilibiliVideo.fromJson(jsonDecode(e))).toList();
    currentMediaList.value =
        (json['currentMediaList'] as List).map<LiveMediaInfo>((e) => LiveMediaInfo.fromJson(jsonDecode(e))).toList();
    currentMediaIndex.value = json['currentMediaIndex'] ?? 0;
    currentMusicPosition.value = json['currentMusicPosition'] ?? 0;
    currentMusicDuration.value = json['currentMusicDuration'] ?? 0;
    lrcApiIndex.value = json['lrcApiIndex'] ?? 0;
    followers.value = (json['followers'] as List).map<UpUserInfo>((e) => UpUserInfo.fromJson(jsonDecode(e))).toList();
    volume.value = json['volume'] ?? 0.0;
    changeThemeMode(themeModeName.value);
    changeThemeColorSwitch(themeColorSwitch.value);
    changePreferResolution(preferResolution.value);
    changeShutDownConfig(autoShutDownTime.value, enableAutoShutDownTime.value);
    setBilibiliCookit(bilibiliCookie.value);
    audioController.isMusicFirstLoad.value = true;
    audioController.startPlay(currentMediaList[currentMediaIndex.value]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['themeMode'] = themeModeName.value;
    json['autoShutDownTime'] = autoShutDownTime.value;
    json['enableAutoShutDownTime'] = enableAutoShutDownTime.value;
    json['enableAutoPlay'] = enableAutoPlay.value;
    json['enableAutoCheckUpdate'] = enableAutoCheckUpdate.value;
    json['enableFullScreenDefault'] = enableFullScreenDefault.value;
    json['preferResolution'] = preferResolution.value;
    json['bilibiliCookie'] = bilibiliCookie.value;
    json['themeColorSwitch'] = themeColorSwitch.value;
    json['device'] = device.value;
    json['webKeyTimeStamp'] = webKeyTimeStamp.value;
    json['webKeys'] = webKeys.value;
    json['musicAlbum'] = musicAlbum.map((e) => jsonEncode(e.toJson())).toList();
    json['currentMediaList'] = currentMediaList.map((e) => jsonEncode(e.toJson())).toList();
    json['currentMediaIndex'] = currentMediaIndex.value;
    json['currentMusicPosition'] = currentMusicPosition.value;
    json['currentMusicDuration'] = currentMusicDuration.value;
    json['lrcApiIndex'] = lrcApiIndex.value;
    json['followers'] = followers.map((e) => jsonEncode(e.toJson())).toList();
    json['volume'] = volume.value;
    return json;
  }
}
