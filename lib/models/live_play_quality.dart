import 'dart:convert';

class LivePlayQuality {
  /// 清晰度
  final String quality;

  /// 清晰度信息
  final int value;

  final int sort;

  LivePlayQuality({
    required this.quality,
    required this.value,
    this.sort = 0,
  });

  @override
  String toString() {
    return json.encode({
      "quality": quality,
      "value": value.toString(),
    });
  }
}

class LivePlayQualityList {
  static List<LivePlayQuality> qualityList = [
    LivePlayQuality(quality: "高清1080P60", value: 116),
    LivePlayQuality(quality: "高清1080P", value: 112),
    LivePlayQuality(quality: "高清1080P", value: 80),
    LivePlayQuality(quality: "高清720P60", value: 74),
    LivePlayQuality(quality: "高清720P", value: 64),
    LivePlayQuality(quality: "清晰480P", value: 32),
    LivePlayQuality(quality: "流畅360P", value: 16),
  ];

  static List<LivePlayQuality> getQuality(List<int> values) {
    return qualityList.where((quality) => values.contains(quality.value)).toList();
  }
}
