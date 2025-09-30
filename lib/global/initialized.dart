import 'package:media_kit/media_kit.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInitializer {
  // 单例实例
  static final AppInitializer _instance = AppInitializer._internal();

  // 是否已经初始化
  bool _isInitialized = false;

  // 工厂构造函数，返回单例
  factory AppInitializer() {
    return _instance;
  }

  // 私有构造函数
  AppInitializer._internal();

  // 初始化方法
  Future<void> initialize() async {
    if (_isInitialized) {
      // 已经初始化过，直接返回
      return;
    }

    // 执行初始化操作
    WidgetsFlutterBinding.ensureInitialized();
    PrefUtil.prefs = await SharedPreferences.getInstance();
    MediaKit.ensureInitialized();

    // 标记为已初始化
    _isInitialized = true;
  }

  // 检查是否已初始化
  bool get isInitialized => _isInitialized;
}
