import 'package:bilibilimusic/database/db.dart';

/// 为 Drift 生成的 [Album] 添加业务方法
extension AlbumBus on Album {
  Uri? get coverUri => cover != null ? Uri.tryParse(cover!) : null;

  String get artistDisplayName => artist ?? upName ?? 'Unknown Artist';

  String get titleOrUnknown => title.isNotEmpty ? title : 'Unknown Album';
}

typedef FullAlbum = ({
  Album album,
  List<int> songIds,
  int trackCount,
  int totalDuration,
});

extension FullAlbumExtension on FullAlbum {
  String get durationString {
    final hours = totalDuration ~/ 3600000;
    final minutes = (totalDuration % 3600000) ~/ 60000;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get trackCountString {
    return '$trackCount track${trackCount == 1 ? '' : 's'}';
  }

  String get yearString => album.releaseDate?.year.toString() ?? 'Unknown Year';

  Map<String, dynamic> toMap() {
    return {
      'name': album.title,
      'artist': album.artistDisplayName,
      'albumArt': album.cover,
      'year': album.releaseDate?.year,
      'songIds': songIds,
      'trackCount': trackCount,
      'totalDuration': totalDuration,
      'genre': album.genre,
    };
  }

  FullAlbum copyWith({
    Album? album,
    List<int>? songIds,
    int? trackCount,
    int? totalDuration,
  }) {
    return (
      album: album ?? this.album,
      songIds: songIds ?? this.songIds,
      trackCount: trackCount ?? this.trackCount,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }
}

Album albumFromMap(Map<String, dynamic> map) {
  return Album(
    id: map['id'] ?? 0,
    uuid: map['uuid'] ?? DateTime.now().microsecondsSinceEpoch.toString(),
    avid: map['avid'],
    bvid: map['bvid'],
    cid: map['cid'],
    musicId: map['musicId'],
    sessionId: map['sessionId'],
    title: map['title'] ?? 'Unknown Album',
    artist: map['artist'],
    artistId: map['artistId'],
    artistAvatar: map['artistAvatar'],
    upAvatar: map['upAvatar'],
    upName: map['upName'],
    upId: map['upId'],
    genre: map['genre'],
    language: map['language'],
    cover: map['cover'],
    fileUrl: map['fileUrl'],
    downloadUrl: map['downloadUrl'],
    albumArtPath: map['albumArtPath'],
    duration: map['duration'],
    lastPlayedTime:
        map['lastPlayedTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastPlayedTime']) : DateTime.now(),
    releaseDate: map['releaseDate'] != null ? DateTime.fromMillisecondsSinceEpoch(map['releaseDate']) : null,
    playedCount: map['playedCount'] ?? 0,
    addStatus: map['addStatus'],
    createdAt: map['createdAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) : DateTime.now(),
    updatedAt: map['updatedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt']) : DateTime.now(),
  );
}

FullAlbum fullAlbumFrom({
  required Album album,
  required List<int> songIds,
  required int trackCount,
  required int totalDuration,
}) {
  return (
    album: album,
    songIds: songIds,
    trackCount: trackCount,
    totalDuration: totalDuration,
  );
}
