import 'dart:async';
import 'dart:math' as math;
import 'package:bilibilimusic/database/db.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:audio_service/audio_service.dart';
import 'package:bilibilimusic/utils/core_log.dart';
import 'package:bilibilimusic/events/player_event.dart';
import 'package:bilibilimusic/states/player_state.dart';
import 'package:media_kit/media_kit.dart' hide PlayerState;
import 'package:bilibilimusic/services/audio_player_service.dart';
import 'package:bilibilimusic/services/player_state_storage.dart';

final playerNotifierProvider = NotifierProvider<PlayerProvider, PlayerState>(() {
  return PlayerProvider();
});

class PlayerProvider extends Notifier<PlayerState> {
  late final AudioPlayerService _audioService;
  late final PlayerStateStorage _playerState;
  late final Player _player;

  // 用于防抖和打乱逻辑
  Timer? _completeDebounceTimer;
  bool _isHandlingComplete = false;
  final math.Random _random = math.Random();

  // 原始和打乱的播放列表
  List<Song> _originalPlaylist = [];
  List<Song> _shuffledPlaylist = [];

  // 流订阅
  StreamSubscription? _playingSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _completedSub;

  @override
  PlayerState build() {
    _audioService = AudioPlayerService();
    _player = _audioService.player;
    _setupAudioServiceCallbacks();
    _initFromStorage();
    ref.onDispose(() {
      CoreLog.i(
        'Player 被销毁了！释放资源...',
      );
      _playingSub?.cancel();
      _positionSub?.cancel();
      _durationSub?.cancel();
      _completedSub?.cancel();
      _completeDebounceTimer?.cancel();
      _audioService.dispose();
    });
    return PlayerState();
  }

  Future<void> _initFromStorage() async {
    final storage = await PlayerStateStorage.getInstance();

    final currentSong = storage.currentSong;
    final playlist = storage.playlist;
    final volume = storage.volume;
    final playMode = storage.playMode;
    final position = storage.position;
    final isPlaying = storage.isPlaying;

    _playerState = storage;
    _originalPlaylist = List.from(playlist);
    _shuffledPlaylist = List.from(playlist);

    if (currentSong != null) {
      if (playMode == PlayMode.shuffle) {
        _createShuffledPlaylist(currentSong: currentSong);
      }

      final effectivePlaylist = playMode == PlayMode.shuffle ? _shuffledPlaylist : playlist;

      state = state.copyWith(
        currentSong: currentSong,
        playlist: effectivePlaylist,
        currentIndex: effectivePlaylist.indexWhere((s) => s.id == currentSong.id),
        volume: volume,
        playMode: playMode,
        position: position,
        isPlaying: isPlaying,
      );

      // 恢复播放
      if (isPlaying) {
        await _audioService.playSong(currentSong, playNow: true);
        _audioService.updateCurrentMediaItem(currentSong);
        _audioService.updatePlaybackState(playing: true, position: position);
      }
    }

    // 开始监听 media_kit 事件
    _startListeningToPlayer();
  }

  void _startListeningToPlayer() {
    _playingSub = _player.stream.playing.listen((playing) {
      final newState = state.copyWith(isPlaying: playing, isLoading: false);
      _updateAudioServicePlayback(playing: playing, position: newState.currentPosition);
      state = newState;
    });

    Duration lastNotify = Duration.zero;
    const Duration notifyInterval = Duration(milliseconds: 200);
    _positionSub = _player.stream.position.listen((pos) {
      state.positionNotifier.value = pos;
      final newState = state.copyWith(position: pos);
      if ((pos - lastNotify) >= notifyInterval) {
        lastNotify = pos;
        _updateAudioServicePlayback(playing: state.isPlaying, position: pos);
      }
      state = newState;
    });

    _durationSub = _player.stream.duration.listen((dur) {
      state = state.copyWith(duration: dur);
    });

    _completedSub = _player.stream.completed.listen((completed) {
      if (completed) {
        _handleSongCompleteWithDebounce();
      }
    });
  }

  void _setupAudioServiceCallbacks() {
    _audioService.setCallbacks(
      onPlay: () => togglePlay(),
      onPause: () => togglePlay(),
      onStop: () => stop(),
      onNext: () => next(),
      onPrevious: () => previous(),
      onSeek: (position) => seekTo(position),
    );
  }

  void _updateAudioServicePlayback({required bool playing, required Duration position}) {
    _audioService.updatePlaybackState(
      playing: playing,
      position: position,
    );
  }

  void _handleSongCompleteWithDebounce() {
    _completeDebounceTimer?.cancel();
    _completeDebounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (!_isHandlingComplete) {
        _onSongComplete();
      }
    });
  }

  void _createShuffledPlaylist({Song? currentSong}) {
    final current = currentSong ?? state.currentSong;
    if (_originalPlaylist.isEmpty || current == null) return;

    _shuffledPlaylist = List.from(_originalPlaylist)..removeWhere((s) => s.id == current.id);
    _shuffledPlaylist.insert(0, current);
    if (_shuffledPlaylist.length > 1) {
      final rest = _shuffledPlaylist.sublist(1);
      rest.shuffle(_random);
      _shuffledPlaylist = [current, ...rest];
    }
  }

  /// 播放指定歌曲
  Future<void> playSong(
    Song song, {
    List<Song>? playlist,
    int? index,
    bool shuffle = true,
    bool playNow = true,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      _isHandlingComplete = false;

      List<Song> effectivePlaylist = [];
      int effectiveIndex = 0;

      if (playlist != null && playlist.isNotEmpty) {
        _originalPlaylist = List.from(playlist);

        if (state.playMode == PlayMode.shuffle && shuffle) {
          _createShuffledPlaylist(currentSong: song);
          effectivePlaylist = _shuffledPlaylist;
          effectiveIndex = _shuffledPlaylist.indexOf(song);
        } else if (state.playMode == PlayMode.shuffle) {
          effectivePlaylist = _shuffledPlaylist;
          effectiveIndex = _shuffledPlaylist.indexWhere((s) => s.id == song.id);
          if (effectiveIndex == -1) {
            effectivePlaylist = _originalPlaylist;
            effectiveIndex = index ?? _originalPlaylist.indexOf(song);
          }
        } else {
          effectivePlaylist = List.from(playlist);
          effectiveIndex = index ?? playlist.indexOf(song);
        }
      } else {
        effectivePlaylist = [song];
        effectiveIndex = 0;
        _originalPlaylist = [song];
        _shuffledPlaylist = [song];
      }

      state = state.copyWith(
        currentSong: song,
        playlist: effectivePlaylist,
        currentIndex: effectiveIndex.clamp(0, effectivePlaylist.length - 1),
        isLoading: false,
      );

      _audioService.updateCurrentMediaItem(song);
      await _audioService.playSong(song, playNow: playNow);

      // 持久化
      _playerState.setCurrentSong(song);
      _playerState.setPlaylist(effectivePlaylist);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isPlaying: false,
        errorMessage: '播放失败: $e',
      );
      _audioService.updatePlaybackState(
        playing: false,
        processingState: AudioProcessingState.error,
      );
    }
  }

  /// 切换播放/暂停
  Future<void> togglePlay() async {
    if (state.currentSong == null) return;
    try {
      if (state.isPlaying) {
        await _audioService.pausePlayer();
      } else {
        await _audioService.resume();
      }
    } catch (e) {
      state = state.copyWith(errorMessage: '操作失败: $e');
    }
  }

  /// 停止播放
  Future<void> stop() async {
    _isHandlingComplete = true;
    await _audioService.stopPlayer();

    state = state.copyWith(
      currentSong: null,
      isPlaying: false,
      position: Duration.zero,
      errorMessage: null,
    );
    state.positionNotifier.value = Duration.zero;

    _audioService.updatePlaybackState(
      playing: false,
      processingState: AudioProcessingState.idle,
    );

    Future.delayed(const Duration(milliseconds: 200), () {
      _isHandlingComplete = false;
    });
  }

  /// 上一首
  Future<void> previous() async {
    if (state.playlist.isEmpty) return;

    int newIndex;
    if (state.playMode == PlayMode.shuffle) {
      newIndex = state.currentIndex > 0 ? state.currentIndex - 1 : state.playlist.length - 1;
    } else {
      if (!state.hasPrevious) {
        if (state.playMode != PlayMode.loop && state.playMode != PlayMode.singleLoop) return;
        newIndex = state.playlist.length - 1;
      } else {
        newIndex = state.currentIndex - 1;
      }
    }

    final song = state.playlist[newIndex];
    await playSong(song);
    PlayerEvent.notifySongChanged(song);
  }

  /// 下一首
  Future<void> next() async {
    if (state.playlist.isEmpty) return;

    int newIndex;
    if (state.playMode == PlayMode.shuffle) {
      newIndex = state.currentIndex < state.playlist.length - 1 ? state.currentIndex + 1 : 0;
    } else {
      if (!state.hasNext) {
        if (state.playMode != PlayMode.loop && state.playMode != PlayMode.singleLoop) return;
        newIndex = 0;
      } else {
        newIndex = state.currentIndex + 1;
      }
    }

    final song = state.playlist[newIndex];
    await playSong(song);
    PlayerEvent.notifySongChanged(song);
  }

  /// 跳转到指定位置
  Future<void> seekTo(Duration position) async {
    try {
      await _audioService.seekPlayer(position);
    } catch (e) {
      state = state.copyWith(errorMessage: '跳转失败: $e');
    }
  }

  /// 设置音量
  Future<void> setVolume(double volume) async {
    final clamped = volume.clamp(0.0, 1.0);
    try {
      await _player.setVolume(clamped * 100);
      state = state.copyWith(volume: clamped);
      _playerState.setVolume(clamped);
    } catch (e) {
      state = state.copyWith(errorMessage: '设置音量失败: $e');
    }
  }

  /// 静音切换
  Future<void> toggleMute() async {
    if (state.volume > 0) {
      await setVolume(0);
    } else {
      await setVolume(1.0);
    }
  }

  /// 设置播放模式
  void setPlayMode(PlayMode mode) {
    if (state.playMode == mode) return;

    final oldMode = state.playMode;
    state = state.copyWith(playMode: mode);
    _playerState.setPlayMode(mode);

    // 模式切换处理
    if (oldMode == PlayMode.shuffle && mode != PlayMode.shuffle) {
      // 恢复原始顺序
      state = state.copyWith(playlist: _originalPlaylist);
      final idx = _originalPlaylist.indexWhere((s) => s.id == state.currentSong?.id);
      if (idx != -1) {
        state = state.copyWith(currentIndex: idx);
      }
    } else if (oldMode != PlayMode.shuffle && mode == PlayMode.shuffle) {
      // 进入随机模式
      if (state.currentSong != null) {
        _createShuffledPlaylist(currentSong: state.currentSong);
        state = state.copyWith(playlist: _shuffledPlaylist);
        final idx = _shuffledPlaylist.indexWhere((s) => s.id == state.currentSong!.id);
        state = state.copyWith(currentIndex: idx);
      }
    }
  }

  /// 重新打乱播放列表（保持当前歌曲在第一位）
  void reshufflePlaylist() {
    if (state.playMode == PlayMode.shuffle && state.currentSong != null) {
      _createShuffledPlaylist(currentSong: state.currentSong);
      state = state.copyWith(playlist: _shuffledPlaylist);
      final idx = _shuffledPlaylist.indexWhere((s) => s.id == state.currentSong!.id);
      state = state.copyWith(currentIndex: idx);
    }
  }

  /// 添加歌曲到播放列表
  void addToPlaylist(Song song) {
    _originalPlaylist.add(song);

    if (state.playMode == PlayMode.shuffle) {
      final idx = _random.nextInt(_shuffledPlaylist.length + 1);
      _shuffledPlaylist.insert(idx, song);
    }

    final newPlaylist = List<Song>.from(state.playlist)..add(song);
    state = state.copyWith(playlist: newPlaylist);
  }

  /// 从播放列表移除
  void removeFromPlaylist(int index) {
    if (index < 0 || index >= state.playlist.length) return;

    final removed = state.playlist[index];
    final newPlaylist = List<Song>.from(state.playlist)..removeAt(index);

    _originalPlaylist.removeWhere((s) => s.id == removed.id);
    if (state.playMode == PlayMode.shuffle) {
      _shuffledPlaylist.removeWhere((s) => s.id == removed.id);
    }

    int newCurrentIndex = state.currentIndex;
    if (index < newCurrentIndex) {
      newCurrentIndex--;
    } else if (index == newCurrentIndex && newPlaylist.isNotEmpty) {
      newCurrentIndex = newCurrentIndex.clamp(0, newPlaylist.length - 1);
    }

    Song? newCurrentSong = newPlaylist.isEmpty ? null : newPlaylist[newCurrentIndex];

    state = state.copyWith(
      playlist: newPlaylist,
      currentIndex: newCurrentIndex,
      currentSong: newCurrentSong,
    );

    if (newPlaylist.isEmpty) {
      stop();
    }
  }

  /// 设置整个播放列表
  void setPlaylist(List<Song> songs, {int currentIndex = 0}) {
    _originalPlaylist = List.from(songs);
    if (songs.isEmpty) return;

    final current = songs[currentIndex.clamp(0, songs.length - 1)];

    if (state.playMode == PlayMode.shuffle) {
      _createShuffledPlaylist(currentSong: current);
      state = state.copyWith(
        playlist: _shuffledPlaylist,
        currentIndex: _shuffledPlaylist.indexOf(current),
        currentSong: current,
      );
    } else {
      state = state.copyWith(
        playlist: songs,
        currentIndex: currentIndex,
        currentSong: current,
      );
    }
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  void _onSongComplete() {
    if (_isHandlingComplete) return;
    _isHandlingComplete = true;

    try {
      switch (state.playMode) {
        case PlayMode.single:
          state = state.copyWith(isPlaying: false);
          state.positionNotifier.value = Duration.zero;
          break;
        case PlayMode.singleLoop:
          seekTo(Duration.zero);
          _audioService.resume();
          break;
        case PlayMode.sequence:
          if (state.hasNext) {
            next();
          } else {
            state = state.copyWith(isPlaying: false);
            state.positionNotifier.value = Duration.zero;
          }
          break;
        case PlayMode.loop:
          next();
          break;
        case PlayMode.shuffle:
          next();
          break;
      }
    } finally {
      Future.delayed(const Duration(milliseconds: 500), () {
        _isHandlingComplete = false;
      });
    }
  }
}
