import 'package:get/get.dart';
import 'playlist_controller.dart';
import 'package:bilibilimusic/common/index.dart';
import 'package:bilibilimusic/routes/app_navigation.dart';
import 'package:bilibilimusic/models/live_media_info.dart';

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
                      if (controller.list.isNotEmpty) {
                        controller.settingsService.setCurrentMedia(controller.list[0]);
                        AppNavigator.toLiveRoomDetail(mediaInfo: controller.list[0]);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), // 调整内边距
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700), // 调整文本大小
                    ),
                    child: const Text('播放全部视频'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.list.isNotEmpty) {
                        controller.settingsService
                            .setCurreentMusicList(controller.list.value.map((item) => item as LiveMediaInfo).toList());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8), // 调整内边距
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700), // 调整文本大小
                    ),
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
                  LiveMediaInfo mediaInfo = controller.list[index];
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
                                Icons.library_music_outlined,
                                color:
                                    controller.settingsService.isCurrentMediia(mediaInfo) ? Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                controller.audioController.startPlayAtIndex(
                                    index, controller.list.value.map((item) => item as LiveMediaInfo).toList());
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.video_collection_outlined,
                                color:
                                    controller.settingsService.isCurrentMediia(mediaInfo) ? Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                if (controller.list.isNotEmpty) {
                                  controller.audioController.pause();
                                  controller.settingsService.startPlayVideoAtIndex(
                                      index, controller.list.value.map((item) => item as LiveMediaInfo).toList());
                                  AppNavigator.toLiveRoomDetail(mediaInfo: mediaInfo);
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color:
                                    controller.settingsService.isCurrentMediia(mediaInfo) ? Colors.white : Colors.black,
                              ),
                              onPressed: () {
                                controller.settingsService.setCurrentMedia(mediaInfo);
                                AppNavigator.toLiveRoomDetail(mediaInfo: mediaInfo);
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
          ],
        );
      }),
      bottomNavigationBar: const BottomMusicControl(),
    );
  }
}
