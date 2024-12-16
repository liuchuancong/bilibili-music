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
  int? play = 0;
  List<LiveMediaInfo> medias = [];
  VideoStatus? status = VideoStatus.published;
  int? sort = 0;
  BilibiliVideo({
    this.title,
    this.author,
    this.pic,
    this.pubdate,
    this.upic,
    this.favorites,
    this.bvid,
    this.aid,
    this.play,
    this.status,
    this.id,
  });

  BilibiliVideo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        author = json['author'],
        pic = json['pic'],
        pubdate = json['pubdate'],
        upic = json['upic'],
        bvid = json['bvid'],
        aid = json['aid'],
        play = json['play'],
        id = json['id'],
        medias = json['medias'] != null ? (json['medias'] as List).map((e) => LiveMediaInfo.fromJson(e)).toList() : [],
        status = json['status'] != null ? VideoStatus.values[json['status']] : VideoStatus.published,
        favorites = json['favorites'];

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
