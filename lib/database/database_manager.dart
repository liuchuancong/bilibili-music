import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:logger/logger.dart';
import 'package:bilibilimusic/database/db.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseManager {
  AppDatabase appDatabase = AppDatabase();
  static const databaseVersion = 2;
  DatabaseManager._();

  static final DatabaseManager _instance = DatabaseManager._();

  static DatabaseManager get instance {
    return _instance;
  }
}

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    // final settings = Get.find<SettingsService>();
    // final file = File('db.sqlite');
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('${dbFolder.path}/app.db');
    // 确保数据库文件所在的目录存在
    if (!file.existsSync()) {
      await file.create(recursive: true);
    }
    Logger().i('Opening db $file');
    return NativeDatabase(file);
  });
}
