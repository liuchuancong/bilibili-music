import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:bilibilimusic/core/util.dart';
import 'package:bilibilimusic/utils/text_util.dart';
import 'package:bilibilimusic/models/up_user_info.dart';
import 'package:bilibilimusic/plugins/http_client.dart';
import 'package:bilibilimusic/models/bilibili_video.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
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
        id: item["id"] ?? 0,
        title: item["title"].replaceAll(RegExp(r"<.*?em.*?>"), "") ?? "",
        author: item["author"] ?? "",
        pic: item["pic"] ?? "",
        pubdate: item["pubdate"] ?? 0,
        upic: item["upic"] ?? "",
        favorites: item["favorites"] ?? 0,
        bvid: item["bvid"] ?? "",
        aid: item["aid"] ?? 0,
        play: item["play"] ?? 0,
        status: VideoStatus.published,
      );

      items.add(roomItem);
    }
    return VideoSaerchResult(hasMore: queryList.length > 0, items: items);
  }

  Future<List<LiveMediaInfo>> getRoomListDetail(String bvid) async {
    cookie = settings.bilibiliCookie.value;

    List<LiveMediaInfo> videoList = [];
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
        var videoItem = LiveMediaInfo(
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

  Future<SeriesLiveMedia> getAllVideos(String mid) async {
    cookie = settings.bilibiliCookie.value;
    List<LiveMediaInfo> videoList = [];
    var sign = await getSignedParams({
      "mid": mid,
      "pn": 1,
      "ps": 30,
      "order": "pubdate",
      "order_avoided": true,
      "platform": "web",
    });
    var header = {
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
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
      "Referer": "https://space.bilibili.com/$mid",
    };
    var result = await HttpClient.instance.getJson(
      "https://api.bilibili.com/x/space/wbi/arc/search",
      queryParameters: sign,
      header: header,
    );

    if (result["code"] == 0) {
      List queryList = result["data"]['list']['vlist'] ?? [];
      for (var item in queryList.take(20)) {
        var meta = item["meta"];
        var length = item['length'];
        var videoItem = LiveMediaInfo(
          cid: item["cid"] ?? 0,
          page: 0,
          from: "",
          part: "",
          duration: convertToTimestampFromNow(length),
          vid: "",
          weblink: "",
          firstFrame: "",
          tname: "",
          pic: item["pic"] ?? "",
          title: item["title"] ?? "",
          face: "",
          name: item['name'] ?? "",
          aid: item["aid"] ?? 0,
          videos: 0,
          pubdate: item["pubdate"] ?? 0,
          favorite: meta != null && meta['stat'] != null ? meta['stat']['favorite'] : 0,
          bvid: item["bvid"] ?? "",
        );
        videoList.add(videoItem);
      }
    }
    return SeriesLiveMedia(
      name: 'TA的视频',
      total: videoList.length,
      mediaType: VideoMediaTypes.allVideos,
      liveMediaInfoList: videoList,
    );
  }

  Future<SeriesLiveMedia> getMasterpiece(String mid) async {
    cookie = settings.bilibiliCookie.value;
    List<LiveMediaInfo> videoList = [];

    var header = {
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
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
      "Referer": "https://space.bilibili.com/$mid",
    };
    var result = await HttpClient.instance.getJson(
      "https://api.bilibili.com/x/space/masterpiece",
      queryParameters: {
        "vmid": mid,
      },
      header: header,
    );
    if (result["code"] == 0) {
      var queryList = result["data"] ?? [];
      for (var item in queryList.take(10) ?? []) {
        var stat = item["stat"];
        var owner = item["owner"];
        var videoItem = LiveMediaInfo(
          cid: item["cid"] ?? 0,
          page: item["page"] ?? 0,
          from: item["from"] ?? "",
          part: owner != null ? owner["name"] : "",
          duration: item["duration"] ?? 0,
          vid: item["vid"] ?? "",
          weblink: item["weblink"] ?? "",
          firstFrame: item["first_frame"] ?? "",
          tname: item["tname"] ?? "",
          pic: item["pic"] ?? "",
          title: item["title"] ?? "",
          face: owner != null ? owner["face"] : "",
          name: item["name"] ?? "",
          aid: item["aid"] ?? 0,
          videos: item["videos"] ?? 0,
          pubdate: item["pubdate"] ?? 0,
          favorite: stat != null ? stat["favorite"] : 0,
          bvid: item["bvid"] ?? "",
        );
        videoList.add(videoItem);
      }
    }
    return SeriesLiveMedia(
      name: '代表作',
      total: videoList.length,
      mediaType: VideoMediaTypes.masterpiece,
      liveMediaInfoList: videoList,
    );
  }

  Future<List<SeriesLiveMedia>> getSeasonsSeries(String mid) async {
    cookie = settings.bilibiliCookie.value;
    List<SeriesLiveMedia> seriesLiveList = [];
    var header = {
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
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
      "Referer": "https://space.bilibili.com/$mid",
    };
    var result = await HttpClient.instance.getJson(
      "https://api.bilibili.com/x/polymer/web-space/home/seasons_series",
      queryParameters: {
        "mid": mid,
        "page_num": 1,
        "page_size": 10,
      },
      header: header,
    );
    if (result["code"] == 0) {
      var queryList = result["data"]['items_lists']['seasons_list'] ?? [];
      for (var item in queryList ?? []) {
        List<LiveMediaInfo> videoList = [];
        var archives = item['archives'] ?? [];
        var meta = item['meta'];
        for (var archive in archives.take(10) ?? []) {
          var videoItem = LiveMediaInfo(
            cid: archive["cid"] ?? 0,
            page: 0,
            from: "",
            part: "",
            duration: archive["duration"] ?? 0,
            vid: "",
            weblink: "",
            firstFrame: "",
            tname: "",
            pic: archive["pic"] ?? "",
            title: archive["title"] ?? "",
            face: "",
            name: "",
            aid: archive["aid"] ?? 0,
            videos: 0,
            pubdate: archive["pubdate"] ?? 0,
            favorite: 0,
            bvid: archive["bvid"] ?? "",
          );
          videoList.add(videoItem);
        }
        seriesLiveList.add(SeriesLiveMedia(
          name: meta['name'] ?? '',
          total: videoList.length,
          liveMediaInfoList: videoList,
          mediaType: VideoMediaTypes.series,
          sessionId: meta['season_id'] ?? 0,
        ));
      }
    }
    return seriesLiveList;
  }

  Future<LiveMediaInfoData?> getVideoDetail(int avid, int cid, String bvid, {String qn = '80'}) async {
    cookie = settings.bilibiliCookie.value;
    var header = {
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
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
      "Referer": "https://www.bilibili.com/video/$bvid",
    };
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
      header: header,
    );
    if (result["code"] == 0) {
      List<int> acceptQuality = [];
      for (var item in result["data"]["accept_quality"]) {
        acceptQuality.add(item);
      }
      return LiveMediaInfoData(
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

  Future<UpUserInfo> getVidoeInfo(BilibiliVideo video) async {
    if (video.status == VideoStatus.customized) {
      return UpUserInfo(
        name: "",
        desc: "",
        face: "",
        like: 0,
        mid: '',
        follower: 0,
        loaded: false,
      );
    }
    cookie = settings.bilibiliCookie.value;
    var header = {
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
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
      "Referer": "https://www.bilibili.com/video/${video.bvid}",
    };
    var result = await HttpClient.instance.getJson(
      "https://api.bilibili.com/x/web-interface/wbi/view/detail",
      queryParameters: {
        "bvid": video.bvid,
      },
      header: header,
    );
    if (result["code"] == 0) {
      var videoDetails = result["data"];
      var owner = videoDetails["Card"];
      return UpUserInfo(
        name: owner["card"]['name'] ?? "",
        desc: owner['card']['sign'] ?? "",
        face: owner['card']['face'] ?? "",
        mid: owner['card']['mid'] ?? "",
        like: owner['like_num'],
        follower: owner['follower'],
        loaded: true,
      );
    }
    return UpUserInfo(
      name: "",
      desc: "",
      face: "",
      mid: '',
      like: 0,
      follower: 0,
      loaded: false,
    );
  }

  //  public ApiModel GetMediaList(string medisListId, string lastAid, int pagesize = 20)
  //       {
  //           var api = new ApiModel()
  //           {
  //               method = HttpMethods.Get,
  //               baseUrl = $"https://api.bilibili.com/x/v2/medialist/resource/list",
  //               parameter =
  //                   $"{ApiHelper.MustParameter(AppKey, true)}&type=1&biz_id={medisListId}&oid={lastAid}&otype=2&ps={pagesize}&direction=false&desc=true&sort_field=1&tid=0&with_current=false",
  //           };
  //           api.parameter += ApiHelper.GetSign(api.parameter, AppKey);
  //           return api;
  //       }

  // Future<List<BilibiliVideo>> getMediaList(String medisListId, String lastAid, {int pagesize = 20}) async {
  //   cookie = settings.bilibiliCookie.value;
  //   var header = {
  //     "cookie": cookie,
  //     "authority": "api.bilibili.com",
  //     "accept":
  //         "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
  //     "accept-language": "zh-CN,zh;q=0.9",
  //     "cache-control": "no-cache",
  //     "dnt": "1",
  //     "pragma": "no-cache",
  //     "sec-ch-ua": '"Not A(Brand";v="99", "Google Chrome";v="121", "Chromium";v="121"',
  //     "sec-ch-ua-mobile": "?0",
  //     "sec-ch-ua-platform": '"macOS"',
  //     "sec-fetch-dest": "document",
  //     "sec-fetch-mode": "navigate",
  //     "sec-fetch-site": "none",
  //     "sec-fetch-user": "?1",
  //     "upgrade-insecure-requests": "1",
  //     "user-agent":
  //         "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
  //     "Referer": "https://www.bilibili.com/list/$medisListId",
  //   };
  //   var result =
  //       await HttpClient.instance.getJson("https://api.bilibili.com/x/v2/medialist/resource/list", queryParameters: {
  //     "type": 1,
  //     "biz_id": medisListId,
  //     "oid": lastAid,
  //     "otype": 2,
  //     "ps": pagesize,
  //     "direction": false,
  //     "desc": true,
  //     "sort_field": 1,
  //     "tid": 0,
  //     "with_current": false,
  //   });
  // }

  Future<LiveMediaInfoData?> getAudioDetail(int avid, int cid, String bvid, {String qn = '32'}) async {
    cookie = settings.bilibiliCookie.value;

    var sign = await getSignedParams({"bvid": bvid, "cid": cid, "fnval": 16});
    var header = {
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
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
      "Referer": "https://www.bilibili.com/video/$bvid",
    };
    var result = await HttpClient.instance.getJson(
      "http://api.bilibili.com/x/player/wbi/playurl",
      queryParameters: sign,
      header: header,
    );

    if (result["code"] == 0) {
      List<int> acceptQuality = [];
      for (var item in result["data"]["accept_quality"]) {
        acceptQuality.add(item);
      }
      var baseUrl = '';
      var audio = result["data"]["dash"]["audio"] ?? [];
      if (audio.isNotEmpty) {
        for (var item in audio) {
          if (item["id"].toString() == qn) baseUrl = item["baseUrl"];
        }
        if (baseUrl.isEmpty) {
          baseUrl = audio.last["baseUrl"];
        }
      }
      return LiveMediaInfoData(
        url: baseUrl,
        quality: result["data"]["quality"],
        format: result["data"]["format"],
        size: 0,
        time: result["data"]["timelength"].toString(),
        acceptQuality: acceptQuality,
      );
    }
    return null;
  }

  Future<Map<String, dynamic>> getAudioLyric(int avid, int cid, String bvid) async {
    cookie = settings.bilibiliCookie.value;

    var sign = await getSignedParams({
      "aid": avid,
      "bvid": bvid,
      "cid": cid,
    });
    var header = {
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
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
      "Referer": "https://www.bilibili.com/video/$bvid",
    };
    var result = await HttpClient.instance.getJson(
      "http://api.bilibili.com/x/player/wbi/v2",
      queryParameters: sign,
      header: header,
    );
    if (result["code"] == 0) {
      if (result["data"]["bgm_info"] != null && result["data"]["bgm_info"]["music_id"] != null) {
        return await getMusicInfo(result["data"]["bgm_info"]['music_id']);
      }
      return {
        'album': '',
        'title': "",
        'author': '',
        'cover': '',
        'lyric': '',
      };
    }
    return {
      'album': '',
      'title': '',
      'author': '',
      'cover': '',
      'lyric': '',
    };
  }

  Future<Map<String, dynamic>> getMusicInfo(String musicId) async {
    cookie = settings.bilibiliCookie.value;
    var sign = await getSignedParams({"music_id": musicId, "relation_from": "bgm_page"});
    var header = {
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
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
      "Referer": "https://music.bilibili.com/",
    };
    var result = await HttpClient.instance.getJson(
      "https://api.bilibili.com/x/copyright-music-publicity/bgm/detail",
      queryParameters: sign,
      header: header,
    );
    if (result["code"] == 0) {
      return {
        'album': result['data']['album'],
        'title': result['data']['music_title'],
        'author': result['data']['origin_artist'],
        'cover': result['data']['mv_cover'],
        'lyric': result['data']['mv_lyric'],
      };
    }
    return {
      'album': '',
      'title': '',
      'author': '',
      'cover': '',
      'lyric': '',
    };
  }

  Future<String> getBilibiliLyrics(String url) async {
    var lyrics = await HttpClient.instance.getFile(url);
    return utf8.decode(lyrics.data);
  }

  String convertTimestamp(String input) {
    // 正则表达式匹配整个时间戳
    RegExp pattern = RegExp(r"\[(\d{2}:\d{2}:\d{3},\d{2}:\d{2}:\d{3})\]");
    final match = pattern.firstMatch(input);
    if (pattern.hasMatch(input)) {
      // 提取小时、分钟和毫秒
      String timestamp = match!.group(0)!.replaceAll("[", "").replaceAll("]", "");
      List<String> timeList = timestamp.split(",");
      String tHours = timeList[0].split(":")[0];
      String tMinutes = timeList[0].split(":")[1];
      String tMilliseconds = timeList[1].split(":")[2];
      int milliseconds = int.parse(tMilliseconds);

      // 毫秒转换为百分秒，并四舍五入
      double hundredthsDouble = (milliseconds % 1000) / 10.0; // 将毫秒转换为百分秒
      int hundredths = (hundredthsDouble).round(); // 四舍五入

      // 格式化输出
      return '[${tHours.padLeft(2, '0')}:${tMinutes.padLeft(2, '0')}.${hundredths.toString().padLeft(2, '0')}]';
    }
    return input;
  }

  Future<List<LyricResults>> getSearchLyrics(String title, String author) async {
    var url = settings.lrcApiUrl[settings.lrcApiIndex.value];
    bool isLrcApi = settings.lrcApiIndex.value == 0;
    var result = await HttpClient.instance.getJson("$url?title=$title&artist=$author");
    List<dynamic> lyricResults = [];
    if (isLrcApi) {
      lyricResults = result;
    } else {
      lyricResults = result['data'] ?? [];
    }
    List<LyricResults> list = [];
    for (var i = 0; i < lyricResults.length; i++) {
      RegExp pattern = RegExp(r"\[\d{2}:\d{2}:\d{3},\d{2}:\d{2}:\d{3}]");
      String text = isLrcApi ? lyricResults[i]['lyrics'] ?? '' : lyricResults[i]['lrc'];
      try {
        if (pattern.hasMatch(text)) {
          text = text.replaceAllMapped(pattern, (match) => convertTimestamp(match.group(0)!));
        }
      } catch (e) {
        log(e.toString(), name: 'getSearchLyrics');
      }
      list.add(LyricResults(
        album: lyricResults[i]['album'] ?? '',
        id: lyricResults[i]['id'].toString(),
        artist: lyricResults[i]['artist'] ?? '',
        lyrics: text,
        title: lyricResults[i]['title'] ?? '',
      ));
    }

    return list;
  }

  Future<List<LiveMediaInfo>> getArchivesVideos(
      int page, int pageSize, String mid, int sessionId, String avatar, String name, int like) async {
    cookie = settings.bilibiliCookie.value;
    List<LiveMediaInfo> videoList = [];
    var sign = await getSignedParams({
      "mid": mid,
      "season_id": sessionId,
      "page_num": page,
      "page_size": pageSize,
    });
    var header = {
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
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
      "Referer": "https://space.bilibili.com/$mid//channel/collectiondetail?sid=$sessionId&ctype=0",
    };
    var result = await HttpClient.instance.getJson(
      "https://api.bilibili.com/x/polymer/web-space/seasons_archives_list",
      queryParameters: sign,
      header: header,
    );

    if (result["code"] == 0) {
      List queryList = result["data"]['archives'] ?? [];
      var meta = result["data"]['meta'];
      for (var item in queryList) {
        var videoItem = LiveMediaInfo(
          cid: item["cid"] ?? 0,
          page: 0,
          from: "",
          part: "",
          duration: item["duration"] ?? "",
          vid: "",
          weblink: "",
          firstFrame: "",
          tname: "",
          face: avatar,
          pic: item["pic"] ?? "",
          title: meta != null ? meta['name'] : "",
          name: name,
          aid: item["aid"] ?? 0,
          videos: meta != null ? meta['total'] : "",
          pubdate: meta != null ? meta['ptime'] : "",
          favorite: 0,
          bvid: item["bvid"] ?? "",
        );
        videoList.add(videoItem);
      }
    }
    return videoList;
  }

  Future<List<LiveMediaInfo>> getUpAllVideos(page, size, String mid) async {
    cookie = settings.bilibiliCookie.value;
    List<LiveMediaInfo> videoList = [];
    var sign = await getSignedParams({
      "mid": mid,
      "pn": page,
      "ps": size,
      "order": "pubdate",
      "order_avoided": true,
      "platform": "web",
    });
    var header = {
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
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
      "Referer": "https://space.bilibili.com/$mid",
    };
    var result = await HttpClient.instance.getJson(
      "https://api.bilibili.com/x/space/wbi/arc/search",
      queryParameters: sign,
      header: header,
    );

    if (result["code"] == 0) {
      List queryList = result["data"]['list']['vlist'] ?? [];
      for (var item in queryList) {
        var meta = item["meta"];
        var length = item['length'];
        var videoItem = LiveMediaInfo(
          cid: item["cid"] ?? 0,
          page: 0,
          from: "",
          part: "",
          duration: convertToTimestampFromNow(length),
          vid: "",
          weblink: "",
          firstFrame: "",
          tname: "",
          pic: item["pic"] ?? "",
          title: item["title"] ?? "",
          face: "",
          name: item['name'] ?? "",
          aid: item["aid"] ?? 0,
          videos: 0,
          pubdate: item["pubdate"] ?? 0,
          favorite: meta != null && meta['stat'] != null ? meta['stat']['favorite'] : 0,
          bvid: item["bvid"] ?? "",
        );
        videoList.add(videoItem);
      }
    }
    return videoList;
  }

  Future<List<LiveMediaInfo>> playAlbumAllVideos(int aid, String bvid) async {
    List<LiveMediaInfo> videoList = [];
    cookie = settings.bilibiliCookie.value;
    var header = {
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
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36",
      "Referer": "https://www.bilibili.com/video/$bvid",
    };
    var result = await HttpClient.instance.getJson(
      "https://api.bilibili.com/x/web-interface/wbi/view/detail",
      queryParameters: {
        "aid": aid,
      },
      header: header,
    );
    try {
      if (result["code"] == 0) {
        var videoDetails = result["data"];
        var view = videoDetails["View"];
        var ownerList = view["ugc_season"]['sections'][0]['episodes'];
        var owner = view["owner"];
        var stat = view["stat"];
        for (var item in ownerList ?? []) {
          var arc = item["arc"];
          var queryList = item["pages"];
          for (var queryItem in queryList ?? []) {
            var videoItem = LiveMediaInfo(
              cid: queryItem["cid"] ?? 0,
              page: queryItem["page"] ?? 0,
              from: queryItem["from"] ?? "",
              part: queryItem["part"] ?? "",
              duration: queryItem["duration"] ?? 0,
              vid: queryItem["vid"] ?? "",
              weblink: "",
              firstFrame: "",
              tname: view["tname"] ?? "",
              pic: view["pic"] ?? "",
              title: view["title"] ?? "",
              face: owner['face'] ?? "",
              name: owner['name'] ?? "",
              aid: item["aid"] ?? 0,
              videos: arc != null ? arc["videos"] : 0,
              pubdate: view["pubdate"] ?? 0,
              favorite: stat != null ? stat["like"] : 0,
              bvid: item["bvid"] ?? "",
            );
            videoList.add(videoItem);
          }
        }
      }
    } catch (e) {
      log(e.toString(), name: 'playAlbumAllVideos');
    }
    return videoList;
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

class LyricResults {
  final String album;
  final String id;
  final String artist;
  final String lyrics;
  final String title;
  LyricResults({
    required this.album,
    required this.id,
    required this.artist,
    required this.lyrics,
    required this.title,
  });

  @override
  String toString() {
    return 'LyricResults{album: $album, id: $id, artist: $artist, lyrics: $lyrics, title: $title}';
  }
}
