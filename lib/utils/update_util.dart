import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/utils/version_util.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:bilibilimusic/modules/about/widgets/version_dialog.dart';

class AppUpdateChecker {
  static Future<void> checkAndShowUpdate() async {
    final settings = Get.find<AppSettingsService>();
    await VersionUtil.checkUpdate();

    bool hasNewVersion = settings.enableAutoCheckUpdate.value && VersionUtil.hasNewVersion();
    if (!hasNewVersion) return;
    final context = Get.context;
    if (context == null || !context.mounted) return;
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Container(
        alignment: Alignment.center,
        color: Colors.black54,
        child: NewVersionDialog(entry: entry),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => overlay.insert(entry));
  }

  static void showUpdateOverlay(BuildContext context) {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Container(
        alignment: Alignment.center,
        color: Colors.black54,
        child: NewVersionDialog(entry: entry),
      ),
    );

    // 确保在帧渲染完成后插入，防止 context 状态冲突
    WidgetsBinding.instance.addPostFrameCallback((_) {
      overlay.insert(entry);
    });
  }
}
