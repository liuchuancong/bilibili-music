import 'package:bilibilimusic/models/live_media_info.dart';

enum VideoStatus { published, series, allVideos, customized }

class BilibiliVideo {
  int? id;
  String? title;
  String? author;
  String? pic;
  int? pubdate;
  String? upic;
  int? favorites;
  String? bvid;
  int? aid;
  int? play;
  List<LiveMediaInfo> medias = [];
  VideoStatus? status;
  int? sort = 0;
  String? mid;
  BilibiliVideo({
    this.title = '',
    this.author = '',
    this.pic = '',
    this.pubdate = 0,
    this.upic = '',
    this.favorites = 0,
    this.bvid,
    this.aid,
    this.play = 0,
    this.status = VideoStatus.published,
    this.id,
    this.medias = const [],
    this.mid = "",
  });

  BilibiliVideo.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '',
        author = json['author'] ?? '',
        pic = json['pic'] ?? '',
        pubdate = json['pubdate'] ?? 0,
        upic = json['upic'] ?? '',
        bvid = json['bvid'],
        aid = json['aid'],
        play = json['play'],
        id = json['id'],
        medias = json['medias'] != null ? (json['medias'] as List).map((e) => LiveMediaInfo.fromJson(e)).toList() : [],
        status = json['status'] != null ? VideoStatus.values[json['status']] : VideoStatus.published,
        favorites = json['favorites'] ?? 0;

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
    data['status'] = status?.index;
    data['favorites'] = favorites;
    return data;
  }

  @override
  String toString() {
    return 'BilibiliVideo(title: $title, author: $author, pic: $pic, pubdate: $pubdate, upic: $upic, favorites: $favorites, bvid: $bvid, aid: $aid, play: $play, medias: $medias, status: $status, id: $id)';
  }
}
