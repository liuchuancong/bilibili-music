import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bilibilimusic/core/bilibili_site.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';

class AudioController extends GetxController {
  late AudioPlayer _audioPlayer;
  final _playlist = <LiveMediaInfo>[].obs; // 使用RxList来管理播放列表
  final _currentIndex = 0.obs;
  final SettingsService settingsService = Get.find<SettingsService>();
  AudioPlayer get audioPlayer => _audioPlayer;
  List<LiveMediaInfo> get playlist => _playlist;
  final isPlaying = false.obs;
  int get currentIndex => _currentIndex.value;

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
      print('position: $position');
      currentMusicPosition.value = position;
    });

    _audioPlayer.durationStream.listen((duration) {
      // 监听总时长
      print('duration: $duration');
      currentMusicDuration.value = duration!;
    });

    _audioPlayer.playerStateStream.listen((state) {
      // 监听播放状态
      print('state: $state');
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

  Future<void> startPlay(LiveMediaInfo mediaInfo, {int retries = 0}) async {
    if (retries >= 3) {
      print('Failed to fetch audio detail after 3 attempts.');

      return;
    }

    try {
      LiveMediaInfoData? videoInfoData =
          await BiliBiliSite().getAudioDetail(mediaInfo.aid, mediaInfo.cid, mediaInfo.bvid);
      if (videoInfoData != null) {
        _audioPlayer.setUrl(videoInfoData.url); // 假设audioUrl是videoInfoData的一个属性
        await _audioPlayer.play();
      } else {
        await Future.delayed(const Duration(seconds: 2));
        await startPlay(mediaInfo, retries: retries + 1);
      }
    } catch (e) {
      print('Error fetching audio detail: $e');
      await Future.delayed(const Duration(seconds: 2));
      await startPlay(mediaInfo, retries: retries + 1);
    }
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
    if (_playlist.isNotEmpty) {
      int newIndex;
      if (_currentIndex.value < _playlist.length - 1) {
        newIndex = _currentIndex.value + 1;
      } else {
        newIndex = 0; // 到达列表末尾，跳转到第一个元素
      }
      _currentIndex.value = newIndex;
      await startPlay(_playlist[_currentIndex.value]);
    }
  }

  Future<void> previous() async {
    if (_playlist.isNotEmpty) {
      int newIndex;
      if (_currentIndex.value > 0) {
        newIndex = _currentIndex.value - 1;
      } else {
        newIndex = _playlist.length - 1; // 到达列表开头，跳转到最后一个元素
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
