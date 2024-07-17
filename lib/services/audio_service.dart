import 'dart:math';
import 'dart:async';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:bilibilimusic/play/lyric/lyric_ui/ui_netease.dart';
import 'package:bilibilimusic/play/lyric/lyrics_reader_model.dart';

enum PlayMode {
  singleLoop, // 单曲循环
  listLoop, // 列表循环
  random, // 随机播放
}

enum LyricStatus {
  loading, // 单曲循环
  loadSuccess, // 列表循环
  loadFailed, // 随机播放
}

class AudioController extends GetxController {
  late AudioPlayer _audioPlayer;
  final SettingsService settingsService = Get.find<SettingsService>();
  late LyricsReaderModel lyricModel;
  late UINetease lyricUI;
  AudioPlayer get audioPlayer => _audioPlayer;
  List<LiveMediaInfo> get playlist => settingsService.currentMediaList.value;
  final isPlaying = false.obs;
  final showLyric = false.obs;
  int tryTimes = 0;
  int get currentIndex => settingsService.currentMediaIndex.value;
  final playMode = PlayMode.listLoop.obs; // 默认播放模式为列表循环
  final currentMusicDuration = const Duration(seconds: 0).obs;
  final currentMusicPosition = const Duration(seconds: 0).obs;
  final normalLyric = ''.obs;
  final lyricStatus = LyricStatus.loading.obs;

  final currentMusicInfo = {
    'album': '',
    'title': '',
    'author': '',
    'cover': '',
    'lyric': '',
  }.obs;

  @override
  void onInit() {
    super.onInit();
    _audioPlayer = AudioPlayer();
    _audioPlayer.positionStream.listen((position) {
      // 监听播放进度
      currentMusicPosition.value = position;
    });

    _audioPlayer.durationStream.listen((duration) {
      // 监听总时长
      if (duration != null) {
        currentMusicDuration.value = duration;
      }
    });

    _audioPlayer.playerStateStream.listen((state) {
      // 监听播放状态
      isPlaying.value = state.playing;
      if (state.processingState == ProcessingState.completed) {
        next();
      }
    });

    // 监听播放列表变化

    if (playlist.isNotEmpty) {
      currentMusicInfo.value = {
        'album': '',
        'title': playlist[currentIndex].part,
        'author': playlist[currentIndex].name,
        'cover': playlist[currentIndex].pic,
        'lyric': '',
      };
      Timer(const Duration(seconds: 2), () {
        startPlay(playlist[currentIndex]);
      });
    }
  }

  void setPlaylist(List<LiveMediaInfo> urls) {
    settingsService.currentMediaList.assignAll(urls);
  }

  Future<void> startPlay(LiveMediaInfo mediaInfo, {bool isAutoPlay = true}) async {
    if (tryTimes >= 3) {
      SmartDialog.showToast("当前歌曲加载失败,正在播放下一首");
      next();
      return;
    }

    try {
      LiveMediaInfoData? videoInfoData =
          await BiliBiliSite().getAudioDetail(mediaInfo.aid, mediaInfo.cid, mediaInfo.bvid);
      if (videoInfoData != null) {
        getLyric(mediaInfo);
        try {
          await _audioPlayer.setUrl(videoInfoData.url, headers: getHeaders(mediaInfo));
          tryTimes = 0; // 重置重试计数器
        } on PlayerException {
          await retryStartPlay(mediaInfo);
        } on PlayerInterruptedException {
          await retryStartPlay(mediaInfo);
        } catch (_) {
          await retryStartPlay(mediaInfo);
        }
      } else {
        await retryStartPlay(mediaInfo);
      }
      if (isAutoPlay) {
        await _audioPlayer.play();
      }
    } catch (_) {
      await retryStartPlay(mediaInfo);
    }
  }

  Future<void> retryStartPlay(LiveMediaInfo mediaInfo) async {
    await Future.delayed(const Duration(seconds: 1));
    tryTimes++; // 增加重试计数器
    await startPlay(mediaInfo);
  }

  Future<void> play() async {
    _audioPlayer.play();
  }

  Future<void> seek(Duration position) async {
    _audioPlayer.seek(position);
  }

  Future<void> getLyric(LiveMediaInfo mediaInfo) async {
    lyricStatus.value = LyricStatus.loading;
    Map musicInfo = await BiliBiliSite().getAudioLyric(mediaInfo.aid, mediaInfo.cid, mediaInfo.bvid);
    currentMusicInfo.value = {
      'album': musicInfo['album'],
      'title': musicInfo['title'],
      'author': musicInfo['author'],
      'cover': musicInfo['cover'],
      'lyric': musicInfo['lyric'],
    };
    if (musicInfo['title'].isEmpty) {
      lyricStatus.value = LyricStatus.loadFailed;
      normalLyric.value = ' ';
    } else {
      if (musicInfo['lyric'].isEmpty) {
        try {
          String lyric = await BiliBiliSite().getLyrics(musicInfo['title']);
          normalLyric.value = lyric;
          lyricStatus.value = LyricStatus.loadSuccess;
        } catch (_) {
          lyricStatus.value = LyricStatus.loadFailed;
          normalLyric.value = ' ';
        }
      } else {
        try {
          String lyric = await BiliBiliSite().getBilibiliLyrics(musicInfo['lyric']);
          normalLyric.value = lyric;
          lyricStatus.value = LyricStatus.loadSuccess;
        } catch (e) {
          try {
            String lyric = await BiliBiliSite().getLyrics(musicInfo['title']);
            normalLyric.value = lyric;
            lyricStatus.value = LyricStatus.loadSuccess;
          } catch (_) {
            lyricStatus.value = LyricStatus.loadFailed;
            normalLyric.value = ' ';
          }
        }
      }
    }
  }

  Map<String, String> getHeaders(LiveMediaInfo mediaInfo) {
    Map<String, String> header = {
      "cookie": settingsService.bilibiliCookie.value,
      "authority": "api.bilibili.com",
      "accept":
          "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
      "accept-language": "zh-CN,zh;q=0.9",
      "cache-control": "no-cache",
      "dnt": "1",
      "pragma": "no-cache",
      "sec-ch-ua": '"Not A(Brand";v="99", "Google Chrome";v="121", "Chromium";v="121"',
      "sec-ch-ua-mobile": "?0",
      "sec-ch-ua-platform": '"macOS"',
      "sec-fetch-dest": "document",
      "sec-fetch-mode": "navigate",
      "sec-fetch-site": "none",
      "sec-fetch-user": "?1",
      "upgrade-insecure-requests": "1",
      "user-agent":
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
      "Referer": "https://www.bilibili.com/video/${mediaInfo.bvid}",
    };
    return header;
  }

  Future<void> pause() async {
    _audioPlayer.pause();
  }

  Future<void> stop() async {
    _audioPlayer.stop();
  }

  Future<void> startPlayAtIndex(int index, List<LiveMediaInfo> currentPlaylist) async {
    settingsService.currentMediaList.assignAll(currentPlaylist);
    settingsService.currentMediaIndex.value = index;
    await startPlay(currentPlaylist[index]);
  }

  Future<void> next() async {
    tryTimes = 0; // 重置重试计数器
    if (settingsService.currentMediaList.isNotEmpty) {
      int newIndex;
      switch (playMode.value) {
        case PlayMode.singleLoop:
          // 如果是单曲循环，保持索引不变
          newIndex = settingsService.currentMediaIndex.value;
          break;
        case PlayMode.listLoop:
          // 如果是列表循环，按正常顺序或循环到第一个元素
          if (settingsService.currentMediaIndex.value < settingsService.currentMediaList.length - 1) {
            newIndex = settingsService.currentMediaIndex.value + 1;
          } else {
            newIndex = 0;
          }
          break;
        case PlayMode.random:
          // 如果是随机播放，选择一个随机索引
          newIndex = Random().nextInt(settingsService.currentMediaList.length);
          break;
      }
      settingsService.currentMediaIndex.value = newIndex;
      await startPlay(settingsService.currentMediaList[settingsService.currentMediaIndex.value]);
    }
  }

  Future<void> previous() async {
    tryTimes = 0; // 重置重试计数器
    if (settingsService.currentMediaList.isNotEmpty) {
      int newIndex;
      switch (playMode.value) {
        case PlayMode.singleLoop:
          // 如果是单曲循环，保持索引不变
          newIndex = settingsService.currentMediaIndex.value;
          break;
        case PlayMode.listLoop:
          // 如果是列表循环，按正常顺序或循环到最后一个元素
          if (settingsService.currentMediaIndex.value > 0) {
            newIndex = settingsService.currentMediaIndex.value - 1;
          } else {
            newIndex = settingsService.currentMediaList.length - 1;
          }
          break;
        case PlayMode.random:
          // 如果是随机播放，选择一个随机索引
          newIndex = Random().nextInt(settingsService.currentMediaList.length);
          break;
      }
      settingsService.currentMediaIndex.value = newIndex;
      await startPlay(settingsService.currentMediaList[settingsService.currentMediaIndex.value]);
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }

  changePlayMode() {
    switch (playMode.value) {
      case PlayMode.listLoop:
        playMode.value = PlayMode.singleLoop;
        SmartDialog.showToast("单曲循环");
        break;
      case PlayMode.singleLoop:
        playMode.value = PlayMode.random;
        SmartDialog.showToast("随机播放");
        break;
      case PlayMode.random:
        playMode.value = PlayMode.listLoop;
        SmartDialog.showToast("列表循环");
        break;
    }
  }
}
