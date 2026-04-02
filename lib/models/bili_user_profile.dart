import 'dart:convert';

/// 类型安全转换工具方法
T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

/// B站用户个人信息实体
/// 存储用户ID、昵称、签名、性别、生日、等级等基础信息
class BiliUserProfile {
  /// 用户唯一标识 MID
  int? mid;

  /// 用户昵称
  String? uname;

  /// 用户账号ID
  String? userid;

  /// 个性签名
  String? sign;

  /// 生日（格式：YYYY-MM-DD）
  String? birthday;

  /// 性别
  String? sex;

  /// 是否为免费昵称
  bool? nickFree;

  /// 用户等级 / 排名
  String? rank;

  BiliUserProfile({
    this.mid,
    this.uname,
    this.userid,
    this.sign,
    this.birthday,
    this.sex,
    this.nickFree,
    this.rank,
  });

  /// JSON 转实体
  factory BiliUserProfile.fromJson(Map<String, dynamic> json) {
    return BiliUserProfile(
      mid: asT<int?>(json['mid']),
      uname: asT<String?>(json['uname']),
      userid: asT<String?>(json['userid']),
      sign: asT<String?>(json['sign']),
      birthday: asT<String?>(json['birthday']),
      sex: asT<String?>(json['sex']),
      nickFree: asT<bool?>(json['nick_free']),
      rank: asT<String?>(json['rank']),
    );
  }

  /// 实体转 JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'mid': mid,
      'uname': uname,
      'userid': userid,
      'sign': sign,
      'birthday': birthday,
      'sex': sex,
      'nick_free': nickFree,
      'rank': rank,
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
