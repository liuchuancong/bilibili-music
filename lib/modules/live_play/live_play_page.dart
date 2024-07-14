import 'widgets/index.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/utils/text_util.dart';
import 'package:bilibilimusic/utils/cache_manager.dart';
import 'package:bilibilimusic/models/live_play_quality.dart';
import 'package:bilibilimusic/services/settings_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bilibilimusic/modules/live_play/live_play_controller.dart';

class LivePlayPage extends GetWidget<LivePlayController> {
  LivePlayPage({super.key});

  final SettingsService settings = Get.find<SettingsService>();
  Future<bool> onWillPop() async {
    try {
      var exit = await controller.onBackPressed();
      if (exit) {
        Get.back();
      }
    } catch (e) {
      Get.back();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: onWillPop,
      child: Scaffold(
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
                          const ResolutionsRow(),
                          const Divider(height: 1),
                          // Expanded(
                          //   child: Obx(() => DanmakuListView(
                          //         key: controller.danmakuViewKey,
                          //         room: controller.detail.value!,
                          //       )),
                          // ),
                        ],
                      )
                    : Row(children: <Widget>[
                        Flexible(
                          flex: 5,
                          child: buildVideoPlayer(),
                        ),
                        Flexible(
                          flex: 3,
                          child: Column(children: [
                            const ResolutionsRow(),
                            const Divider(height: 1),
                            // Expanded(
                            //   child: Obx(() => DanmakuListView(
                            //         key: controller.danmakuViewKey,
                            //         room: controller.detail.value!,
                            //       )),
                            // ),
                          ]),
                        ),
                      ]),
              );
            });
          },
        ),
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
                        )
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

class ResolutionsRow extends StatefulWidget {
  const ResolutionsRow({super.key});

  @override
  State<ResolutionsRow> createState() => _ResolutionsRowState();
}

class _ResolutionsRowState extends State<ResolutionsRow> {
  LivePlayController get controller => Get.find();
  Widget buildInfoCount() {
    // controller.detail.value! watching or followers
    return Row(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.whatshot_rounded, size: 14),
      const SizedBox(width: 4),
      Text(
        readableCount(controller.videoInfo.favorite.toString()),
        style: Get.textTheme.bodySmall,
      ),
    ]);
  }

  Widget buildResultionsList() {
    List<LivePlayQuality> qualities = LivePlayQualityList.getQuality(controller.videoInfoData.acceptQuality);
    String quality = qualities.firstWhere((quality) => quality.value == controller.videoInfoData.quality).quality;
    return PopupMenuButton<String>(
      itemBuilder: (context) => qualities.map((quality) {
        return PopupMenuItem<String>(
          value: quality.value.toString(),
          child: Text(quality.quality, style: Get.textTheme.bodySmall),
        );
      }).toList(),
      tooltip: '切换清晰度',
      color: Get.theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      offset: const Offset(0.0, 5.0),
      position: PopupMenuPosition.under,
      onSelected: (value) {
        controller.setResolution(value);
      },
      icon: Text(
        quality,
        style: Get.theme.textTheme.labelSmall?.copyWith(color: Get.theme.colorScheme.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: 55,
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: buildInfoCount(),
            ),
            const Spacer(),
            controller.success.value ? buildResultionsList() : Container(),
          ],
        ),
      ),
    );
  }
}
