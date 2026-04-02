import 'package:bilibilimusic/models/video_media_info.dart';

/// 视频分类状态枚举
/// [published] 已发布视频
/// [series] 系列合集视频
/// [allVideos] 全部视频
/// [customized] 自定义分类
enum VideoCategory {
  published,
  series,
  allVideos,
  customized,
}

/// B站视频实体类
/// 存储视频的标题、UP主、封面、发布时间、分集列表等核心信息
class BilibiliVideoItem {
  /// 数据库/本地存储ID
  int? id;

  /// 视频标题
  String? title;

  /// UP主名称
  String? author;

  /// 视频封面链接
  String? pic;

  /// 发布时间戳
  int? pubdate;

  /// UP主头像链接
  String? upic;

  /// 收藏数量
  int? favorites;

  /// 视频BV号
  String? bvid;

  /// 视频AV号
  int? aid;

  /// 播放量
  int? play;

  /// 视频分集列表（对应之前优化的 VideoMediaInfo）
  List<VideoMediaInfo> medias;

  /// 视频分类状态
  VideoCategory? category;

  /// 排序序号
  int? sort;

  /// UP主MID
  String? mid;

  /// 构造函数
  BilibiliVideoItem({
    this.title = '',
    this.author = '',
    this.pic = '',
    this.pubdate = 0,
    this.upic = '',
    this.favorites = 0,
    this.bvid,
    this.aid,
    this.play = 0,
    this.category = VideoCategory.published,
    this.id,
    List<VideoMediaInfo>? medias,
    this.mid = '',
    this.sort = 0,
  }) : medias = medias ?? [];

  /// JSON 转实体
  BilibiliVideoItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'] ?? '',
        author = json['author'] ?? '',
        pic = json['pic'] ?? '',
        pubdate = json['pubdate'] ?? 0,
        upic = json['upic'] ?? '',
        favorites = json['favorites'] ?? 0,
        bvid = json['bvid'],
        aid = json['aid'],
        play = json['play'] ?? 0,
        medias = json['medias'] != null ? (json['medias'] as List).map((e) => VideoMediaInfo.fromJson(e)).toList() : [],
        category = json['status'] != null ? VideoCategory.values[json['status']] : VideoCategory.published,
        sort = json['sort'] ?? 0,
        mid = json['mid'] ?? '';

  /// 实体转 JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['author'] = author;
    data['pic'] = pic;
    data['pubdate'] = pubdate;
    data['upic'] = upic;
    data['bvid'] = bvid;
    data['aid'] = aid;
    data['play'] = play;
    data['id'] = id;
    data['medias'] = medias.map((e) => e.toJson()).toList();
    data['status'] = category?.index;
    data['favorites'] = favorites;
    data['sort'] = sort;
    data['mid'] = mid;
    return data;
  }

  @override
  String toString() {
    return 'BilibiliVideoItem{id: $id, title: $title, author: $author, pic: $pic, pubdate: $pubdate, upic: $upic, favorites: $favorites, bvid: $bvid, aid: $aid, play: $play, medias: $medias, category: $category, sort: $sort, mid: $mid}';
  }
}
