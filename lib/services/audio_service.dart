import 'dart:io';
import 'dart:math';
import 'dart:async';
import 'package:get/get.dart';
import 'dart:developer' as developer;
import 'package:media_kit/media_kit.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
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
  final SettingsService settingsService = Get.find<SettingsService>();
  late LyricsReaderModel lyricModel;
  late UINetease lyricUI;
  AudioPlayer get audioPlayer => _audioPlayer;
  Player get desktopPlayer => player;
  List<LiveMediaInfo> get playlist => settingsService.currentMediaList.value;
  final isPlaying = false.obs;
  final showLyric = false.obs;
  final isFavorite = false.obs;
  final currentVolumn = 1.0.obs;
  int get currentIndex => settingsService.currentMediaIndex.value;
  final playMode = PlayMode.listLoop.obs; // 默认播放模式为列表循环
  final currentMusicDuration = const Duration(seconds: 0).obs;
  final currentMusicPosition = const Duration(seconds: 0).obs;
  final normalLyric = ''.obs;
  final lyricStatus = LyricStatus.loading.obs;
  final ScrollController _scrollController = ScrollController();
  final currentMusicInfo = {
    'album': '',
    'title': '',
    'author': '',
    'cover': '',
  }.obs;
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
        currentMusicPosition.value = position;
        if (!isMusicFirstLoad.value) {
          settingsService.currentMusicPosition.value = position.inSeconds;
        }
      });

      _audioPlayer.durationStream.listen((duration) {
        // 监听总时长
        if (duration != null) {
          currentMusicDuration.value = duration;
          settingsService.currentMusicDuration.value = duration.inSeconds;
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
          settingsService.currentMusicDuration.value = duration.inSeconds;
        },
      );
      player.stream.position.listen(
        (Duration position) {
          currentMusicPosition.value = position;
          if (!isMusicFirstLoad.value) {
            settingsService.currentMusicPosition.value = position.inSeconds;
          }
        },
      );
    }
    // 监听播放列表变化
    if (playlist.isNotEmpty) {
      Timer(const Duration(seconds: 2), () {
        currentMusicInfo.value = {
          'album': '',
          'title': playlist[currentIndex].part,
          'author': '',
          'cover': playlist[currentIndex].face,
        };
        startPlay(
          playlist[currentIndex],
          isAutoPlay: settingsService.enableAutoPlay.value,
        );
      });
    }
    currentVolumn.listen((value) {
      double localVolume = settingsService.volume.value;
      if (localVolume != value) {
        settingsService.volume.value = value;
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
    _audioPlayer.dispose();
  }

  void setPlaylist(List<LiveMediaInfo> urls) {
    settingsService.currentMediaList.assignAll(urls);
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

  Future<void> startPlay(LiveMediaInfo mediaInfo, {bool isAutoPlay = true}) async {
    isFavorite.value = settingsService.isInFavoriteMusic(mediaInfo);
    isPlaying.value = false;
    if (Platform.isAndroid) {
      await audioPlayer.stop();
    } else {
      player.stop();
    }
    LiveMediaInfoData? videoInfoData =
        await BiliBiliSite().getAudioDetail(mediaInfo.aid, mediaInfo.cid, mediaInfo.bvid);
    if (videoInfoData != null) {
      getLyric(mediaInfo);
      try {
        if (Platform.isAndroid) {
          await _audioPlayer.setUrl(
            Uri.decodeComponent(videoInfoData.url),
            initialPosition:
                isMusicFirstLoad.value ? Duration(seconds: settingsService.currentMusicPosition.value) : Duration.zero,
            headers: getHeaders(mediaInfo),
          );
        } else {
          await player.open(
            Media(
              videoInfoData.url,
              httpHeaders: getHeaders(mediaInfo),
              start: isMusicFirstLoad.value
                  ? Duration(seconds: settingsService.currentMusicPosition.value)
                  : Duration.zero,
            ),
            play: isAutoPlay,
          );
          await getVolume();
          await setVolume(currentVolumn.value);
        }
        isMusicFirstLoad.value = false;
        if (isAutoPlay) {
          if (Platform.isAndroid) {
            Timer(const Duration(seconds: 1), () async {
              await _audioPlayer.play();
              await getVolume();
              await setVolume(currentVolumn.value);
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

  Future<void> retryStartPlay(LiveMediaInfo mediaInfo) async {
    await Future.delayed(const Duration(seconds: 2));
    await startPlay(mediaInfo);
  }

  LiveMediaInfo get currentMediaInfo => settingsService.currentMediaList[settingsService.currentMediaIndex.value];

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
    double localVolume = settingsService.volume.value;
    if (localVolume == 0.0) {
      if (Platform.isWindows) {
        currentVolumn.value = player.state.volume / 100;
      } else {
        currentVolumn.value = (await FlutterVolumeController.getVolume())!;
      }
    } else {
      currentVolumn.value = localVolume;
    }
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

  Future<void> getLyric(LiveMediaInfo mediaInfo) async {
    lyricStatus.value = LyricStatus.loading;
    normalLyric.value = '';
    currentMusicInfo.value = {
      'album': '',
      'title': mediaInfo.part,
      'author': mediaInfo.name,
      'cover': mediaInfo.face,
    };

    try {
      Map<String, dynamic> lyric = await BiliBiliSite().getAudioLyric(mediaInfo.aid, mediaInfo.cid, mediaInfo.bvid);
      String title = lyric['title'] ?? mediaInfo.part;
      String author = lyric['author'] ?? '';
      currentMusicInfo.value = {
        'album': lyric['album'] ?? '',
        'title': title,
        'author': author,
        'cover': lyric['cover'] ?? ''
      };
      // 定义正则表达式，用于匹配整个结构
      String pattern = r'\([^)]*\)|（[^）]*）';
      final regex = RegExp(pattern, dotAll: true);
      String lyricContent = '';
      title = title.replaceAll(regex, '');
      title = title.replaceAll(RegExp(r'$[^)]*$'), '').replaceAll(RegExp(r'\s*$[^)]*$\s*'), '');
      developer.log(title, name: 'getAudioLyric');
      developer.log(author, name: 'getAudioLyric');
      List<LyricResults> lyricResults = await BiliBiliSite().getSearchLyrics(title, author);
      developer.log(lyricResults.length.toString(), name: 'getAudioLyric');
      // 匹配歌词的正则表达式
      if (lyricResults.isEmpty) {
        if (lyric['lyric'] != null) {
          lyricContent = await BiliBiliSite().getBilibiliLyrics(lyric['lyric']);
        }
      } else {
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

  Future<void> stop() async {
    if (Platform.isAndroid) {
      _audioPlayer.stop();
    } else {
      player.stop();
    }
  }

  Future<void> startPlayAtIndex(int index, List<LiveMediaInfo> currentPlaylist) async {
    settingsService.currentMediaList.assignAll(currentPlaylist);
    settingsService.currentMediaIndex.value = index;
    await startPlay(currentPlaylist[index]);
  }

  Future<void> next() async {
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
      await startPlay(settingsService.currentMediaList[newIndex]);
      settingsService.currentMediaIndex.value = newIndex;
    }
  }

  Future<void> previous() async {
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
      await startPlay(settingsService.currentMediaList[newIndex]);
      settingsService.currentMediaIndex.value = newIndex;
    }
  }

  Future<void> showMenuMedias() async {
    List<LiveMediaInfo> list = settingsService.currentMediaList.value;
    Timer(const Duration(milliseconds: 500), () {
      _scrollController.jumpTo(settingsService.currentMediaIndex.value * 32.0 - 200);
    });

    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('正在播放', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(Get.context!).pop();
                      },
                    )
                  ],
                ),
                const Divider(height: 1, color: Colors.black)
              ],
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 400,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: list
                      .map((item) => InkWell(
                            onTap: () {
                              if (settingsService.currentMediaIndex.value == list.indexOf(item)) {
                                SmartDialog.showToast("当前正在播放");
                              } else {
                                int currentIndex = settingsService.currentMediaList.indexWhere((element) =>
                                    element.aid == item.aid && element.cid == item.cid && element.bvid == item.bvid);
                                settingsService.currentMediaIndex.value = currentIndex;
                                startPlay(item);
                              }
                              Navigator.of(Get.context!).pop();
                            },
                            child: SizedBox(
                              width: double.infinity,
                              height: 32,
                              child: Text(item.part,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: settingsService.isCurrentMediia(item)
                                          ? Theme.of(context).colorScheme.primary
                                          : Colors.black)),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          );
        });
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
