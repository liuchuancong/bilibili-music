import 'package:drift/drift.dart';
import 'package:bilibilimusic/database/models/songs.dart';
import 'package:bilibilimusic/database/models/albums.dart';
import 'package:bilibilimusic/database/daos/song_dao.dart';
import 'package:bilibilimusic/database/daos/album_dao.dart';
import 'package:bilibilimusic/database/models/artlists.dart';
import 'package:bilibilimusic/database/daos/artlist_dao.dart';
import 'package:bilibilimusic/database/database_manager.dart';

part 'db.g.dart';

@DriftDatabase(tables: [Songs, Artlists, Albums], daos: [AlbumDao, SongDao, ArtlistDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}
