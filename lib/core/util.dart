import 'dart:convert';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/services/index.dart';
import 'package:bilibilimusic/plugins/http_client.dart';

var headers = {
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
};

const List<int> mixinKeyEncTab = [
  46,
  47,
  18,
  2,
  53,
  8,
  23,
  32,
  15,
  50,
  10,
  31,
  58,
  3,
  45,
  35,
  27,
  43,
  5,
  49,
  33,
  9,
  42,
  19,
  29,
  28,
  14,
  39,
  12,
  38,
  41,
  13,
  37,
  48,
  7,
  16,
  24,
  55,
  40,
  61,
  26,
  17,
  0,
  1,
  60,
  51,
  30,
  4,
  22,
  25,
  54,
  21,
  56,
  59,
  6,
  63,
  57,
  62,
  11,
  36,
  20,
  34,
  44,
  52,
];

Map<String, int> audioQualityMap = {
  "64": 30216,
  "132": 30232,
  "192": 30280,
};

enum AudioQualityEnums { k64, k132, k192 }

extension AudioQualityEnumsExtension on AudioQualityEnums {
  int get qualityId {
    switch (this) {
      case AudioQualityEnums.k64:
        return audioQualityMap["64"]!;
      case AudioQualityEnums.k132:
        return audioQualityMap["132"]!;
      case AudioQualityEnums.k192:
        return audioQualityMap["192"]!;
    }
  }
}

String getMixinKey(String orig) {
  return mixinKeyEncTab.map((i) => orig[i]).join().substring(0, 32);
}

Map<String, dynamic> encWbi(Map<String, dynamic> params, String imgKey, String subKey) {
  String mixinKey = getMixinKey(imgKey + subKey); // 假设 getMixinKey 已经被正确地定义
  String currTime = (DateTime.now().millisecondsSinceEpoch / 1000).round().toString(); // 获取当前时间戳（秒）

  // 添加 wts 字段
  params['wts'] = currTime;

  // 按照 key 重排参数
  List<MapEntry<String, dynamic>> entries = params.entries.toList();
  entries.sort((a, b) => a.key.compareTo(b.key));
  Map<String, dynamic> sortedParams = Map.fromEntries(entries);

  // 过滤 value 中的 "!'()" 字符
  Map<String, dynamic> filteredParams = {};
  sortedParams.forEach((key, value) {
    String strValue = value.toString();
    String filteredValue = strValue.replaceAll(RegExp(r"[!'()]"), "");
    filteredParams[key] = filteredValue;
  });

  // 序列化参数
  String query = Uri(queryParameters: filteredParams).query;

  // 计算 w_rid
  String wbiSign = _computeMd5Hash(query + mixinKey);

  // 添加 w_rid 到参数
  filteredParams['w_rid'] = wbiSign;

  return filteredParams;
}

// MD5哈希计算辅助函数
String _computeMd5Hash(String input) {
  var bytes = utf8.encode(input);
  var digest = md5.convert(bytes);
  return digest.toString();
}

Future<Map<String, String>> getWbiKeys() async {
  final SettingsService settings = Get.find<SettingsService>();
  headers['cookie'] = settings.bilibiliCookie.value;
  final result = await HttpClient.instance.getJson('https://api.bilibili.com/x/web-interface/nav', header: headers);
  if (result["code"] == 0) {
    final imgUrl = result["data"]["wbi_img"]["img_url"];
    final subUrl = result["data"]["wbi_img"]["sub_url"];
    final imgKey = imgUrl.split('/').last.split('.').first;
    final subKey = subUrl.split('/').last.split('.').first;
    return {'imgKey': imgKey, 'subKey': subKey};
  } else {
    SmartDialog.showToast(result['message']);
  }
  return {'imgKey': "", 'subKey': ""};
}

Future<Map<String, dynamic>> getSignedParams(Map<String, dynamic> params) async {
  final keys = await getWbiKeys();
  return encWbi(params, keys['imgKey']!, keys['subKey']!);
}
