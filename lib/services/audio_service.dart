import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:get/get.dart';
import 'dart:developer' as developer;
import 'package:media_kit/media_kit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:audio_service/audio_service.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/video_media_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:bilibilimusic/play/lyric/lyric_ui/ui_netease.dart';
import 'package:bilibilimusic/play/lyric/lyrics_reader_model.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

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
  late Player player = Player();
  final AppSettingsService settingsService = Get.find<AppSettingsService>();
  late LyricsReaderModel lyricModel;
  late UINetease lyricUI;
  AudioPlayer get audioPlayer => _audioPlayer;
  Player get desktopPlayer => player;
  List<VideoMediaInfo> get playlist => settingsService.currentPlaylist.value;
  final isPlaying = false.obs;
  final showLyric = false.obs;
  final isFavorite = false.obs;
  final currentVolume = 1.0.obs;
  int get currentIndex => settingsService.currentPlayIndex.value;
  final playMode = PlayMode.listLoop.obs; // 默认播放模式为列表循环
  final currentMusicDuration = const Duration(seconds: 0).obs;
  final currentPlayPosition = const Duration(seconds: 0).obs;
  final normalLyric = ''.obs;
  final lyricStatus = LyricStatus.loading.obs;
  final ScrollController _scrollController = ScrollController();
  final Rx<MediaItem> currentMusicInfo = Rx<MediaItem>(MediaItem(id: '', title: '', artist: ''));
  final isMusicFirstLoad = true.obs;
  @override
  void onInit() {
    super.onInit();
    if (Platform.isAndroid) {
      _audioPlayer = AudioPlayer(
        userAgent:
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
        useProxyForRequestHeaders: false,
      );

      _audioPlayer.positionStream.listen((position) {
        // 监听播放进度
        currentPlayPosition.value = position;
        if (!isMusicFirstLoad.value) {
          settingsService.currentPlayPosition.value = position.inSeconds;
        }
      });

      _audioPlayer.durationStream.listen((duration) {
        // 监听总时长
        if (duration != null) {
          currentMusicDuration.value = duration;
          settingsService.currentPlayDuration.value = duration.inSeconds;
        }
      });

      _audioPlayer.playerStateStream.listen((state) {
        // 监听播放状态
        isPlaying.value = state.playing;
        if (state.processingState == ProcessingState.completed) {
          next();
        }
      });
    } else {
      player = Player();
      player.stream.playing.listen(
        (bool playing) {
          isPlaying.value = playing;
        },
      );
      player.stream.completed.listen(
        (bool completed) {
          if (completed) {
            next();
          }
        },
      );
      player.stream.duration.listen(
        (Duration duration) {
          currentMusicDuration.value = duration;
          settingsService.currentPlayDuration.value = duration.inSeconds;
        },
      );
      player.stream.position.listen(
        (Duration position) {
          currentPlayPosition.value = position;
          if (!isMusicFirstLoad.value) {
            settingsService.currentPlayPosition.value = position.inSeconds;
          }
        },
      );
    }
    // 监听播放列表变化
    if (playlist.isNotEmpty) {
      Timer(const Duration(seconds: 2), () {
        currentMusicInfo.value = MediaItem(
          id: "${currentMediaInfo.aid}_${currentMediaInfo.cid}_${currentMediaInfo.bvid}",
          title: currentMediaInfo.part,
          artist: currentMediaInfo.name,
          album: '',
          artUri: Uri.tryParse(currentMediaInfo.face),
        );
        registerVolumeListener();
        startPlay(
          playlist[currentIndex],
          isAutoPlay: settingsService.enableAutoPlay.value,
        );
      });
    }
    currentVolume.listen((value) {
      double localVolume = settingsService.audioVolume.value;
      if (localVolume != value) {
        settingsService.audioVolume.value = value;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (Platform.isAndroid) {
      _audioPlayer.dispose();
    } else {
      player.dispose();
    }
  }

  void setPlaylist(List<VideoMediaInfo> urls) {
    settingsService.currentPlaylist.assignAll(urls);
  }

  void toggleFavorite() {
    isFavorite.value = settingsService.isInFavoriteMusic(currentMediaInfo);
    if (isFavorite.value) {
      settingsService.removeInFavoriteMusic(currentMediaInfo);
    } else {
      settingsService.addInFavoriteMusic(currentMediaInfo);
    }
    isFavorite.toggle();
  }

  Future<void> startPlay(VideoMediaInfo mediaInfo, {bool isAutoPlay = true}) async {
    isFavorite.value = settingsService.isInFavoriteMusic(mediaInfo);
    isPlaying.value = false;
    if (Platform.isAndroid) {
      await audioPlayer.stop();
    } else {
      player.stop();
    }
    VideoPlaySource? videoInfoData = await BiliBiliSite().getAudioDetail(mediaInfo.aid, mediaInfo.cid, mediaInfo.bvid);
    if (videoInfoData != null) {
      getLyric(mediaInfo);
      developer.log('videoInfoData: ${videoInfoData.toString()}', name: 'audioPlayerSetUrl');
      developer.log('mediaInfo: ${mediaInfo.toString()}', name: 'mediaInfo');
      try {
        if (Platform.isAndroid) {
          await _audioPlayer.setUrl(
            Uri.decodeComponent(videoInfoData.url),
            initialPosition:
                isMusicFirstLoad.value ? Duration(seconds: settingsService.currentPlayPosition.value) : Duration.zero,
            headers: getHeaders(mediaInfo),
          );
        } else {
          await player.open(
            Media(
              videoInfoData.url,
              httpHeaders: getHeaders(mediaInfo),
              start:
                  isMusicFirstLoad.value ? Duration(seconds: settingsService.currentPlayPosition.value) : Duration.zero,
            ),
            play: isAutoPlay,
          );
          await getVolume();
          await setVolume(currentVolume.value);
        }
        isMusicFirstLoad.value = false;
        if (isAutoPlay) {
          if (Platform.isAndroid) {
            Timer(const Duration(seconds: 1), () async {
              await _audioPlayer.play();
              await getVolume();
              await setVolume(currentVolume.value);
            });
          }
        }
      } catch (e) {
        developer.log(e.toString(), name: 'audioPlayerSetUrl');
        SmartDialog.showToast("当前歌曲加载失败,正在播放下一首");
        await Future.delayed(const Duration(seconds: 2));
        next();
      }
    } else {
      SmartDialog.showToast("当前歌曲加载失败,正在播放下一首");
      await Future.delayed(const Duration(seconds: 2));
      next();
    }
  }

  Future<void> retryStartPlay(VideoMediaInfo mediaInfo) async {
    await Future.delayed(const Duration(seconds: 2));
    await startPlay(mediaInfo);
  }

  VideoMediaInfo get currentMediaInfo => settingsService.currentPlaylist[settingsService.currentPlayIndex.value];

  Future<void> play() async {
    if (Platform.isAndroid) {
      _audioPlayer.play();
    } else {
      player.play();
    }
  }

  Future<void> pause() async {
    if (Platform.isAndroid) {
      _audioPlayer.pause();
    } else {
      player.pause();
    }
  }

  Future<void> seek(Duration position) async {
    if (Platform.isAndroid) {
      _audioPlayer.seek(position);
    } else {
      player.seek(position);
    }
  }

  Future<void> getVolume() async {
    double localVolume = settingsService.audioVolume.value;
    if (localVolume == 0.0) {
      if (Platform.isWindows) {
        currentVolume.value = player.state.volume / 100;
      } else {
        currentVolume.value = (await FlutterVolumeController.getVolume())!;
      }
    } else {
      currentVolume.value = localVolume;
    }
  }

  // 注册音量变化监听器
  void registerVolumeListener() {
    FlutterVolumeController.addListener((volume) {
      // 音量变化时的回调
      if (Platform.isAndroid) {
        currentVolume.value = volume;
      }
    });
  }

  Future<void> setVolume(double volume) async {
    volume = min(volume, 1.0);
    volume = max(volume, 0.0);
    if (Platform.isAndroid) {
      _audioPlayer.setVolume(volume);
    } else {
      player.setVolume(volume * 100);
    }
  }

  Future<void> getLyric(VideoMediaInfo mediaInfo) async {
    lyricStatus.value = LyricStatus.loading;
    normalLyric.value = '';

    currentMusicInfo.value = MediaItem(
      id: "${mediaInfo.aid}_${mediaInfo.cid}_${mediaInfo.bvid}",
      title: mediaInfo.part,
      artist: mediaInfo.name,
      album: '',
      artUri: Uri.tryParse(mediaInfo.face),
    );

    try {
      MediaItem? mediaItem =
          await BiliBiliSite().getAudioLyricAsMediaItem(mediaInfo.aid, mediaInfo.cid, mediaInfo.bvid);
      String title = mediaItem!.title;
      String author = mediaItem.artist ?? '';
      currentMusicInfo.value = mediaItem;
      // 定义正则表达式，用于匹配整个结构
      String pattern = r'\([^)]*\)|（[^）]*）';
      final regex = RegExp(pattern, dotAll: true);
      String lyricContent = '';
      title = title.replaceAll(regex, '');
      title = title.replaceAll(RegExp(r'$[^)]*$'), '').replaceAll(RegExp(r'\s*$[^)]*$\s*'), '');
      List<LyricResults> lyricResults = await BiliBiliSite().getSearchLyrics(title, author);

      // 匹配歌词的正则表达式
      if (lyricResults.isNotEmpty) {
        lyricContent = lyricResults[0].lyrics;
      }
      if (currentMediaInfo.aid == mediaInfo.aid &&
          currentMediaInfo.cid == mediaInfo.cid &&
          currentMediaInfo.bvid == mediaInfo.bvid) {
        lyricStatus.value = LyricStatus.loadSuccess;
        normalLyric.value = lyricContent;
      } else {
        lyricStatus.value = LyricStatus.loadSuccess;
        normalLyric.value = '';
      }
    } catch (_) {
      lyricStatus.value = LyricStatus.loadFailed;
      normalLyric.value = '';
    }
  }

  Map<String, String> getHeaders(VideoMediaInfo mediaInfo) {
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

  Future<void> stop() async {
    if (Platform.isAndroid) {
      _audioPlayer.stop();
    } else {
      player.stop();
    }
  }

  Future<void> startPlayAtIndex(int index, List<VideoMediaInfo> currentPlaylist) async {
    settingsService.currentPlaylist.assignAll(currentPlaylist);
    settingsService.currentPlayIndex.value = index;
    await startPlay(currentPlaylist[index]);
  }

  Future<void> next() async {
    if (settingsService.currentPlaylist.isNotEmpty) {
      int newIndex;
      switch (playMode.value) {
        case PlayMode.singleLoop:
          // 如果是单曲循环，保持索引不变
          newIndex = settingsService.currentPlayIndex.value;
          break;
        case PlayMode.listLoop:
          // 如果是列表循环，按正常顺序或循环到第一个元素
          if (settingsService.currentPlayIndex.value < settingsService.currentPlaylist.length - 1) {
            newIndex = settingsService.currentPlayIndex.value + 1;
          } else {
            newIndex = 0;
          }
          break;
        case PlayMode.random:
          // 如果是随机播放，选择一个随机索引
          newIndex = Random().nextInt(settingsService.currentPlaylist.length);
          break;
      }
      await startPlay(settingsService.currentPlaylist[newIndex]);
      settingsService.currentPlayIndex.value = newIndex;
    }
  }

  Future<void> previous() async {
    if (settingsService.currentPlaylist.isNotEmpty) {
      int newIndex;
      switch (playMode.value) {
        case PlayMode.singleLoop:
          // 如果是单曲循环，保持索引不变
          newIndex = settingsService.currentPlayIndex.value;
          break;
        case PlayMode.listLoop:
          // 如果是列表循环，按正常顺序或循环到最后一个元素
          if (settingsService.currentPlayIndex.value > 0) {
            newIndex = settingsService.currentPlayIndex.value - 1;
          } else {
            newIndex = settingsService.currentPlaylist.length - 1;
          }
          break;
        case PlayMode.random:
          // 如果是随机播放，选择一个随机索引
          newIndex = Random().nextInt(settingsService.currentPlaylist.length);
          break;
      }
      await startPlay(settingsService.currentPlaylist[newIndex]);
      settingsService.currentPlayIndex.value = newIndex;
    }
  }

  Future<void> showMenuMedias() async {
    List<VideoMediaInfo> list = settingsService.currentPlaylist.value;
    int currentIndex = settingsService.currentPlayIndex.value;

    // 先计算要滚动的位置（精准居中）
    double itemHeight = 36; // 每行高度
    double screenHeight = 400; // 弹窗高度
    double targetOffset = currentIndex * itemHeight - (screenHeight / 2) + (itemHeight / 2);

    // 延迟一帧确保布局完成后滚动（不抖动）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent));
      }
    });

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '播放列表',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () {
                Navigator.of(Get.context!).pop();
              },
            ),
          ],
        ),
        content: SizedBox(
          width: Get.width * 0.8,
          height: 420,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: list.asMap().entries.map((entry) {
                int index = entry.key;
                VideoMediaInfo item = entry.value;
                bool isPlaying = settingsService.isCurrentMedia(item);

                return InkWell(
                  onTap: () {
                    if (isPlaying) {
                      SmartDialog.showToast("已在播放中");
                      return;
                    }
                    settingsService.currentPlayIndex.value = index;
                    startPlay(item);
                    Navigator.of(Get.context!).pop();
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Text(
                      item.part,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.2,
                        fontWeight: isPlaying ? FontWeight.w600 : FontWeight.w400,
                        color: isPlaying ? Theme.of(Get.context!).colorScheme.primary : Colors.grey[800],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  @override
  void onClose() {
    if (Platform.isAndroid) {
      _audioPlayer.dispose();
    } else {
      player.dispose();
    }
    _scrollController.dispose(); // 避免内存泄漏
    super.onClose();
  }

  void changePlayMode() {
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
