import 'package:get/get.dart';
import 'playlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/utils/text_util.dart';
import 'package:bilibilimusic/routes/app_navigation.dart';
import 'package:bilibilimusic/models/live_video_info.dart';

class PlayListPage extends GetView<PlayListController> {
  const PlayListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '播放列表',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.list.length,
          itemBuilder: (context, index) {
            VideoInfo videoInfo = controller.list[index];
            return GestureDetector(
              onTap: () {
                controller.settingsService.setCurrentVideo(videoInfo);
                AppNavigator.toLiveRoomDetail(videoInfo: videoInfo);
              },
              child: Obx(
                () => Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  color:
                      controller.settingsService.isCurrentVideoInfo(videoInfo) ? Get.theme.colorScheme.primary : null,
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      videoInfo.part,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: controller.settingsService.isCurrentVideoInfo(videoInfo) ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Text(formatDuration(videoInfo.duration),
                        style: TextStyle(
                            fontSize: 14,
                            color: controller.settingsService.isCurrentVideoInfo(videoInfo)
                                ? Colors.white
                                : Colors.black)),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.keyboard_arrow_right_sharp,
                          color: controller.settingsService.isCurrentVideoInfo(videoInfo) ? Colors.white : Colors.black,
                        ),
                        onPressed: () {
                          AppNavigator.toLiveRoomDetail(videoInfo: videoInfo);
                        }),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
