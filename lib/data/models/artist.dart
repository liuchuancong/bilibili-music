class Artist {
  final String name;
  final List<int> songIds;
  final List<String> albums;
  final int songCount;
  final int albumCount;
  final String? image;
  final String? bio;
  final List<String> genres;

  const Artist({
    required this.name,
    required this.songIds,
    required this.albums,
    required this.songCount,
    required this.albumCount,
    this.image,
    this.bio,
    required this.genres,
  });

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      name: map['name'] ?? 'Unknown Artist',
      songIds: List<int>.from(map['songIds'] ?? []),
      albums: List<String>.from(map['albums'] ?? []),
      songCount: map['songCount'] ?? 0,
      albumCount: map['albumCount'] ?? 0,
      image: map['image'],
      bio: map['bio'],
      genres: List<String>.from(map['genres'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'songIds': songIds,
      'albums': albums,
      'songCount': songCount,
      'albumCount': albumCount,
      'image': image,
      'bio': bio,
      'genres': genres,
    };
  }

  Artist copyWith({
    String? name,
    List<int>? songIds,
    List<String>? albums,
    int? songCount,
    int? albumCount,
    String? image,
    String? bio,
    List<String>? genres,
  }) {
    return Artist(
      name: name ?? this.name,
      songIds: songIds ?? this.songIds,
      albums: albums ?? this.albums,
      songCount: songCount ?? this.songCount,
      albumCount: albumCount ?? this.albumCount,
      image: image ?? this.image,
      bio: bio ?? this.bio,
      genres: genres ?? this.genres,
    );
  }

  String get songCountString {
    return '$songCount song${songCount == 1 ? '' : 's'}';
  }

  String get albumCountString {
    return '$albumCount album${albumCount == 1 ? '' : 's'}';
  }

  String get primaryGenre {
    return genres.isNotEmpty ? genres.first : 'Unknown Genre';
  }

  String get genresString {
    if (genres.isEmpty) return 'Unknown Genre';
    if (genres.length == 1) return genres.first;
    if (genres.length <= 3) return genres.join(', ');
    return '${genres.take(2).join(', ')} +${genres.length - 2} more';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Artist && runtimeType == other.runtimeType && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return 'Artist{name: $name, songCount: $songCount, albumCount: $albumCount}';
  }
}
