import 'dart:convert';
import 'dart:developer';
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

// 对 imgKey 和 subKey 进行字符顺序打乱编码
String getMixinKey(String orig) {
  String temp = '';
  for (int i = 0; i < mixinKeyEncTab.length; i++) {
    temp += orig.split('')[mixinKeyEncTab[i]];
  }
  return temp.substring(0, 32);
}

// 为请求参数进行 wbi 签名
Map<String, dynamic> encWbi(Map<String, dynamic> params, String imgKey, String subKey) {
  final String mixinKey = getMixinKey(imgKey + subKey);
  final DateTime now = DateTime.now();
  final int currTime = (now.millisecondsSinceEpoch / 1000).round();
  final RegExp chrFilter = RegExp(r"[!\'\(\)*]");
  final List<String> query = <String>[];
  final Map<String, dynamic> newParams = Map.from(params)..addAll({"wts": currTime}); // 添加 wts 字段
  // 按照 key 重排参数
  final List<String> keys = newParams.keys.toList()..sort();
  for (String i in keys) {
    query.add('${Uri.encodeComponent(i)}=${Uri.encodeComponent(newParams[i].toString().replaceAll(chrFilter, ''))}');
  }
  final String queryStr = query.join('&');
  final String wbiSign = md5.convert(utf8.encode(queryStr + mixinKey)).toString(); // 计算 w_rid
  return {'wts': currTime.toString(), 'w_rid': wbiSign};
}

Future<Map<String, dynamic>> getWbiKeys() async {
  final SettingsService settings = Get.find<SettingsService>();
  final DateTime nowDate = DateTime.now();
  if (settings.webKeys.isNotEmpty &&
      DateTime.fromMillisecondsSinceEpoch(settings.webKeyTimeStamp.value).day == nowDate.day) {
    return Map.from(jsonDecode(settings.webKeys.value));
  }
  headers['cookie'] = settings.bilibiliCookie.value;
  final result = await HttpClient.instance.getJson('https://api.bilibili.com/x/web-interface/nav', header: headers);
  if (result["code"] == 0) {
    final imgUrl = result["data"]["wbi_img"]["img_url"];
    final subUrl = result["data"]["wbi_img"]["sub_url"];
    final imgKey = imgUrl.split('/').last.split('.').first.toString();
    final subKey = subUrl.split('/').last.split('.').first.toString();
    settings.webKeys.value = jsonEncode({'imgKey': imgKey, 'subKey': subKey});
    settings.webKeyTimeStamp.value = nowDate.millisecondsSinceEpoch;
    return {'imgKey': imgKey, 'subKey': subKey};
  } else {
    SmartDialog.showToast(result['message']);
  }
  return {'imgKey': "", 'subKey': ""};
}

Future<Map<String, dynamic>> getSignedParams(Map<String, dynamic> params) async {
// params 为需要加密的请求参数
  final Map<String, dynamic> wbiKeys = await getWbiKeys();
  final Map<String, dynamic> query = params..addAll(encWbi(params, wbiKeys['imgKey'], wbiKeys['subKey']));
  return query;
}
