import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:bilibilimusic/modules/sync/sync_controller.dart';

class SyncPage extends GetView<SyncController> {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('同步设置'),
      ),
      body: Column(
        children: [
          Expanded(
              child: Obx(
            () => Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(Get.context!).pop();
                    },
                    child: SizedBox(
                      width: 200,
                      child: QrImageView(
                        data: 'http://${controller.ipAddress.value}:11220',
                        version: QrVersions.auto,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      '服务已启动：http://${controller.ipAddress.value}:11220',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Text(
                    "请使用手机扫描上方二维码\n建立连接后同步数据",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
