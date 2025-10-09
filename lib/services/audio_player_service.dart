import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:media_kit/media_kit.dart';
import 'package:bilibilimusic/exports.dart';
import 'package:bilibilimusic/database/db.dart';
import 'package:audio_service/audio_service.dart';
import 'package:bilibilimusic/database/extensions/song_extension.dart';

class AudioPlayerService extends BaseAudioHandler with SeekHandler {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  final Player player = Player(
    configuration: const PlayerConfiguration(title: 'Bilibili Music'),
  );
  static late AppDatabase _database;
  static AppDatabase get database => _database;

  // PlayerProvider 回调
  Function()? onPlay;
  Function()? onPause;
  Function()? onStop;
  Function()? onNext;
  Function()? onPrevious;
  Function(Duration)? onSeek;

  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal() {
    _setupPlaybackStatePipe();
  }

  MediaItem? _currentMediaItem;
  StreamSubscription? _playbackStateSubscription;
  // 初始化 AudioService
  static Future<AudioPlayerService> init() async {
    await AudioService.init(
      builder: () => AudioPlayerService(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.example.app.channel.audio',
        androidNotificationChannelName: 'Audio Service',
        androidNotificationOngoing: true,
        androidNotificationClickStartsActivity: true,
        androidShowNotificationBadge: true,
      ),
    );
    return _instance;
  }

  void _setupPlaybackStatePipe() {
    // 组合多个流，但保存订阅以便控制
    final stateStream = Rx.combineLatest4<bool, Duration, Duration, bool, PlaybackState>(
      player.stream.playing,
      player.stream.position,
      player.stream.duration,
      player.stream.buffering,
      (playing, position, duration, buffering) {
        return _createPlaybackState(
          playing: playing,
          position: position,
          buffering: buffering,
        );
      },
    );

    // 不要直接 pipe，而是监听并手动更新
    // 这样可以确保状态不会被意外清除
    _playbackStateSubscription = stateStream.listen((state) {
      playbackState.add(state);
    });
  }

  PlaybackState _createPlaybackState({
    required bool playing,
    required Duration position,
    required bool buffering,
  }) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        playing ? MediaControl.pause : MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 2],
      processingState: buffering
          ? AudioProcessingState.buffering
          : (_currentMediaItem != null ? AudioProcessingState.ready : AudioProcessingState.idle),
      playing: playing,
      updatePosition: position,
      bufferedPosition: position,
      speed: playing ? 1.0 : 0.0,
      queueIndex: 0,
    );
  }

  // 设置 PlayerProvider 的回调
  void setCallbacks({
    Function()? onPlay,
    Function()? onPause,
    Function()? onStop,
    Function()? onNext,
    Function()? onPrevious,
    Function(Duration)? onSeek,
  }) {
    this.onPlay = onPlay;
    this.onPause = onPause;
    this.onStop = onStop;
    this.onNext = onNext;
    this.onPrevious = onPrevious;
    this.onSeek = onSeek;
  }

  // 更新媒体项 - 由 PlayerProvider 调用
  void updateCurrentMediaItem(Song song) {
    _currentMediaItem = song.toMediaItem();
    mediaItem.add(_currentMediaItem);
    playbackState.add(_createPlaybackState(
      playing: player.state.playing,
      position: player.state.position,
      buffering: player.state.buffering,
    ));
  }

  // 原有的播放方法，使用 media_kit 播放
  Future<void> playSong(Song song, {bool playNow = true}) async {
    try {
      updateCurrentMediaItem(song);
      await player.open(Media(song.fileUrl!), play: playNow);
    } catch (e) {
      CoreLog.logger.e('Error playing song: $e');
    }
  }

  // BaseAudioHandler 覆盖方法 - 这些会被系统通知栏调用
  // 但实际播放控制仍然通过 PlayerProvider
  @override
  Future<void> play() async {
    onPlay?.call(); // 调用 PlayerProvider 的 togglePlay
  }

  @override
  Future<void> pause() async {
    onPause?.call(); // 调用 PlayerProvider 的 togglePlay
  }

  @override
  Future<void> stop() async {
    onStop?.call(); // 调用 PlayerProvider 的 stop
  }

  @override
  Future<void> skipToNext() async {
    onNext?.call(); // 调用 PlayerProvider 的 next
  }

  @override
  Future<void> skipToPrevious() async {
    onPrevious?.call(); // 调用 PlayerProvider 的 previous
  }

  @override
  Future<void> seek(Duration position) async {
    onSeek?.call(position); // 调用 PlayerProvider 的 seekTo
  }

  // 保留原有的 media_kit 控制方法，供 PlayerProvider 调用
  Future<void> pausePlayer() async => await player.pause();
  Future<void> resume() async => await player.play();
  Future<void> stopPlayer() async {
    await player.stop();
    _currentMediaItem = null;
  }

  Future<void> seekPlayer(Duration position) async => await player.seek(position);

  // 保留原有的流
  Stream<Duration> get positionStream => player.stream.position;
  Stream<Duration> get durationStream => player.stream.duration;

  @override
  Future<void> onTaskRemoved() async {
    await stopPlayer();
    await super.onTaskRemoved();
  }

  void dispose() {
    _playbackStateSubscription?.cancel();
    player.dispose();
    super.stop();
  }
}
