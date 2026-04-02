import 'package:audio_service/audio_service.dart';

class Song {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String? albumArt;
  final String path;
  final int duration;
  final String? genre;
  final int? year;
  final int? track;
  final int size;
  final DateTime? dateAdded;
  final DateTime? dateModified;
  bool isFavorite;
  int playCount;
  DateTime? lastPlayed;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    this.albumArt,
    required this.path,
    required this.duration,
    this.genre,
    this.year,
    this.track,
    required this.size,
    this.dateAdded,
    this.dateModified,
    this.isFavorite = false,
    this.playCount = 0,
    this.lastPlayed,
  });

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['_id'] ?? map['id'] ?? 0, // on_audio_query uses '_id'
      title: map['title'] ?? 'Unknown Title',
      artist: map['artist'] ?? 'Unknown Artist',
      album: map['album'] ?? 'Unknown Album',
      albumArt: map['album_art'] ?? map['albumArt'], // on_audio_query uses 'album_art'
      path: map['data'] ?? map['path'] ?? '', // on_audio_query uses 'data'
      duration: map['duration'] ?? 0,
      genre: map['genre'],
      year: map['year'],
      track: map['track'],
      size: map['size'] ?? 0,
      dateAdded: map['date_added'] != null // on_audio_query uses 'date_added'
          ? DateTime.fromMillisecondsSinceEpoch(map['date_added'] * 1000)
          : (map['dateAdded'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dateAdded']) : null),
      dateModified: map['date_modified'] != null // on_audio_query uses 'date_modified'
          ? DateTime.fromMillisecondsSinceEpoch(map['date_modified'] * 1000)
          : (map['dateModified'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dateModified']) : null),
      isFavorite: map['isFavorite'] == 1 || map['isFavorite'] == true,
      playCount: map['playCount'] ?? 0,
      lastPlayed: map['lastPlayed'] != null ? DateTime.fromMillisecondsSinceEpoch(map['lastPlayed']) : null,
    );
  }

  /// Create a Song from MediaItem (used by AudioService)
  factory Song.fromMediaItem(MediaItem mediaItem) {
    return Song(
      id: int.tryParse(mediaItem.id) ?? 0,
      title: mediaItem.title,
      artist: mediaItem.artist ?? 'Unknown Artist',
      album: mediaItem.album ?? 'Unknown Album',
      albumArt: mediaItem.artUri?.toString(),
      path: mediaItem.extras?['path'] ?? '',
      duration: mediaItem.duration?.inMilliseconds ?? 0,
      genre: mediaItem.genre,
      year: mediaItem.extras?['year'],
      track: mediaItem.extras?['track'],
      size: mediaItem.extras?['size'] ?? 0,
      dateAdded: mediaItem.extras?['dateAdded'] != null
          ? DateTime.fromMillisecondsSinceEpoch(mediaItem.extras!['dateAdded'])
          : null,
      dateModified: mediaItem.extras?['dateModified'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              mediaItem.extras!['dateModified'],
            )
          : null,
      isFavorite: mediaItem.extras?['isFavorite'] == true,
      playCount: mediaItem.extras?['playCount'] ?? 0,
      lastPlayed: mediaItem.extras?['lastPlayed'] != null
          ? DateTime.fromMillisecondsSinceEpoch(mediaItem.extras!['lastPlayed'])
          : null,
    );
  }

  /// Convert Song to MediaItem (used by AudioService)
  MediaItem toMediaItem() {
    return MediaItem(
      id: id.toString(),
      title: title,
      artist: artist,
      album: album,
      artUri: albumArt != null ? Uri.tryParse(albumArt!) : null,
      duration: Duration(milliseconds: duration),
      genre: genre,
      extras: {
        'path': path,
        'year': year,
        'track': track,
        'size': size,
        'dateAdded': dateAdded?.millisecondsSinceEpoch,
        'dateModified': dateModified?.millisecondsSinceEpoch,
        'isFavorite': isFavorite,
        'playCount': playCount,
        'lastPlayed': lastPlayed?.millisecondsSinceEpoch,
      },
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'albumArt': albumArt,
      'path': path,
      'duration': duration,
      'genre': genre,
      'year': year,
      'track': track,
      'size': size,
      'dateAdded': dateAdded?.millisecondsSinceEpoch,
      'dateModified': dateModified?.millisecondsSinceEpoch,
      'isFavorite': isFavorite ? 1 : 0,
      'playCount': playCount,
      'lastPlayed': lastPlayed?.millisecondsSinceEpoch,
    };
  }

  Song copyWith({
    int? id,
    String? title,
    String? artist,
    String? album,
    String? albumArt,
    String? path,
    int? duration,
    String? genre,
    int? year,
    int? track,
    int? size,
    DateTime? dateAdded,
    DateTime? dateModified,
    bool? isFavorite,
    int? playCount,
    DateTime? lastPlayed,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      albumArt: albumArt ?? this.albumArt,
      path: path ?? this.path,
      duration: duration ?? this.duration,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      track: track ?? this.track,
      size: size ?? this.size,
      dateAdded: dateAdded ?? this.dateAdded,
      dateModified: dateModified ?? this.dateModified,
      isFavorite: isFavorite ?? this.isFavorite,
      playCount: playCount ?? this.playCount,
      lastPlayed: lastPlayed ?? this.lastPlayed,
    );
  }

  String get durationString {
    final minutes = duration ~/ 60000;
    final seconds = (duration % 60000) ~/ 1000;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get sizeString {
    if (size < 1024) return '${size}B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)}KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Song && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Song{id: $id, title: $title, artist: $artist, album: $album}';
  }
}
