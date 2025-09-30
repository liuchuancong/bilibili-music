import 'dart:convert';
import 'package:bilibilimusic/database/db.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/contants/player_state_keys.dart';

class PlayerStateStorage {
  static PlayerStateStorage? _instance;

  static Future<PlayerStateStorage> getInstance() async {
    if (_instance != null) return _instance!;
    _instance = await _load();
    return _instance!;
  }

  PlayerStateStorage._();

  // 私有成员
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Song? _currentSong;
  PlayMode _playMode = PlayMode.shuffle;
  double _volume = 1.0;
  PlayerPage _currentPage = PlayerPage.library;
  final Map<String, SortState> _pageSortStates = {};
  List<Song> _playlist = [];

  /// 对外只读属性
  bool get isPlaying => _isPlaying;
  Duration get position => _position;
  Song? get currentSong => _currentSong;
  PlayMode get playMode => _playMode;
  double get volume => _volume;
  PlayerPage get currentPage => _currentPage;
  Map<String, SortState> get pageSortStates => Map.unmodifiable(_pageSortStates);
  List<Song> get playlist => List.unmodifiable(_playlist);

  /// 启动时初始化，从本地读取
  static Future<PlayerStateStorage> _load() async {
    final state = PlayerStateStorage._();
    state._isPlaying = PrefUtil.getBool(PlayerStateKeys.isPlaying) ?? false;
    state._position = Duration(seconds: PrefUtil.getInt(PlayerStateKeys.position) ?? 0);
    final songJson = PrefUtil.getString(PlayerStateKeys.currentSong);
    if (songJson != null) {
      state._currentSong = Song.fromJson(jsonDecode(songJson));
    }
    final modeIndex = PrefUtil.getInt(PlayerStateKeys.playMode);
    if (modeIndex != null && modeIndex >= 0 && modeIndex < PlayMode.values.length) {
      state._playMode = PlayMode.values[modeIndex];
    }
    state._volume = PrefUtil.getDouble(PlayerStateKeys.volume) ?? 1.0;

    final pageIndex = PrefUtil.getInt(PlayerStateKeys.currentPage);
    if (pageIndex != null && pageIndex >= 0 && pageIndex < PlayerPage.values.length) {
      state._currentPage = PlayerPage.values[pageIndex];
    }

    final sortJsonStr = PrefUtil.getString(PlayerStateKeys.pageSortStates);
    if (sortJsonStr != null) {
      final Map<String, dynamic> sortJson = jsonDecode(sortJsonStr);
      sortJson.forEach((page, value) {
        state._pageSortStates[page] = SortState.fromJson(value);
      });
    }

    final playlistStr = PrefUtil.getString(PlayerStateKeys.playlist);
    if (playlistStr != null) {
      final List<dynamic> listJson = jsonDecode(playlistStr);
      state._playlist = listJson.map((e) => Song.fromJson(e as Map<String, dynamic>)).toList();
    }

    return state;
  }

  /// 内部保存方法
  Future<void> _savePlaybackState() async {
    await PrefUtil.setBool(PlayerStateKeys.isPlaying, _isPlaying);
    await PrefUtil.setInt(PlayerStateKeys.position, _position.inSeconds);
    if (_currentSong != null) {
      await PrefUtil.setString(PlayerStateKeys.currentSong, jsonEncode(_currentSong!.toJson()));
    }
  }

  Future<void> _savePlayMode() async {
    await PrefUtil.setInt(PlayerStateKeys.playMode, _playMode.index);
  }

  Future<void> _saveVolume() async {
    await PrefUtil.setDouble(PlayerStateKeys.volume, _volume);
  }

  Future<void> _saveCurrentPage() async {
    await PrefUtil.setInt(PlayerStateKeys.currentPage, _currentPage.index);
  }

  Future<void> _saveSortState() async {
    final Map<String, dynamic> jsonMap = {};
    _pageSortStates.forEach((page, sortState) {
      jsonMap[page] = sortState.toJson();
    });
    await PrefUtil.setString(PlayerStateKeys.pageSortStates, jsonEncode(jsonMap));
  }

  Future<void> _savePlaylist() async {
    final listJson = _playlist.map((s) => s.toJson()).toList();
    await PrefUtil.setString(PlayerStateKeys.playlist, jsonEncode(listJson));
  }
}

/// 对外操作扩展
extension PlayerStateSetters on PlayerStateStorage {
  Future<void> setCurrentSong(Song song) async {
    _currentSong = song;
    await _savePlaybackState();
  }

  Future<void> setPlaylist(List<Song> songs) async {
    _playlist = songs;
    await _savePlaylist();
  }

  Future<void> addToPlaylist(Song song) async {
    _playlist.add(song);
    await _savePlaylist();
  }

  Future<void> removeFromPlaylist(Song song) async {
    _playlist.removeWhere((s) => s.id == song.id);
    await _savePlaylist();
  }

  Future<void> setPlayingState(bool playing, {Duration? pos}) async {
    _isPlaying = playing;
    if (pos != null) _position = pos;
    await _savePlaybackState();
  }

  Future<void> setPlayMode(PlayMode mode) async {
    _playMode = mode;
    await _savePlayMode();
  }

  Future<void> setVolume(double vol) async {
    _volume = vol;
    await _saveVolume();
  }

  Future<void> setCurrentPage(PlayerPage page) async {
    _currentPage = page;
    await _saveCurrentPage();
  }

  Future<void> setPageSort(
    String page,
    String? field,
    String? direction,
  ) async {
    _pageSortStates[page] = SortState(field: field, direction: direction);
    await _saveSortState();
  }

  SortState getPageSort(String page) => _pageSortStates[page] ?? SortState();
}
