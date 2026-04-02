/// 视频分类类型枚举
enum VideoMediaType {
  masterpiece, // 精品视频
  series, // 系列合集
  allVideos, // 全部视频
  customized, // 自定义分类
}

/// 视频分集信息实体（单P视频信息）
class VideoMediaInfo {
  /// 稿件aid
  final int aid;

  /// 视频分P总数
  final int videos;

  /// 发布时间戳
  final int pubdate;

  /// 收藏数
  final int favorite;

  /// 分集cid
  final int cid;

  /// 分P页码
  final int page;

  /// 来源
  final String from;

  /// 分P标题
  final String part;

  /// 视频时长（秒）
  final int duration;

  /// 视频源ID
  final String vid;

  /// 网页链接
  final String weblink;

  /// 首帧封面
  final String firstFrame;

  /// 分区名称
  final String tname;

  /// 视频封面
  final String pic;

  /// 视频标题
  final String title;

  /// UP主头像
  final String face;

  /// UP主名称
  final String name;

  /// 视频bvid
  final String bvid;

  VideoMediaInfo({
    required this.aid,
    required this.videos,
    required this.pubdate,
    required this.favorite,
    required this.cid,
    required this.page,
    required this.from,
    required this.part,
    required this.duration,
    required this.vid,
    required this.weblink,
    required this.firstFrame,
    required this.tname,
    required this.pic,
    required this.title,
    required this.face,
    required this.name,
    required this.bvid,
  });

  /// JSON 转实体
  factory VideoMediaInfo.fromJson(Map<String, dynamic> json) {
    return VideoMediaInfo(
      aid: json['aid'],
      videos: json['videos'],
      pubdate: json['pubdate'],
      favorite: json['favorite'],
      cid: json['cid'],
      page: json['page'],
      from: json['from'] ?? '',
      part: json['part'] ?? '',
      duration: json['duration'],
      vid: json['vid'],
      weblink: json['weblink'] ?? '',
      firstFrame: json['first_frame'] ?? '',
      tname: json['tname'] ?? '',
      pic: json['pic'] ?? '',
      title: json['title'] ?? '',
      face: json['face'] ?? '',
      name: json['name'] ?? '',
      bvid: json['bvid'] ?? '',
    );
  }

  /// 实体转 JSON
  Map<String, dynamic> toJson() {
    return {
      'aid': aid,
      'videos': videos,
      'pubdate': pubdate,
      'favorite': favorite,
      'cid': cid,
      'page': page,
      'from': from,
      'part': part,
      'duration': duration,
      'vid': vid,
      'weblink': weblink,
      'first_frame': firstFrame,
      'tname': tname,
      'pic': pic,
      'title': title,
      'face': face,
      'name': name,
      'bvid': bvid,
    };
  }

  @override
  String toString() {
    return 'VideoMediaInfo{aid: $aid, videos: $videos, pubdate: $pubdate, favorite: $favorite, cid: $cid, page: $page, from: $from, part: $part, duration: $duration, vid: $vid, weblink: $weblink, firstFrame: $firstFrame, tname: $tname, pic: $pic, title: $title, face: $face, name: $name, bvid: $bvid}';
  }
}

/// 视频系列/合集实体
class VideoMediaSeries {
  final String name;
  final int total;
  final List<VideoMediaInfo> mediaList;
  final int? sessionId;
  final VideoMediaType mediaType;

  VideoMediaSeries({
    required this.name,
    required this.total,
    required this.mediaList,
    this.mediaType = VideoMediaType.masterpiece,
    this.sessionId = 0,
  });
}

/// 视频播放地址信息（清晰度、链接、格式等）
class VideoPlaySource {
  final String url;
  final int quality;
  final String format;
  final int size;
  final String time;
  final List<int> acceptQuality;

  VideoPlaySource({
    required this.url,
    required this.quality,
    required this.format,
    required this.size,
    required this.time,
    required this.acceptQuality,
  });

  factory VideoPlaySource.fromJson(Map<String, dynamic> json) {
    return VideoPlaySource(
      url: json['url'],
      quality: json['quality'],
      format: json['format'],
      size: json['size'],
      time: json['time'],
      acceptQuality: List<int>.from(json['accept_quality'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'quality': quality,
      'format': format,
      'size': size,
      'time': time,
      'accept_quality': acceptQuality,
    };
  }

  @override
  String toString() {
    return 'VideoPlaySource{url: $url, quality: $quality, format: $format, size: $size, time: $time, acceptQuality: $acceptQuality}';
  }
}
