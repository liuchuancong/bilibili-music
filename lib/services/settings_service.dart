import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/style/theme.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:bilibilimusic/models/bili_up_info.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:bilibilimusic/utils/hive_pref_util.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:bilibilimusic/services/audio_service.dart';
import 'package:bilibilimusic/models/video_media_info.dart';
import 'package:bilibilimusic/services/bilibili_account_service.dart';

class AppSettingsService extends GetxController {
  ThemeMode get themeMode => AppThemeConstants.themeModes[themeModeName.value]!;

  // ==============================
  // 🎨 主题
  // ==============================
  final themeModeName = (HivePrefUtil.getString('theme_mode') ?? "System").obs;
  final themeColorHex = (HivePrefUtil.getString('theme_color_hex') ?? Colors.blue.hex).obs;

  // ==============================
  // ⚙️ 基础设置
  // ==============================
  final enableAutoCheckUpdate = (HivePrefUtil.getBool('enable_auto_check_update') ?? true).obs;
  final enableAutoPlay = (HivePrefUtil.getBool('enable_auto_play') ?? true).obs;
  final enableFullScreenByDefault = (HivePrefUtil.getBool('enable_fullscreen_default') ?? false).obs;
  final playDeviceType = (HivePrefUtil.getString('play_device_type') ?? 'phone').obs;
  final webKeyTimestamp = (HivePrefUtil.getInt('web_key_timestamp') ?? 0).obs;
  final bilibiliWebKeys = (HivePrefUtil.getString('bilibili_web_keys') ?? '').obs;
  final lyricApiIndex = (HivePrefUtil.getInt('lyric_api_index') ?? 0).obs;
  final audioVolume = (HivePrefUtil.getDouble('audio_volume') ?? 0.0).obs;
  final enableLaunchAtStartup = (HivePrefUtil.getBool('enable_launch_at_startup') ?? false).obs;
  final enableExitWithoutConfirm = (HivePrefUtil.getBool('enable_exit_without_confirm') ?? false).obs;
  final exitActionType = (HivePrefUtil.getString('exit_action_type') ?? '').obs;
  final enableBackgroundPlay = (HivePrefUtil.getBool('enable_background_play') ?? false).obs;
  // ==============================
  // ⏰ 自动退出
  // ==============================
  final autoExitAfterMinutes = (HivePrefUtil.getInt('auto_exit_minutes') ?? 120).obs;
  final enableAutoExit = (HivePrefUtil.getBool('enable_auto_exit') ?? false).obs;
  final StopWatchTimer _autoExitTimer = StopWatchTimer(mode: StopWatchMode.countDown);
  StopWatchTimer get autoExitTimer => _autoExitTimer;

  // ==============================
  // 🍪 Cookie
  // ==============================
  final bilibiliCookie = (HivePrefUtil.getString('bilibili_cookie') ?? '').obs;

  // ==============================
  // 🎥 播放设置
  // ==============================
  final preferredVideoQuality =
      (HivePrefUtil.getString('preferred_video_quality') ?? AppPlayConstants.videoQualities[0]).obs;
  static const List<String> videoQualities = ['原画', '蓝光8M', '蓝光4M', '超清', '流畅'];

  // ==============================
  // ❤️ 关注 UP 主
  // ==============================
  final followedUpList =
      ((HivePrefUtil.getStringList('followed_up_list') ?? []).map((e) => BiliUpInfo.fromJson(jsonDecode(e))).toList())
          .obs;

  // ==============================
  // 🎵 播放列表 & 歌单
  // ==============================
  final currentPlayIndex = (HivePrefUtil.getInt('current_play_index') ?? 0).obs;
  final currentPlayPosition = (HivePrefUtil.getInt('current_play_position') ?? 0).obs;
  final currentPlayDuration = (HivePrefUtil.getInt('current_play_duration') ?? 0).obs;

  final currentPlaylist = (HivePrefUtil.getStringList('current_playlist') ?? [])
      .map((e) => VideoMediaInfo.fromJson(jsonDecode(e)))
      .toList()
      .obs;

  final musicPlaylists = (HivePrefUtil.getStringList('music_playlists') ?? [])
      .map((e) => BilibiliVideoItem.fromJson(jsonDecode(e)))
      .toList()
      .obs;

  // ==============================
  // ☁️ 备份
  // ==============================
  final backupFolderPath = (HivePrefUtil.getString('backup_folder_path') ?? '').obs;

  // ==============================
  // 🎨 常量
  // ==============================
  final deviceOptions = ['phone', 'pad', 'pc'].obs;
  final lyricApiList = ["https://api.lrc.cx/jsonapi", "https://tools.rangotec.com/api/anon/lrc"];
  final int favoriteMusicPlaylistId = 8888888888;

  final Map<ColorSwatch<Object>, String> themeColorMap =
      AppThemeConstants.themeColors.map((key, value) => MapEntry(ColorTools.createPrimarySwatch(value), key));

  // ==============================
  // onInit
  // ==============================
  @override
  void onInit() {
    super.onInit();
    initFavoriteMusic();
    _setupAllListeners();
    onInitShutDown();

    _autoExitTimer.fetchEnded.listen((_) {
      _autoExitTimer.onStopTimer();
      FlutterExitApp.exitApp();
    });
  }

  // ==============================
  // 监听绑定
  // ==============================
  void _setupAllListeners() {
    themeColorHex.listen((v) => HivePrefUtil.setString('theme_color_hex', v));
    enableAutoCheckUpdate.listen((v) => HivePrefUtil.setBool('enable_auto_check_update', v));
    backupFolderPath.listen((v) => HivePrefUtil.setString('backup_folder_path', v));
    bilibiliCookie.listen((v) => HivePrefUtil.setString('bilibili_cookie', v));
    playDeviceType.listen((v) => HivePrefUtil.setString('play_device_type', v));
    webKeyTimestamp.listen((v) => HivePrefUtil.setInt('web_key_timestamp', v));
    bilibiliWebKeys.listen((v) => HivePrefUtil.setString('bilibili_web_keys', v));
    enableAutoPlay.listen((v) => HivePrefUtil.setBool('enable_auto_play', v));
    enableExitWithoutConfirm.listen((v) => HivePrefUtil.setBool('enable_exit_without_confirm', v));
    exitActionType.listen((v) => HivePrefUtil.setString('exit_action_type', v));
    enableFullScreenByDefault.listen((v) => HivePrefUtil.setBool('enable_fullscreen_default', v));

    enableLaunchAtStartup.listen((v) {
      HivePrefUtil.setBool('enable_launch_at_startup', v);
      v ? launchAtStartup.enable() : launchAtStartup.disable();
    });

    debounce(autoExitAfterMinutes, (_) {
      HivePrefUtil.setInt('auto_exit_minutes', autoExitAfterMinutes.value);
      _restartAutoExitTimer();
    }, time: 1.seconds);

    debounce(enableAutoExit, (_) {
      HivePrefUtil.setBool('enable_auto_exit', enableAutoExit.value);
      enableAutoExit.value ? _restartAutoExitTimer() : _autoExitTimer.onStopTimer();
    });

    musicPlaylists.listen((v) {
      HivePrefUtil.setStringList('music_playlists', v.map((e) => jsonEncode(e.toJson())).toList());
    });

    currentPlaylist.listen((v) {
      HivePrefUtil.setStringList('current_playlist', v.map((e) => jsonEncode(e.toJson())).toList());
    });

    followedUpList.listen((v) {
      HivePrefUtil.setStringList('followed_up_list', v.map((e) => jsonEncode(e.toJson())).toList());
    });

    currentPlayIndex.listen((v) => HivePrefUtil.setInt('current_play_index', v));
    currentPlayPosition.listen((v) => HivePrefUtil.setInt('current_play_position', v));
    currentPlayDuration.listen((v) => HivePrefUtil.setInt('current_play_duration', v));
    lyricApiIndex.listen((v) => HivePrefUtil.setInt('lyric_api_index', v));
    audioVolume.listen((v) => HivePrefUtil.setDouble('audio_volume', v));
    enableBackgroundPlay.listen((v) {
      HivePrefUtil.setBool('enable_background_play', v);
    });
  }

  // ==============================
  // 自动关机
  // ==============================
  void onInitShutDown() {
    if (enableAutoExit.isTrue) {
      _autoExitTimer.setPresetMinuteTime(autoExitAfterMinutes.value, add: false);
      _autoExitTimer.onStartTimer();
    }
  }

  void _restartAutoExitTimer() {
    _autoExitTimer.onStopTimer();
    _autoExitTimer.setPresetMinuteTime(autoExitAfterMinutes.value, add: false);
    _autoExitTimer.onStartTimer();
  }

  void changeShutDownConfig(int minutes, bool isAutoExit) {
    autoExitAfterMinutes.value = minutes;
    enableAutoExit.value = isAutoExit;
    HivePrefUtil.setInt('auto_exit_minutes', minutes);
    HivePrefUtil.setBool('enable_auto_exit', isAutoExit);
    onInitShutDown();
  }

  // ==============================
  // 主题
  // ==============================
  void updateThemeMode(String mode) {
    themeModeName.value = mode;
    HivePrefUtil.setString('theme_mode', mode);
    Get.changeThemeMode(themeMode);
  }

  void updateThemeColor(String hexColor) {
    final color = HexColor(hexColor);
    Get.changeTheme(MyTheme(primaryColor: color).lightThemeData);
    Get.changeTheme(MyTheme(primaryColor: color).darkThemeData);
  }

  void changeLrcApiIndex(int index) {
    lyricApiIndex.value = index;
    HivePrefUtil.setInt('lyric_api_index', index);
  }

  void changeDevice(String dv) {
    playDeviceType.value = dv;
    HivePrefUtil.setString('play_device_type', dv);
  }

  void changePreferResolution(String name) {
    if (videoQualities.contains(name)) {
      preferredVideoQuality.value = name;
      HivePrefUtil.setString('preferred_video_quality', name);
    }
  }

  // ==============================
  // 关注 UP 主
  // ==============================
  bool isFollowed(String mid) {
    return followedUpList.any((e) => e.mid == mid);
  }

  void follow(BiliUpInfo user) {
    if (!isFollowed(user.mid)) {
      followedUpList.add(user);
    }
  }

  void toggleFollow(BiliUpInfo user) {
    isFollowed(user.mid) ? followedUpList.remove(user) : followedUpList.add(user);
  }

  void unFollow(BiliUpInfo user) {
    followedUpList.remove(user);
  }

  // ==============================
  // 播放控制
  // ==============================
  void setCurrentMusicDuration(int duration) => currentPlayDuration.value = duration;
  void setCurrentMusicPosition(int position) => currentPlayPosition.value = position;
  void setCurrentMediaIndex(int index) => currentPlayIndex.value = index;

  void setCurrentMedia(VideoMediaInfo mediaInfo) {
    setCurrentMediaIndex(currentPlaylist.indexWhere((e) => e.cid == mediaInfo.cid));
  }

  Future<void> startPlayVideoAtIndex(int index, List<VideoMediaInfo> playlist) async {
    currentPlaylist.assignAll(playlist);
    currentPlayIndex.value = index;
  }

  VideoMediaInfo getCurrentVideoInfo() => currentPlaylist[currentPlayIndex.value];

  VideoMediaInfo getNextVideoInfo() {
    int next = currentPlayIndex.value + 1;
    setCurrentMediaIndex(next < currentPlaylist.length ? next : 0);
    return currentPlaylist[currentPlayIndex.value];
  }

  VideoMediaInfo getPreviousVideoInfo() {
    int prev = currentPlayIndex.value - 1;
    setCurrentMediaIndex(prev >= 0 ? prev : currentPlaylist.length - 1);
    return currentPlaylist[currentPlayIndex.value];
  }

  bool isCurrentMedia(VideoMediaInfo mediaInfo) {
    if (currentPlaylist.isEmpty) return false;
    return currentPlaylist[currentPlayIndex.value].cid == mediaInfo.cid;
  }

  void setCurrentMusicList(List<VideoMediaInfo> medias) {
    currentPlaylist.value = medias;
    currentPlayIndex.value = 0;
    final audioController = Get.find<AudioController>();
    audioController.startPlay(medias[0]);
  }

  // ==============================
  // 歌单方法（完全原版逻辑，100% 不报错）
  // ==============================
  void initFavoriteMusic() {
    if (!musicPlaylists.any((e) => e.id == favoriteMusicPlaylistId)) {
      var video = BilibiliVideoItem(
        id: favoriteMusicPlaylistId,
        title: '我喜欢的',
        author: '我喜欢的音乐',
        pubdate: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        category: VideoCategory.customized,
      );
      musicPlaylists.insert(0, video);
    }
  }

  bool isInFavoriteMusic(VideoMediaInfo mediaInfo) {
    final album = musicPlaylists.firstWhere((e) => e.id == favoriteMusicPlaylistId);
    return album.medias.any((e) => e.cid == mediaInfo.cid);
  }

  void addInFavoriteMusic(VideoMediaInfo mediaInfo) {
    final album = musicPlaylists.firstWhere((e) => e.id == favoriteMusicPlaylistId);
    if (!album.medias.any((e) => e.cid == mediaInfo.cid)) {
      album.medias.add(mediaInfo);
      musicPlaylists.refresh();
    }
  }

  void removeInFavoriteMusic(VideoMediaInfo mediaInfo) {
    final album = musicPlaylists.firstWhere((e) => e.id == favoriteMusicPlaylistId);
    album.medias.removeWhere((e) => e.cid == mediaInfo.cid);
    musicPlaylists.refresh();
  }

  void toggleFavoriteMusic(VideoMediaInfo mediaInfo) {
    final album = musicPlaylists.firstWhere((e) => e.id == favoriteMusicPlaylistId);
    if (album.medias.any((e) => e.cid == mediaInfo.cid)) {
      album.medias.removeWhere((e) => e.cid == mediaInfo.cid);
    } else {
      album.medias.add(mediaInfo);
    }
    musicPlaylists.refresh();
  }

  void addToPlaylist(int playlistId, VideoMediaInfo mediaInfo) {
    final album = musicPlaylists.firstWhere((e) => e.id == playlistId);
    if (!album.medias.any((e) => e.cid == mediaInfo.cid)) {
      album.medias.add(mediaInfo);
      musicPlaylists.refresh();
    }
  }

  void addMusicPlaylist(BilibiliVideoItem video, List<VideoMediaInfo> medias) {
    if (!musicPlaylists.any((e) => e.id == video.id)) {
      video.medias = medias;
      musicPlaylists.add(video);
    }
  }

  void toggleCollectMusic(BilibiliVideoItem video, List<VideoMediaInfo> medias) {
    if (musicPlaylists.any((e) => e.id == video.id)) {
      musicPlaylists.removeWhere((e) => e.id == video.id);
    } else {
      video.medias = medias;
      musicPlaylists.add(video);
    }
  }

  bool isExistMusicAlbum(BilibiliVideoItem video) => musicPlaylists.any((e) => e.id == video.id);

  void editMusicAlbum(BilibiliVideoItem video) {
    final idx = musicPlaylists.indexWhere((e) => e.id == video.id);
    if (idx != -1) {
      musicPlaylists[idx].title = video.title;
      if (video.author?.isNotEmpty ?? false) musicPlaylists[idx].author = video.author;
      musicPlaylists.refresh();
      update();
    }
  }

  void removeMusicAlbum(BilibiliVideoItem video) {
    musicPlaylists.removeWhere((e) => e.id == video.id);
  }

  bool isInMusicAlbum(BilibiliVideoItem video) => musicPlaylists.any((e) => e.id == video.id);

  void moveMusicToTop(BilibiliVideoItem video) {
    if (musicPlaylists.any((e) => e.id == video.id)) {
      musicPlaylists.removeWhere((e) => e.id == video.id);
      musicPlaylists.insert(0, video);
    }
  }

  bool isExistInMusicAlbum(int? id, VideoMediaInfo media) {
    final album = musicPlaylists.firstWhere((e) => e.id == id);
    return album.medias.any((e) => e.cid == media.cid);
  }

  void addMusicToAlbum(int? id, List<VideoMediaInfo> medias) {
    final album = musicPlaylists.firstWhere((e) => e.id == id);
    for (var m in medias) {
      if (!album.medias.any((e) => e.cid == m.cid)) {
        album.medias.add(m);
      }
    }
    musicPlaylists.refresh();
  }

  List<VideoMediaInfo> deleteMusicFromAlbum(int? id, List<VideoMediaInfo> medias) {
    final album = musicPlaylists.firstWhere((e) => e.id == id);
    for (var m in medias) {
      album.medias.removeWhere((e) => e.cid == m.cid);
    }
    musicPlaylists.refresh();
    return album.medias;
  }

  // ==============================
  // 账号
  // ==============================
  void setBilibiliCookie(String cookie) {
    final service = Get.find<BiliBiliAccountService>();
    if (service.cookie.isEmpty || service.uid == 0) {
      service.resetCookie(cookie);
      service.loadUserInfo();
    }
  }

  // ==============================
  // 备份 / 恢复
  // ==============================
  bool backupToFile(File file) {
    try {
      file.writeAsStringSync(jsonEncode(toJson()));
      return true;
    } catch (e) {
      return false;
    }
  }

  bool restoreFromFile(File file) {
    try {
      fromJson(jsonDecode(file.readAsStringSync()));
      return true;
    } catch (e) {
      return false;
    }
  }

  // ==============================
  // JSON
  // ==============================
  Map<String, dynamic> toJson() => {
        'theme_mode': themeModeName.value,
        'theme_color_hex': themeColorHex.value,
        'bilibili_cookie': bilibiliCookie.value,
        'enable_auto_play': enableAutoPlay.value,
        'enable_auto_check_update': enableAutoCheckUpdate.value,
        'enable_fullscreen_default': enableFullScreenByDefault.value,
        'auto_exit_minutes': autoExitAfterMinutes.value,
        'enable_auto_exit': enableAutoExit.value,
        'preferred_video_quality': preferredVideoQuality.value,
        'play_device_type': playDeviceType.value,
        'web_key_timestamp': webKeyTimestamp.value,
        'bilibili_web_keys': bilibiliWebKeys.value,
        'lyric_api_index': lyricApiIndex.value,
        'audio_volume': audioVolume.value,
        'enable_launch_at_startup': enableLaunchAtStartup.value,
        'enable_exit_without_confirm': enableExitWithoutConfirm.value,
        'exit_action_type': exitActionType.value,
        'music_playlists': musicPlaylists.map((e) => jsonEncode(e.toJson())).toList(),
        'current_playlist': currentPlaylist.map((e) => jsonEncode(e.toJson())).toList(),
        'followed_up_list': followedUpList.map((e) => jsonEncode(e.toJson())).toList(),
        'current_play_index': currentPlayIndex.value,
        'current_play_position': currentPlayPosition.value,
        'current_play_duration': currentPlayDuration.value,
        'backup_folder_path': backupFolderPath.value,
        'enable_background_play': enableBackgroundPlay.value,
      };

  void fromJson(Map<String, dynamic> json) {
    final audioController = Get.find<AudioController>();
    audioController.pause();

    themeModeName.value = json['theme_mode'] ?? "System";
    bilibiliCookie.value = json['bilibili_cookie'] ?? '';
    themeColorHex.value = json['theme_color_hex'] ?? Colors.blue.hex;
    enableAutoPlay.value = json['enable_auto_play'] ?? true;
    enableAutoCheckUpdate.value = json['enable_auto_check_update'] ?? true;
    enableFullScreenByDefault.value = json['enable_fullscreen_default'] ?? false;
    autoExitAfterMinutes.value = json['auto_exit_minutes'] ?? 120;
    enableAutoExit.value = json['enable_auto_exit'] ?? false;
    preferredVideoQuality.value = json['preferred_video_quality'] ?? videoQualities[0];
    playDeviceType.value = json['play_device_type'] ?? 'phone';
    webKeyTimestamp.value = json['web_key_timestamp'] ?? 0;
    bilibiliWebKeys.value = json['bilibili_web_keys'] ?? '';
    lyricApiIndex.value = json['lyric_api_index'] ?? 0;
    audioVolume.value = json['audio_volume'] ?? 0.0;
    enableLaunchAtStartup.value = json['enable_launch_at_startup'] ?? false;
    enableExitWithoutConfirm.value = json['enable_exit_without_confirm'] ?? false;
    exitActionType.value = json['exit_action_type'] ?? '';
    backupFolderPath.value = json['backup_folder_path'] ?? '';
    enableBackgroundPlay.value = json['enable_background_play'] ?? false;

    musicPlaylists.value =
        (json['music_playlists'] as List?)?.map((e) => BilibiliVideoItem.fromJson(jsonDecode(e))).toList() ?? [];
    currentPlaylist.value =
        (json['current_playlist'] as List?)?.map((e) => VideoMediaInfo.fromJson(jsonDecode(e))).toList() ?? [];
    followedUpList.value =
        (json['followed_up_list'] as List?)?.map((e) => BiliUpInfo.fromJson(jsonDecode(e))).toList() ?? [];

    currentPlayIndex.value = json['current_play_index'] ?? 0;
    currentPlayPosition.value = json['current_play_position'] ?? 0;
    currentPlayDuration.value = json['current_play_duration'] ?? 0;

    updateThemeMode(themeModeName.value);
    updateThemeColor(themeColorHex.value);
    changePreferResolution(preferredVideoQuality.value);
    changeShutDownConfig(autoExitAfterMinutes.value, enableAutoExit.value);
    setBilibiliCookie(bilibiliCookie.value);

    if (currentPlaylist.isNotEmpty) {
      audioController.isMusicFirstLoad.value = true;
      audioController.startPlay(currentPlaylist[currentPlayIndex.value]);
    }

    if (enableLaunchAtStartup.value) {
      launchAtStartup.enable();
    } else {
      launchAtStartup.disable();
    }
  }
}

class AppThemeConstants {
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
}

class AppPlayConstants {
  static List<String> videoQualities = ['原画', '蓝光8M', '蓝光4M', '超清', '流畅'];
}
