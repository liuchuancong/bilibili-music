// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $SongsTable extends Songs with TableInfo<$SongsTable, Song> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentUuidMeta =
      const VerificationMeta('parentUuid');
  @override
  late final GeneratedColumn<String> parentUuid = GeneratedColumn<String>(
      'parent_uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avidMeta = const VerificationMeta('avid');
  @override
  late final GeneratedColumn<String> avid = GeneratedColumn<String>(
      'avid', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bvidMeta = const VerificationMeta('bvid');
  @override
  late final GeneratedColumn<String> bvid = GeneratedColumn<String>(
      'bvid', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cidMeta = const VerificationMeta('cid');
  @override
  late final GeneratedColumn<String> cid = GeneratedColumn<String>(
      'cid', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _musicIdMeta =
      const VerificationMeta('musicId');
  @override
  late final GeneratedColumn<String> musicId = GeneratedColumn<String>(
      'music_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lyricsMeta = const VerificationMeta('lyrics');
  @override
  late final GeneratedColumn<String> lyrics = GeneratedColumn<String>(
      'lyrics', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _albumMeta = const VerificationMeta('album');
  @override
  late final GeneratedColumn<String> album = GeneratedColumn<String>(
      'album', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _albumArtPathMeta =
      const VerificationMeta('albumArtPath');
  @override
  late final GeneratedColumn<String> albumArtPath = GeneratedColumn<String>(
      'album_art_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
      'artist', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _upAvatarMeta =
      const VerificationMeta('upAvatar');
  @override
  late final GeneratedColumn<String> upAvatar = GeneratedColumn<String>(
      'up_avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _upNameMeta = const VerificationMeta('upName');
  @override
  late final GeneratedColumn<String> upName = GeneratedColumn<String>(
      'up_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _upIdMeta = const VerificationMeta('upId');
  @override
  late final GeneratedColumn<String> upId = GeneratedColumn<String>(
      'up_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _artistIdMeta =
      const VerificationMeta('artistId');
  @override
  late final GeneratedColumn<String> artistId = GeneratedColumn<String>(
      'artist_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _artistAvatarMeta =
      const VerificationMeta('artistAvatar');
  @override
  late final GeneratedColumn<String> artistAvatar = GeneratedColumn<String>(
      'artist_avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
      'genre', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coverMeta = const VerificationMeta('cover');
  @override
  late final GeneratedColumn<String> cover = GeneratedColumn<String>(
      'cover', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fileUrlMeta =
      const VerificationMeta('fileUrl');
  @override
  late final GeneratedColumn<String> fileUrl = GeneratedColumn<String>(
      'file_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _downloadUrlMeta =
      const VerificationMeta('downloadUrl');
  @override
  late final GeneratedColumn<String> downloadUrl = GeneratedColumn<String>(
      'download_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sizeMeta = const VerificationMeta('size');
  @override
  late final GeneratedColumn<int> size = GeneratedColumn<int>(
      'size', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastPlayedTimeMeta =
      const VerificationMeta('lastPlayedTime');
  @override
  late final GeneratedColumn<DateTime> lastPlayedTime =
      GeneratedColumn<DateTime>('last_played_time', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _releaseDateMeta =
      const VerificationMeta('releaseDate');
  @override
  late final GeneratedColumn<DateTime> releaseDate = GeneratedColumn<DateTime>(
      'release_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _trackNumberMeta =
      const VerificationMeta('trackNumber');
  @override
  late final GeneratedColumn<int> trackNumber = GeneratedColumn<int>(
      'track_number', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _playedCountMeta =
      const VerificationMeta('playedCount');
  @override
  late final GeneratedColumn<int> playedCount = GeneratedColumn<int>(
      'played_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _likeCountMeta =
      const VerificationMeta('likeCount');
  @override
  late final GeneratedColumn<int> likeCount = GeneratedColumn<int>(
      'like_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _addStatusMeta =
      const VerificationMeta('addStatus');
  @override
  late final GeneratedColumn<int> addStatus = GeneratedColumn<int>(
      'add_status', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isLikedMeta =
      const VerificationMeta('isLiked');
  @override
  late final GeneratedColumn<bool> isLiked = GeneratedColumn<bool>(
      'is_liked', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_liked" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDownloadedMeta =
      const VerificationMeta('isDownloaded');
  @override
  late final GeneratedColumn<bool> isDownloaded = GeneratedColumn<bool>(
      'is_downloaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_downloaded" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        parentUuid,
        avid,
        bvid,
        cid,
        musicId,
        sessionId,
        title,
        lyrics,
        album,
        albumArtPath,
        artist,
        upAvatar,
        upName,
        upId,
        artistId,
        artistAvatar,
        genre,
        language,
        cover,
        fileUrl,
        downloadUrl,
        duration,
        size,
        lastPlayedTime,
        releaseDate,
        trackNumber,
        playedCount,
        likeCount,
        addStatus,
        isLiked,
        isDownloaded,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'songs';
  @override
  VerificationContext validateIntegrity(Insertable<Song> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('parent_uuid')) {
      context.handle(
          _parentUuidMeta,
          parentUuid.isAcceptableOrUnknown(
              data['parent_uuid']!, _parentUuidMeta));
    } else if (isInserting) {
      context.missing(_parentUuidMeta);
    }
    if (data.containsKey('avid')) {
      context.handle(
          _avidMeta, avid.isAcceptableOrUnknown(data['avid']!, _avidMeta));
    }
    if (data.containsKey('bvid')) {
      context.handle(
          _bvidMeta, bvid.isAcceptableOrUnknown(data['bvid']!, _bvidMeta));
    }
    if (data.containsKey('cid')) {
      context.handle(
          _cidMeta, cid.isAcceptableOrUnknown(data['cid']!, _cidMeta));
    }
    if (data.containsKey('music_id')) {
      context.handle(_musicIdMeta,
          musicId.isAcceptableOrUnknown(data['music_id']!, _musicIdMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('lyrics')) {
      context.handle(_lyricsMeta,
          lyrics.isAcceptableOrUnknown(data['lyrics']!, _lyricsMeta));
    }
    if (data.containsKey('album')) {
      context.handle(
          _albumMeta, album.isAcceptableOrUnknown(data['album']!, _albumMeta));
    }
    if (data.containsKey('album_art_path')) {
      context.handle(
          _albumArtPathMeta,
          albumArtPath.isAcceptableOrUnknown(
              data['album_art_path']!, _albumArtPathMeta));
    }
    if (data.containsKey('artist')) {
      context.handle(_artistMeta,
          artist.isAcceptableOrUnknown(data['artist']!, _artistMeta));
    }
    if (data.containsKey('up_avatar')) {
      context.handle(_upAvatarMeta,
          upAvatar.isAcceptableOrUnknown(data['up_avatar']!, _upAvatarMeta));
    }
    if (data.containsKey('up_name')) {
      context.handle(_upNameMeta,
          upName.isAcceptableOrUnknown(data['up_name']!, _upNameMeta));
    }
    if (data.containsKey('up_id')) {
      context.handle(
          _upIdMeta, upId.isAcceptableOrUnknown(data['up_id']!, _upIdMeta));
    }
    if (data.containsKey('artist_id')) {
      context.handle(_artistIdMeta,
          artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta));
    }
    if (data.containsKey('artist_avatar')) {
      context.handle(
          _artistAvatarMeta,
          artistAvatar.isAcceptableOrUnknown(
              data['artist_avatar']!, _artistAvatarMeta));
    }
    if (data.containsKey('genre')) {
      context.handle(
          _genreMeta, genre.isAcceptableOrUnknown(data['genre']!, _genreMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('cover')) {
      context.handle(
          _coverMeta, cover.isAcceptableOrUnknown(data['cover']!, _coverMeta));
    }
    if (data.containsKey('file_url')) {
      context.handle(_fileUrlMeta,
          fileUrl.isAcceptableOrUnknown(data['file_url']!, _fileUrlMeta));
    }
    if (data.containsKey('download_url')) {
      context.handle(
          _downloadUrlMeta,
          downloadUrl.isAcceptableOrUnknown(
              data['download_url']!, _downloadUrlMeta));
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    }
    if (data.containsKey('size')) {
      context.handle(
          _sizeMeta, size.isAcceptableOrUnknown(data['size']!, _sizeMeta));
    }
    if (data.containsKey('last_played_time')) {
      context.handle(
          _lastPlayedTimeMeta,
          lastPlayedTime.isAcceptableOrUnknown(
              data['last_played_time']!, _lastPlayedTimeMeta));
    }
    if (data.containsKey('release_date')) {
      context.handle(
          _releaseDateMeta,
          releaseDate.isAcceptableOrUnknown(
              data['release_date']!, _releaseDateMeta));
    }
    if (data.containsKey('track_number')) {
      context.handle(
          _trackNumberMeta,
          trackNumber.isAcceptableOrUnknown(
              data['track_number']!, _trackNumberMeta));
    }
    if (data.containsKey('played_count')) {
      context.handle(
          _playedCountMeta,
          playedCount.isAcceptableOrUnknown(
              data['played_count']!, _playedCountMeta));
    }
    if (data.containsKey('like_count')) {
      context.handle(_likeCountMeta,
          likeCount.isAcceptableOrUnknown(data['like_count']!, _likeCountMeta));
    }
    if (data.containsKey('add_status')) {
      context.handle(_addStatusMeta,
          addStatus.isAcceptableOrUnknown(data['add_status']!, _addStatusMeta));
    }
    if (data.containsKey('is_liked')) {
      context.handle(_isLikedMeta,
          isLiked.isAcceptableOrUnknown(data['is_liked']!, _isLikedMeta));
    }
    if (data.containsKey('is_downloaded')) {
      context.handle(
          _isDownloadedMeta,
          isDownloaded.isAcceptableOrUnknown(
              data['is_downloaded']!, _isDownloadedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Song map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Song(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      parentUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_uuid'])!,
      avid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avid']),
      bvid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bvid']),
      cid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cid']),
      musicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}music_id']),
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      lyrics: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lyrics']),
      album: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}album']),
      albumArtPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}album_art_path']),
      artist: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist']),
      upAvatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}up_avatar']),
      upName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}up_name']),
      upId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}up_id']),
      artistId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist_id']),
      artistAvatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist_avatar']),
      genre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}genre']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language']),
      cover: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover']),
      fileUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_url']),
      downloadUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}download_url']),
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration']),
      size: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}size']),
      lastPlayedTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_played_time'])!,
      releaseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}release_date']),
      trackNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}track_number']),
      playedCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}played_count'])!,
      likeCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}like_count'])!,
      addStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}add_status']),
      isLiked: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_liked'])!,
      isDownloaded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_downloaded'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SongsTable createAlias(String alias) {
    return $SongsTable(attachedDatabase, alias);
  }
}

class Song extends DataClass implements Insertable<Song> {
  final int id;
  final String uuid;
  final String parentUuid;
  final String? avid;
  final String? bvid;
  final String? cid;
  final String? musicId;
  final String? sessionId;
  final String title;
  final String? lyrics;
  final String? album;
  final String? albumArtPath;
  final String? artist;
  final String? upAvatar;
  final String? upName;
  final String? upId;
  final String? artistId;
  final String? artistAvatar;
  final String? genre;
  final String? language;
  final String? cover;
  final String? fileUrl;
  final String? downloadUrl;
  final int? duration;
  final int? size;
  final DateTime lastPlayedTime;
  final DateTime? releaseDate;
  final int? trackNumber;
  final int playedCount;
  final int likeCount;
  final int? addStatus;
  final bool isLiked;
  final bool isDownloaded;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Song(
      {required this.id,
      required this.uuid,
      required this.parentUuid,
      this.avid,
      this.bvid,
      this.cid,
      this.musicId,
      this.sessionId,
      required this.title,
      this.lyrics,
      this.album,
      this.albumArtPath,
      this.artist,
      this.upAvatar,
      this.upName,
      this.upId,
      this.artistId,
      this.artistAvatar,
      this.genre,
      this.language,
      this.cover,
      this.fileUrl,
      this.downloadUrl,
      this.duration,
      this.size,
      required this.lastPlayedTime,
      this.releaseDate,
      this.trackNumber,
      required this.playedCount,
      required this.likeCount,
      this.addStatus,
      required this.isLiked,
      required this.isDownloaded,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['parent_uuid'] = Variable<String>(parentUuid);
    if (!nullToAbsent || avid != null) {
      map['avid'] = Variable<String>(avid);
    }
    if (!nullToAbsent || bvid != null) {
      map['bvid'] = Variable<String>(bvid);
    }
    if (!nullToAbsent || cid != null) {
      map['cid'] = Variable<String>(cid);
    }
    if (!nullToAbsent || musicId != null) {
      map['music_id'] = Variable<String>(musicId);
    }
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || lyrics != null) {
      map['lyrics'] = Variable<String>(lyrics);
    }
    if (!nullToAbsent || album != null) {
      map['album'] = Variable<String>(album);
    }
    if (!nullToAbsent || albumArtPath != null) {
      map['album_art_path'] = Variable<String>(albumArtPath);
    }
    if (!nullToAbsent || artist != null) {
      map['artist'] = Variable<String>(artist);
    }
    if (!nullToAbsent || upAvatar != null) {
      map['up_avatar'] = Variable<String>(upAvatar);
    }
    if (!nullToAbsent || upName != null) {
      map['up_name'] = Variable<String>(upName);
    }
    if (!nullToAbsent || upId != null) {
      map['up_id'] = Variable<String>(upId);
    }
    if (!nullToAbsent || artistId != null) {
      map['artist_id'] = Variable<String>(artistId);
    }
    if (!nullToAbsent || artistAvatar != null) {
      map['artist_avatar'] = Variable<String>(artistAvatar);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    if (!nullToAbsent || cover != null) {
      map['cover'] = Variable<String>(cover);
    }
    if (!nullToAbsent || fileUrl != null) {
      map['file_url'] = Variable<String>(fileUrl);
    }
    if (!nullToAbsent || downloadUrl != null) {
      map['download_url'] = Variable<String>(downloadUrl);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<int>(duration);
    }
    if (!nullToAbsent || size != null) {
      map['size'] = Variable<int>(size);
    }
    map['last_played_time'] = Variable<DateTime>(lastPlayedTime);
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<DateTime>(releaseDate);
    }
    if (!nullToAbsent || trackNumber != null) {
      map['track_number'] = Variable<int>(trackNumber);
    }
    map['played_count'] = Variable<int>(playedCount);
    map['like_count'] = Variable<int>(likeCount);
    if (!nullToAbsent || addStatus != null) {
      map['add_status'] = Variable<int>(addStatus);
    }
    map['is_liked'] = Variable<bool>(isLiked);
    map['is_downloaded'] = Variable<bool>(isDownloaded);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SongsCompanion toCompanion(bool nullToAbsent) {
    return SongsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      parentUuid: Value(parentUuid),
      avid: avid == null && nullToAbsent ? const Value.absent() : Value(avid),
      bvid: bvid == null && nullToAbsent ? const Value.absent() : Value(bvid),
      cid: cid == null && nullToAbsent ? const Value.absent() : Value(cid),
      musicId: musicId == null && nullToAbsent
          ? const Value.absent()
          : Value(musicId),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      title: Value(title),
      lyrics:
          lyrics == null && nullToAbsent ? const Value.absent() : Value(lyrics),
      album:
          album == null && nullToAbsent ? const Value.absent() : Value(album),
      albumArtPath: albumArtPath == null && nullToAbsent
          ? const Value.absent()
          : Value(albumArtPath),
      artist:
          artist == null && nullToAbsent ? const Value.absent() : Value(artist),
      upAvatar: upAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(upAvatar),
      upName:
          upName == null && nullToAbsent ? const Value.absent() : Value(upName),
      upId: upId == null && nullToAbsent ? const Value.absent() : Value(upId),
      artistId: artistId == null && nullToAbsent
          ? const Value.absent()
          : Value(artistId),
      artistAvatar: artistAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(artistAvatar),
      genre:
          genre == null && nullToAbsent ? const Value.absent() : Value(genre),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      cover:
          cover == null && nullToAbsent ? const Value.absent() : Value(cover),
      fileUrl: fileUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fileUrl),
      downloadUrl: downloadUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(downloadUrl),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      size: size == null && nullToAbsent ? const Value.absent() : Value(size),
      lastPlayedTime: Value(lastPlayedTime),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
      trackNumber: trackNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(trackNumber),
      playedCount: Value(playedCount),
      likeCount: Value(likeCount),
      addStatus: addStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(addStatus),
      isLiked: Value(isLiked),
      isDownloaded: Value(isDownloaded),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Song.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Song(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      parentUuid: serializer.fromJson<String>(json['parentUuid']),
      avid: serializer.fromJson<String?>(json['avid']),
      bvid: serializer.fromJson<String?>(json['bvid']),
      cid: serializer.fromJson<String?>(json['cid']),
      musicId: serializer.fromJson<String?>(json['musicId']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      title: serializer.fromJson<String>(json['title']),
      lyrics: serializer.fromJson<String?>(json['lyrics']),
      album: serializer.fromJson<String?>(json['album']),
      albumArtPath: serializer.fromJson<String?>(json['albumArtPath']),
      artist: serializer.fromJson<String?>(json['artist']),
      upAvatar: serializer.fromJson<String?>(json['upAvatar']),
      upName: serializer.fromJson<String?>(json['upName']),
      upId: serializer.fromJson<String?>(json['upId']),
      artistId: serializer.fromJson<String?>(json['artistId']),
      artistAvatar: serializer.fromJson<String?>(json['artistAvatar']),
      genre: serializer.fromJson<String?>(json['genre']),
      language: serializer.fromJson<String?>(json['language']),
      cover: serializer.fromJson<String?>(json['cover']),
      fileUrl: serializer.fromJson<String?>(json['fileUrl']),
      downloadUrl: serializer.fromJson<String?>(json['downloadUrl']),
      duration: serializer.fromJson<int?>(json['duration']),
      size: serializer.fromJson<int?>(json['size']),
      lastPlayedTime: serializer.fromJson<DateTime>(json['lastPlayedTime']),
      releaseDate: serializer.fromJson<DateTime?>(json['releaseDate']),
      trackNumber: serializer.fromJson<int?>(json['trackNumber']),
      playedCount: serializer.fromJson<int>(json['playedCount']),
      likeCount: serializer.fromJson<int>(json['likeCount']),
      addStatus: serializer.fromJson<int?>(json['addStatus']),
      isLiked: serializer.fromJson<bool>(json['isLiked']),
      isDownloaded: serializer.fromJson<bool>(json['isDownloaded']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'parentUuid': serializer.toJson<String>(parentUuid),
      'avid': serializer.toJson<String?>(avid),
      'bvid': serializer.toJson<String?>(bvid),
      'cid': serializer.toJson<String?>(cid),
      'musicId': serializer.toJson<String?>(musicId),
      'sessionId': serializer.toJson<String?>(sessionId),
      'title': serializer.toJson<String>(title),
      'lyrics': serializer.toJson<String?>(lyrics),
      'album': serializer.toJson<String?>(album),
      'albumArtPath': serializer.toJson<String?>(albumArtPath),
      'artist': serializer.toJson<String?>(artist),
      'upAvatar': serializer.toJson<String?>(upAvatar),
      'upName': serializer.toJson<String?>(upName),
      'upId': serializer.toJson<String?>(upId),
      'artistId': serializer.toJson<String?>(artistId),
      'artistAvatar': serializer.toJson<String?>(artistAvatar),
      'genre': serializer.toJson<String?>(genre),
      'language': serializer.toJson<String?>(language),
      'cover': serializer.toJson<String?>(cover),
      'fileUrl': serializer.toJson<String?>(fileUrl),
      'downloadUrl': serializer.toJson<String?>(downloadUrl),
      'duration': serializer.toJson<int?>(duration),
      'size': serializer.toJson<int?>(size),
      'lastPlayedTime': serializer.toJson<DateTime>(lastPlayedTime),
      'releaseDate': serializer.toJson<DateTime?>(releaseDate),
      'trackNumber': serializer.toJson<int?>(trackNumber),
      'playedCount': serializer.toJson<int>(playedCount),
      'likeCount': serializer.toJson<int>(likeCount),
      'addStatus': serializer.toJson<int?>(addStatus),
      'isLiked': serializer.toJson<bool>(isLiked),
      'isDownloaded': serializer.toJson<bool>(isDownloaded),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Song copyWith(
          {int? id,
          String? uuid,
          String? parentUuid,
          Value<String?> avid = const Value.absent(),
          Value<String?> bvid = const Value.absent(),
          Value<String?> cid = const Value.absent(),
          Value<String?> musicId = const Value.absent(),
          Value<String?> sessionId = const Value.absent(),
          String? title,
          Value<String?> lyrics = const Value.absent(),
          Value<String?> album = const Value.absent(),
          Value<String?> albumArtPath = const Value.absent(),
          Value<String?> artist = const Value.absent(),
          Value<String?> upAvatar = const Value.absent(),
          Value<String?> upName = const Value.absent(),
          Value<String?> upId = const Value.absent(),
          Value<String?> artistId = const Value.absent(),
          Value<String?> artistAvatar = const Value.absent(),
          Value<String?> genre = const Value.absent(),
          Value<String?> language = const Value.absent(),
          Value<String?> cover = const Value.absent(),
          Value<String?> fileUrl = const Value.absent(),
          Value<String?> downloadUrl = const Value.absent(),
          Value<int?> duration = const Value.absent(),
          Value<int?> size = const Value.absent(),
          DateTime? lastPlayedTime,
          Value<DateTime?> releaseDate = const Value.absent(),
          Value<int?> trackNumber = const Value.absent(),
          int? playedCount,
          int? likeCount,
          Value<int?> addStatus = const Value.absent(),
          bool? isLiked,
          bool? isDownloaded,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Song(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        parentUuid: parentUuid ?? this.parentUuid,
        avid: avid.present ? avid.value : this.avid,
        bvid: bvid.present ? bvid.value : this.bvid,
        cid: cid.present ? cid.value : this.cid,
        musicId: musicId.present ? musicId.value : this.musicId,
        sessionId: sessionId.present ? sessionId.value : this.sessionId,
        title: title ?? this.title,
        lyrics: lyrics.present ? lyrics.value : this.lyrics,
        album: album.present ? album.value : this.album,
        albumArtPath:
            albumArtPath.present ? albumArtPath.value : this.albumArtPath,
        artist: artist.present ? artist.value : this.artist,
        upAvatar: upAvatar.present ? upAvatar.value : this.upAvatar,
        upName: upName.present ? upName.value : this.upName,
        upId: upId.present ? upId.value : this.upId,
        artistId: artistId.present ? artistId.value : this.artistId,
        artistAvatar:
            artistAvatar.present ? artistAvatar.value : this.artistAvatar,
        genre: genre.present ? genre.value : this.genre,
        language: language.present ? language.value : this.language,
        cover: cover.present ? cover.value : this.cover,
        fileUrl: fileUrl.present ? fileUrl.value : this.fileUrl,
        downloadUrl: downloadUrl.present ? downloadUrl.value : this.downloadUrl,
        duration: duration.present ? duration.value : this.duration,
        size: size.present ? size.value : this.size,
        lastPlayedTime: lastPlayedTime ?? this.lastPlayedTime,
        releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
        trackNumber: trackNumber.present ? trackNumber.value : this.trackNumber,
        playedCount: playedCount ?? this.playedCount,
        likeCount: likeCount ?? this.likeCount,
        addStatus: addStatus.present ? addStatus.value : this.addStatus,
        isLiked: isLiked ?? this.isLiked,
        isDownloaded: isDownloaded ?? this.isDownloaded,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Song copyWithCompanion(SongsCompanion data) {
    return Song(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      parentUuid:
          data.parentUuid.present ? data.parentUuid.value : this.parentUuid,
      avid: data.avid.present ? data.avid.value : this.avid,
      bvid: data.bvid.present ? data.bvid.value : this.bvid,
      cid: data.cid.present ? data.cid.value : this.cid,
      musicId: data.musicId.present ? data.musicId.value : this.musicId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      title: data.title.present ? data.title.value : this.title,
      lyrics: data.lyrics.present ? data.lyrics.value : this.lyrics,
      album: data.album.present ? data.album.value : this.album,
      albumArtPath: data.albumArtPath.present
          ? data.albumArtPath.value
          : this.albumArtPath,
      artist: data.artist.present ? data.artist.value : this.artist,
      upAvatar: data.upAvatar.present ? data.upAvatar.value : this.upAvatar,
      upName: data.upName.present ? data.upName.value : this.upName,
      upId: data.upId.present ? data.upId.value : this.upId,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
      artistAvatar: data.artistAvatar.present
          ? data.artistAvatar.value
          : this.artistAvatar,
      genre: data.genre.present ? data.genre.value : this.genre,
      language: data.language.present ? data.language.value : this.language,
      cover: data.cover.present ? data.cover.value : this.cover,
      fileUrl: data.fileUrl.present ? data.fileUrl.value : this.fileUrl,
      downloadUrl:
          data.downloadUrl.present ? data.downloadUrl.value : this.downloadUrl,
      duration: data.duration.present ? data.duration.value : this.duration,
      size: data.size.present ? data.size.value : this.size,
      lastPlayedTime: data.lastPlayedTime.present
          ? data.lastPlayedTime.value
          : this.lastPlayedTime,
      releaseDate:
          data.releaseDate.present ? data.releaseDate.value : this.releaseDate,
      trackNumber:
          data.trackNumber.present ? data.trackNumber.value : this.trackNumber,
      playedCount:
          data.playedCount.present ? data.playedCount.value : this.playedCount,
      likeCount: data.likeCount.present ? data.likeCount.value : this.likeCount,
      addStatus: data.addStatus.present ? data.addStatus.value : this.addStatus,
      isLiked: data.isLiked.present ? data.isLiked.value : this.isLiked,
      isDownloaded: data.isDownloaded.present
          ? data.isDownloaded.value
          : this.isDownloaded,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Song(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('parentUuid: $parentUuid, ')
          ..write('avid: $avid, ')
          ..write('bvid: $bvid, ')
          ..write('cid: $cid, ')
          ..write('musicId: $musicId, ')
          ..write('sessionId: $sessionId, ')
          ..write('title: $title, ')
          ..write('lyrics: $lyrics, ')
          ..write('album: $album, ')
          ..write('albumArtPath: $albumArtPath, ')
          ..write('artist: $artist, ')
          ..write('upAvatar: $upAvatar, ')
          ..write('upName: $upName, ')
          ..write('upId: $upId, ')
          ..write('artistId: $artistId, ')
          ..write('artistAvatar: $artistAvatar, ')
          ..write('genre: $genre, ')
          ..write('language: $language, ')
          ..write('cover: $cover, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('downloadUrl: $downloadUrl, ')
          ..write('duration: $duration, ')
          ..write('size: $size, ')
          ..write('lastPlayedTime: $lastPlayedTime, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('playedCount: $playedCount, ')
          ..write('likeCount: $likeCount, ')
          ..write('addStatus: $addStatus, ')
          ..write('isLiked: $isLiked, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        uuid,
        parentUuid,
        avid,
        bvid,
        cid,
        musicId,
        sessionId,
        title,
        lyrics,
        album,
        albumArtPath,
        artist,
        upAvatar,
        upName,
        upId,
        artistId,
        artistAvatar,
        genre,
        language,
        cover,
        fileUrl,
        downloadUrl,
        duration,
        size,
        lastPlayedTime,
        releaseDate,
        trackNumber,
        playedCount,
        likeCount,
        addStatus,
        isLiked,
        isDownloaded,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Song &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.parentUuid == this.parentUuid &&
          other.avid == this.avid &&
          other.bvid == this.bvid &&
          other.cid == this.cid &&
          other.musicId == this.musicId &&
          other.sessionId == this.sessionId &&
          other.title == this.title &&
          other.lyrics == this.lyrics &&
          other.album == this.album &&
          other.albumArtPath == this.albumArtPath &&
          other.artist == this.artist &&
          other.upAvatar == this.upAvatar &&
          other.upName == this.upName &&
          other.upId == this.upId &&
          other.artistId == this.artistId &&
          other.artistAvatar == this.artistAvatar &&
          other.genre == this.genre &&
          other.language == this.language &&
          other.cover == this.cover &&
          other.fileUrl == this.fileUrl &&
          other.downloadUrl == this.downloadUrl &&
          other.duration == this.duration &&
          other.size == this.size &&
          other.lastPlayedTime == this.lastPlayedTime &&
          other.releaseDate == this.releaseDate &&
          other.trackNumber == this.trackNumber &&
          other.playedCount == this.playedCount &&
          other.likeCount == this.likeCount &&
          other.addStatus == this.addStatus &&
          other.isLiked == this.isLiked &&
          other.isDownloaded == this.isDownloaded &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SongsCompanion extends UpdateCompanion<Song> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> parentUuid;
  final Value<String?> avid;
  final Value<String?> bvid;
  final Value<String?> cid;
  final Value<String?> musicId;
  final Value<String?> sessionId;
  final Value<String> title;
  final Value<String?> lyrics;
  final Value<String?> album;
  final Value<String?> albumArtPath;
  final Value<String?> artist;
  final Value<String?> upAvatar;
  final Value<String?> upName;
  final Value<String?> upId;
  final Value<String?> artistId;
  final Value<String?> artistAvatar;
  final Value<String?> genre;
  final Value<String?> language;
  final Value<String?> cover;
  final Value<String?> fileUrl;
  final Value<String?> downloadUrl;
  final Value<int?> duration;
  final Value<int?> size;
  final Value<DateTime> lastPlayedTime;
  final Value<DateTime?> releaseDate;
  final Value<int?> trackNumber;
  final Value<int> playedCount;
  final Value<int> likeCount;
  final Value<int?> addStatus;
  final Value<bool> isLiked;
  final Value<bool> isDownloaded;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SongsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.parentUuid = const Value.absent(),
    this.avid = const Value.absent(),
    this.bvid = const Value.absent(),
    this.cid = const Value.absent(),
    this.musicId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.title = const Value.absent(),
    this.lyrics = const Value.absent(),
    this.album = const Value.absent(),
    this.albumArtPath = const Value.absent(),
    this.artist = const Value.absent(),
    this.upAvatar = const Value.absent(),
    this.upName = const Value.absent(),
    this.upId = const Value.absent(),
    this.artistId = const Value.absent(),
    this.artistAvatar = const Value.absent(),
    this.genre = const Value.absent(),
    this.language = const Value.absent(),
    this.cover = const Value.absent(),
    this.fileUrl = const Value.absent(),
    this.downloadUrl = const Value.absent(),
    this.duration = const Value.absent(),
    this.size = const Value.absent(),
    this.lastPlayedTime = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.trackNumber = const Value.absent(),
    this.playedCount = const Value.absent(),
    this.likeCount = const Value.absent(),
    this.addStatus = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.isDownloaded = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SongsCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    required String parentUuid,
    this.avid = const Value.absent(),
    this.bvid = const Value.absent(),
    this.cid = const Value.absent(),
    this.musicId = const Value.absent(),
    this.sessionId = const Value.absent(),
    required String title,
    this.lyrics = const Value.absent(),
    this.album = const Value.absent(),
    this.albumArtPath = const Value.absent(),
    this.artist = const Value.absent(),
    this.upAvatar = const Value.absent(),
    this.upName = const Value.absent(),
    this.upId = const Value.absent(),
    this.artistId = const Value.absent(),
    this.artistAvatar = const Value.absent(),
    this.genre = const Value.absent(),
    this.language = const Value.absent(),
    this.cover = const Value.absent(),
    this.fileUrl = const Value.absent(),
    this.downloadUrl = const Value.absent(),
    this.duration = const Value.absent(),
    this.size = const Value.absent(),
    this.lastPlayedTime = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.trackNumber = const Value.absent(),
    this.playedCount = const Value.absent(),
    this.likeCount = const Value.absent(),
    this.addStatus = const Value.absent(),
    this.isLiked = const Value.absent(),
    this.isDownloaded = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : uuid = Value(uuid),
        parentUuid = Value(parentUuid),
        title = Value(title);
  static Insertable<Song> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? parentUuid,
    Expression<String>? avid,
    Expression<String>? bvid,
    Expression<String>? cid,
    Expression<String>? musicId,
    Expression<String>? sessionId,
    Expression<String>? title,
    Expression<String>? lyrics,
    Expression<String>? album,
    Expression<String>? albumArtPath,
    Expression<String>? artist,
    Expression<String>? upAvatar,
    Expression<String>? upName,
    Expression<String>? upId,
    Expression<String>? artistId,
    Expression<String>? artistAvatar,
    Expression<String>? genre,
    Expression<String>? language,
    Expression<String>? cover,
    Expression<String>? fileUrl,
    Expression<String>? downloadUrl,
    Expression<int>? duration,
    Expression<int>? size,
    Expression<DateTime>? lastPlayedTime,
    Expression<DateTime>? releaseDate,
    Expression<int>? trackNumber,
    Expression<int>? playedCount,
    Expression<int>? likeCount,
    Expression<int>? addStatus,
    Expression<bool>? isLiked,
    Expression<bool>? isDownloaded,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (parentUuid != null) 'parent_uuid': parentUuid,
      if (avid != null) 'avid': avid,
      if (bvid != null) 'bvid': bvid,
      if (cid != null) 'cid': cid,
      if (musicId != null) 'music_id': musicId,
      if (sessionId != null) 'session_id': sessionId,
      if (title != null) 'title': title,
      if (lyrics != null) 'lyrics': lyrics,
      if (album != null) 'album': album,
      if (albumArtPath != null) 'album_art_path': albumArtPath,
      if (artist != null) 'artist': artist,
      if (upAvatar != null) 'up_avatar': upAvatar,
      if (upName != null) 'up_name': upName,
      if (upId != null) 'up_id': upId,
      if (artistId != null) 'artist_id': artistId,
      if (artistAvatar != null) 'artist_avatar': artistAvatar,
      if (genre != null) 'genre': genre,
      if (language != null) 'language': language,
      if (cover != null) 'cover': cover,
      if (fileUrl != null) 'file_url': fileUrl,
      if (downloadUrl != null) 'download_url': downloadUrl,
      if (duration != null) 'duration': duration,
      if (size != null) 'size': size,
      if (lastPlayedTime != null) 'last_played_time': lastPlayedTime,
      if (releaseDate != null) 'release_date': releaseDate,
      if (trackNumber != null) 'track_number': trackNumber,
      if (playedCount != null) 'played_count': playedCount,
      if (likeCount != null) 'like_count': likeCount,
      if (addStatus != null) 'add_status': addStatus,
      if (isLiked != null) 'is_liked': isLiked,
      if (isDownloaded != null) 'is_downloaded': isDownloaded,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SongsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? parentUuid,
      Value<String?>? avid,
      Value<String?>? bvid,
      Value<String?>? cid,
      Value<String?>? musicId,
      Value<String?>? sessionId,
      Value<String>? title,
      Value<String?>? lyrics,
      Value<String?>? album,
      Value<String?>? albumArtPath,
      Value<String?>? artist,
      Value<String?>? upAvatar,
      Value<String?>? upName,
      Value<String?>? upId,
      Value<String?>? artistId,
      Value<String?>? artistAvatar,
      Value<String?>? genre,
      Value<String?>? language,
      Value<String?>? cover,
      Value<String?>? fileUrl,
      Value<String?>? downloadUrl,
      Value<int?>? duration,
      Value<int?>? size,
      Value<DateTime>? lastPlayedTime,
      Value<DateTime?>? releaseDate,
      Value<int?>? trackNumber,
      Value<int>? playedCount,
      Value<int>? likeCount,
      Value<int?>? addStatus,
      Value<bool>? isLiked,
      Value<bool>? isDownloaded,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return SongsCompanion(
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (parentUuid.present) {
      map['parent_uuid'] = Variable<String>(parentUuid.value);
    }
    if (avid.present) {
      map['avid'] = Variable<String>(avid.value);
    }
    if (bvid.present) {
      map['bvid'] = Variable<String>(bvid.value);
    }
    if (cid.present) {
      map['cid'] = Variable<String>(cid.value);
    }
    if (musicId.present) {
      map['music_id'] = Variable<String>(musicId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (lyrics.present) {
      map['lyrics'] = Variable<String>(lyrics.value);
    }
    if (album.present) {
      map['album'] = Variable<String>(album.value);
    }
    if (albumArtPath.present) {
      map['album_art_path'] = Variable<String>(albumArtPath.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (upAvatar.present) {
      map['up_avatar'] = Variable<String>(upAvatar.value);
    }
    if (upName.present) {
      map['up_name'] = Variable<String>(upName.value);
    }
    if (upId.present) {
      map['up_id'] = Variable<String>(upId.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<String>(artistId.value);
    }
    if (artistAvatar.present) {
      map['artist_avatar'] = Variable<String>(artistAvatar.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (cover.present) {
      map['cover'] = Variable<String>(cover.value);
    }
    if (fileUrl.present) {
      map['file_url'] = Variable<String>(fileUrl.value);
    }
    if (downloadUrl.present) {
      map['download_url'] = Variable<String>(downloadUrl.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (size.present) {
      map['size'] = Variable<int>(size.value);
    }
    if (lastPlayedTime.present) {
      map['last_played_time'] = Variable<DateTime>(lastPlayedTime.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<DateTime>(releaseDate.value);
    }
    if (trackNumber.present) {
      map['track_number'] = Variable<int>(trackNumber.value);
    }
    if (playedCount.present) {
      map['played_count'] = Variable<int>(playedCount.value);
    }
    if (likeCount.present) {
      map['like_count'] = Variable<int>(likeCount.value);
    }
    if (addStatus.present) {
      map['add_status'] = Variable<int>(addStatus.value);
    }
    if (isLiked.present) {
      map['is_liked'] = Variable<bool>(isLiked.value);
    }
    if (isDownloaded.present) {
      map['is_downloaded'] = Variable<bool>(isDownloaded.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('parentUuid: $parentUuid, ')
          ..write('avid: $avid, ')
          ..write('bvid: $bvid, ')
          ..write('cid: $cid, ')
          ..write('musicId: $musicId, ')
          ..write('sessionId: $sessionId, ')
          ..write('title: $title, ')
          ..write('lyrics: $lyrics, ')
          ..write('album: $album, ')
          ..write('albumArtPath: $albumArtPath, ')
          ..write('artist: $artist, ')
          ..write('upAvatar: $upAvatar, ')
          ..write('upName: $upName, ')
          ..write('upId: $upId, ')
          ..write('artistId: $artistId, ')
          ..write('artistAvatar: $artistAvatar, ')
          ..write('genre: $genre, ')
          ..write('language: $language, ')
          ..write('cover: $cover, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('downloadUrl: $downloadUrl, ')
          ..write('duration: $duration, ')
          ..write('size: $size, ')
          ..write('lastPlayedTime: $lastPlayedTime, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('trackNumber: $trackNumber, ')
          ..write('playedCount: $playedCount, ')
          ..write('likeCount: $likeCount, ')
          ..write('addStatus: $addStatus, ')
          ..write('isLiked: $isLiked, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ArtlistsTable extends Artlists with TableInfo<$ArtlistsTable, Artlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArtlistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
      'artist', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descMeta = const VerificationMeta('desc');
  @override
  late final GeneratedColumn<String> desc = GeneratedColumn<String>(
      'desc', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _artistAvatarMeta =
      const VerificationMeta('artistAvatar');
  @override
  late final GeneratedColumn<String> artistAvatar = GeneratedColumn<String>(
      'artist_avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
      'alias', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _likeMeta = const VerificationMeta('like');
  @override
  late final GeneratedColumn<int> like = GeneratedColumn<int>(
      'like', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _followMeta = const VerificationMeta('follow');
  @override
  late final GeneratedColumn<int> follow = GeneratedColumn<int>(
      'follow', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _fansMeta = const VerificationMeta('fans');
  @override
  late final GeneratedColumn<int> fans = GeneratedColumn<int>(
      'fans', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _playCountMeta =
      const VerificationMeta('playCount');
  @override
  late final GeneratedColumn<int> playCount = GeneratedColumn<int>(
      'play_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _musicIdMeta =
      const VerificationMeta('musicId');
  @override
  late final GeneratedColumn<String> musicId = GeneratedColumn<String>(
      'music_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        artist,
        desc,
        artistAvatar,
        alias,
        like,
        follow,
        fans,
        playCount,
        musicId,
        sessionId,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'artlists';
  @override
  VerificationContext validateIntegrity(Insertable<Artlist> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('artist')) {
      context.handle(_artistMeta,
          artist.isAcceptableOrUnknown(data['artist']!, _artistMeta));
    }
    if (data.containsKey('desc')) {
      context.handle(
          _descMeta, desc.isAcceptableOrUnknown(data['desc']!, _descMeta));
    }
    if (data.containsKey('artist_avatar')) {
      context.handle(
          _artistAvatarMeta,
          artistAvatar.isAcceptableOrUnknown(
              data['artist_avatar']!, _artistAvatarMeta));
    }
    if (data.containsKey('alias')) {
      context.handle(
          _aliasMeta, alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta));
    }
    if (data.containsKey('like')) {
      context.handle(
          _likeMeta, like.isAcceptableOrUnknown(data['like']!, _likeMeta));
    }
    if (data.containsKey('follow')) {
      context.handle(_followMeta,
          follow.isAcceptableOrUnknown(data['follow']!, _followMeta));
    }
    if (data.containsKey('fans')) {
      context.handle(
          _fansMeta, fans.isAcceptableOrUnknown(data['fans']!, _fansMeta));
    }
    if (data.containsKey('play_count')) {
      context.handle(_playCountMeta,
          playCount.isAcceptableOrUnknown(data['play_count']!, _playCountMeta));
    }
    if (data.containsKey('music_id')) {
      context.handle(_musicIdMeta,
          musicId.isAcceptableOrUnknown(data['music_id']!, _musicIdMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Artlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Artlist(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      artist: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist']),
      desc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}desc']),
      artistAvatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist_avatar']),
      alias: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}alias']),
      like: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}like']),
      follow: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}follow']),
      fans: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fans']),
      playCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}play_count']),
      musicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}music_id']),
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ArtlistsTable createAlias(String alias) {
    return $ArtlistsTable(attachedDatabase, alias);
  }
}

class Artlist extends DataClass implements Insertable<Artlist> {
  final int id;
  final String uuid;
  final String? artist;
  final String? desc;
  final String? artistAvatar;
  final String? alias;
  final int? like;
  final int? follow;
  final int? fans;
  final int? playCount;
  final String? musicId;
  final String? sessionId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Artlist(
      {required this.id,
      required this.uuid,
      this.artist,
      this.desc,
      this.artistAvatar,
      this.alias,
      this.like,
      this.follow,
      this.fans,
      this.playCount,
      this.musicId,
      this.sessionId,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    if (!nullToAbsent || artist != null) {
      map['artist'] = Variable<String>(artist);
    }
    if (!nullToAbsent || desc != null) {
      map['desc'] = Variable<String>(desc);
    }
    if (!nullToAbsent || artistAvatar != null) {
      map['artist_avatar'] = Variable<String>(artistAvatar);
    }
    if (!nullToAbsent || alias != null) {
      map['alias'] = Variable<String>(alias);
    }
    if (!nullToAbsent || like != null) {
      map['like'] = Variable<int>(like);
    }
    if (!nullToAbsent || follow != null) {
      map['follow'] = Variable<int>(follow);
    }
    if (!nullToAbsent || fans != null) {
      map['fans'] = Variable<int>(fans);
    }
    if (!nullToAbsent || playCount != null) {
      map['play_count'] = Variable<int>(playCount);
    }
    if (!nullToAbsent || musicId != null) {
      map['music_id'] = Variable<String>(musicId);
    }
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ArtlistsCompanion toCompanion(bool nullToAbsent) {
    return ArtlistsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      artist:
          artist == null && nullToAbsent ? const Value.absent() : Value(artist),
      desc: desc == null && nullToAbsent ? const Value.absent() : Value(desc),
      artistAvatar: artistAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(artistAvatar),
      alias:
          alias == null && nullToAbsent ? const Value.absent() : Value(alias),
      like: like == null && nullToAbsent ? const Value.absent() : Value(like),
      follow:
          follow == null && nullToAbsent ? const Value.absent() : Value(follow),
      fans: fans == null && nullToAbsent ? const Value.absent() : Value(fans),
      playCount: playCount == null && nullToAbsent
          ? const Value.absent()
          : Value(playCount),
      musicId: musicId == null && nullToAbsent
          ? const Value.absent()
          : Value(musicId),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Artlist.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Artlist(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      artist: serializer.fromJson<String?>(json['artist']),
      desc: serializer.fromJson<String?>(json['desc']),
      artistAvatar: serializer.fromJson<String?>(json['artistAvatar']),
      alias: serializer.fromJson<String?>(json['alias']),
      like: serializer.fromJson<int?>(json['like']),
      follow: serializer.fromJson<int?>(json['follow']),
      fans: serializer.fromJson<int?>(json['fans']),
      playCount: serializer.fromJson<int?>(json['playCount']),
      musicId: serializer.fromJson<String?>(json['musicId']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'artist': serializer.toJson<String?>(artist),
      'desc': serializer.toJson<String?>(desc),
      'artistAvatar': serializer.toJson<String?>(artistAvatar),
      'alias': serializer.toJson<String?>(alias),
      'like': serializer.toJson<int?>(like),
      'follow': serializer.toJson<int?>(follow),
      'fans': serializer.toJson<int?>(fans),
      'playCount': serializer.toJson<int?>(playCount),
      'musicId': serializer.toJson<String?>(musicId),
      'sessionId': serializer.toJson<String?>(sessionId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Artlist copyWith(
          {int? id,
          String? uuid,
          Value<String?> artist = const Value.absent(),
          Value<String?> desc = const Value.absent(),
          Value<String?> artistAvatar = const Value.absent(),
          Value<String?> alias = const Value.absent(),
          Value<int?> like = const Value.absent(),
          Value<int?> follow = const Value.absent(),
          Value<int?> fans = const Value.absent(),
          Value<int?> playCount = const Value.absent(),
          Value<String?> musicId = const Value.absent(),
          Value<String?> sessionId = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Artlist(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        artist: artist.present ? artist.value : this.artist,
        desc: desc.present ? desc.value : this.desc,
        artistAvatar:
            artistAvatar.present ? artistAvatar.value : this.artistAvatar,
        alias: alias.present ? alias.value : this.alias,
        like: like.present ? like.value : this.like,
        follow: follow.present ? follow.value : this.follow,
        fans: fans.present ? fans.value : this.fans,
        playCount: playCount.present ? playCount.value : this.playCount,
        musicId: musicId.present ? musicId.value : this.musicId,
        sessionId: sessionId.present ? sessionId.value : this.sessionId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Artlist copyWithCompanion(ArtlistsCompanion data) {
    return Artlist(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      artist: data.artist.present ? data.artist.value : this.artist,
      desc: data.desc.present ? data.desc.value : this.desc,
      artistAvatar: data.artistAvatar.present
          ? data.artistAvatar.value
          : this.artistAvatar,
      alias: data.alias.present ? data.alias.value : this.alias,
      like: data.like.present ? data.like.value : this.like,
      follow: data.follow.present ? data.follow.value : this.follow,
      fans: data.fans.present ? data.fans.value : this.fans,
      playCount: data.playCount.present ? data.playCount.value : this.playCount,
      musicId: data.musicId.present ? data.musicId.value : this.musicId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Artlist(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('artist: $artist, ')
          ..write('desc: $desc, ')
          ..write('artistAvatar: $artistAvatar, ')
          ..write('alias: $alias, ')
          ..write('like: $like, ')
          ..write('follow: $follow, ')
          ..write('fans: $fans, ')
          ..write('playCount: $playCount, ')
          ..write('musicId: $musicId, ')
          ..write('sessionId: $sessionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, artist, desc, artistAvatar, alias,
      like, follow, fans, playCount, musicId, sessionId, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Artlist &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.artist == this.artist &&
          other.desc == this.desc &&
          other.artistAvatar == this.artistAvatar &&
          other.alias == this.alias &&
          other.like == this.like &&
          other.follow == this.follow &&
          other.fans == this.fans &&
          other.playCount == this.playCount &&
          other.musicId == this.musicId &&
          other.sessionId == this.sessionId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ArtlistsCompanion extends UpdateCompanion<Artlist> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String?> artist;
  final Value<String?> desc;
  final Value<String?> artistAvatar;
  final Value<String?> alias;
  final Value<int?> like;
  final Value<int?> follow;
  final Value<int?> fans;
  final Value<int?> playCount;
  final Value<String?> musicId;
  final Value<String?> sessionId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ArtlistsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.artist = const Value.absent(),
    this.desc = const Value.absent(),
    this.artistAvatar = const Value.absent(),
    this.alias = const Value.absent(),
    this.like = const Value.absent(),
    this.follow = const Value.absent(),
    this.fans = const Value.absent(),
    this.playCount = const Value.absent(),
    this.musicId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ArtlistsCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    this.artist = const Value.absent(),
    this.desc = const Value.absent(),
    this.artistAvatar = const Value.absent(),
    this.alias = const Value.absent(),
    this.like = const Value.absent(),
    this.follow = const Value.absent(),
    this.fans = const Value.absent(),
    this.playCount = const Value.absent(),
    this.musicId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : uuid = Value(uuid);
  static Insertable<Artlist> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? artist,
    Expression<String>? desc,
    Expression<String>? artistAvatar,
    Expression<String>? alias,
    Expression<int>? like,
    Expression<int>? follow,
    Expression<int>? fans,
    Expression<int>? playCount,
    Expression<String>? musicId,
    Expression<String>? sessionId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (artist != null) 'artist': artist,
      if (desc != null) 'desc': desc,
      if (artistAvatar != null) 'artist_avatar': artistAvatar,
      if (alias != null) 'alias': alias,
      if (like != null) 'like': like,
      if (follow != null) 'follow': follow,
      if (fans != null) 'fans': fans,
      if (playCount != null) 'play_count': playCount,
      if (musicId != null) 'music_id': musicId,
      if (sessionId != null) 'session_id': sessionId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ArtlistsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String?>? artist,
      Value<String?>? desc,
      Value<String?>? artistAvatar,
      Value<String?>? alias,
      Value<int?>? like,
      Value<int?>? follow,
      Value<int?>? fans,
      Value<int?>? playCount,
      Value<String?>? musicId,
      Value<String?>? sessionId,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return ArtlistsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      artist: artist ?? this.artist,
      desc: desc ?? this.desc,
      artistAvatar: artistAvatar ?? this.artistAvatar,
      alias: alias ?? this.alias,
      like: like ?? this.like,
      follow: follow ?? this.follow,
      fans: fans ?? this.fans,
      playCount: playCount ?? this.playCount,
      musicId: musicId ?? this.musicId,
      sessionId: sessionId ?? this.sessionId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (desc.present) {
      map['desc'] = Variable<String>(desc.value);
    }
    if (artistAvatar.present) {
      map['artist_avatar'] = Variable<String>(artistAvatar.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (like.present) {
      map['like'] = Variable<int>(like.value);
    }
    if (follow.present) {
      map['follow'] = Variable<int>(follow.value);
    }
    if (fans.present) {
      map['fans'] = Variable<int>(fans.value);
    }
    if (playCount.present) {
      map['play_count'] = Variable<int>(playCount.value);
    }
    if (musicId.present) {
      map['music_id'] = Variable<String>(musicId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArtlistsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('artist: $artist, ')
          ..write('desc: $desc, ')
          ..write('artistAvatar: $artistAvatar, ')
          ..write('alias: $alias, ')
          ..write('like: $like, ')
          ..write('follow: $follow, ')
          ..write('fans: $fans, ')
          ..write('playCount: $playCount, ')
          ..write('musicId: $musicId, ')
          ..write('sessionId: $sessionId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AlbumsTable extends Albums with TableInfo<$AlbumsTable, Album> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlbumsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avidMeta = const VerificationMeta('avid');
  @override
  late final GeneratedColumn<String> avid = GeneratedColumn<String>(
      'avid', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _bvidMeta = const VerificationMeta('bvid');
  @override
  late final GeneratedColumn<String> bvid = GeneratedColumn<String>(
      'bvid', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cidMeta = const VerificationMeta('cid');
  @override
  late final GeneratedColumn<String> cid = GeneratedColumn<String>(
      'cid', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _musicIdMeta =
      const VerificationMeta('musicId');
  @override
  late final GeneratedColumn<String> musicId = GeneratedColumn<String>(
      'music_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sessionIdMeta =
      const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
      'session_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
      'artist', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _artistIdMeta =
      const VerificationMeta('artistId');
  @override
  late final GeneratedColumn<String> artistId = GeneratedColumn<String>(
      'artist_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _artistAvatarMeta =
      const VerificationMeta('artistAvatar');
  @override
  late final GeneratedColumn<String> artistAvatar = GeneratedColumn<String>(
      'artist_avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _upAvatarMeta =
      const VerificationMeta('upAvatar');
  @override
  late final GeneratedColumn<String> upAvatar = GeneratedColumn<String>(
      'up_avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _upNameMeta = const VerificationMeta('upName');
  @override
  late final GeneratedColumn<String> upName = GeneratedColumn<String>(
      'up_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _upIdMeta = const VerificationMeta('upId');
  @override
  late final GeneratedColumn<String> upId = GeneratedColumn<String>(
      'up_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
      'genre', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coverMeta = const VerificationMeta('cover');
  @override
  late final GeneratedColumn<String> cover = GeneratedColumn<String>(
      'cover', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fileUrlMeta =
      const VerificationMeta('fileUrl');
  @override
  late final GeneratedColumn<String> fileUrl = GeneratedColumn<String>(
      'file_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _downloadUrlMeta =
      const VerificationMeta('downloadUrl');
  @override
  late final GeneratedColumn<String> downloadUrl = GeneratedColumn<String>(
      'download_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _albumArtPathMeta =
      const VerificationMeta('albumArtPath');
  @override
  late final GeneratedColumn<String> albumArtPath = GeneratedColumn<String>(
      'album_art_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<String> duration = GeneratedColumn<String>(
      'duration', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastPlayedTimeMeta =
      const VerificationMeta('lastPlayedTime');
  @override
  late final GeneratedColumn<DateTime> lastPlayedTime =
      GeneratedColumn<DateTime>('last_played_time', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _releaseDateMeta =
      const VerificationMeta('releaseDate');
  @override
  late final GeneratedColumn<DateTime> releaseDate = GeneratedColumn<DateTime>(
      'release_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _playedCountMeta =
      const VerificationMeta('playedCount');
  @override
  late final GeneratedColumn<int> playedCount = GeneratedColumn<int>(
      'played_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _addStatusMeta =
      const VerificationMeta('addStatus');
  @override
  late final GeneratedColumn<int> addStatus = GeneratedColumn<int>(
      'add_status', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        avid,
        bvid,
        cid,
        musicId,
        sessionId,
        title,
        artist,
        artistId,
        artistAvatar,
        upAvatar,
        upName,
        upId,
        genre,
        language,
        cover,
        fileUrl,
        downloadUrl,
        albumArtPath,
        duration,
        lastPlayedTime,
        releaseDate,
        playedCount,
        addStatus,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'albums';
  @override
  VerificationContext validateIntegrity(Insertable<Album> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('avid')) {
      context.handle(
          _avidMeta, avid.isAcceptableOrUnknown(data['avid']!, _avidMeta));
    }
    if (data.containsKey('bvid')) {
      context.handle(
          _bvidMeta, bvid.isAcceptableOrUnknown(data['bvid']!, _bvidMeta));
    }
    if (data.containsKey('cid')) {
      context.handle(
          _cidMeta, cid.isAcceptableOrUnknown(data['cid']!, _cidMeta));
    }
    if (data.containsKey('music_id')) {
      context.handle(_musicIdMeta,
          musicId.isAcceptableOrUnknown(data['music_id']!, _musicIdMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta,
          sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('artist')) {
      context.handle(_artistMeta,
          artist.isAcceptableOrUnknown(data['artist']!, _artistMeta));
    }
    if (data.containsKey('artist_id')) {
      context.handle(_artistIdMeta,
          artistId.isAcceptableOrUnknown(data['artist_id']!, _artistIdMeta));
    }
    if (data.containsKey('artist_avatar')) {
      context.handle(
          _artistAvatarMeta,
          artistAvatar.isAcceptableOrUnknown(
              data['artist_avatar']!, _artistAvatarMeta));
    }
    if (data.containsKey('up_avatar')) {
      context.handle(_upAvatarMeta,
          upAvatar.isAcceptableOrUnknown(data['up_avatar']!, _upAvatarMeta));
    }
    if (data.containsKey('up_name')) {
      context.handle(_upNameMeta,
          upName.isAcceptableOrUnknown(data['up_name']!, _upNameMeta));
    }
    if (data.containsKey('up_id')) {
      context.handle(
          _upIdMeta, upId.isAcceptableOrUnknown(data['up_id']!, _upIdMeta));
    }
    if (data.containsKey('genre')) {
      context.handle(
          _genreMeta, genre.isAcceptableOrUnknown(data['genre']!, _genreMeta));
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    }
    if (data.containsKey('cover')) {
      context.handle(
          _coverMeta, cover.isAcceptableOrUnknown(data['cover']!, _coverMeta));
    }
    if (data.containsKey('file_url')) {
      context.handle(_fileUrlMeta,
          fileUrl.isAcceptableOrUnknown(data['file_url']!, _fileUrlMeta));
    }
    if (data.containsKey('download_url')) {
      context.handle(
          _downloadUrlMeta,
          downloadUrl.isAcceptableOrUnknown(
              data['download_url']!, _downloadUrlMeta));
    }
    if (data.containsKey('album_art_path')) {
      context.handle(
          _albumArtPathMeta,
          albumArtPath.isAcceptableOrUnknown(
              data['album_art_path']!, _albumArtPathMeta));
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    }
    if (data.containsKey('last_played_time')) {
      context.handle(
          _lastPlayedTimeMeta,
          lastPlayedTime.isAcceptableOrUnknown(
              data['last_played_time']!, _lastPlayedTimeMeta));
    }
    if (data.containsKey('release_date')) {
      context.handle(
          _releaseDateMeta,
          releaseDate.isAcceptableOrUnknown(
              data['release_date']!, _releaseDateMeta));
    }
    if (data.containsKey('played_count')) {
      context.handle(
          _playedCountMeta,
          playedCount.isAcceptableOrUnknown(
              data['played_count']!, _playedCountMeta));
    }
    if (data.containsKey('add_status')) {
      context.handle(_addStatusMeta,
          addStatus.isAcceptableOrUnknown(data['add_status']!, _addStatusMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Album map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Album(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      avid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avid']),
      bvid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bvid']),
      cid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cid']),
      musicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}music_id']),
      sessionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}session_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      artist: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist']),
      artistId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist_id']),
      artistAvatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}artist_avatar']),
      upAvatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}up_avatar']),
      upName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}up_name']),
      upId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}up_id']),
      genre: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}genre']),
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language']),
      cover: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover']),
      fileUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_url']),
      downloadUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}download_url']),
      albumArtPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}album_art_path']),
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}duration']),
      lastPlayedTime: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_played_time'])!,
      releaseDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}release_date']),
      playedCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}played_count'])!,
      addStatus: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}add_status']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AlbumsTable createAlias(String alias) {
    return $AlbumsTable(attachedDatabase, alias);
  }
}

class Album extends DataClass implements Insertable<Album> {
  final int id;
  final String uuid;
  final String? avid;
  final String? bvid;
  final String? cid;
  final String? musicId;
  final String? sessionId;
  final String title;
  final String? artist;
  final String? artistId;
  final String? artistAvatar;
  final String? upAvatar;
  final String? upName;
  final String? upId;
  final String? genre;
  final String? language;
  final String? cover;
  final String? fileUrl;
  final String? downloadUrl;
  final String? albumArtPath;
  final String? duration;
  final DateTime lastPlayedTime;
  final DateTime? releaseDate;
  final int playedCount;
  final int? addStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Album(
      {required this.id,
      required this.uuid,
      this.avid,
      this.bvid,
      this.cid,
      this.musicId,
      this.sessionId,
      required this.title,
      this.artist,
      this.artistId,
      this.artistAvatar,
      this.upAvatar,
      this.upName,
      this.upId,
      this.genre,
      this.language,
      this.cover,
      this.fileUrl,
      this.downloadUrl,
      this.albumArtPath,
      this.duration,
      required this.lastPlayedTime,
      this.releaseDate,
      required this.playedCount,
      this.addStatus,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    if (!nullToAbsent || avid != null) {
      map['avid'] = Variable<String>(avid);
    }
    if (!nullToAbsent || bvid != null) {
      map['bvid'] = Variable<String>(bvid);
    }
    if (!nullToAbsent || cid != null) {
      map['cid'] = Variable<String>(cid);
    }
    if (!nullToAbsent || musicId != null) {
      map['music_id'] = Variable<String>(musicId);
    }
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || artist != null) {
      map['artist'] = Variable<String>(artist);
    }
    if (!nullToAbsent || artistId != null) {
      map['artist_id'] = Variable<String>(artistId);
    }
    if (!nullToAbsent || artistAvatar != null) {
      map['artist_avatar'] = Variable<String>(artistAvatar);
    }
    if (!nullToAbsent || upAvatar != null) {
      map['up_avatar'] = Variable<String>(upAvatar);
    }
    if (!nullToAbsent || upName != null) {
      map['up_name'] = Variable<String>(upName);
    }
    if (!nullToAbsent || upId != null) {
      map['up_id'] = Variable<String>(upId);
    }
    if (!nullToAbsent || genre != null) {
      map['genre'] = Variable<String>(genre);
    }
    if (!nullToAbsent || language != null) {
      map['language'] = Variable<String>(language);
    }
    if (!nullToAbsent || cover != null) {
      map['cover'] = Variable<String>(cover);
    }
    if (!nullToAbsent || fileUrl != null) {
      map['file_url'] = Variable<String>(fileUrl);
    }
    if (!nullToAbsent || downloadUrl != null) {
      map['download_url'] = Variable<String>(downloadUrl);
    }
    if (!nullToAbsent || albumArtPath != null) {
      map['album_art_path'] = Variable<String>(albumArtPath);
    }
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<String>(duration);
    }
    map['last_played_time'] = Variable<DateTime>(lastPlayedTime);
    if (!nullToAbsent || releaseDate != null) {
      map['release_date'] = Variable<DateTime>(releaseDate);
    }
    map['played_count'] = Variable<int>(playedCount);
    if (!nullToAbsent || addStatus != null) {
      map['add_status'] = Variable<int>(addStatus);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AlbumsCompanion toCompanion(bool nullToAbsent) {
    return AlbumsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      avid: avid == null && nullToAbsent ? const Value.absent() : Value(avid),
      bvid: bvid == null && nullToAbsent ? const Value.absent() : Value(bvid),
      cid: cid == null && nullToAbsent ? const Value.absent() : Value(cid),
      musicId: musicId == null && nullToAbsent
          ? const Value.absent()
          : Value(musicId),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      title: Value(title),
      artist:
          artist == null && nullToAbsent ? const Value.absent() : Value(artist),
      artistId: artistId == null && nullToAbsent
          ? const Value.absent()
          : Value(artistId),
      artistAvatar: artistAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(artistAvatar),
      upAvatar: upAvatar == null && nullToAbsent
          ? const Value.absent()
          : Value(upAvatar),
      upName:
          upName == null && nullToAbsent ? const Value.absent() : Value(upName),
      upId: upId == null && nullToAbsent ? const Value.absent() : Value(upId),
      genre:
          genre == null && nullToAbsent ? const Value.absent() : Value(genre),
      language: language == null && nullToAbsent
          ? const Value.absent()
          : Value(language),
      cover:
          cover == null && nullToAbsent ? const Value.absent() : Value(cover),
      fileUrl: fileUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(fileUrl),
      downloadUrl: downloadUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(downloadUrl),
      albumArtPath: albumArtPath == null && nullToAbsent
          ? const Value.absent()
          : Value(albumArtPath),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      lastPlayedTime: Value(lastPlayedTime),
      releaseDate: releaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(releaseDate),
      playedCount: Value(playedCount),
      addStatus: addStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(addStatus),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Album.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Album(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      avid: serializer.fromJson<String?>(json['avid']),
      bvid: serializer.fromJson<String?>(json['bvid']),
      cid: serializer.fromJson<String?>(json['cid']),
      musicId: serializer.fromJson<String?>(json['musicId']),
      sessionId: serializer.fromJson<String?>(json['sessionId']),
      title: serializer.fromJson<String>(json['title']),
      artist: serializer.fromJson<String?>(json['artist']),
      artistId: serializer.fromJson<String?>(json['artistId']),
      artistAvatar: serializer.fromJson<String?>(json['artistAvatar']),
      upAvatar: serializer.fromJson<String?>(json['upAvatar']),
      upName: serializer.fromJson<String?>(json['upName']),
      upId: serializer.fromJson<String?>(json['upId']),
      genre: serializer.fromJson<String?>(json['genre']),
      language: serializer.fromJson<String?>(json['language']),
      cover: serializer.fromJson<String?>(json['cover']),
      fileUrl: serializer.fromJson<String?>(json['fileUrl']),
      downloadUrl: serializer.fromJson<String?>(json['downloadUrl']),
      albumArtPath: serializer.fromJson<String?>(json['albumArtPath']),
      duration: serializer.fromJson<String?>(json['duration']),
      lastPlayedTime: serializer.fromJson<DateTime>(json['lastPlayedTime']),
      releaseDate: serializer.fromJson<DateTime?>(json['releaseDate']),
      playedCount: serializer.fromJson<int>(json['playedCount']),
      addStatus: serializer.fromJson<int?>(json['addStatus']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'avid': serializer.toJson<String?>(avid),
      'bvid': serializer.toJson<String?>(bvid),
      'cid': serializer.toJson<String?>(cid),
      'musicId': serializer.toJson<String?>(musicId),
      'sessionId': serializer.toJson<String?>(sessionId),
      'title': serializer.toJson<String>(title),
      'artist': serializer.toJson<String?>(artist),
      'artistId': serializer.toJson<String?>(artistId),
      'artistAvatar': serializer.toJson<String?>(artistAvatar),
      'upAvatar': serializer.toJson<String?>(upAvatar),
      'upName': serializer.toJson<String?>(upName),
      'upId': serializer.toJson<String?>(upId),
      'genre': serializer.toJson<String?>(genre),
      'language': serializer.toJson<String?>(language),
      'cover': serializer.toJson<String?>(cover),
      'fileUrl': serializer.toJson<String?>(fileUrl),
      'downloadUrl': serializer.toJson<String?>(downloadUrl),
      'albumArtPath': serializer.toJson<String?>(albumArtPath),
      'duration': serializer.toJson<String?>(duration),
      'lastPlayedTime': serializer.toJson<DateTime>(lastPlayedTime),
      'releaseDate': serializer.toJson<DateTime?>(releaseDate),
      'playedCount': serializer.toJson<int>(playedCount),
      'addStatus': serializer.toJson<int?>(addStatus),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Album copyWith(
          {int? id,
          String? uuid,
          Value<String?> avid = const Value.absent(),
          Value<String?> bvid = const Value.absent(),
          Value<String?> cid = const Value.absent(),
          Value<String?> musicId = const Value.absent(),
          Value<String?> sessionId = const Value.absent(),
          String? title,
          Value<String?> artist = const Value.absent(),
          Value<String?> artistId = const Value.absent(),
          Value<String?> artistAvatar = const Value.absent(),
          Value<String?> upAvatar = const Value.absent(),
          Value<String?> upName = const Value.absent(),
          Value<String?> upId = const Value.absent(),
          Value<String?> genre = const Value.absent(),
          Value<String?> language = const Value.absent(),
          Value<String?> cover = const Value.absent(),
          Value<String?> fileUrl = const Value.absent(),
          Value<String?> downloadUrl = const Value.absent(),
          Value<String?> albumArtPath = const Value.absent(),
          Value<String?> duration = const Value.absent(),
          DateTime? lastPlayedTime,
          Value<DateTime?> releaseDate = const Value.absent(),
          int? playedCount,
          Value<int?> addStatus = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      Album(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        avid: avid.present ? avid.value : this.avid,
        bvid: bvid.present ? bvid.value : this.bvid,
        cid: cid.present ? cid.value : this.cid,
        musicId: musicId.present ? musicId.value : this.musicId,
        sessionId: sessionId.present ? sessionId.value : this.sessionId,
        title: title ?? this.title,
        artist: artist.present ? artist.value : this.artist,
        artistId: artistId.present ? artistId.value : this.artistId,
        artistAvatar:
            artistAvatar.present ? artistAvatar.value : this.artistAvatar,
        upAvatar: upAvatar.present ? upAvatar.value : this.upAvatar,
        upName: upName.present ? upName.value : this.upName,
        upId: upId.present ? upId.value : this.upId,
        genre: genre.present ? genre.value : this.genre,
        language: language.present ? language.value : this.language,
        cover: cover.present ? cover.value : this.cover,
        fileUrl: fileUrl.present ? fileUrl.value : this.fileUrl,
        downloadUrl: downloadUrl.present ? downloadUrl.value : this.downloadUrl,
        albumArtPath:
            albumArtPath.present ? albumArtPath.value : this.albumArtPath,
        duration: duration.present ? duration.value : this.duration,
        lastPlayedTime: lastPlayedTime ?? this.lastPlayedTime,
        releaseDate: releaseDate.present ? releaseDate.value : this.releaseDate,
        playedCount: playedCount ?? this.playedCount,
        addStatus: addStatus.present ? addStatus.value : this.addStatus,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Album copyWithCompanion(AlbumsCompanion data) {
    return Album(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      avid: data.avid.present ? data.avid.value : this.avid,
      bvid: data.bvid.present ? data.bvid.value : this.bvid,
      cid: data.cid.present ? data.cid.value : this.cid,
      musicId: data.musicId.present ? data.musicId.value : this.musicId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      title: data.title.present ? data.title.value : this.title,
      artist: data.artist.present ? data.artist.value : this.artist,
      artistId: data.artistId.present ? data.artistId.value : this.artistId,
      artistAvatar: data.artistAvatar.present
          ? data.artistAvatar.value
          : this.artistAvatar,
      upAvatar: data.upAvatar.present ? data.upAvatar.value : this.upAvatar,
      upName: data.upName.present ? data.upName.value : this.upName,
      upId: data.upId.present ? data.upId.value : this.upId,
      genre: data.genre.present ? data.genre.value : this.genre,
      language: data.language.present ? data.language.value : this.language,
      cover: data.cover.present ? data.cover.value : this.cover,
      fileUrl: data.fileUrl.present ? data.fileUrl.value : this.fileUrl,
      downloadUrl:
          data.downloadUrl.present ? data.downloadUrl.value : this.downloadUrl,
      albumArtPath: data.albumArtPath.present
          ? data.albumArtPath.value
          : this.albumArtPath,
      duration: data.duration.present ? data.duration.value : this.duration,
      lastPlayedTime: data.lastPlayedTime.present
          ? data.lastPlayedTime.value
          : this.lastPlayedTime,
      releaseDate:
          data.releaseDate.present ? data.releaseDate.value : this.releaseDate,
      playedCount:
          data.playedCount.present ? data.playedCount.value : this.playedCount,
      addStatus: data.addStatus.present ? data.addStatus.value : this.addStatus,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Album(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('avid: $avid, ')
          ..write('bvid: $bvid, ')
          ..write('cid: $cid, ')
          ..write('musicId: $musicId, ')
          ..write('sessionId: $sessionId, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('artistId: $artistId, ')
          ..write('artistAvatar: $artistAvatar, ')
          ..write('upAvatar: $upAvatar, ')
          ..write('upName: $upName, ')
          ..write('upId: $upId, ')
          ..write('genre: $genre, ')
          ..write('language: $language, ')
          ..write('cover: $cover, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('downloadUrl: $downloadUrl, ')
          ..write('albumArtPath: $albumArtPath, ')
          ..write('duration: $duration, ')
          ..write('lastPlayedTime: $lastPlayedTime, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('playedCount: $playedCount, ')
          ..write('addStatus: $addStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        uuid,
        avid,
        bvid,
        cid,
        musicId,
        sessionId,
        title,
        artist,
        artistId,
        artistAvatar,
        upAvatar,
        upName,
        upId,
        genre,
        language,
        cover,
        fileUrl,
        downloadUrl,
        albumArtPath,
        duration,
        lastPlayedTime,
        releaseDate,
        playedCount,
        addStatus,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Album &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.avid == this.avid &&
          other.bvid == this.bvid &&
          other.cid == this.cid &&
          other.musicId == this.musicId &&
          other.sessionId == this.sessionId &&
          other.title == this.title &&
          other.artist == this.artist &&
          other.artistId == this.artistId &&
          other.artistAvatar == this.artistAvatar &&
          other.upAvatar == this.upAvatar &&
          other.upName == this.upName &&
          other.upId == this.upId &&
          other.genre == this.genre &&
          other.language == this.language &&
          other.cover == this.cover &&
          other.fileUrl == this.fileUrl &&
          other.downloadUrl == this.downloadUrl &&
          other.albumArtPath == this.albumArtPath &&
          other.duration == this.duration &&
          other.lastPlayedTime == this.lastPlayedTime &&
          other.releaseDate == this.releaseDate &&
          other.playedCount == this.playedCount &&
          other.addStatus == this.addStatus &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AlbumsCompanion extends UpdateCompanion<Album> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String?> avid;
  final Value<String?> bvid;
  final Value<String?> cid;
  final Value<String?> musicId;
  final Value<String?> sessionId;
  final Value<String> title;
  final Value<String?> artist;
  final Value<String?> artistId;
  final Value<String?> artistAvatar;
  final Value<String?> upAvatar;
  final Value<String?> upName;
  final Value<String?> upId;
  final Value<String?> genre;
  final Value<String?> language;
  final Value<String?> cover;
  final Value<String?> fileUrl;
  final Value<String?> downloadUrl;
  final Value<String?> albumArtPath;
  final Value<String?> duration;
  final Value<DateTime> lastPlayedTime;
  final Value<DateTime?> releaseDate;
  final Value<int> playedCount;
  final Value<int?> addStatus;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const AlbumsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.avid = const Value.absent(),
    this.bvid = const Value.absent(),
    this.cid = const Value.absent(),
    this.musicId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.title = const Value.absent(),
    this.artist = const Value.absent(),
    this.artistId = const Value.absent(),
    this.artistAvatar = const Value.absent(),
    this.upAvatar = const Value.absent(),
    this.upName = const Value.absent(),
    this.upId = const Value.absent(),
    this.genre = const Value.absent(),
    this.language = const Value.absent(),
    this.cover = const Value.absent(),
    this.fileUrl = const Value.absent(),
    this.downloadUrl = const Value.absent(),
    this.albumArtPath = const Value.absent(),
    this.duration = const Value.absent(),
    this.lastPlayedTime = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.playedCount = const Value.absent(),
    this.addStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AlbumsCompanion.insert({
    this.id = const Value.absent(),
    required String uuid,
    this.avid = const Value.absent(),
    this.bvid = const Value.absent(),
    this.cid = const Value.absent(),
    this.musicId = const Value.absent(),
    this.sessionId = const Value.absent(),
    required String title,
    this.artist = const Value.absent(),
    this.artistId = const Value.absent(),
    this.artistAvatar = const Value.absent(),
    this.upAvatar = const Value.absent(),
    this.upName = const Value.absent(),
    this.upId = const Value.absent(),
    this.genre = const Value.absent(),
    this.language = const Value.absent(),
    this.cover = const Value.absent(),
    this.fileUrl = const Value.absent(),
    this.downloadUrl = const Value.absent(),
    this.albumArtPath = const Value.absent(),
    this.duration = const Value.absent(),
    this.lastPlayedTime = const Value.absent(),
    this.releaseDate = const Value.absent(),
    this.playedCount = const Value.absent(),
    this.addStatus = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  })  : uuid = Value(uuid),
        title = Value(title);
  static Insertable<Album> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? avid,
    Expression<String>? bvid,
    Expression<String>? cid,
    Expression<String>? musicId,
    Expression<String>? sessionId,
    Expression<String>? title,
    Expression<String>? artist,
    Expression<String>? artistId,
    Expression<String>? artistAvatar,
    Expression<String>? upAvatar,
    Expression<String>? upName,
    Expression<String>? upId,
    Expression<String>? genre,
    Expression<String>? language,
    Expression<String>? cover,
    Expression<String>? fileUrl,
    Expression<String>? downloadUrl,
    Expression<String>? albumArtPath,
    Expression<String>? duration,
    Expression<DateTime>? lastPlayedTime,
    Expression<DateTime>? releaseDate,
    Expression<int>? playedCount,
    Expression<int>? addStatus,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (avid != null) 'avid': avid,
      if (bvid != null) 'bvid': bvid,
      if (cid != null) 'cid': cid,
      if (musicId != null) 'music_id': musicId,
      if (sessionId != null) 'session_id': sessionId,
      if (title != null) 'title': title,
      if (artist != null) 'artist': artist,
      if (artistId != null) 'artist_id': artistId,
      if (artistAvatar != null) 'artist_avatar': artistAvatar,
      if (upAvatar != null) 'up_avatar': upAvatar,
      if (upName != null) 'up_name': upName,
      if (upId != null) 'up_id': upId,
      if (genre != null) 'genre': genre,
      if (language != null) 'language': language,
      if (cover != null) 'cover': cover,
      if (fileUrl != null) 'file_url': fileUrl,
      if (downloadUrl != null) 'download_url': downloadUrl,
      if (albumArtPath != null) 'album_art_path': albumArtPath,
      if (duration != null) 'duration': duration,
      if (lastPlayedTime != null) 'last_played_time': lastPlayedTime,
      if (releaseDate != null) 'release_date': releaseDate,
      if (playedCount != null) 'played_count': playedCount,
      if (addStatus != null) 'add_status': addStatus,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AlbumsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String?>? avid,
      Value<String?>? bvid,
      Value<String?>? cid,
      Value<String?>? musicId,
      Value<String?>? sessionId,
      Value<String>? title,
      Value<String?>? artist,
      Value<String?>? artistId,
      Value<String?>? artistAvatar,
      Value<String?>? upAvatar,
      Value<String?>? upName,
      Value<String?>? upId,
      Value<String?>? genre,
      Value<String?>? language,
      Value<String?>? cover,
      Value<String?>? fileUrl,
      Value<String?>? downloadUrl,
      Value<String?>? albumArtPath,
      Value<String?>? duration,
      Value<DateTime>? lastPlayedTime,
      Value<DateTime?>? releaseDate,
      Value<int>? playedCount,
      Value<int?>? addStatus,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return AlbumsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      avid: avid ?? this.avid,
      bvid: bvid ?? this.bvid,
      cid: cid ?? this.cid,
      musicId: musicId ?? this.musicId,
      sessionId: sessionId ?? this.sessionId,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      artistId: artistId ?? this.artistId,
      artistAvatar: artistAvatar ?? this.artistAvatar,
      upAvatar: upAvatar ?? this.upAvatar,
      upName: upName ?? this.upName,
      upId: upId ?? this.upId,
      genre: genre ?? this.genre,
      language: language ?? this.language,
      cover: cover ?? this.cover,
      fileUrl: fileUrl ?? this.fileUrl,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      albumArtPath: albumArtPath ?? this.albumArtPath,
      duration: duration ?? this.duration,
      lastPlayedTime: lastPlayedTime ?? this.lastPlayedTime,
      releaseDate: releaseDate ?? this.releaseDate,
      playedCount: playedCount ?? this.playedCount,
      addStatus: addStatus ?? this.addStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (avid.present) {
      map['avid'] = Variable<String>(avid.value);
    }
    if (bvid.present) {
      map['bvid'] = Variable<String>(bvid.value);
    }
    if (cid.present) {
      map['cid'] = Variable<String>(cid.value);
    }
    if (musicId.present) {
      map['music_id'] = Variable<String>(musicId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (artistId.present) {
      map['artist_id'] = Variable<String>(artistId.value);
    }
    if (artistAvatar.present) {
      map['artist_avatar'] = Variable<String>(artistAvatar.value);
    }
    if (upAvatar.present) {
      map['up_avatar'] = Variable<String>(upAvatar.value);
    }
    if (upName.present) {
      map['up_name'] = Variable<String>(upName.value);
    }
    if (upId.present) {
      map['up_id'] = Variable<String>(upId.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (cover.present) {
      map['cover'] = Variable<String>(cover.value);
    }
    if (fileUrl.present) {
      map['file_url'] = Variable<String>(fileUrl.value);
    }
    if (downloadUrl.present) {
      map['download_url'] = Variable<String>(downloadUrl.value);
    }
    if (albumArtPath.present) {
      map['album_art_path'] = Variable<String>(albumArtPath.value);
    }
    if (duration.present) {
      map['duration'] = Variable<String>(duration.value);
    }
    if (lastPlayedTime.present) {
      map['last_played_time'] = Variable<DateTime>(lastPlayedTime.value);
    }
    if (releaseDate.present) {
      map['release_date'] = Variable<DateTime>(releaseDate.value);
    }
    if (playedCount.present) {
      map['played_count'] = Variable<int>(playedCount.value);
    }
    if (addStatus.present) {
      map['add_status'] = Variable<int>(addStatus.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlbumsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('avid: $avid, ')
          ..write('bvid: $bvid, ')
          ..write('cid: $cid, ')
          ..write('musicId: $musicId, ')
          ..write('sessionId: $sessionId, ')
          ..write('title: $title, ')
          ..write('artist: $artist, ')
          ..write('artistId: $artistId, ')
          ..write('artistAvatar: $artistAvatar, ')
          ..write('upAvatar: $upAvatar, ')
          ..write('upName: $upName, ')
          ..write('upId: $upId, ')
          ..write('genre: $genre, ')
          ..write('language: $language, ')
          ..write('cover: $cover, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('downloadUrl: $downloadUrl, ')
          ..write('albumArtPath: $albumArtPath, ')
          ..write('duration: $duration, ')
          ..write('lastPlayedTime: $lastPlayedTime, ')
          ..write('releaseDate: $releaseDate, ')
          ..write('playedCount: $playedCount, ')
          ..write('addStatus: $addStatus, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SongsTable songs = $SongsTable(this);
  late final $ArtlistsTable artlists = $ArtlistsTable(this);
  late final $AlbumsTable albums = $AlbumsTable(this);
  late final AlbumDao albumDao = AlbumDao(this as AppDatabase);
  late final SongDao songDao = SongDao(this as AppDatabase);
  late final ArtlistDao artlistDao = ArtlistDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [songs, artlists, albums];
}

typedef $$SongsTableCreateCompanionBuilder = SongsCompanion Function({
  Value<int> id,
  required String uuid,
  required String parentUuid,
  Value<String?> avid,
  Value<String?> bvid,
  Value<String?> cid,
  Value<String?> musicId,
  Value<String?> sessionId,
  required String title,
  Value<String?> lyrics,
  Value<String?> album,
  Value<String?> albumArtPath,
  Value<String?> artist,
  Value<String?> upAvatar,
  Value<String?> upName,
  Value<String?> upId,
  Value<String?> artistId,
  Value<String?> artistAvatar,
  Value<String?> genre,
  Value<String?> language,
  Value<String?> cover,
  Value<String?> fileUrl,
  Value<String?> downloadUrl,
  Value<int?> duration,
  Value<int?> size,
  Value<DateTime> lastPlayedTime,
  Value<DateTime?> releaseDate,
  Value<int?> trackNumber,
  Value<int> playedCount,
  Value<int> likeCount,
  Value<int?> addStatus,
  Value<bool> isLiked,
  Value<bool> isDownloaded,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$SongsTableUpdateCompanionBuilder = SongsCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> parentUuid,
  Value<String?> avid,
  Value<String?> bvid,
  Value<String?> cid,
  Value<String?> musicId,
  Value<String?> sessionId,
  Value<String> title,
  Value<String?> lyrics,
  Value<String?> album,
  Value<String?> albumArtPath,
  Value<String?> artist,
  Value<String?> upAvatar,
  Value<String?> upName,
  Value<String?> upId,
  Value<String?> artistId,
  Value<String?> artistAvatar,
  Value<String?> genre,
  Value<String?> language,
  Value<String?> cover,
  Value<String?> fileUrl,
  Value<String?> downloadUrl,
  Value<int?> duration,
  Value<int?> size,
  Value<DateTime> lastPlayedTime,
  Value<DateTime?> releaseDate,
  Value<int?> trackNumber,
  Value<int> playedCount,
  Value<int> likeCount,
  Value<int?> addStatus,
  Value<bool> isLiked,
  Value<bool> isDownloaded,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$SongsTableFilterComposer extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get parentUuid => $composableBuilder(
      column: $table.parentUuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avid => $composableBuilder(
      column: $table.avid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bvid => $composableBuilder(
      column: $table.bvid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cid => $composableBuilder(
      column: $table.cid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get musicId => $composableBuilder(
      column: $table.musicId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lyrics => $composableBuilder(
      column: $table.lyrics, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get album => $composableBuilder(
      column: $table.album, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get albumArtPath => $composableBuilder(
      column: $table.albumArtPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get upAvatar => $composableBuilder(
      column: $table.upAvatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get upName => $composableBuilder(
      column: $table.upName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get upId => $composableBuilder(
      column: $table.upId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artistId => $composableBuilder(
      column: $table.artistId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artistAvatar => $composableBuilder(
      column: $table.artistAvatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get genre => $composableBuilder(
      column: $table.genre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileUrl => $composableBuilder(
      column: $table.fileUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get downloadUrl => $composableBuilder(
      column: $table.downloadUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastPlayedTime => $composableBuilder(
      column: $table.lastPlayedTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get trackNumber => $composableBuilder(
      column: $table.trackNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get playedCount => $composableBuilder(
      column: $table.playedCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get likeCount => $composableBuilder(
      column: $table.likeCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get addStatus => $composableBuilder(
      column: $table.addStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isLiked => $composableBuilder(
      column: $table.isLiked, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SongsTableOrderingComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get parentUuid => $composableBuilder(
      column: $table.parentUuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avid => $composableBuilder(
      column: $table.avid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bvid => $composableBuilder(
      column: $table.bvid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cid => $composableBuilder(
      column: $table.cid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get musicId => $composableBuilder(
      column: $table.musicId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lyrics => $composableBuilder(
      column: $table.lyrics, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get album => $composableBuilder(
      column: $table.album, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get albumArtPath => $composableBuilder(
      column: $table.albumArtPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get upAvatar => $composableBuilder(
      column: $table.upAvatar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get upName => $composableBuilder(
      column: $table.upName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get upId => $composableBuilder(
      column: $table.upId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artistId => $composableBuilder(
      column: $table.artistId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artistAvatar => $composableBuilder(
      column: $table.artistAvatar,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get genre => $composableBuilder(
      column: $table.genre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileUrl => $composableBuilder(
      column: $table.fileUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get downloadUrl => $composableBuilder(
      column: $table.downloadUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get size => $composableBuilder(
      column: $table.size, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastPlayedTime => $composableBuilder(
      column: $table.lastPlayedTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get trackNumber => $composableBuilder(
      column: $table.trackNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get playedCount => $composableBuilder(
      column: $table.playedCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get likeCount => $composableBuilder(
      column: $table.likeCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get addStatus => $composableBuilder(
      column: $table.addStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isLiked => $composableBuilder(
      column: $table.isLiked, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get parentUuid => $composableBuilder(
      column: $table.parentUuid, builder: (column) => column);

  GeneratedColumn<String> get avid =>
      $composableBuilder(column: $table.avid, builder: (column) => column);

  GeneratedColumn<String> get bvid =>
      $composableBuilder(column: $table.bvid, builder: (column) => column);

  GeneratedColumn<String> get cid =>
      $composableBuilder(column: $table.cid, builder: (column) => column);

  GeneratedColumn<String> get musicId =>
      $composableBuilder(column: $table.musicId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get lyrics =>
      $composableBuilder(column: $table.lyrics, builder: (column) => column);

  GeneratedColumn<String> get album =>
      $composableBuilder(column: $table.album, builder: (column) => column);

  GeneratedColumn<String> get albumArtPath => $composableBuilder(
      column: $table.albumArtPath, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get upAvatar =>
      $composableBuilder(column: $table.upAvatar, builder: (column) => column);

  GeneratedColumn<String> get upName =>
      $composableBuilder(column: $table.upName, builder: (column) => column);

  GeneratedColumn<String> get upId =>
      $composableBuilder(column: $table.upId, builder: (column) => column);

  GeneratedColumn<String> get artistId =>
      $composableBuilder(column: $table.artistId, builder: (column) => column);

  GeneratedColumn<String> get artistAvatar => $composableBuilder(
      column: $table.artistAvatar, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get cover =>
      $composableBuilder(column: $table.cover, builder: (column) => column);

  GeneratedColumn<String> get fileUrl =>
      $composableBuilder(column: $table.fileUrl, builder: (column) => column);

  GeneratedColumn<String> get downloadUrl => $composableBuilder(
      column: $table.downloadUrl, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<int> get size =>
      $composableBuilder(column: $table.size, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPlayedTime => $composableBuilder(
      column: $table.lastPlayedTime, builder: (column) => column);

  GeneratedColumn<DateTime> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => column);

  GeneratedColumn<int> get trackNumber => $composableBuilder(
      column: $table.trackNumber, builder: (column) => column);

  GeneratedColumn<int> get playedCount => $composableBuilder(
      column: $table.playedCount, builder: (column) => column);

  GeneratedColumn<int> get likeCount =>
      $composableBuilder(column: $table.likeCount, builder: (column) => column);

  GeneratedColumn<int> get addStatus =>
      $composableBuilder(column: $table.addStatus, builder: (column) => column);

  GeneratedColumn<bool> get isLiked =>
      $composableBuilder(column: $table.isLiked, builder: (column) => column);

  GeneratedColumn<bool> get isDownloaded => $composableBuilder(
      column: $table.isDownloaded, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SongsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SongsTable,
    Song,
    $$SongsTableFilterComposer,
    $$SongsTableOrderingComposer,
    $$SongsTableAnnotationComposer,
    $$SongsTableCreateCompanionBuilder,
    $$SongsTableUpdateCompanionBuilder,
    (Song, BaseReferences<_$AppDatabase, $SongsTable, Song>),
    Song,
    PrefetchHooks Function()> {
  $$SongsTableTableManager(_$AppDatabase db, $SongsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> parentUuid = const Value.absent(),
            Value<String?> avid = const Value.absent(),
            Value<String?> bvid = const Value.absent(),
            Value<String?> cid = const Value.absent(),
            Value<String?> musicId = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> lyrics = const Value.absent(),
            Value<String?> album = const Value.absent(),
            Value<String?> albumArtPath = const Value.absent(),
            Value<String?> artist = const Value.absent(),
            Value<String?> upAvatar = const Value.absent(),
            Value<String?> upName = const Value.absent(),
            Value<String?> upId = const Value.absent(),
            Value<String?> artistId = const Value.absent(),
            Value<String?> artistAvatar = const Value.absent(),
            Value<String?> genre = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<String?> cover = const Value.absent(),
            Value<String?> fileUrl = const Value.absent(),
            Value<String?> downloadUrl = const Value.absent(),
            Value<int?> duration = const Value.absent(),
            Value<int?> size = const Value.absent(),
            Value<DateTime> lastPlayedTime = const Value.absent(),
            Value<DateTime?> releaseDate = const Value.absent(),
            Value<int?> trackNumber = const Value.absent(),
            Value<int> playedCount = const Value.absent(),
            Value<int> likeCount = const Value.absent(),
            Value<int?> addStatus = const Value.absent(),
            Value<bool> isLiked = const Value.absent(),
            Value<bool> isDownloaded = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SongsCompanion(
            id: id,
            uuid: uuid,
            parentUuid: parentUuid,
            avid: avid,
            bvid: bvid,
            cid: cid,
            musicId: musicId,
            sessionId: sessionId,
            title: title,
            lyrics: lyrics,
            album: album,
            albumArtPath: albumArtPath,
            artist: artist,
            upAvatar: upAvatar,
            upName: upName,
            upId: upId,
            artistId: artistId,
            artistAvatar: artistAvatar,
            genre: genre,
            language: language,
            cover: cover,
            fileUrl: fileUrl,
            downloadUrl: downloadUrl,
            duration: duration,
            size: size,
            lastPlayedTime: lastPlayedTime,
            releaseDate: releaseDate,
            trackNumber: trackNumber,
            playedCount: playedCount,
            likeCount: likeCount,
            addStatus: addStatus,
            isLiked: isLiked,
            isDownloaded: isDownloaded,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            required String parentUuid,
            Value<String?> avid = const Value.absent(),
            Value<String?> bvid = const Value.absent(),
            Value<String?> cid = const Value.absent(),
            Value<String?> musicId = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
            required String title,
            Value<String?> lyrics = const Value.absent(),
            Value<String?> album = const Value.absent(),
            Value<String?> albumArtPath = const Value.absent(),
            Value<String?> artist = const Value.absent(),
            Value<String?> upAvatar = const Value.absent(),
            Value<String?> upName = const Value.absent(),
            Value<String?> upId = const Value.absent(),
            Value<String?> artistId = const Value.absent(),
            Value<String?> artistAvatar = const Value.absent(),
            Value<String?> genre = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<String?> cover = const Value.absent(),
            Value<String?> fileUrl = const Value.absent(),
            Value<String?> downloadUrl = const Value.absent(),
            Value<int?> duration = const Value.absent(),
            Value<int?> size = const Value.absent(),
            Value<DateTime> lastPlayedTime = const Value.absent(),
            Value<DateTime?> releaseDate = const Value.absent(),
            Value<int?> trackNumber = const Value.absent(),
            Value<int> playedCount = const Value.absent(),
            Value<int> likeCount = const Value.absent(),
            Value<int?> addStatus = const Value.absent(),
            Value<bool> isLiked = const Value.absent(),
            Value<bool> isDownloaded = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SongsCompanion.insert(
            id: id,
            uuid: uuid,
            parentUuid: parentUuid,
            avid: avid,
            bvid: bvid,
            cid: cid,
            musicId: musicId,
            sessionId: sessionId,
            title: title,
            lyrics: lyrics,
            album: album,
            albumArtPath: albumArtPath,
            artist: artist,
            upAvatar: upAvatar,
            upName: upName,
            upId: upId,
            artistId: artistId,
            artistAvatar: artistAvatar,
            genre: genre,
            language: language,
            cover: cover,
            fileUrl: fileUrl,
            downloadUrl: downloadUrl,
            duration: duration,
            size: size,
            lastPlayedTime: lastPlayedTime,
            releaseDate: releaseDate,
            trackNumber: trackNumber,
            playedCount: playedCount,
            likeCount: likeCount,
            addStatus: addStatus,
            isLiked: isLiked,
            isDownloaded: isDownloaded,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SongsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SongsTable,
    Song,
    $$SongsTableFilterComposer,
    $$SongsTableOrderingComposer,
    $$SongsTableAnnotationComposer,
    $$SongsTableCreateCompanionBuilder,
    $$SongsTableUpdateCompanionBuilder,
    (Song, BaseReferences<_$AppDatabase, $SongsTable, Song>),
    Song,
    PrefetchHooks Function()>;
typedef $$ArtlistsTableCreateCompanionBuilder = ArtlistsCompanion Function({
  Value<int> id,
  required String uuid,
  Value<String?> artist,
  Value<String?> desc,
  Value<String?> artistAvatar,
  Value<String?> alias,
  Value<int?> like,
  Value<int?> follow,
  Value<int?> fans,
  Value<int?> playCount,
  Value<String?> musicId,
  Value<String?> sessionId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$ArtlistsTableUpdateCompanionBuilder = ArtlistsCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String?> artist,
  Value<String?> desc,
  Value<String?> artistAvatar,
  Value<String?> alias,
  Value<int?> like,
  Value<int?> follow,
  Value<int?> fans,
  Value<int?> playCount,
  Value<String?> musicId,
  Value<String?> sessionId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$ArtlistsTableFilterComposer
    extends Composer<_$AppDatabase, $ArtlistsTable> {
  $$ArtlistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get desc => $composableBuilder(
      column: $table.desc, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artistAvatar => $composableBuilder(
      column: $table.artistAvatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get like => $composableBuilder(
      column: $table.like, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get follow => $composableBuilder(
      column: $table.follow, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fans => $composableBuilder(
      column: $table.fans, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get playCount => $composableBuilder(
      column: $table.playCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get musicId => $composableBuilder(
      column: $table.musicId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$ArtlistsTableOrderingComposer
    extends Composer<_$AppDatabase, $ArtlistsTable> {
  $$ArtlistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get desc => $composableBuilder(
      column: $table.desc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artistAvatar => $composableBuilder(
      column: $table.artistAvatar,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get alias => $composableBuilder(
      column: $table.alias, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get like => $composableBuilder(
      column: $table.like, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get follow => $composableBuilder(
      column: $table.follow, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fans => $composableBuilder(
      column: $table.fans, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get playCount => $composableBuilder(
      column: $table.playCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get musicId => $composableBuilder(
      column: $table.musicId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$ArtlistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArtlistsTable> {
  $$ArtlistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get desc =>
      $composableBuilder(column: $table.desc, builder: (column) => column);

  GeneratedColumn<String> get artistAvatar => $composableBuilder(
      column: $table.artistAvatar, builder: (column) => column);

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<int> get like =>
      $composableBuilder(column: $table.like, builder: (column) => column);

  GeneratedColumn<int> get follow =>
      $composableBuilder(column: $table.follow, builder: (column) => column);

  GeneratedColumn<int> get fans =>
      $composableBuilder(column: $table.fans, builder: (column) => column);

  GeneratedColumn<int> get playCount =>
      $composableBuilder(column: $table.playCount, builder: (column) => column);

  GeneratedColumn<String> get musicId =>
      $composableBuilder(column: $table.musicId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ArtlistsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ArtlistsTable,
    Artlist,
    $$ArtlistsTableFilterComposer,
    $$ArtlistsTableOrderingComposer,
    $$ArtlistsTableAnnotationComposer,
    $$ArtlistsTableCreateCompanionBuilder,
    $$ArtlistsTableUpdateCompanionBuilder,
    (Artlist, BaseReferences<_$AppDatabase, $ArtlistsTable, Artlist>),
    Artlist,
    PrefetchHooks Function()> {
  $$ArtlistsTableTableManager(_$AppDatabase db, $ArtlistsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArtlistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArtlistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArtlistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String?> artist = const Value.absent(),
            Value<String?> desc = const Value.absent(),
            Value<String?> artistAvatar = const Value.absent(),
            Value<String?> alias = const Value.absent(),
            Value<int?> like = const Value.absent(),
            Value<int?> follow = const Value.absent(),
            Value<int?> fans = const Value.absent(),
            Value<int?> playCount = const Value.absent(),
            Value<String?> musicId = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ArtlistsCompanion(
            id: id,
            uuid: uuid,
            artist: artist,
            desc: desc,
            artistAvatar: artistAvatar,
            alias: alias,
            like: like,
            follow: follow,
            fans: fans,
            playCount: playCount,
            musicId: musicId,
            sessionId: sessionId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            Value<String?> artist = const Value.absent(),
            Value<String?> desc = const Value.absent(),
            Value<String?> artistAvatar = const Value.absent(),
            Value<String?> alias = const Value.absent(),
            Value<int?> like = const Value.absent(),
            Value<int?> follow = const Value.absent(),
            Value<int?> fans = const Value.absent(),
            Value<int?> playCount = const Value.absent(),
            Value<String?> musicId = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              ArtlistsCompanion.insert(
            id: id,
            uuid: uuid,
            artist: artist,
            desc: desc,
            artistAvatar: artistAvatar,
            alias: alias,
            like: like,
            follow: follow,
            fans: fans,
            playCount: playCount,
            musicId: musicId,
            sessionId: sessionId,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ArtlistsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ArtlistsTable,
    Artlist,
    $$ArtlistsTableFilterComposer,
    $$ArtlistsTableOrderingComposer,
    $$ArtlistsTableAnnotationComposer,
    $$ArtlistsTableCreateCompanionBuilder,
    $$ArtlistsTableUpdateCompanionBuilder,
    (Artlist, BaseReferences<_$AppDatabase, $ArtlistsTable, Artlist>),
    Artlist,
    PrefetchHooks Function()>;
typedef $$AlbumsTableCreateCompanionBuilder = AlbumsCompanion Function({
  Value<int> id,
  required String uuid,
  Value<String?> avid,
  Value<String?> bvid,
  Value<String?> cid,
  Value<String?> musicId,
  Value<String?> sessionId,
  required String title,
  Value<String?> artist,
  Value<String?> artistId,
  Value<String?> artistAvatar,
  Value<String?> upAvatar,
  Value<String?> upName,
  Value<String?> upId,
  Value<String?> genre,
  Value<String?> language,
  Value<String?> cover,
  Value<String?> fileUrl,
  Value<String?> downloadUrl,
  Value<String?> albumArtPath,
  Value<String?> duration,
  Value<DateTime> lastPlayedTime,
  Value<DateTime?> releaseDate,
  Value<int> playedCount,
  Value<int?> addStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$AlbumsTableUpdateCompanionBuilder = AlbumsCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String?> avid,
  Value<String?> bvid,
  Value<String?> cid,
  Value<String?> musicId,
  Value<String?> sessionId,
  Value<String> title,
  Value<String?> artist,
  Value<String?> artistId,
  Value<String?> artistAvatar,
  Value<String?> upAvatar,
  Value<String?> upName,
  Value<String?> upId,
  Value<String?> genre,
  Value<String?> language,
  Value<String?> cover,
  Value<String?> fileUrl,
  Value<String?> downloadUrl,
  Value<String?> albumArtPath,
  Value<String?> duration,
  Value<DateTime> lastPlayedTime,
  Value<DateTime?> releaseDate,
  Value<int> playedCount,
  Value<int?> addStatus,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$AlbumsTableFilterComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avid => $composableBuilder(
      column: $table.avid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bvid => $composableBuilder(
      column: $table.bvid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cid => $composableBuilder(
      column: $table.cid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get musicId => $composableBuilder(
      column: $table.musicId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artistId => $composableBuilder(
      column: $table.artistId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get artistAvatar => $composableBuilder(
      column: $table.artistAvatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get upAvatar => $composableBuilder(
      column: $table.upAvatar, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get upName => $composableBuilder(
      column: $table.upName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get upId => $composableBuilder(
      column: $table.upId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get genre => $composableBuilder(
      column: $table.genre, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileUrl => $composableBuilder(
      column: $table.fileUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get downloadUrl => $composableBuilder(
      column: $table.downloadUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get albumArtPath => $composableBuilder(
      column: $table.albumArtPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastPlayedTime => $composableBuilder(
      column: $table.lastPlayedTime,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get playedCount => $composableBuilder(
      column: $table.playedCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get addStatus => $composableBuilder(
      column: $table.addStatus, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AlbumsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avid => $composableBuilder(
      column: $table.avid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bvid => $composableBuilder(
      column: $table.bvid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cid => $composableBuilder(
      column: $table.cid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get musicId => $composableBuilder(
      column: $table.musicId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sessionId => $composableBuilder(
      column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artist => $composableBuilder(
      column: $table.artist, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artistId => $composableBuilder(
      column: $table.artistId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get artistAvatar => $composableBuilder(
      column: $table.artistAvatar,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get upAvatar => $composableBuilder(
      column: $table.upAvatar, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get upName => $composableBuilder(
      column: $table.upName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get upId => $composableBuilder(
      column: $table.upId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get genre => $composableBuilder(
      column: $table.genre, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get language => $composableBuilder(
      column: $table.language, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileUrl => $composableBuilder(
      column: $table.fileUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get downloadUrl => $composableBuilder(
      column: $table.downloadUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get albumArtPath => $composableBuilder(
      column: $table.albumArtPath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastPlayedTime => $composableBuilder(
      column: $table.lastPlayedTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get playedCount => $composableBuilder(
      column: $table.playedCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get addStatus => $composableBuilder(
      column: $table.addStatus, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AlbumsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlbumsTable> {
  $$AlbumsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get avid =>
      $composableBuilder(column: $table.avid, builder: (column) => column);

  GeneratedColumn<String> get bvid =>
      $composableBuilder(column: $table.bvid, builder: (column) => column);

  GeneratedColumn<String> get cid =>
      $composableBuilder(column: $table.cid, builder: (column) => column);

  GeneratedColumn<String> get musicId =>
      $composableBuilder(column: $table.musicId, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<String> get artistId =>
      $composableBuilder(column: $table.artistId, builder: (column) => column);

  GeneratedColumn<String> get artistAvatar => $composableBuilder(
      column: $table.artistAvatar, builder: (column) => column);

  GeneratedColumn<String> get upAvatar =>
      $composableBuilder(column: $table.upAvatar, builder: (column) => column);

  GeneratedColumn<String> get upName =>
      $composableBuilder(column: $table.upName, builder: (column) => column);

  GeneratedColumn<String> get upId =>
      $composableBuilder(column: $table.upId, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get cover =>
      $composableBuilder(column: $table.cover, builder: (column) => column);

  GeneratedColumn<String> get fileUrl =>
      $composableBuilder(column: $table.fileUrl, builder: (column) => column);

  GeneratedColumn<String> get downloadUrl => $composableBuilder(
      column: $table.downloadUrl, builder: (column) => column);

  GeneratedColumn<String> get albumArtPath => $composableBuilder(
      column: $table.albumArtPath, builder: (column) => column);

  GeneratedColumn<String> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<DateTime> get lastPlayedTime => $composableBuilder(
      column: $table.lastPlayedTime, builder: (column) => column);

  GeneratedColumn<DateTime> get releaseDate => $composableBuilder(
      column: $table.releaseDate, builder: (column) => column);

  GeneratedColumn<int> get playedCount => $composableBuilder(
      column: $table.playedCount, builder: (column) => column);

  GeneratedColumn<int> get addStatus =>
      $composableBuilder(column: $table.addStatus, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AlbumsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlbumsTable,
    Album,
    $$AlbumsTableFilterComposer,
    $$AlbumsTableOrderingComposer,
    $$AlbumsTableAnnotationComposer,
    $$AlbumsTableCreateCompanionBuilder,
    $$AlbumsTableUpdateCompanionBuilder,
    (Album, BaseReferences<_$AppDatabase, $AlbumsTable, Album>),
    Album,
    PrefetchHooks Function()> {
  $$AlbumsTableTableManager(_$AppDatabase db, $AlbumsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlbumsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlbumsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlbumsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String?> avid = const Value.absent(),
            Value<String?> bvid = const Value.absent(),
            Value<String?> cid = const Value.absent(),
            Value<String?> musicId = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> artist = const Value.absent(),
            Value<String?> artistId = const Value.absent(),
            Value<String?> artistAvatar = const Value.absent(),
            Value<String?> upAvatar = const Value.absent(),
            Value<String?> upName = const Value.absent(),
            Value<String?> upId = const Value.absent(),
            Value<String?> genre = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<String?> cover = const Value.absent(),
            Value<String?> fileUrl = const Value.absent(),
            Value<String?> downloadUrl = const Value.absent(),
            Value<String?> albumArtPath = const Value.absent(),
            Value<String?> duration = const Value.absent(),
            Value<DateTime> lastPlayedTime = const Value.absent(),
            Value<DateTime?> releaseDate = const Value.absent(),
            Value<int> playedCount = const Value.absent(),
            Value<int?> addStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AlbumsCompanion(
            id: id,
            uuid: uuid,
            avid: avid,
            bvid: bvid,
            cid: cid,
            musicId: musicId,
            sessionId: sessionId,
            title: title,
            artist: artist,
            artistId: artistId,
            artistAvatar: artistAvatar,
            upAvatar: upAvatar,
            upName: upName,
            upId: upId,
            genre: genre,
            language: language,
            cover: cover,
            fileUrl: fileUrl,
            downloadUrl: downloadUrl,
            albumArtPath: albumArtPath,
            duration: duration,
            lastPlayedTime: lastPlayedTime,
            releaseDate: releaseDate,
            playedCount: playedCount,
            addStatus: addStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String uuid,
            Value<String?> avid = const Value.absent(),
            Value<String?> bvid = const Value.absent(),
            Value<String?> cid = const Value.absent(),
            Value<String?> musicId = const Value.absent(),
            Value<String?> sessionId = const Value.absent(),
            required String title,
            Value<String?> artist = const Value.absent(),
            Value<String?> artistId = const Value.absent(),
            Value<String?> artistAvatar = const Value.absent(),
            Value<String?> upAvatar = const Value.absent(),
            Value<String?> upName = const Value.absent(),
            Value<String?> upId = const Value.absent(),
            Value<String?> genre = const Value.absent(),
            Value<String?> language = const Value.absent(),
            Value<String?> cover = const Value.absent(),
            Value<String?> fileUrl = const Value.absent(),
            Value<String?> downloadUrl = const Value.absent(),
            Value<String?> albumArtPath = const Value.absent(),
            Value<String?> duration = const Value.absent(),
            Value<DateTime> lastPlayedTime = const Value.absent(),
            Value<DateTime?> releaseDate = const Value.absent(),
            Value<int> playedCount = const Value.absent(),
            Value<int?> addStatus = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              AlbumsCompanion.insert(
            id: id,
            uuid: uuid,
            avid: avid,
            bvid: bvid,
            cid: cid,
            musicId: musicId,
            sessionId: sessionId,
            title: title,
            artist: artist,
            artistId: artistId,
            artistAvatar: artistAvatar,
            upAvatar: upAvatar,
            upName: upName,
            upId: upId,
            genre: genre,
            language: language,
            cover: cover,
            fileUrl: fileUrl,
            downloadUrl: downloadUrl,
            albumArtPath: albumArtPath,
            duration: duration,
            lastPlayedTime: lastPlayedTime,
            releaseDate: releaseDate,
            playedCount: playedCount,
            addStatus: addStatus,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AlbumsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlbumsTable,
    Album,
    $$AlbumsTableFilterComposer,
    $$AlbumsTableOrderingComposer,
    $$AlbumsTableAnnotationComposer,
    $$AlbumsTableCreateCompanionBuilder,
    $$AlbumsTableUpdateCompanionBuilder,
    (Album, BaseReferences<_$AppDatabase, $AlbumsTable, Album>),
    Album,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SongsTableTableManager get songs =>
      $$SongsTableTableManager(_db, _db.songs);
  $$ArtlistsTableTableManager get artlists =>
      $$ArtlistsTableTableManager(_db, _db.artlists);
  $$AlbumsTableTableManager get albums =>
      $$AlbumsTableTableManager(_db, _db.albums);
}
