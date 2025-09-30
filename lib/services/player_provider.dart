// import 'dart:async';
// import 'dart:math' as math;
// import 'package:bilibilimusic/data/models/song.dart';
// import 'package:bilibilimusic/states/player_state.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final playerProvider = NotifierProvider<PlayerNotifier, PlayerState>(
//   () => PlayerNotifier(),
// );

// class PlayerNotifier extends Notifier<PlayerState> {
//   late final AudioPlayerService _audioService;
//   late final PlayerStateStorage _playerState;

//   final math.Random _random = math.Random();

//   List<Song> _originalPlaylist = [];
//   List<Song> _shuffledPlaylist = [];

//   // 流订阅
//   StreamSubscription? _playingSub;
//   StreamSubscription? _positionSub;
//   StreamSubscription? _durationSub;
//   StreamSubscription? _completedSub;

//   bool _isHandlingComplete = false;
//   Timer? _completeDebounceTimer;

//   // 外部回调（可选）
//   static void Function()? onSongChange;

//   @override
//   PlayerState build() {
//     _audioService = AudioPlayerService();
//     _setupAudioServiceCallbacks();

//     // 初始状态（加载中）
//     state = PlayerState(isLoading: true);

//     // 异步初始化
//     _initializeAsync();

//     return state;
//   }

//   Future<void> _initializeAsync() async {
//     try {
//       // 初始化 AudioService
//       await _audioService.init(MusicDatabase());

//       // 加载持久化状态
//       final storage = await PlayerStateStorage.getInstance();
//       _playerState = storage;

//       final savedSong = storage.currentSong;
//       final savedPlaylist = storage.playlist;
//       final savedVolume = storage.volume;
//       final savedPlayMode = storage.playMode;
//       final savedPosition = storage.position;
//       final savedIsPlaying = storage.isPlaying;

//       _originalPlaylist = List.from(savedPlaylist);
//       _shuffledPlaylist = List.from(savedPlaylist);

//       List<Song> currentPlaylist;
//       int currentIndex;

//       if (savedPlayMode == PlayMode.shuffle) {
//         _createShuffledPlaylist(currentSong: savedSong);
//         currentPlaylist = _shuffledPlaylist;
//         currentIndex = _shuffledPlaylist.indexWhere((s) => s.id == savedSong?.id);
//         if (currentIndex == -1) currentIndex = 0;
//       } else {
//         currentPlaylist = _originalPlaylist;
//         currentIndex = _originalPlaylist.indexWhere((s) => s.id == savedSong?.id);
//         if (currentIndex == -1) currentIndex = 0;
//       }

//       state = state.copyWith(
//         currentSong: savedSong,
//         playlist: currentPlaylist,
//         currentIndex: currentIndex,
//         volume: savedVolume,
//         playMode: savedPlayMode,
//         position: savedPosition,
//         isPlaying: false, // 先不自动播放
//         isLoading: false,
//       );

//       // 设置音量
//       await _audioService.player.setVolume(savedVolume * 100);

//       // 如果有保存的歌曲，预加载（但不播放）
//       if (savedSong != null) {
//         await _audioService.playSong(savedSong, playNow: false);
//         _audioService.updateCurrentMediaItem(savedSong);
//         _audioService.updatePlaybackState(
//           playing: savedIsPlaying,
//           position: savedPosition,
//         );
//       }

//       // 启动监听
//       _initializeListeners();
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         errorMessage: '初始化失败: $e',
//       );
//     }
//   }

//   void _initializeListeners() {
//     final player = _audioService.player;

//     _playingSub = player.stream.playing.listen((playing) {
//       state = state.copyWith(isPlaying: playing, isLoading: false);
//       _audioService.updatePlaybackState(playing: playing, position: state.position);
//     });

//     Duration _lastNotify = Duration.zero;
//     const Duration notifyInterval = Duration(milliseconds: 200);
//     _positionSub = player.stream.position.listen((pos) {
//       state.positionNotifier.value = pos;
//       if ((pos - _lastNotify) > notifyInterval) {
//         _lastNotify = pos;
//         _audioService.updatePlaybackState(playing: state.isPlaying, position: pos);
//       }
//     });

//     _durationSub = player.stream.duration.listen((dur) {
//       state = state.copyWith(duration: dur);
//     });

//     _completedSub = player.stream.completed.listen((completed) {
//       if (completed) _handleSongCompleteWithDebounce();
//     });
//   }

//   void _setupAudioServiceCallbacks() {
//     _audioService.setCallbacks(
//       onPlay: () => togglePlay(),
//       onPause: () => togglePlay(),
//       onStop: () => stop(),
//       onNext: () => next(),
//       onPrevious: () => previous(),
//       onSeek: (position) => seekTo(position),
//     );
//   }

//   void _handleSongCompleteWithDebounce() {
//     _completeDebounceTimer?.cancel();
//     _completeDebounceTimer = Timer(const Duration(milliseconds: 100), () {
//       if (!_isHandlingComplete) _onSongComplete();
//     });
//   }

//   // --- 以下是公开方法（与原 PlayerProvider 一致）---

//   Future<void> playSong(
//     Song song, {
//     List<Song>? playlist,
//     int? index,
//     bool shuffle = true,
//     bool playNow = true,
//   }) async {
//     try {
//       state = state.copyWith(isLoading: true, errorMessage: null);
//       _isHandlingComplete = false;

//       List<Song> newPlaylist;
//       int newIndex;

//       if (playlist != null) {
//         _originalPlaylist = List.from(playlist);

//         if (state.playMode == PlayMode.shuffle && shuffle) {
//           _createShuffledPlaylist(currentSong: song);
//           newPlaylist = _shuffledPlaylist;
//           newIndex = _shuffledPlaylist.indexWhere((s) => s.id == song.id);
//         } else if (state.playMode == PlayMode.shuffle && !shuffle) {
//           newPlaylist = _shuffledPlaylist.isNotEmpty ? _shuffledPlaylist : _originalPlaylist;
//           newIndex = newPlaylist.indexWhere((s) => s.id == song.id);
//           if (newIndex == -1) {
//             newPlaylist = _originalPlaylist;
//             newIndex = index ?? 0;
//           }
//         } else {
//           newPlaylist = List.from(playlist);
//           newIndex = index ?? 0;
//         }
//       } else if (_originalPlaylist.isEmpty || !_originalPlaylist.any((s) => s.id == song.id)) {
//         _originalPlaylist = [song];
//         _shuffledPlaylist = [song];
//         newPlaylist = [song];
//         newIndex = 0;
//       } else {
//         if (state.playMode == PlayMode.shuffle) {
//           newPlaylist = _shuffledPlaylist;
//           newIndex = _shuffledPlaylist.indexWhere((s) => s.id == song.id);
//         } else {
//           newPlaylist = _originalPlaylist;
//           newIndex = _originalPlaylist.indexWhere((s) => s.id == song.id);
//         }
//       }

//       if (newIndex == -1) newIndex = 0;

//       _currentSong = song;
//       _currentIndex = newIndex;
//       _playlist = newPlaylist;

//       state = state.copyWith(
//         currentSong: song,
//         playlist: newPlaylist,
//         currentIndex: newIndex,
//         isLoading: false,
//       );

//       _audioService.updateCurrentMediaItem(song);
//       await _audioService.playSong(song, playNow: playNow);

//       _playerState.setCurrentSong(song);
//       _playerState.setPlaylist(newPlaylist);
//       onSongChange?.call();
//     } catch (e) {
//       state = state.copyWith(
//         isLoading: false,
//         isPlaying: false,
//         errorMessage: '播放失败: $e',
//       );
//       _audioService.updatePlaybackState(
//         playing: false,
//         processingState: AudioProcessingState.error,
//       );
//     }
//   }

//   // 简化：用 getter 缓存
//   Song? get _currentSong => state.currentSong;
//   int get _currentIndex => state.currentIndex;
//   List<Song> get _playlist => state.playlist;

//   set _currentSong(Song? song) => state = state.copyWith(currentSong: song);
//   set _currentIndex(int index) => state = state.copyWith(currentIndex: index);
//   set _playlist(List<Song> list) => state = state.copyWith(playlist: list);

//   Future<void> togglePlay() async {
//     if (_currentSong == null) return;
//     try {
//       if (state.isPlaying) {
//         await _audioService.pausePlayer();
//       } else {
//         await _audioService.resume();
//       }
//     } catch (e) {
//       state = state.copyWith(errorMessage: '操作失败: $e');
//     }
//   }

//   Future<void> stop() async {
//     try {
//       _isHandlingComplete = true;
//       await _audioService.stopPlayer();
//       state = state.copyWith(
//         currentSong: null,
//         isPlaying: false,
//         position: Duration.zero,
//         errorMessage: null,
//       );
//       state.positionNotifier.value = Duration.zero;
//       _audioService.updatePlaybackState(
//         playing: false,
//         processingState: AudioProcessingState.idle,
//       );
//     } catch (e) {
//       state = state.copyWith(errorMessage: '停止失败: $e');
//     } finally {
//       Timer(const Duration(milliseconds: 200), () => _isHandlingComplete = false);
//     }
//   }

//   Future<void> previous() async {
//     if (_playlist.isEmpty) return;
//     int newIndex;

//     if (state.playMode == PlayMode.shuffle) {
//       newIndex = _currentIndex > 0 ? _currentIndex - 1 : _playlist.length - 1;
//     } else {
//       if (!state.hasPrevious && state.playMode != PlayMode.loop && state.playMode != PlayMode.singleLoop) return;
//       if ((state.playMode == PlayMode.loop || state.playMode == PlayMode.singleLoop) && !state.hasPrevious) {
//         newIndex = _playlist.length - 1;
//       } else {
//         newIndex = _currentIndex - 1;
//       }
//     }

//     _currentIndex = newIndex;
//     await playSong(_playlist[newIndex], playNow: true);
//   }

//   Future<void> next() async {
//     if (_playlist.isEmpty) return;
//     int newIndex;

//     if (state.playMode == PlayMode.shuffle) {
//       newIndex = _currentIndex < _playlist.length - 1 ? _currentIndex + 1 : 0;
//     } else {
//       if (!state.hasNext && state.playMode != PlayMode.loop && state.playMode != PlayMode.singleLoop) return;
//       if ((state.playMode == PlayMode.loop || state.playMode == PlayMode.singleLoop) && !state.hasNext) {
//         newIndex = 0;
//       } else {
//         newIndex = _currentIndex + 1;
//       }
//     }

//     _currentIndex = newIndex;
//     await playSong(_playlist[newIndex], playNow: true);
//   }

//   Future<void> seekTo(Duration position) async {
//     try {
//       await _audioService.seekPlayer(position);
//     } catch (e) {
//       state = state.copyWith(errorMessage: '跳转失败: $e');
//     }
//   }

//   Future<void> setVolume(double volume) async {
//     final clamped = volume.clamp(0.0, 1.0);
//     try {
//       await _audioService.player.setVolume(clamped * 100);
//       state = state.copyWith(volume: clamped);
//       _playerState.setVolume(clamped);
//     } catch (e) {
//       state = state.copyWith(errorMessage: '设置音量失败: $e');
//     }
//   }

//   Future<void> toggleMute() async {
//     if (state.volume > 0) {
//       await setVolume(0);
//     } else {
//       await setVolume(1.0);
//     }
//   }

//   void setPlayMode(PlayMode mode) {
//     if (state.playMode == mode) return;

//     final prevMode = state.playMode;
//     state = state.copyWith(playMode: mode);
//     _playerState.setPlayMode(mode);

//     if (prevMode == PlayMode.shuffle && mode != PlayMode.shuffle) {
//       _restoreOriginalPlaylist();
//     } else if (prevMode != PlayMode.shuffle && mode == PlayMode.shuffle) {
//       _switchToShuffleMode();
//     }
//   }

//   void _restoreOriginalPlaylist() {
//     if (_originalPlaylist.isEmpty) return;
//     _playlist = List.from(_originalPlaylist);
//     final idx = _originalPlaylist.indexWhere((s) => s.id == _currentSong?.id);
//     _currentIndex = idx == -1 ? 0 : idx;
//   }

//   void _switchToShuffleMode() {
//     if (_originalPlaylist.isEmpty) return;
//     _createShuffledPlaylist(currentSong: _currentSong);
//     _playlist = _shuffledPlaylist;
//     final idx = _shuffledPlaylist.indexWhere((s) => s.id == _currentSong?.id);
//     _currentIndex = idx == -1 ? 0 : idx;
//   }

//   void _createShuffledPlaylist({Song? currentSong}) {
//     _shuffledPlaylist = List.from(_originalPlaylist);
//     if (currentSong != null) {
//       _shuffledPlaylist.removeWhere((s) => s.id == currentSong.id);
//       _shuffledPlaylist.insert(0, currentSong);
//     }
//     if (_shuffledPlaylist.length > 1) {
//       final rest = _shuffledPlaylist.sublist(1);
//       rest.shuffle(_random);
//       _shuffledPlaylist = [_shuffledPlaylist[0], ...rest];
//     }
//   }

//   void setPlaylist(List<Song> songs, {int currentIndex = 0}) {
//     _originalPlaylist = List.from(songs);
//     final clampedIndex = currentIndex.clamp(0, songs.length - 1);

//     if (state.playMode == PlayMode.shuffle) {
//       if (songs.isNotEmpty) {
//         _createShuffledPlaylist(currentSong: songs[clampedIndex]);
//         _playlist = _shuffledPlaylist;
//         _currentIndex = _shuffledPlaylist.indexWhere((s) => s.id == songs[clampedIndex].id);
//       }
//     } else {
//       _playlist = List.from(songs);
//       _currentIndex = clampedIndex;
//     }

//     _currentSong = songs.isEmpty ? null : songs[clampedIndex];
//   }

//   void addToPlaylist(Song song) {
//     _originalPlaylist.add(song);
//     if (state.playMode == PlayMode.shuffle) {
//       if (_shuffledPlaylist.isEmpty) {
//         _shuffledPlaylist.add(song);
//       } else {
//         final idx = _random.nextInt(_shuffledPlaylist.length + 1);
//         _shuffledPlaylist.insert(idx, song);
//       }
//       _playlist = _shuffledPlaylist;
//     } else {
//       _playlist = List.from(_playlist)..add(song);
//     }
//     state = state.copyWith(playlist: _playlist);
//   }

//   void removeFromPlaylist(int index) {
//     if (index < 0 || index >= _playlist.length) return;
//     final removed = _playlist[index];
//     _originalPlaylist.removeWhere((s) => s.id == removed.id);
//     if (state.playMode == PlayMode.shuffle) {
//       _shuffledPlaylist.removeWhere((s) => s.id == removed.id);
//     }
//     _playlist = List.from(_playlist)..removeAt(index);
//     int newCurrentIndex = _currentIndex;
//     if (index < _currentIndex) {
//       newCurrentIndex--;
//     } else if (index == _currentIndex) {
//       if (newCurrentIndex >= _playlist.length) newCurrentIndex = _playlist.length - 1;
//       if (_playlist.isEmpty) {
//         stop();
//         return;
//       }
//     }
//     _currentIndex = newCurrentIndex;
//     _currentSong = _playlist.isEmpty ? null : _playlist[newCurrentIndex];
//     state = state.copyWith(playlist: _playlist, currentIndex: newCurrentIndex, currentSong: _currentSong);
//   }

//   void reshufflePlaylist() {
//     if (state.playMode != PlayMode.shuffle || _originalPlaylist.isEmpty) return;
//     _createShuffledPlaylist(currentSong: _currentSong);
//     _playlist = _shuffledPlaylist;
//     final idx = _shuffledPlaylist.indexWhere((s) => s.id == _currentSong?.id);
//     _currentIndex = idx == -1 ? 0 : idx;
//     state = state.copyWith(playlist: _playlist, currentIndex: _currentIndex);
//   }

//   void clearError() {
//     state = state.copyWith(errorMessage: null);
//   }

//   void _onSongComplete() {
//     if (_isHandlingComplete) return;
//     _isHandlingComplete = true;

//     try {
//       switch (state.playMode) {
//         case PlayMode.single:
//           state = state.copyWith(isPlaying: false);
//           state.positionNotifier.value = Duration.zero;
//           break;
//         case PlayMode.singleLoop:
//           if (_currentSong != null) {
//             Future.microtask(() {
//               seekTo(Duration.zero);
//               _audioService.resume();
//             });
//           }
//           break;
//         case PlayMode.sequence:
//           if (state.hasNext) {
//             Future.microtask(() => next());
//           } else {
//             state = state.copyWith(isPlaying: false);
//             state.positionNotifier.value = Duration.zero;
//           }
//           break;
//         case PlayMode.loop:
//         case PlayMode.shuffle:
//           Future.microtask(() => next());
//           break;
//       }
//     } finally {
//       Timer(const Duration(milliseconds: 500), () => _isHandlingComplete = false);
//     }
//   }

//   @override
//   void dispose() {
//     _playingSub?.cancel();
//     _positionSub?.cancel();
//     _durationSub?.cancel();
//     _completedSub?.cancel();
//     _completeDebounceTimer?.cancel();
//     _audioService.dispose();
//     super.dispose();
//   }
// }
