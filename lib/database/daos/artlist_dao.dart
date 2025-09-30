import 'package:drift/drift.dart';
import 'package:bilibilimusic/database/db.dart';
import 'package:bilibilimusic/database/models/artlists.dart';

part 'artlist_dao.g.dart';

@DriftAccessor(tables: [Artlists])
class ArtlistDao extends DatabaseAccessor<AppDatabase> with _$ArtlistDaoMixin {
  final AppDatabase db;

  // 构造函数
  ArtlistDao(this.db) : super(db);

  // 获取所有歌手列表
  Future<List<Artlist>> getAllArtlists() => select(artlists).get();

  // 监听所有歌手变化（用于实时更新UI）
  Stream<List<Artlist>> watchAllArtlists() => select(artlists).watch();

  // 根据ID获取歌手
  Future<Artlist?> getArtlistById(int id) {
    return (select(artlists)..where((a) => a.id.equals(id))).getSingleOrNull();
  }

  // 根据UUID获取歌手
  Future<Artlist?> getArtlistByUuid(String uuid) {
    return (select(artlists)..where((a) => a.uuid.equals(uuid))).getSingleOrNull();
  }

  // 添加新歌手 - 使用正确的Companion类
  Future<int> insertArtlist(ArtlistsCompanion artlistCompanion) => into(artlists).insert(artlistCompanion);

  // 批量插入多个歌手（避免重复插入）
  Future<void> insertAllArtlists(List<ArtlistsCompanion> artlistCompanions) async {
    final uuids = artlistCompanions.where((c) => c.uuid.present).map((c) => c.uuid.value).toList();

    await batch((b) {
      b.deleteWhere(artlists, (a) => a.uuid.isIn(uuids));
      b.insertAll(artlists, artlistCompanions);
    });
  }

  // 更新歌手信息（整行替换）
  Future<bool> updateArtlist(Artlist artlistData) => update(artlists).replace(artlistData);

  // 根据ID删除歌手
  Future<int> deleteArtlistById(int id) {
    return (delete(artlists)..where((a) => a.id.equals(id))).go();
  }

  // 根据UUID删除歌手
  Future<int> deleteArtlistByUuid(String uuid) {
    return (delete(artlists)..where((a) => a.uuid.equals(uuid))).go();
  }

  // 删除所有歌手（谨慎使用，通常用于重置或清除缓存）
  Future<int> deleteAllArtlists() => delete(artlists).go();

  // 搜索歌手（按艺术家名称或别名模糊匹配，忽略大小写）
  Future<List<Artlist>> searchArtlists(String keyword) {
    if (keyword.trim().isEmpty) return getAllArtlists();
    final term = '%${keyword.toLowerCase()}%';
    return (select(artlists)
          ..where((a) =>
              (a.artist.isNotNull() & a.artist.lower().like(term)) |
              (a.alias.isNotNull() & a.alias.lower().like(term))))
        .get();
  }

  // 分页获取歌手列表（用于长列表懒加载）
  Future<List<Artlist>> getPaginatedArtlists({
    required int offset,
    required int limit,
    String orderByField = 'createdAt',
    bool ascending = false,
  }) async {
    final query = select(artlists)..limit(limit, offset: offset);

    // 动态排序字段映射 - 使用coalesce处理可空字段
    final columnMap = <String, Expression<Object>>{
      'id': artlists.id,
      'artist': coalesce([artlists.artist, const Constant('')]),
      'alias': coalesce([artlists.alias, const Constant('')]),
      'like': coalesce([artlists.like, const Constant(0)]),
      'follow': coalesce([artlists.follow, const Constant(0)]),
      'fans': coalesce([artlists.fans, const Constant(0)]),
      'playCount': coalesce([artlists.playCount, const Constant(0)]),
      'createdAt': artlists.createdAt,
      'updatedAt': artlists.updatedAt,
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

  // 获取歌手总数（用于统计或显示总数）
  Future<int> getTotalArtlistsCount() async {
    final result = await (selectOnly(artlists)..addColumns([countAll()])).getSingle();
    return result.read(countAll()) ?? 0;
  }

  // 根据艺术家名称获取歌手（精确匹配）
  Future<List<Artlist>> getArtlistsByArtistName(String artistName) {
    return (select(artlists)..where((a) => a.artist.equals(artistName))).get();
  }

  // 获取所有不同的艺术家名称（去重）
  Future<List<String>> getAllArtistNames() async {
    final rows = await (selectOnly(artlists, distinct: true)
          ..addColumns([artlists.artist])
          ..where(artlists.artist.isNotNull()))
        .get();
    return rows.map((row) => row.read(artlists.artist)!).toList();
  }

  // 清除所有无关联数据的临时歌手（例如：无 artist 字段的脏数据）
  Future<int> clearInvalidArtlists() {
    return (delete(artlists)..where((t) => t.artist.isNull())).go();
  }
}
