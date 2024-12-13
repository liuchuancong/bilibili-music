class UpUserInfo {
  final String name;
  final String face;
  final String desc;
  final String mid;
  final int? like;
  final int? follower;
  final bool loaded;
  UpUserInfo({
    required this.name,
    required this.desc,
    required this.face,
    required this.mid,
    required this.like,
    required this.follower,
    required this.loaded,
  });

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

  factory UpUserInfo.fromJson(Map<String, dynamic> json) {
    return UpUserInfo(
      name: json["name"],
      face: json["face"],
      desc: json["desc"],
      mid: json["mid"],
      like: json["like"],
      follower: json["follower"],
      loaded: json["loaded"],
    );
  }
}
