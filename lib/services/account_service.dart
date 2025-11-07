// bilibili_account_service.dart

/// 哔哩哔哩账号服务类 - 管理账号信息与Cookie
class AccountService {
  // 单例模式
  static final AccountService _instance = AccountService._internal();
  factory AccountService() => _instance;
  AccountService._internal();

  String? _cookie;
  Map<String, dynamic>? _userInfo;

  String? get cookie => _cookie;
  Map<String, dynamic>? get userInfo => _userInfo;

  void setCookie(String cookie) => _cookie = cookie;

  Future<void> loadUserInfo() async {
    // 实现用户信息加载逻辑
    await Future.delayed(const Duration(seconds: 1));
    _userInfo = {'name': 'test_user'}; // 示例数据
  }
}
