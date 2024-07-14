import 'dart:developer';
import 'package:get/get.dart';
import 'package:bilibilimusic/plugins/http_client.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/models/live_video_info.dart';
import 'package:bilibilimusic/services/settings_service.dart';

class BiliBiliSite {
  String name = "哔哩哔哩直播";
  String cookie = "";
  int userId = 0;
  final SettingsService settings = Get.find<SettingsService>();

  Future<VideoSaerchResult> getSearchVideoLists(String keyword, String order, {int page = 1}) async {
    cookie = settings.bilibiliCookie.value;
    var result = await HttpClient.instance.getJson(
      "https://api.bilibili.com/x/web-interface/wbi/search/type",
      queryParameters: {
        "order": order,
        "keyword": keyword,
        "search_type": "video",
        "page": page,
        "page_size": 20,
        "category_id": "",
        "platform": "pc",
        "__refresh__": "",
        "_extra": "",
        "highlight": 1,
        "single_column": 0,
      },
      header: {
        "cookie": cookie,
        "user-agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36"
      },
    );

    var items = <BilibiliVideo>[];
    var queryList = result["data"]["result"] ?? [];
    for (var item in queryList ?? []) {
      var roomItem = BilibiliVideo(
        type: item["type"],
        id: item["id"],
        author: item["author"],
        mid: item["mid"],
        typeid: item["typeid"],
        typename: item["typename"],
        arcurl: item["arcurl"],
        aid: item["aid"],
        bvid: item["bvid"],
        title: item["title"].replaceAll(RegExp(r"<.*?em.*?>"), ""),
        description: item["description"],
        arcrank: item["arcrank"].toString(),
        pic: item["pic"],
        play: item["play"],
        videoReview: item["videoReview"],
        favorites: item["favorites"],
        tag: item["tag"],
        review: item["review"],
        pubdate: item["pubdate"],
        senddate: item["senddate"],
        duration: item["duration"],
        badgepay: item["badgepay"],
        hitColumns: item["hitColumns"],
        viewType: item["viewType"],
        isPay: item["isPay"],
        isUnionVideo: item["isUnionVideo"],
        recTags: item["recTags"],
        newRecTags: item["newRecTags"],
        rankScore: item["rankScore"],
        like: item["like"],
        upic: item["upic"],
        corner: item["corner"],
        cover: item["cover"],
        desc: item["desc"],
        url: item["url"],
        recReason: item["recReason"],
        danmaku: item["danmaku"],
        bizData: item["bizData"],
        isChargeVideo: item["isChargeVideo"],
        vt: item["vt"],
        enableVt: item["enableVt"],
        vtDisplay: item["vtDisplay"],
        subtitle: item["subtitle"],
        episodeCountText: item["episodeCountText"],
        releaseStatus: item["releaseStatus"],
        isIntervene: item["isIntervene"],
        area: item["area"],
        style: item["style"],
        cateName: item["cateName"],
        isLiveRoomInline: item["isLiveRoomInline"],
        liveStatus: item["liveStatus"],
        liveTime: item["liveTime"],
        online: item["online"],
        rankIndex: item["rankIndex"],
        rankOffset: item["rankOffset"],
        roomid: item["roomid"],
        shortId: item["shortId"],
        spreadId: item["spreadId"],
        tags: item["tags"],
        uface: item["uface"],
        uid: item["uid"],
        uname: item["uname"],
        userCover: item["userCover"],
        parentAreaId: item["parentAreaId"],
        parentAreaName: item["parentAreaName"],
        watchedShow: item["watchedShow"],
        status: item["status"],
      );

      items.add(roomItem);
    }
    return VideoSaerchResult(hasMore: queryList.length > 0, items: items);
  }

  Future<List<VideoInfo>> getRoomListDetail(String bvid) async {
    cookie = settings.bilibiliCookie.value;

    List<VideoInfo> videoList = [];
    var result = await HttpClient.instance.getJson(
      "https://api.bilibili.com/x/web-interface/view",
      queryParameters: {
        "bvid": bvid,
      },
      header: {
        "cookie": cookie,
        "User-Agent":
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
        "Accept": "*/*",
        "Accept-Language": "en-US,en;q=0.5",
        "Accept-Encoding": "gzip, deflate, br",
        "Range": "bytes=0-",
        "Origin": "https://www.bilibili.com",
        "Connection": "keep-alive",
        "Referer": "https://www.bilibili.com/video/$bvid",
      },
    );
    if (result["code"] == 0) {
      var videoDetails = result["data"];
      var queryList = videoDetails["pages"] ?? [];
      var owner = videoDetails["owner"];
      var stat = videoDetails["stat"];
      for (var item in queryList ?? []) {
        var videoItem = VideoInfo(
          cid: item["cid"] ?? 0,
          page: item["page"] ?? 0,
          from: item["from"] ?? "",
          part: item["part"] ?? "",
          duration: item["duration"] ?? 0,
          vid: item["vid"] ?? "",
          weblink: item["weblink"] ?? "",
          firstFrame: item["first_frame"] ?? "",
          tname: videoDetails["tname"] ?? "",
          pic: videoDetails["pic"] ?? "",
          title: videoDetails["title"] ?? "",
          face: owner["face"] ?? "",
          name: owner["name"] ?? "",
          aid: videoDetails["aid"] ?? 0,
          videos: videoDetails["videos"] ?? 0,
          pubdate: videoDetails["pubdate"] ?? 0,
          favorite: stat["favorite"] ?? 0,
          bvid: videoDetails["bvid"] ?? "",
        );
        videoList.add(videoItem);
      }
    }
    return videoList;
  }

  Future<String> getToken(int avid, int cid) async {
    cookie = settings.bilibiliCookie.value;
    var result = await HttpClient.instance.getJson(
      "https://api.bilibili.com/x/player/playurl/token",
      queryParameters: {
        "aid": avid,
        "cid": cid,
      },
      header: {
        "cookie": cookie,
        "authority": "api.bilibili.com",
        "accept":
            "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "accept-language": "zh-CN,zh;q=0.9",
        "cache-control": "no-cache",
        "dnt": "1",
        "pragma": "no-cache",
        "sec-ch-ua": '"Not A(Brand";v="99", "Google Chrome";v="121", "Chromium";v="121"',
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": '"macOS"',
        "sec-fetch-dest": "document",
        "sec-fetch-mode": "navigate",
        "sec-fetch-site": "none",
        "sec-fetch-user": "?1",
        "upgrade-insecure-requests": "1",
        "user-agent":
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
        "Referer": "https://www.bilibili.com",
      },
    );
    if (result["code"] == 0) {
      return result["data"]["token"];
    }
    return "";
  }

  Future<VideoInfoData?> getVideoDetail(int avid, int cid, String bvid, {String qn = '80'}) async {
    cookie = settings.bilibiliCookie.value;
    // var utoken = await getToken(avid, cid);
    var result = await HttpClient.instance.getJson(
      "https://api.bilibili.com/x/player/playurl",
      queryParameters: {
        "avid": avid,
        "bvid": bvid,
        "cid": cid,
        "qn": qn,
        "type": 'video',
        "otype": "json",
        "format": "mp4",
        "fnval": 0,
        "fourk": 1,
        "platform": "html5",
        "high_quality": "1",
      },
      header: {
        "cookie": cookie,
        "authority": "api.bilibili.com",
        "accept":
            "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
        "accept-language": "zh-CN,zh;q=0.9",
        "cache-control": "no-cache",
        "dnt": "1",
        "pragma": "no-cache",
        "sec-ch-ua": '"Not A(Brand";v="99", "Google Chrome";v="121", "Chromium";v="121"',
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": '"macOS"',
        "sec-fetch-dest": "document",
        "sec-fetch-mode": "navigate",
        "sec-fetch-site": "none",
        "sec-fetch-user": "?1",
        "upgrade-insecure-requests": "1",
        "user-agent":
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
        "Referer": "https://www.bilibili.com",
      },
    );

    if (result["code"] == 0) {
      List<int> acceptQuality = [];
      for (var item in result["data"]["accept_quality"]) {
        acceptQuality.add(item);
      }
      log(result.toString());
      return VideoInfoData(
        url: result["data"]["durl"][0]["url"],
        quality: result["data"]["quality"],
        format: result["data"]["format"],
        size: result["data"]["durl"][0]["size"],
        time: result["data"]["timelength"].toString(),
        acceptQuality: acceptQuality,
      );
    }
    return null;
  }
}

class VideoSaerchResult {
  final bool hasMore;
  final List<BilibiliVideo> items;
  VideoSaerchResult({
    required this.hasMore,
    required this.items,
  });
}
