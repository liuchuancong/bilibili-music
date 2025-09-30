import 'package:bilibilimusic/database/db.dart';
import 'package:audio_service/audio_service.dart';

// 扩展 Drift 生成的 Song 类
extension SongBus on Song {
  // ========== 1. 转换为 MediaItem ==========
  MediaItem toMediaItem() {
    return MediaItem(
      id: uuid, // 使用 uuid 作为唯一 ID（更稳定）
      title: title,
      artist: artist ?? upName ?? 'Unknown Artist',
      album: album ?? 'Unknown Album',
      artUri: cover != null
          ? Uri.tryParse(cover!)
          : albumArtPath != null
              ? Uri.tryParse(albumArtPath!)
              : null,
      duration: duration != null ? Duration(milliseconds: duration!) : null,
      genre: genre,
      extras: {
        'id': id,
        'uuid': uuid,
        'parentUuid': parentUuid,
        'avid': avid,
        'bvid': bvid,
        'cid': cid,
        'musicId': musicId,
        'sessionId': sessionId,
        'lyrics': lyrics,
        'upAvatar': upAvatar,
        'upName': upName,
        'upId': upId,
        'artistId': artistId,
        'artistAvatar': artistAvatar,
        'language': language,
        'fileUrl': fileUrl,
        'downloadUrl': downloadUrl,
        'size': size,
        'releaseDate': releaseDate?.millisecondsSinceEpoch,
        'trackNumber': trackNumber,
        'playedCount': playedCount,
        'likeCount': likeCount,
        'addStatus': addStatus,
        'isLiked': isLiked,
        'isDownloaded': isDownloaded,
        'createdAt': createdAt.millisecondsSinceEpoch,
        'updatedAt': updatedAt.millisecondsSinceEpoch,
        'lastPlayedTime': lastPlayedTime.millisecondsSinceEpoch,
        // 原 path 字段用 fileUrl 替代
        'path': fileUrl,
      },
    );
  }

  // ========== 2. 工具属性 ==========
  String get durationString {
    if (duration == null || duration! <= 0) return '0:00';
    final totalSeconds = duration! ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String get sizeString {
    if (size == null) return '0B';
    if (size! < 1024) return '${size!}B';
    if (size! < 1024 * 1024) return '${(size! / 1024).toStringAsFixed(1)}KB';
    return '${(size! / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  // ========== 3. 转为 Map（用于本地缓存或日志） ==========
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'parentUuid': parentUuid,
      'avid': avid,
      'bvid': bvid,
      'cid': cid,
      'musicId': musicId,
      'sessionId': sessionId,
      'title': title,
      'lyrics': lyrics,
      'album': album,
      'albumArtPath': albumArtPath,
      'artist': artist,
      'upAvatar': upAvatar,
      'upName': upName,
      'upId': upId,
      'artistId': artistId,
      'artistAvatar': artistAvatar,
      'genre': genre,
      'language': language,
      'cover': cover,
      'fileUrl': fileUrl,
      'downloadUrl': downloadUrl,
      'duration': duration,
      'size': size,
      'lastPlayedTime': lastPlayedTime.millisecondsSinceEpoch,
      'releaseDate': releaseDate?.millisecondsSinceEpoch,
      'trackNumber': trackNumber,
      'playedCount': playedCount,
      'likeCount': likeCount,
      'addStatus': addStatus,
      'isLiked': isLiked,
      'isDownloaded': isDownloaded,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  // ========== 4. copyWith（用于状态更新） ==========
  Song copyWith({
    int? id,
    String? uuid,
    String? parentUuid,
    String? avid,
    String? bvid,
    String? cid,
    String? musicId,
    String? sessionId,
    String? title,
    String? lyrics,
    String? album,
    String? albumArtPath,
    String? artist,
    String? upAvatar,
    String? upName,
    String? upId,
    String? artistId,
    String? artistAvatar,
    String? genre,
    String? language,
    String? cover,
    String? fileUrl,
    String? downloadUrl,
    int? duration,
    int? size,
    DateTime? lastPlayedTime,
    DateTime? releaseDate,
    int? trackNumber,
    int? playedCount,
    int? likeCount,
    int? addStatus,
    bool? isLiked,
    bool? isDownloaded,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Song(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      parentUuid: parentUuid ?? this.parentUuid,
      avid: avid ?? this.avid,
      bvid: bvid ?? this.bvid,
      cid: cid ?? this.cid,
      musicId: musicId ?? this.musicId,
      sessionId: sessionId ?? this.sessionId,
      title: title ?? this.title,
      lyrics: lyrics ?? this.lyrics,
      album: album ?? this.album,
      albumArtPath: albumArtPath ?? this.albumArtPath,
      artist: artist ?? this.artist,
      upAvatar: upAvatar ?? this.upAvatar,
      upName: upName ?? this.upName,
      upId: upId ?? this.upId,
      artistId: artistId ?? this.artistId,
      artistAvatar: artistAvatar ?? this.artistAvatar,
      genre: genre ?? this.genre,
      language: language ?? this.language,
      cover: cover ?? this.cover,
      fileUrl: fileUrl ?? this.fileUrl,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      duration: duration ?? this.duration,
      size: size ?? this.size,
      lastPlayedTime: lastPlayedTime ?? this.lastPlayedTime,
      releaseDate: releaseDate ?? this.releaseDate,
      trackNumber: trackNumber ?? this.trackNumber,
      playedCount: playedCount ?? this.playedCount,
      likeCount: likeCount ?? this.likeCount,
      addStatus: addStatus ?? this.addStatus,
      isLiked: isLiked ?? this.isLiked,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// ========== 5. 静态工厂方法（不能放在 extension 内，需单独定义） ==========

/// 从 MediaItem 创建 Song（用于 AudioService 回调）
Song songFromMediaItem(MediaItem mediaItem) {
  final extras = mediaItem.extras ?? const <String, dynamic>{};
  return Song(
    id: extras['id'] ?? 0,
    uuid: mediaItem.id, // MediaItem.id 用 uuid
    parentUuid: extras['parentUuid'] ?? '',
    avid: extras['avid'],
    bvid: extras['bvid'],
    cid: extras['cid'],
    musicId: extras['musicId'],
    sessionId: extras['sessionId'],
    title: mediaItem.title,
    lyrics: extras['lyrics'],
    album: mediaItem.album,
    albumArtPath: null, // 可从 artUri 解析，但通常用 cover
    artist: mediaItem.artist,
    upAvatar: extras['upAvatar'],
    upName: extras['upName'],
    upId: extras['upId'],
    artistId: extras['artistId'],
    artistAvatar: extras['artistAvatar'],
    genre: mediaItem.genre,
    language: extras['language'],
    cover: mediaItem.artUri?.toString(),
    fileUrl: extras['path'] ?? extras['fileUrl'],
    downloadUrl: extras['downloadUrl'],
    duration: mediaItem.duration?.inMilliseconds,
    size: extras['size'],
    lastPlayedTime: extras['lastPlayedTime'] != null
        ? DateTime.fromMillisecondsSinceEpoch(extras['lastPlayedTime'])
        : DateTime.now(),
    releaseDate: extras['releaseDate'] != null ? DateTime.fromMillisecondsSinceEpoch(extras['releaseDate']) : null,
    trackNumber: extras['trackNumber'],
    playedCount: extras['playedCount'] ?? 0,
    likeCount: extras['likeCount'] ?? 0,
    addStatus: extras['addStatus'],
    isLiked: extras['isLiked'] == true,
    isDownloaded: extras['isDownloaded'] == true,
    createdAt: extras['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(extras['createdAt']) : DateTime.now(),
    updatedAt: extras['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(extras['updatedAt']) : DateTime.now(),
  );
}

/// 从 Map 创建 Song（兼容旧数据或网络响应）
Song songFromMap(Map<String, dynamic> map) {
  return Song(
    id: map['id'] ?? 0,
    uuid: map['uuid'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
    parentUuid: map['parentUuid'] ?? '',
    avid: map['avid'],
    bvid: map['bvid'],
    cid: map['cid'],
    musicId: map['musicId'],
    sessionId: map['sessionId'],
    title: map['title'] ?? 'Unknown Title',
    lyrics: map['lyrics'],
    album: map['album'],
    albumArtPath: map['albumArtPath'],
    artist: map['artist'],
    upAvatar: map['upAvatar'],
    upName: map['upName'],
    upId: map['upId'],
    artistId: map['artistId'],
    artistAvatar: map['artistAvatar'],
    genre: map['genre'],
    language: map['language'],
    cover: map['cover'],
    fileUrl: map['fileUrl'] ?? map['path'],
    downloadUrl: map['downloadUrl'],
    duration: map['duration'],
    size: map['size'],
    lastPlayedTime:
        map['lastPlayedTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastPlayedTime']) : DateTime.now(),
    releaseDate: map['releaseDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['releaseDate']) : null,
    trackNumber: map['trackNumber'],
    playedCount: map['playedCount'] ?? 0,
    likeCount: map['likeCount'] ?? 0,
    addStatus: map['addStatus'],
    isLiked: map['isLiked'] == true || map['isLiked'] == 1,
    isDownloaded: map['isDownloaded'] == true || map['isDownloaded'] == 1,
    createdAt: map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) : DateTime.now(),
    updatedAt: map['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt']) : DateTime.now(),
  );
}
