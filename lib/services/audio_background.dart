import 'dart:async';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:bilibilimusic/services/audio_service.dart';

/// An [AudioHandler] for playing a single item.
class AudioPlayerHandler extends BaseAudioHandler with SeekHandler {
  final AudioController audioController = Get.find<AudioController>();
  AudioPlayerHandler() {
    audioController.audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);
    audioController.currentMusicDuration.listen((p0) {
      Timer(const Duration(seconds: 2), () {
        Map info = {
          'album': '',
          'title': audioController.currentMusicInfo['title'],
          'author': audioController.currentMusicInfo['author'],
          'cover': audioController.currentMusicInfo['cover'],
          'lyric': '',
        };
        final item = MediaItem(
          id: info['album'],
          album: info['author'],
          title: info['title'],
          artist: info['album'],
          duration: audioController.currentMusicDuration.value,
          artUri: Uri.parse(info['cover']),
        );
        mediaItem.add(item);
      });
    });
  }

  @override
  Future<void> play() => audioController.audioPlayer.play();

  @override
  Future<void> pause() => audioController.audioPlayer.pause();

  @override
  Future<void> seek(Duration position) => audioController.audioPlayer.seek(position);

  @override
  Future<void> stop() => audioController.audioPlayer.stop();

  @override
  Future<void> skipToNext() => audioController.next();

  @override
  Future<void> skipToPrevious() => audioController.previous();

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (audioController.audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.skipToPrevious,
        MediaAction.seekForward,
        MediaAction.skipToNext,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[audioController.audioPlayer.processingState]!,
      playing: audioController.audioPlayer.playing,
      updatePosition: audioController.audioPlayer.position,
      bufferedPosition: audioController.audioPlayer.bufferedPosition,
      speed: audioController.audioPlayer.speed,
      queueIndex: audioController.currentIndex,
    );
  }
}
