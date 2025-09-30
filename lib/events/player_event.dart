import 'dart:async';
import 'package:bilibilimusic/database/db.dart';

class PlayerEvent {
  PlayerEvent._();

  static final PlayerEvent _instance = PlayerEvent._();
  static PlayerEvent get instance => _instance;

  final StreamController<Song> _songChangedController = StreamController<Song>.broadcast();

  /// 歌曲切换事件流
  Stream<Song> get songChanged => _songChangedController.stream;

  /// 通知歌曲已切换
  static void notifySongChanged(Song song) {
    _instance._songChangedController.add(song);
  }

  /// 销毁（通常不需要手动调用）
  void dispose() {
    _songChangedController.close();
  }
}
