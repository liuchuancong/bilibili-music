class LiveMediaInfo {
  final int aid;
  final int videos;
  final int pubdate;
  final int favorite;
  final int cid;
  final int page;
  final String from;
  final String part;
  final int duration;
  final String vid;
  final String weblink;
  final String firstFrame;
  final String tname;
  final String pic;
  final String title;
  final String face;
  final String name;
  final String bvid;
  LiveMediaInfo({
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

  factory LiveMediaInfo.fromJson(Map<String, dynamic> json) {
    return LiveMediaInfo(
      cid: json['cid'],
      aid: json['aid'],
      videos: json['videos'],
      pubdate: json['pubdate'],
      favorite: json['favorite'],
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

  Map<String, dynamic> toJson() {
    return {
      'cid': cid,
      'aid': aid,
      'videos': videos,
      'pubdate': pubdate,
      'favorite': favorite,
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
    return 'LiveMediaInfo{aid: $aid, videos: $videos, pubdate: $pubdate, favorite: $favorite, cid: $cid, page: $page, from: $from, part: $part, duration: $duration, vid: $vid, weblink: $weblink, firstFrame: $firstFrame, tname: $tname, pic: $pic, title: $title, face: $face, name: $name, bvid: $bvid}';
  }
}

class LiveMediaInfoData {
  final String url;
  final int quality;
  final String format;
  final int size;
  final String time;
  final List<int> acceptQuality;

  LiveMediaInfoData({
    required this.url,
    required this.quality,
    required this.format,
    required this.size,
    required this.time,
    required this.acceptQuality,
  });

  factory LiveMediaInfoData.fromJson(Map<String, dynamic> json) {
    return LiveMediaInfoData(
      url: json['url'],
      quality: json['quality'],
      format: json['format'],
      size: json['size'],
      time: json['time'],
      acceptQuality: json['accept_quality'].cast<int>(),
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
    return 'LiveMediaInfoData{url: $url, quality: $quality, format: $format, size: $size, time: $time, acceptQuality: $acceptQuality}';
  }
}

class PlayItems {
  LiveMediaInfo liveMediaInfo;
  int index;
  bool selected;
  PlayItems({
    required this.liveMediaInfo,
    required this.index,
    this.selected = false,
  });
}
