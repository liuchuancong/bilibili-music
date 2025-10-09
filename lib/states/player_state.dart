import 'package:flutter/foundation.dart';
import 'package:bilibilimusic/database/db.dart';
import 'package:bilibilimusic/contants/app_contants.dart';

@immutable
class PlayerState {
  final Song? currentSong;
  final bool isPlaying;
  final bool isLoading;
  final String? errorMessage;
  final Duration position;
  final Duration duration;
  final double volume;
  final PlayMode playMode;
  final List<Song> playlist;
  final int currentIndex;

  // 用于外部监听位置变化的 ValueNotifier
  final ValueNotifier<Duration> positionNotifier;

  // 构造函数：初始化所有状态，默认值与参考代码保持一致
  PlayerState({
    this.currentSong,
    this.isPlaying = false,
    this.isLoading = false,
    this.errorMessage,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.volume = 1.0,
    this.playMode = PlayMode.loop,
    this.playlist = const [],
    this.currentIndex = -1,
  }) : positionNotifier = ValueNotifier(position) {
    // 确保 positionNotifier 初始值与 position 一致
    positionNotifier.value = position;
  }

  // 复制方法：用于创建新状态（保持不可变性）
  PlayerState copyWith({
    Song? currentSong,
    bool? isPlaying,
    bool? isLoading,
    String? errorMessage,
    Duration? position,
    Duration? duration,
    double? volume,
    PlayMode? playMode,
    List<Song>? playlist,
    int? currentIndex,
  }) {
    return PlayerState(
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      volume: volume ?? this.volume,
      playMode: playMode ?? this.playMode,
      playlist: playlist ?? this.playlist,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  Duration get currentPosition => positionNotifier.value;

  bool get hasPrevious => playMode == PlayMode.shuffle ? true : currentIndex > 0;

  bool get hasNext => playMode == PlayMode.shuffle ? true : currentIndex < playlist.length - 1;

  // 相等性判断：确保状态比较正确
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerState &&
          runtimeType == other.runtimeType &&
          currentSong == other.currentSong &&
          isPlaying == other.isPlaying &&
          isLoading == other.isLoading &&
          errorMessage == other.errorMessage &&
          position == other.position &&
          duration == other.duration &&
          volume == other.volume &&
          playMode == other.playMode &&
          listEquals(playlist, other.playlist) &&
          currentIndex == other.currentIndex;

  // 哈希值计算：用于集合操作
  @override
  int get hashCode =>
      currentSong.hashCode ^
      isPlaying.hashCode ^
      isLoading.hashCode ^
      errorMessage.hashCode ^
      position.hashCode ^
      duration.hashCode ^
      volume.hashCode ^
      playMode.hashCode ^
      playlist.hashCode ^
      currentIndex.hashCode;

  // 可选：重写 toString 方便调试
  @override
  String toString() {
    return 'PlayerState('
        'currentSong: ${currentSong?.id}, '
        'isPlaying: $isPlaying, '
        'position: ${position.inSeconds}s, '
        'playlistLength: ${playlist.length}, '
        'playMode: $playMode'
        ')';
  }
}
