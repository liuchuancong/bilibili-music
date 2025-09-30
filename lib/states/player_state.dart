import 'package:flutter/foundation.dart';
import 'package:bilibilimusic/data/models/song.dart';
import 'package:bilibilimusic/contants/app_contants.dart';

// player_state.dart

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

  // 只读流（外部监听位置）
  final ValueNotifier<Duration> positionNotifier;

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
    positionNotifier.value = position;
  }

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
}
