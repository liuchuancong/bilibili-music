import 'package:get/get.dart';
import 'playlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:bilibilimusic/utils/text_util.dart';
import 'package:bilibilimusic/routes/app_navigation.dart';
import 'package:bilibilimusic/models/live_media_info.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

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
          Obx(() => IconButton(
                icon: Icon(
                  controller.settingsService.isExistVideoAlbum(controller.bilibiliVideo)
                      ? Icons.videocam_off_outlined
                      : Icons.videocam_outlined,
                ),
                onPressed: () {
                  controller.settingsService.toggleCollectVideo(
                      controller.bilibiliVideo, controller.list.value.map((item) => item as LiveMediaInfo).toList());
                },
              )),
          Obx(() => IconButton(
                icon: Icon(controller.settingsService.isExistMusicAlbum(controller.bilibiliVideo)
                    ? Icons.music_off_outlined
                    : Icons.music_note_outlined),
                onPressed: () {
                  controller.settingsService.toggleCollectMusic(
                      controller.bilibiliVideo, controller.list.value.map((item) => item as LiveMediaInfo).toList());
                },
              )),
        ],
      ),
      body: Obx(() {
        return Column(
          children: [
            // 操作按钮
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.settingsService.setCurrentVideo(controller.list[0]);
                      AppNavigator.toLiveRoomDetail(videoInfo: controller.list[0]);
                    },
                    child: const Text('播放全部视频'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      controller.settingsService
                          .setCurreentMusicList(controller.list.value.map((item) => item as LiveMediaInfo).toList());
                    },
                    child: const Text('播放全部音乐'),
                  ),
                  // 更多按钮...
                ],
              ),
            ),
            // 分割线
            const Divider(height: 1, color: Color.fromARGB(255, 196, 191, 191)),
            Expanded(
              child: ListView.builder(
                itemCount: controller.list.length,
                itemBuilder: (context, index) {
                  LiveMediaInfo videoInfo = controller.list[index];
                  return GestureDetector(
                    onTap: () {
                      controller.settingsService.setCurrentVideo(videoInfo);
                      AppNavigator.toLiveRoomDetail(videoInfo: videoInfo);
                    },
                    child: Obx(
                      () => Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        color: controller.settingsService.isCurrentVideoInfo(videoInfo)
                            ? Get.theme.colorScheme.primary
                            : null,
                        elevation: 4,
                        child: ListTile(
                          title: Text(
                            videoInfo.part,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: controller.settingsService.isCurrentVideoInfo(videoInfo)
                                  ? Colors.white
                                  : Colors.black,
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
                                color: controller.settingsService.isCurrentVideoInfo(videoInfo)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () {
                                controller.settingsService.setCurrentVideo(videoInfo);
                                AppNavigator.toLiveRoomDetail(videoInfo: videoInfo);
                              }),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black12, width: 0.5)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: controller.audioController.previous,
                ),
                Obx(() => IconButton(
                      icon: Icon(controller.audioController.audioPlayer.playing ? Icons.pause : Icons.play_arrow),
                      onPressed: () {
                        if (controller.audioController.audioPlayer.playing) {
                          controller.audioController.pause();
                        } else {
                          controller.audioController.play();
                        }
                      },
                    )),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: controller.audioController.next,
                ),
              ],
            ),
            Obx(() => ProgressBar(
                  progress: controller.audioController.currentMusicPosition.value,
                  barHeight: 5,
                  thumbRadius: 4,
                  thumbGlowRadius: 8,
                  total: controller.audioController.currentMusicDuration.value,
                  onSeek: (duration) {},
                )),
          ],
        ),
      ),
    );
  }
}
