/// B站 UP主 信息实体
class BiliUpInfo {
  /// UP主昵称
  final String name;

  /// UP主头像
  final String face;

  /// UP主简介
  final String desc;

  /// UP主 MID
  final String mid;

  /// 获赞数
  final int? like;

  /// 粉丝数
  final int? follower;

  /// 是否已加载完成
  final bool loaded;

  /// 支持空实例化（用于 GetX obs 初始化）
  BiliUpInfo({
    this.name = '',
    this.face = '',
    this.desc = '',
    this.mid = '',
    this.like = 0,
    this.follower = 0,
    this.loaded = false,
  });

  /// JSON 转实体
  factory BiliUpInfo.fromJson(Map<String, dynamic> json) {
    return BiliUpInfo(
      name: json["name"] ?? '',
      face: json["face"] ?? '',
      desc: json["desc"] ?? '',
      mid: json["mid"] ?? '',
      like: json["like"] ?? 0,
      follower: json["follower"] ?? 0,
      loaded: json["loaded"] ?? false,
    );
  }

  /// 实体转 JSON
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "face": face,
      "desc": desc,
      "mid": mid,
      "like": like,
      "follower": follower,
      "loaded": loaded,
    };
  }
}
