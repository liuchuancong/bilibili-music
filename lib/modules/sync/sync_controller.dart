import 'dart:io';
import 'dart:async';
import 'package:get/get.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/services/index.dart';
import 'package:bilibilimusic/plugins/local_http.dart';
import 'package:network_info_plus/network_info_plus.dart';

class SyncController extends BaseController {
  final settingServer = Get.find<SettingsService>();
  NetworkInfo networkInfo = NetworkInfo();
  var ipAddress = ''.obs;
  var port = '8080'.obs;
  var isFiretloader = true.obs;
  @override
  void onInit() {
    super.onInit();
    initIpAddresses();
    LocalHttpServer().startServer();
    Timer(const Duration(seconds: 2), () {
      isFiretloader.value = false;
    });
  }

  @override
  void onClose() {
    LocalHttpServer().stopServer();
    super.onClose();
  }

  initIpAddresses() async {
    ipAddress.value = await getLocalIP();
  }

  Future<String> getLocalIP() async {
    var ip = await networkInfo.getWifiIP();
    if (ip == null || ip.isEmpty) {
      var interfaces = await NetworkInterface.list();
      var ipList = <String>[];
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (addr.type.name == 'IPv4' && !addr.address.startsWith('127') && !addr.isMulticast && !addr.isLoopback) {
            ipList.add(addr.address);
            break;
          }
        }
      }
      ip = ipList.join(';');
    }
    return ip;
  }
}
