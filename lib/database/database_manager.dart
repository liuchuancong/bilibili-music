import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:bilibilimusic/database/db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bilibilimusic/utils/core_log.dart';

class DatabaseManager {
  AppDatabase appDatabase = AppDatabase();
  static const databaseVersion = 1;
  DatabaseManager._();

  static final DatabaseManager _instance = DatabaseManager._();

  static DatabaseManager get instance {
    return _instance;
  }
}

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/app.db');
    if (!file.existsSync()) {
      await file.create(recursive: true);
    }
    CoreLog.i('Opening db $file');
    return NativeDatabase(file);
  });
}
