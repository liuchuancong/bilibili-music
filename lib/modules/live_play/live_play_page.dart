import 'widgets/index.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/utils/text_util.dart';
import 'package:bilibilimusic/utils/cache_manager.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
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

  buildPhoneView() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          buildVideoPlayer(),
          const ResolutionsRow(),
          const Divider(height: 1),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: settings.currentMediaList.length,
                itemBuilder: (context, index) {
                  LiveMediaInfo mediaInfo = settings.currentMediaList[index];
                  return Obx(
                    () => Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                      color: controller.settingsService.isCurrentMediia(mediaInfo)
                          ? Get.theme.colorScheme.primary.withOpacity(0.8)
                          : null,
                      elevation: 4,
                      child: ListTile(
                        title: Text(
                          mediaInfo.part,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: controller.settingsService.isCurrentMediia(mediaInfo) ? Colors.white : Colors.black,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.video_library_outlined,
                                color:
                                    controller.settingsService.isCurrentMediia(mediaInfo) ? Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                controller.playByVideoInfo(mediaInfo);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color:
                                    controller.settingsService.isCurrentMediia(mediaInfo) ? Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                controller.playByVideoInfo(mediaInfo);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildPadView() {
    return SafeArea(
      child: Row(children: <Widget>[
        Flexible(
          flex: 5,
          child: buildVideoPlayer(),
        ),
        Flexible(
          flex: 3,
          child: Column(children: [
            const ResolutionsRow(),
            const Divider(height: 1),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: settings.currentMediaList.length,
                  itemBuilder: (context, index) {
                    LiveMediaInfo mediaInfo = settings.currentMediaList[index];
                    return GestureDetector(
                      onTap: () {
                        controller.playByVideoInfo(mediaInfo);
                      },
                      child: Obx(
                        () => Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                          color: settings.isCurrentMediia(mediaInfo) ? Get.theme.colorScheme.primary : null,
                          elevation: 4,
                          child: ListTile(
                            title: Text(
                              mediaInfo.part,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: settings.isCurrentMediia(mediaInfo) ? Colors.white : Colors.black,
                              ),
                            ),
                            subtitle: Text(formatDuration(mediaInfo.duration),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: settings.isCurrentMediia(mediaInfo) ? Colors.white : Colors.black)),
                            trailing: IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_right_sharp,
                                  color: settings.isCurrentMediia(mediaInfo) ? Colors.white : Colors.black,
                                ),
                                onPressed: () {
                                  controller.playByVideoInfo(mediaInfo);
                                }),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      onBackButtonPressed: onWillPop,
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: settings.device.value == 'phone' ? buildPhoneView() : buildPadView(),
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
                  imageUrl: controller.mediaInfo.pic,
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
        readableCount(controller.mediaInfo.favorite.toString()),
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
