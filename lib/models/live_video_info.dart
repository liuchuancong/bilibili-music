class VideoInfo {
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
  VideoInfo({
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

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
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
}

class VideoInfoData {
  final String url;
  final int quality;
  final String format;
  final int size;
  final String time;
  final List<int> acceptQuality;

  VideoInfoData({
    required this.url,
    required this.quality,
    required this.format,
    required this.size,
    required this.time,
    required this.acceptQuality,
  });

  factory VideoInfoData.fromJson(Map<String, dynamic> json) {
    return VideoInfoData(
      url: json['url'],
      quality: json['quality'],
      format: json['format'],
      size: json['size'],
      time: json['time'],
      acceptQuality: json['accept_quality'].cast<int>(),
    );
  }
}
