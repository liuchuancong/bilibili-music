import 'package:drift/drift.dart';
import 'package:bilibilimusic/database/db.dart';
import 'package:bilibilimusic/database/models/songs.dart';

part 'song_dao.g.dart';

@DriftAccessor(tables: [Songs])
class SongDao extends DatabaseAccessor<AppDatabase> with _$SongDaoMixin {
  final AppDatabase db;

  // 构造函数
  SongDao(this.db) : super(db);

  // 获取所有歌曲
  Future<List<Song>> getAllSongs() => select(songs).get();

  // 监听所有歌曲变化（用于实时更新UI）
  Stream<List<Song>> watchAllSongs() => select(songs).watch();

  // 根据ID获取歌曲
  Future<Song?> getSongById(int id) {
    return (select(songs)..where((s) => s.id.equals(id))).getSingleOrNull();
  }

  // 根据UUID获取歌曲
  Future<Song?> getSongByUuid(String uuid) {
    return (select(songs)..where((s) => s.uuid.equals(uuid))).getSingleOrNull();
  }

  // 根据父级UUID获取歌曲（例如：歌单ID、专辑ID）
  Future<List<Song>> getSongsByParentUuid(String parentUuid) {
    return (select(songs)..where((s) => s.parentUuid.equals(parentUuid))).get();
  }

  // 添加新歌曲 - 使用正确的Companion类
  Future<int> insertSong(SongsCompanion songCompanion) => into(songs).insert(songCompanion);

  // 批量插入多首歌曲（避免重复插入）
  Future<void> insertAllSongs(List<SongsCompanion> songCompanions) async {
    final uuids = songCompanions.where((c) => c.uuid.present).map((c) => c.uuid.value).toList();

    await batch((b) {
      b.deleteWhere(songs, (s) => s.uuid.isIn(uuids));
      b.insertAll(songs, songCompanions);
    });
  }

  // 更新歌曲信息（整行替换）
  Future<bool> updateSong(Song songData) => update(songs).replace(songData);

  // 根据ID删除歌曲
  Future<int> deleteSongById(int id) {
    return (delete(songs)..where((s) => s.id.equals(id))).go();
  }

  // 根据UUID删除歌曲
  Future<int> deleteSongByUuid(String uuid) {
    return (delete(songs)..where((s) => s.uuid.equals(uuid))).go();
  }

  // 删除所有歌曲（谨慎使用，通常用于重置或清除缓存）
  Future<int> deleteAllSongs() => delete(songs).go();

  // 获取喜欢的歌曲
  Future<List<Song>> getLikedSongs() {
    return (select(songs)
          ..where((s) => s.isLiked.equals(true))
          ..orderBy([(s) => OrderingTerm(expression: s.lastPlayedTime, mode: OrderingMode.desc)]))
        .get();
  }

  // 监听喜欢的歌曲变化（用于“我喜欢”页面实时刷新）
  Stream<List<Song>> watchLikedSongs() {
    return (select(songs)..where((s) => s.isLiked.equals(true))).watch();
  }

  // 获取已下载的歌曲
  Future<List<Song>> getDownloadedSongs() {
    return (select(songs)
          ..where((s) => s.isDownloaded.equals(true))
          ..orderBy([(s) => OrderingTerm(expression: s.lastPlayedTime, mode: OrderingMode.desc)]))
        .get();
  }

  // 监听已下载歌曲的变化（用于“本地音乐”页面）
  Stream<List<Song>> watchDownloadedSongs() {
    return (select(songs)..where((s) => s.isDownloaded.equals(true))).watch();
  }

  // 更新歌曲的喜欢状态
  Future<int> updateLikeStatus(int id, bool isLiked) {
    return (update(songs)..where((s) => s.id.equals(id))).write(SongsCompanion(
      isLiked: Value(isLiked),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // 更新歌曲的下载状态及本地文件路径
  Future<int> updateDownloadStatus(String uuid, bool isDownloaded, {String? fileUrl}) {
    return (update(songs)..where((s) => s.uuid.equals(uuid))).write(SongsCompanion(
      isDownloaded: Value(isDownloaded),
      fileUrl: fileUrl != null ? Value(fileUrl) : const Value.absent(),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // 记录播放历史：更新最后播放时间和播放次数
  Future<int> recordPlayHistory(String uuid) async {
    final song = await getSongByUuid(uuid);
    if (song == null) return 0;
    return (update(songs)..where((s) => s.uuid.equals(uuid))).write(SongsCompanion(
      lastPlayedTime: Value(DateTime.now()),
      playedCount: Value(song.playedCount + 1),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // 搜索歌曲（按标题、艺术家或专辑模糊匹配，忽略大小写）
  Future<List<Song>> searchSongs(String keyword) {
    if (keyword.trim().isEmpty) return getAllSongs();
    final term = '%${keyword.toLowerCase()}%';
    return (select(songs)
          ..where((s) =>
              s.title.lower().like(term) |
              s.artist.lower().like(term) |
              s.album.lower().like(term) |
              s.upName.lower().like(term)))
        .get();
  }

  Future<List<Song>> smartSearch(
    String? keyword, {
    String? orderField,
    String? orderDirection,
    bool? isLiked,
    bool? isLastPlayed,
  }) async {
    final query = select(songs);
    if (keyword != null && keyword.trim().isNotEmpty) {
      final lowerKeyword = keyword.toLowerCase();

      query.where(
        (song) =>
            song.title.lower().like('%$lowerKeyword%') |
            song.artist.lower().like('%$lowerKeyword%') |
            song.album.lower().like('%$lowerKeyword%'),
      );

      // 优先级排序的条件
      if (isLastPlayed == null) {
        query.orderBy([
          (song) => OrderingTerm(
                expression: CaseWhenExpression(
                  cases: [
                    CaseWhen(
                      song.title.lower().equals(lowerKeyword),
                      then: const Constant(0),
                    ),
                    CaseWhen(
                      song.artist.lower().equals(lowerKeyword),
                      then: const Constant(1),
                    ),
                    CaseWhen(
                      song.album.lower().equals(lowerKeyword),
                      then: const Constant(2),
                    ),
                    CaseWhen(
                      song.title.lower().like('$lowerKeyword%'),
                      then: const Constant(3),
                    ),
                    CaseWhen(
                      song.artist.lower().like('$lowerKeyword%'),
                      then: const Constant(4),
                    ),
                    CaseWhen(
                      song.album.lower().like('$lowerKeyword%'),
                      then: const Constant(5),
                    ),
                  ],
                  orElse: const Constant(6),
                ),
              ),
        ]);
      }
    }
    if (isLiked != null) {
      query.where((song) => song.isLiked.equals(isLiked));
    }
    if (isLastPlayed == true) {
      query.where((song) => song.playedCount.isBiggerThanValue(0));
      query.orderBy([(song) => OrderingTerm.desc(song.lastPlayedTime)]);
      query.limit(100);
      return await query.get();
    }

    // 无论有没有关键字，都执行排序逻辑
    query.orderBy([
      (song) {
        if (orderField == null || orderDirection == null) {
          return OrderingTerm.desc(song.id);
        }
        final Expression orderExpr;
        switch (orderField) {
          case 'id':
            orderExpr = song.duration;
            break;
          case 'title':
            orderExpr = song.title;
            break;
          case 'artist':
            orderExpr = song.artist;
            break;
          case 'album':
            orderExpr = song.album;
            break;
          case 'duration':
            orderExpr = song.duration;
            break;
          default:
            orderExpr = song.id;
        }
        return orderDirection.toLowerCase() == 'desc' ? OrderingTerm.desc(orderExpr) : OrderingTerm.asc(orderExpr);
      },
    ]);

    return await query.get();
  }

  // 获取最近播放的歌曲（按最后播放时间倒序）
  Future<List<Song>> getRecentPlayedSongs({int limit = 20}) {
    return (select(songs)
          ..where((s) => s.lastPlayedTime.isNotNull())
          ..orderBy([(s) => OrderingTerm(expression: s.lastPlayedTime, mode: OrderingMode.desc)])
          ..limit(limit))
        .get();
  }

  // 监听最近播放列表的变化
  Stream<List<Song>> watchRecentPlayedSongs({int limit = 20}) {
    return (select(songs)
          ..where((s) => s.lastPlayedTime.isNotNull())
          ..orderBy([(s) => OrderingTerm(expression: s.lastPlayedTime, mode: OrderingMode.desc)])
          ..limit(limit))
        .watch();
  }

  // 分页获取歌曲列表（用于长列表懒加载）
  Future<List<Song>> getPaginatedSongs({
    required int offset,
    required int limit,
    String orderByField = 'createdAt',
    bool ascending = false,
  }) async {
    final query = select(songs)..limit(limit, offset: offset);

    // 动态排序字段映射 - 使用coalesce顶级函数处理可空字段
    final columnMap = <String, Expression<Object>>{
      'id': songs.id,
      'title': songs.title,
      'artist': coalesce([songs.artist, const Constant('')]), // 处理可空字符串
      'album': coalesce([songs.album, const Constant('')]), // 处理可空字符串
      'duration': coalesce([songs.duration, const Constant(0)]), // 处理可空数字
      'playedCount': songs.playedCount,
      'lastPlayedTime': songs.lastPlayedTime,
      'createdAt': songs.createdAt,
      'updatedAt': songs.updatedAt,
      'releaseDate': coalesce([songs.releaseDate, Constant(DateTime.fromMicrosecondsSinceEpoch(0))]), // 处理可空日期
    };

    if (columnMap.containsKey(orderByField)) {
      final column = columnMap[orderByField]!;
      final orderMode = ascending ? OrderingMode.asc : OrderingMode.desc;
      query.orderBy([(t) => OrderingTerm(expression: column, mode: orderMode)]);
    } else {
      query.orderBy([(s) => OrderingTerm(expression: s.createdAt, mode: OrderingMode.desc)]);
    }

    return await query.get();
  }

  // 获取歌曲总数（用于统计或显示总数）
  Future<int> getTotalSongsCount() async {
    final result = await (selectOnly(songs)..addColumns([countAll()])).getSingle();
    return result.read(countAll()) ?? 0;
  }

  // 获取喜欢的歌曲数量
  Future<int> getLikedSongsCount() async {
    final result = await (selectOnly(songs)
          ..where(songs.isLiked.equals(true))
          ..addColumns([countAll()]))
        .getSingle();
    return result.read(countAll()) ?? 0;
  }

  // 获取已下载歌曲数量
  Future<int> getDownloadedSongsCount() async {
    final result = await (selectOnly(songs)
          ..where(songs.isLiked.equals(true))
          ..addColumns([countAll()]))
        .getSingle();
    return result.read(countAll()) ?? 0;
  }

  // 根据UP主ID获取歌曲（适用于B站场景）
  Future<List<Song>> getSongsByUploaderId(String upId) async {
    return (select(songs)..where((s) => s.upId.equals(upId))).get();
  }

  // 获取所有不同的父级UUID（用于构建歌单/专辑列表）
  Future<List<String>> getAllParentUuids() {
    return (select(songs, distinct: true)).map((song) => song.parentUuid).get();
  }

  // 清除所有未下载且未喜欢的临时歌曲（例如：缓存清理）
  Future<int> clearTemporarySongs() {
    return (delete(songs)..where((s) => s.isDownloaded.equals(false) & s.isLiked.equals(false))).go();
  }
}
