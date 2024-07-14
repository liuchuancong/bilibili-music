import 'widgets/index.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/utils/cache_manager.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bilibilimusic/modules/live_play/live_play_controller.dart';

class LivePlayPage extends GetWidget<LivePlayController> {
  LivePlayPage({super.key});

  final SettingsService settings = Get.find<SettingsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (BuildContext context) {
          return LayoutBuilder(builder: (context, constraint) {
            final width = Get.width;
            return SafeArea(
              child: width <= 680
                  ? Column(
                      children: <Widget>[
                        buildVideoPlayer(),
                        const Divider(height: 1),
                      ],
                    )
                  : Row(children: <Widget>[
                      Flexible(
                        flex: 5,
                        child: buildVideoPlayer(),
                      ),
                      const Flexible(
                        flex: 3,
                        child: Column(children: [
                          Divider(height: 1),
                        ]),
                      ),
                    ]),
            );
          });
        },
      ),
    );
  }

  Widget buildVideoPlayer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: Obx(
          () {
            if (controller.success.value) {
              return VideoPlayer(controller: controller.videoController!);
            } else {
              return Card(
                elevation: 0,
                margin: const EdgeInsets.all(0),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                clipBehavior: Clip.antiAlias,
                color: Get.theme.focusColor,
                child: CachedNetworkImage(
                  imageUrl: controller.videoInfo.pic,
                  cacheManager: CustomCacheManager.instance,
                  fit: BoxFit.fill,
                  errorWidget: (context, error, stackTrace) => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.live_tv_rounded, size: 48),
                        Text(
                          "无法获取播放信息",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          "当前房间未开播或无法观看",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          "请按确定按钮刷新重试",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
