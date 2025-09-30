import 'package:drift/drift.dart';

class Albums extends Table {
  IntColumn get id => integer().autoIncrement()(); // 主键ID
  TextColumn get uuid => text()(); // 全局唯一标识，跨设备唯一
  TextColumn get avid => text().nullable()(); // AV号
  TextColumn get bvid => text().nullable()(); // BV号
  TextColumn get cid => text().nullable()(); //  cid
  TextColumn get musicId => text().nullable()(); // 音乐ID
  TextColumn get sessionId => text().nullable()(); // 会话ID
  TextColumn get title => text()(); // 歌曲标题
  TextColumn get artist => text().nullable()(); // 艺术家
  TextColumn get artistId => text().nullable()(); // 艺术家ID
  TextColumn get artistAvatar => text().nullable()(); // 艺术家头像
  TextColumn get upAvatar => text().nullable()(); // 上传者头像
  TextColumn get upName => text().nullable()(); // 上传者昵称
  TextColumn get upId => text().nullable()(); // 上传者ID
  TextColumn get genre => text().nullable()(); // 风格
  TextColumn get language => text().nullable()(); // 语言
  TextColumn get cover => text().nullable()(); // 封面
  TextColumn get fileUrl => text().nullable()(); // 文件URL/ 文件路径
  TextColumn get downloadUrl => text().nullable()(); // 下载URL
  TextColumn get albumArtPath => text().nullable()(); // 专辑封面路径
  TextColumn get duration => text().nullable()(); // 歌曲时长
  DateTimeColumn get lastPlayedTime => dateTime().withDefault(currentDateAndTime)(); // 上次播放时间
  DateTimeColumn get releaseDate => dateTime().nullable()(); // 发行时间
  IntColumn get playedCount => integer().withDefault(const Constant(0))();
  IntColumn get addStatus => integer().nullable()(); // 添加的来源

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)(); // 创建时间字段，默认值为当前时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)(); // 新增：最后更新时间
}
