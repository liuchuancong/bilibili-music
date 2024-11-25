import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:bilibilimusic/core/util.dart';
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
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
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
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
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
      log(baseUrl, name: 'baseUrl');
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
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
      "Referer": "https://www.bilibili.com/video/$bvid",
    };
    var result = await HttpClient.instance.getJson(
      "http://api.bilibili.com/x/player/wbi/v2",
      queryParameters: sign,
      header: header,
    );
    log(result.toString(), name: 'getAudioLyric');
    if (result["code"] == 0) {
      if (result["data"]["bgm_info"] != null && result["data"]["bgm_info"]["music_id"] != null) {
        return await getMusicInfo(result["data"]["bgm_info"]['music_id']);
      }
      return {
        'album': '',
        'title': result["data"]['bgm_info']['music_title'],
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
          "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36",
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

  Future<String> getLyrics(String bgmInfo) async {
    var lyrics = await HttpClient.instance.getFile("https://api.lrc.cx/lyrics?title=$bgmInfo");
    String lrcText = utf8.decode(lyrics.data);
    var lines = lrcText.split("\n");
    if (lines.length < 10) {
      return await getOtherLyrics(bgmInfo);
    }
    return lrcText;
  }

  Future<String> getBilibiliLyrics(String url) async {
    var lyrics = await HttpClient.instance.getFile(url);
    return utf8.decode(lyrics.data);
  }

  Future<String> getOtherLyrics(String bgmInfo) async {
    List<dynamic> lyricResults = await HttpClient.instance.getJson("https://api.lrc.cx/jsonapi?title=$bgmInfo");
    var lyrics = '';
    for (var i = 0; i < lyricResults.length; i++) {
      if (lyricResults[i]['lyrics'].toString().split("\n").length > 10) {
        lyrics = lyricResults[i]['lyrics'];
        break;
      }
    }
    return lyrics;
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
