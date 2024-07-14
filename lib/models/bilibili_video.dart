enum VideoStatus { unknown, published, removed }

class BilibiliVideo {
  String? type;
  int? id;
  String? author;
  int? mid;
  String? typeid;
  String? typename;
  String? arcurl;
  int? aid;
  String? bvid;
  String? title;
  String? description;
  String? arcrank;
  String? pic;
  int? play;
  int? videoReview;
  int? favorites;
  String? tag;
  int? review;
  int? pubdate;
  int? senddate;
  String? duration;
  bool? badgepay;
  List<String>? hitColumns;
  String? viewType;
  bool? isPay;
  bool? isUnionVideo;
  dynamic recTags;
  List<dynamic>? newRecTags;
  int? rankScore;
  int? like;
  String? upic;
  String? corner;
  String? cover;
  String? desc;
  String? url;
  String? recReason;
  int? danmaku;
  dynamic bizData;
  bool? isChargeVideo;
  int? vt;
  int? enableVt;
  String? vtDisplay;
  String? subtitle;
  String? episodeCountText;
  int? releaseStatus;
  int? isIntervene;
  int? area;
  int? style;
  String? cateName;
  int? isLiveRoomInline;
  int? liveStatus;
  String? liveTime;
  int? online;
  int? rankIndex;
  int? rankOffset;
  int? roomid;
  int? shortId;
  int? spreadId;
  String? tags;
  String? uface;
  int? uid;
  String? uname;
  String? userCover;
  int? parentAreaId;
  String? parentAreaName;
  dynamic watchedShow;
  VideoStatus? status = VideoStatus.unknown; // 添加一个默认状态

  BilibiliVideo({
    this.type,
    this.id,
    this.author,
    this.mid,
    this.typeid,
    this.typename,
    this.arcurl,
    this.aid,
    this.bvid,
    this.title,
    this.description,
    this.arcrank,
    this.pic,
    this.play,
    this.videoReview,
    this.favorites,
    this.tag,
    this.review,
    this.pubdate,
    this.senddate,
    this.duration,
    this.badgepay,
    this.hitColumns,
    this.viewType,
    this.isPay,
    this.isUnionVideo,
    this.recTags,
    this.newRecTags,
    this.rankScore,
    this.like,
    this.upic,
    this.corner,
    this.cover,
    this.desc,
    this.url,
    this.recReason,
    this.danmaku,
    this.bizData,
    this.isChargeVideo,
    this.vt,
    this.enableVt,
    this.vtDisplay,
    this.subtitle,
    this.episodeCountText,
    this.releaseStatus,
    this.isIntervene,
    this.area,
    this.style,
    this.cateName,
    this.isLiveRoomInline,
    this.liveStatus,
    this.liveTime,
    this.online,
    this.rankIndex,
    this.rankOffset,
    this.roomid,
    this.shortId,
    this.spreadId,
    this.tags,
    this.uface,
    this.uid,
    this.uname,
    this.userCover,
    this.parentAreaId,
    this.parentAreaName,
    this.watchedShow,
    this.status,
  });

  BilibiliVideo.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        id = json['id'],
        author = json['author'],
        mid = json['mid'],
        typeid = json['typeid'],
        typename = json['typename'],
        arcurl = json['arcurl'],
        aid = json['aid'],
        bvid = json['bvid'],
        title = json['title'],
        description = json['description'],
        arcrank = json['arcrank'],
        pic = json['pic'],
        play = json['play'],
        videoReview = json['video_review'],
        favorites = json['favorites'],
        tag = json['tag'],
        review = json['review'],
        pubdate = json['pubdate'],
        senddate = json['senddate'],
        duration = json['duration'],
        badgepay = json['badgepay'],
        hitColumns = List<String>.from(json['hit_columns'] ?? []),
        viewType = json['view_type'],
        isPay = json['is_pay'],
        isUnionVideo = json['is_union_video'],
        recTags = json['rec_tags'],
        newRecTags = List<dynamic>.from(json['new_rec_tags'] ?? []),
        rankScore = json['rank_score'],
        like = json['like'],
        upic = json['upic'],
        corner = json['corner'],
        cover = json['cover'],
        desc = json['desc'],
        url = json['url'],
        recReason = json['rec_reason'],
        danmaku = json['danmaku'],
        bizData = json['biz_data'],
        isChargeVideo = json['is_charge_video'],
        vt = json['vt'],
        enableVt = json['enable_vt'],
        vtDisplay = json['vt_display'],
        subtitle = json['subtitle'],
        episodeCountText = json['episode_count_text'],
        releaseStatus = json['release_status'],
        isIntervene = json['is_intervene'],
        area = json['area'],
        style = json['style'],
        cateName = json['cate_name'],
        isLiveRoomInline = json['is_live_room_inline'],
        liveStatus = json['live_status'],
        liveTime = json['live_time'],
        online = json['online'],
        rankIndex = json['rank_index'],
        rankOffset = json['rank_offset'],
        roomid = json['roomid'],
        shortId = json['short_id'],
        spreadId = json['spread_id'],
        tags = json['tags'],
        uface = json['uface'],
        uid = json['uid'],
        uname = json['uname'],
        userCover = json['user_cover'],
        parentAreaId = json['parent_area_id'],
        parentAreaName = json['parent_area_name'],
        watchedShow = json['watched_show'],
        status = VideoStatus.values[json['status'] ?? 0];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['author'] = author;
    data['mid'] = mid;
    data['typeid'] = typeid;
    data['typename'] = typename;
    data['arcurl'] = arcurl;
    data['aid'] = aid;
    data['bvid'] = bvid;
    data['title'] = title;
    data['description'] = description;
    data['arcrank'] = arcrank;
    data['pic'] = pic;
    data['play'] = play;
    data['video_review'] = videoReview;
    data['favorites'] = favorites;
    data['tag'] = tag;
    data['review'] = review;
    data['pubdate'] = pubdate;
    data['senddate'] = senddate;
    data['duration'] = duration;
    data['badgepay'] = badgepay;
    data['hit_columns'] = hitColumns;
    data['view_type'] = viewType;
    data['is_pay'] = isPay;
    data['is_union_video'] = isUnionVideo;
    data['rec_tags'] = recTags;
    data['new_rec_tags'] = newRecTags;
    data['rank_score'] = rankScore;
    data['like'] = like;
    data['upic'] = upic;
    data['corner'] = corner;
    data['cover'] = cover;
    data['desc'] = desc;
    data['url'] = url;
    data['rec_reason'] = recReason;
    data['danmaku'] = danmaku;
    data['biz_data'] = bizData;
    data['is_charge_video'] = isChargeVideo;
    data['vt'] = vt;
    data['enable_vt'] = enableVt;
    data['vt_display'] = vtDisplay;
    data['subtitle'] = subtitle;
    data['episode_count_text'] = episodeCountText;
    data['release_status'] = releaseStatus;
    data['is_intervene'] = isIntervene;
    data['area'] = area;
    data['style'] = style;
    data['cate_name'] = cateName;
    data['is_live_room_inline'] = isLiveRoomInline;
    data['live_status'] = liveStatus;
    data['live_time'] = liveTime;
    data['online'] = online;
    data['rank_index'] = rankIndex;
    data['rank_offset'] = rankOffset;
    data['roomid'] = roomid;
    data['short_id'] = shortId;
    data['spread_id'] = spreadId;
    data['tags'] = tags;
    data['uface'] = uface;
    data['uid'] = uid;
    data['uname'] = uname;
    data['user_cover'] = userCover;
    data['parent_area_id'] = parentAreaId;
    data['parent_area_name'] = parentAreaName;
    data['watched_show'] = watchedShow;
    data['status'] = status?.index ?? 0;
    return data;
  }
}
