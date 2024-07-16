import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';

enum PlayMode {
  singleLoop, // 单曲循环
  listLoop, // 列表循环
  random, // 随机播放
}

class AudioController extends GetxController {
  late AudioPlayer _audioPlayer;
  final _playlist = <LiveMediaInfo>[].obs; // 使用RxList来管理播放列表
  final _currentIndex = 0.obs;
  final SettingsService settingsService = Get.find<SettingsService>();
  AudioPlayer get audioPlayer => _audioPlayer;
  List<LiveMediaInfo> get playlist => _playlist;
  final isPlaying = false.obs;

  int tryTimes = 0;
  int get currentIndex => _currentIndex.value;
  final playMode = PlayMode.listLoop.obs; // 默认播放模式为列表循环
  final currentMusicDuration = const Duration(seconds: 0).obs;
  final currentMusicPosition = const Duration(seconds: 0).obs;

  @override
  void onInit() {
    super.onInit();
    _audioPlayer = AudioPlayer();
    _currentIndex.value = settingsService.currentMusicIndex.value;
    _playlist.assignAll(settingsService.currentMusicList.value);

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

    _currentIndex.listen((value) {
      settingsService.currentMusicIndex.value = value;
    });

    // 监听播放列表变化

    settingsService.currentMusicList.listen((value) {
      if (value.isNotEmpty) {
        _playlist.clear();
        stop();
        _playlist.assignAll(value);
        _currentIndex.value = 0;
        startPlay(_playlist[0]);
      }
    });
  }

  void setPlaylist(List<LiveMediaInfo> urls) {
    _playlist.assignAll(urls);
  }

  Future<void> startPlay(LiveMediaInfo mediaInfo) async {
    if (tryTimes >= 3) {
      next();
      return;
    }

    try {
      LiveMediaInfoData? videoInfoData =
          await BiliBiliSite().getAudioDetail(mediaInfo.aid, mediaInfo.cid, mediaInfo.bvid);
      if (videoInfoData != null) {
        try {
          await _audioPlayer.setUrl(videoInfoData.url);
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
      await _audioPlayer.play();
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

  Future<void> pause() async {
    _audioPlayer.pause();
  }

  Future<void> stop() async {
    _audioPlayer.stop();
  }

  Future<void> next() async {
    tryTimes = 0; // 重置重试计数器
    if (_playlist.isNotEmpty) {
      int newIndex;
      switch (playMode.value) {
        case PlayMode.singleLoop:
          // 如果是单曲循环，保持索引不变
          newIndex = _currentIndex.value;
          break;
        case PlayMode.listLoop:
          // 如果是列表循环，按正常顺序或循环到第一个元素
          if (_currentIndex.value < _playlist.length - 1) {
            newIndex = _currentIndex.value + 1;
          } else {
            newIndex = 0;
          }
          break;
        case PlayMode.random:
          // 如果是随机播放，选择一个随机索引
          newIndex = Random().nextInt(_playlist.length);
          break;
      }
      _currentIndex.value = newIndex;
      await startPlay(_playlist[_currentIndex.value]);
    }
  }

  Future<void> previous() async {
    tryTimes = 0; // 重置重试计数器
    if (_playlist.isNotEmpty) {
      int newIndex;
      switch (playMode.value) {
        case PlayMode.singleLoop:
          // 如果是单曲循环，保持索引不变
          newIndex = _currentIndex.value;
          break;
        case PlayMode.listLoop:
          // 如果是列表循环，按正常顺序或循环到最后一个元素
          if (_currentIndex.value > 0) {
            newIndex = _currentIndex.value - 1;
          } else {
            newIndex = _playlist.length - 1;
          }
          break;
        case PlayMode.random:
          // 如果是随机播放，选择一个随机索引
          newIndex = Random().nextInt(_playlist.length);
          break;
      }
      _currentIndex.value = newIndex;
      await startPlay(_playlist[_currentIndex.value]);
    }
  }

  @override
  void onClose() {
    _audioPlayer.dispose();
    super.onClose();
  }
}
