import 'package:drift/drift.dart';

class Artlists extends Table {
  IntColumn get id => integer().autoIncrement()(); // 主键ID
  TextColumn get uuid => text()(); // 全局唯一标识，跨设备唯一
  TextColumn get artist => text().nullable()(); // 艺术家
  TextColumn get desc => text().nullable()(); // 歌手描述
  TextColumn get artistAvatar => text().nullable()(); // 艺术家头像
  TextColumn get alias => text().nullable()(); // 歌手别名
  IntColumn get like => integer().nullable()(); // 歌手喜欢数
  IntColumn get follow => integer().nullable()(); // 歌手关注数
  IntColumn get fans => integer().nullable()(); // 歌手粉丝数
  IntColumn get playCount => integer().nullable()(); // 歌手播放数
  TextColumn get musicId => text().nullable()(); // 音乐ID
  TextColumn get sessionId => text().nullable()(); // 会话ID
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)(); // 创建时间字段，默认值为当前时间
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)(); // 新增：最后更新时间
}
