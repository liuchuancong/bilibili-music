import 'package:drift/drift.dart';
import 'package:bilibilimusic/database/db.dart';
import 'package:bilibilimusic/database/models/albums.dart';

part 'album_dao.g.dart';

@DriftAccessor(tables: [Albums])
class AlbumDao extends DatabaseAccessor<AppDatabase> with _$AlbumDaoMixin {
  final AppDatabase db;

  // 构造函数
  AlbumDao(this.db) : super(db);

  // 获取所有专辑
  Future<List<Album>> getAllAlbums() => select(albums).get();

  // 监听所有专辑变化（用于实时更新UI）
  Stream<List<Album>> watchAllAlbums() => select(albums).watch();

  // 根据ID获取专辑
  Future<Album?> getAlbumById(int id) {
    return (select(albums)..where((a) => a.id.equals(id))).getSingleOrNull();
  }

  // 根据UUID获取专辑
  Future<Album?> getAlbumByUuid(String uuid) {
    return (select(albums)..where((a) => a.uuid.equals(uuid))).getSingleOrNull();
  }

  // 添加新专辑 - 使用正确的Companion类
  Future<int> insertAlbum(AlbumsCompanion albumCompanion) => into(albums).insert(albumCompanion);

  // 批量插入多张专辑（避免重复插入）
  Future<void> insertAllAlbums(List<AlbumsCompanion> albumCompanions) async {
    final uuids = albumCompanions.where((c) => c.uuid.present).map((c) => c.uuid.value).toList();

    await batch((b) {
      b.deleteWhere(albums, (a) => a.uuid.isIn(uuids));
      b.insertAll(albums, albumCompanions);
    });
  }

  // 更新专辑信息（整行替换）
  Future<bool> updateAlbum(Album albumData) => update(albums).replace(albumData);

  // 根据ID删除专辑
  Future<int> deleteAlbumById(int id) {
    return (delete(albums)..where((a) => a.id.equals(id))).go();
  }

  // 根据UUID删除专辑
  Future<int> deleteAlbumByUuid(String uuid) {
    return (delete(albums)..where((a) => a.uuid.equals(uuid))).go();
  }

  // 删除所有专辑（谨慎使用，通常用于重置或清除缓存）
  Future<int> deleteAllAlbums() => delete(albums).go();

  // 记录播放历史：更新最后播放时间和播放次数
  Future<int> recordPlayHistory(String uuid) async {
    final album = await getAlbumByUuid(uuid);
    if (album == null) return 0;
    return (update(albums)..where((a) => a.uuid.equals(uuid))).write(AlbumsCompanion(
      lastPlayedTime: Value(DateTime.now()),
      playedCount: Value(album.playedCount + 1),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // 搜索专辑（按标题、艺术家、UP主昵称模糊匹配，忽略大小写）
  Future<List<Album>> searchAlbums(String keyword) {
    if (keyword.trim().isEmpty) return getAllAlbums();
    final term = '%${keyword.toLowerCase()}%';
    return (select(albums)
          ..where((a) =>
              a.title.lower().like(term) |
              (a.artist.isNotNull() & a.artist.lower().like(term)) |
              (a.upName.isNotNull() & a.upName.lower().like(term))))
        .get();
  }

  // 获取最近播放的专辑（按最后播放时间倒序）
  Future<List<Album>> getRecentPlayedAlbums({int limit = 20}) {
    return (select(albums)
          ..where((a) => a.lastPlayedTime.isNotNull())
          ..orderBy([(a) => OrderingTerm(expression: a.lastPlayedTime, mode: OrderingMode.desc)])
          ..limit(limit))
        .get();
  }

  // 监听最近播放列表的变化
  Stream<List<Album>> watchRecentPlayedAlbums({int limit = 20}) {
    return (select(albums)
          ..where((a) => a.lastPlayedTime.isNotNull())
          ..orderBy([(a) => OrderingTerm(expression: a.lastPlayedTime, mode: OrderingMode.desc)])
          ..limit(limit))
        .watch();
  }

  // 分页获取专辑列表（用于长列表懒加载）
  Future<List<Album>> getPaginatedAlbums({
    required int offset,
    required int limit,
    String orderByField = 'createdAt',
    bool ascending = false,
  }) async {
    final query = select(albums)..limit(limit, offset: offset);

    // 动态排序字段映射 - 使用coalesce顶级函数处理可空字段
    final columnMap = <String, Expression<Object>>{
      'id': albums.id,
      'title': albums.title,
      'artist': coalesce([albums.artist, const Constant('')]),
      'upName': coalesce([albums.upName, const Constant('')]),
      'playedCount': albums.playedCount,
      'lastPlayedTime': albums.lastPlayedTime,
      'createdAt': albums.createdAt,
      'updatedAt': albums.updatedAt,
      'releaseDate': coalesce([albums.releaseDate, Constant(DateTime.fromMicrosecondsSinceEpoch(0))]),
    };

    if (columnMap.containsKey(orderByField)) {
      final column = columnMap[orderByField]!;
      final orderMode = ascending ? OrderingMode.asc : OrderingMode.desc;
      query.orderBy([(t) => OrderingTerm(expression: column, mode: orderMode)]);
    } else {
      query.orderBy([(a) => OrderingTerm(expression: a.createdAt, mode: OrderingMode.desc)]);
    }

    return await query.get();
  }

  // 获取专辑总数（用于统计或显示总数）
  Future<int> getTotalAlbumsCount() async {
    final result = await (selectOnly(albums)..addColumns([countAll()])).getSingle();
    return result.read(countAll()) ?? 0;
  }

  // 根据UP主ID获取专辑（适用于B站场景）
  Future<List<Album>> getAlbumsByUploaderId(String upId) async {
    return (select(albums)..where((a) => a.upId.equals(upId))).get();
  }
}
