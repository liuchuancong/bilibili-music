import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/plugins/http_client.dart';
import 'package:server_nano_nano/server_nano_nano.dart';
import 'package:bilibilimusic/services/settings_service.dart';

class LocalHttpServer {
  static LocalHttpServer? _instance;
  static LocalHttpServer get instance {
    _instance ??= LocalHttpServer();
    return _instance!;
  }

  late Server server;
  LocalHttpServer() {
    server = Server();
  }
  final SettingsService settings = Get.find<SettingsService>();

  Future<void> startServer() async {
    server.get('/', (req, res) {
      res.sendJson(jsonEncode(settings.toJson()));
    });
    server.post('/sync', (req, res) async {
      var settingStrings = req.query['setting'];
      settings.fromJson(json.decode(settingStrings!));
    });
    server.listen(port: 11220);
  }

  Future<void> importSyncData(String url) async {
    try {
      var result = await HttpClient.instance.getText(url);
      settings.fromJson(json.decode(result));
      SmartDialog.showToast('导入成功');
    } catch (e) {
      SmartDialog.showToast('导入失败');
    }
  }

  Future<void> stopServer() async {
    server.stop();
  }
}
