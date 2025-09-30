class Album {
  final String name;
  final String artist;
  final String? albumArt;
  final int? year;
  final List<int> songIds;
  final int trackCount;
  final int totalDuration;
  final String? genre;

  const Album({
    required this.name,
    required this.artist,
    this.albumArt,
    this.year,
    required this.songIds,
    required this.trackCount,
    required this.totalDuration,
    this.genre,
  });

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      name: map['name'] ?? 'Unknown Album',
      artist: map['artist'] ?? 'Unknown Artist',
      albumArt: map['albumArt'],
      year: map['year'],
      songIds: List<int>.from(map['songIds'] ?? []),
      trackCount: map['trackCount'] ?? 0,
      totalDuration: map['totalDuration'] ?? 0,
      genre: map['genre'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'artist': artist,
      'albumArt': albumArt,
      'year': year,
      'songIds': songIds,
      'trackCount': trackCount,
      'totalDuration': totalDuration,
      'genre': genre,
    };
  }

  Album copyWith({
    String? name,
    String? artist,
    String? albumArt,
    int? year,
    List<int>? songIds,
    int? trackCount,
    int? totalDuration,
    String? genre,
  }) {
    return Album(
      name: name ?? this.name,
      artist: artist ?? this.artist,
      albumArt: albumArt ?? this.albumArt,
      year: year ?? this.year,
      songIds: songIds ?? this.songIds,
      trackCount: trackCount ?? this.trackCount,
      totalDuration: totalDuration ?? this.totalDuration,
      genre: genre ?? this.genre,
    );
  }

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

  String get yearString => year?.toString() ?? 'Unknown Year';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Album && runtimeType == other.runtimeType && name == other.name && artist == other.artist;

  @override
  int get hashCode => name.hashCode ^ artist.hashCode;

  @override
  String toString() {
    return 'Album{name: $name, artist: $artist, trackCount: $trackCount}';
  }
}
